package com.kh.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.kh.project.common.GroqService;
import com.kh.project.dao.BoardDAO;
import com.kh.project.dao.UserDAO;
import com.kh.project.vo.BoardVO;
import com.kh.project.vo.SawonVO;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board")
public class BoardController {

    private static final Logger log = LoggerFactory.getLogger(BoardController.class);
    private final BoardDAO boardDAO;
    private final UserDAO userDAO;
    private final GroqService groqService;

    @Autowired
    HttpSession session;

    public BoardController(BoardDAO boardDAO, UserDAO userDAO, GroqService groqService) {
        this.boardDAO = boardDAO;
        this.userDAO = userDAO;
        this.groqService = groqService;
    }

    // [핵심] DB 기반 권한 검증 메서드
    private boolean isAuthorized(int sabun) {
        // 1. 최고 관리자(사번 1번)는 무조건 통과
        if (sabun == 1) return true;
        // 2. sawonleader 테이블에 등록된 사번인지 확인
        return boardDAO.isLeader(sabun);
    }

    // 공지사항 목록
    @GetMapping("/list")
    public String noticeList(@RequestParam(defaultValue = "1") int page, @RequestParam(required = false) String keyword, Model model) {
        Integer userSabun = (Integer) session.getAttribute("user");
        if(userSabun == null) return "redirect:/login";

        SawonVO loginMember = userDAO.selectUser(userSabun);
        model.addAttribute("loginMember", loginMember);
        
        // 버튼 노출 제어를 위해 권한 여부를 모델에 담아 전달
        model.addAttribute("isAuthorized", isAuthorized(userSabun));

        final int limit = 10;
        int offset = (page - 1) * limit;
        Map<String, Object> param = new HashMap<>();
        param.put("offset", offset);
        param.put("limit", limit);
        param.put("keyword", keyword);

        model.addAttribute("boardList", boardDAO.getBoardList(param));
        model.addAttribute("totalPages", (int) Math.ceil((double) boardDAO.getTotalCount(param) / limit));
        model.addAttribute("currentPage", page);
        return "board/list";
    }

    // 게시글 상세보기
    @GetMapping("/detail")
    public String boardDetail(@RequestParam int idx, Model model) {
        BoardVO board = boardDAO.getBoard(idx);
        if (board == null) return "redirect:/board/list";

        boardDAO.incrementViews(idx);
        model.addAttribute("board", board);
        return "board/detail";
    }

    // 공지사항 작성 폼
    @GetMapping("/write")
    public String writeForm(Model model) {
        Integer sabun = (Integer) session.getAttribute("user");
        if (sabun == null) return "redirect:/login";
        if (!isAuthorized(sabun)) return "redirect:/board/list";

        //  로그인한 사용자의 정보를 조회하여 모델에 담기
        SawonVO loginMember = userDAO.selectUser(sabun);
        model.addAttribute("loginMember", loginMember);
        
        return "board/write";
    }

    // 공지사항 작성 처리
    @PostMapping("/write")
    public String writePro(BoardVO board) {
        Integer sabun = (Integer) session.getAttribute("user");
        if (!isAuthorized(sabun)) return "redirect:/board/list";
        
        board.setSabun(sabun);
        if (board.getFile() == null) board.setFile("");
        boardDAO.insertBoard(board);
        return "redirect:/board/list";
    }

    // AI 요약 및 번역 (기존 로직 유지)
    @PostMapping("/ai-process")
    @ResponseBody
    public Map<String, String> processAi(@RequestBody Map<String, String> params) {
       
        Map<String, String> response = new HashMap<>();
        String content = params.get("content");
        String type = params.get("type");

        if (content == null || content.isBlank()) {
            response.put("result", "내용을 입력해주세요.");
            return response;
        }

        String prompt;
        switch (type) {
            case "summary":
            prompt = """
            당신은 한국 기업의 사내 시스템 어시스턴트입니다.
            아래 [공지사항] 내용을 한국어로 요약하세요.

            [핵심 지침]
            1. 반드시 현대 한국어(한글)만 사용하십시오. 한자, 일본어, 영어는 어떠한 경우에도 포함하지 마십시오.
            2. 모든 문장은 '다'로 끝나는 정중한 문어체로 작성하십시오.
            3. 온점(.)을 사용하여 문장을 마무리하십시오.
            4. 핵심 내용 위주로 3~4개의 문장으로 작성하십시오.
            5. 문장 사이에 빈 줄(공백 라인)을 절대 넣지 마십시오.
            6. 원문에 없는 내용은 절대 추가하지 마십시오.
            7. 각 문장 끝마다 반드시 개행 문자(\\n)를 삽입하여 줄바꿈을 하십시오. 빈 줄은 넣지 마십시오.

            [공지사항 본문]:
            %s
            """.formatted(content);
            break;

            case "translate":
                String language = params.get("language");
                if (language == null || language.isBlank()) language = "영어";
                if ("Chinese".equals(language)) language = "중국어 간체자(Simplified Chinese)";

                prompt = """
                아래 내용을 %s로 자연스럽게 번역해줘.
                [지시 사항]
                1. 원문 전체의 내용을 빠짐없이 번역할 것.
                2. 어떠한 경우에도 번역 결과물 외의 부연 설명은 절대 출력하지 말 것.
                3. 원문의 레이아웃, 문단 구분은 보존하되, 불필요한 줄바꿈(빈 줄)은 제거하여 간결하게 출력할 것.
                4. 비즈니스 이메일의 격식과 매너를 갖춘 정중한 어조로 번역할 것.
                5. 중국어의 경우, 반드시 표준 중국어 간체자(Simplified Chinese)를 사용할 것.
                [번역할 내용]
                %s
                """.formatted(language, content);
                break;

            default:
                response.put("result", "잘못된 요청입니다.");
                return response;
        }

        try {
            String result = groqService.generate(prompt);
            response.put("result", result);
        } catch (Exception e) {
            log.error("Groq API 호출 실패", e);
            response.put("result", "AI 처리 중 오류가 발생했습니다.");
        }
        return response;
    }
}