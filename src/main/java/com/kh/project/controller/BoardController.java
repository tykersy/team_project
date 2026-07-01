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
    private final UserDAO userDAO; // 권한 체크를 위해 추가
    private final GroqService groqService;

    @Autowired
    HttpSession session;

    public BoardController(BoardDAO boardDAO, UserDAO userDAO, GroqService groqService) {
        this.boardDAO = boardDAO;
        this.userDAO = userDAO;
        this.groqService = groqService;
    }

    // 공지사항 목록
    @GetMapping("/list")
    public String noticeList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String keyword,
            Model model) {

        Integer userSabun = (Integer) session.getAttribute("user");
        
        if(userSabun == null){
            return "redirect:/login";
        }

        // [수정] 로그인한 사원 정보 조회하여 모델에 추가
        SawonVO loginMember = userDAO.selectUser(userSabun);
        model.addAttribute("loginMember", loginMember);

        final int limit = 10;
        int offset = (page - 1) * limit;

        Map<String, Object> param = new HashMap<>();
        param.put("offset", offset);
        param.put("limit", limit);
        param.put("keyword", keyword);

        List<BoardVO> boardList = boardDAO.getBoardList(param);

        int totalCount = boardDAO.getTotalCount(param);
        int totalPages = (int) Math.ceil((double) totalCount / limit);

        model.addAttribute("boardList", boardList);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("keyword", keyword);

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

    // [추가] 글쓰기 폼 (팀장만 접근 가능)
    @GetMapping("/write")
    public String writeForm() {
        Integer sabun = (Integer) session.getAttribute("user");
        if (sabun == null) return "redirect:/login";

        SawonVO member = userDAO.selectUser(sabun);
        // 팀장 직급 확인 (필요시 사번 1번 관리자 조건 추가: || sabun == 1)
        if (member == null || !"팀장".equals(member.getSajob())) {
            return "redirect:/board/list";
        }
        return "board/write";
    }

    // [추가] 글쓰기 처리
    @PostMapping("/write")
    public String writePro(BoardVO board) {
        Integer sabun = (Integer) session.getAttribute("user");
        SawonVO member = userDAO.selectUser(sabun);

        // 보안을 위해 여기서도 권한 검증
        if (member == null || !"팀장".equals(member.getSajob())) {
            return "redirect:/board/list";
        }

        board.setSabun(sabun);
        if (board.getFile() == null) board.setFile("");
        
        boardDAO.insertBoard(board);
        return "redirect:/board/list";
    }

    // AI 요약 및 번역
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
            
            [엄격한 제약 사항]
            1. 요약 결과는 오직 한국어(한글)만 사용하십시오.
            2. 입력된 본문에 포함된 외국어(영어, 일본어, 중국어, 한자 등)는 절대 출력하지 마십시오.
            3. 본문에 포함된 외국어 단어는 문맥을 파악하여 자연스러운 한국어로 번역하거나, 번역이 불가능하다면 해당 단어를 제거하십시오.
            4. 특수문자나 기호 사용을 지양하고, 온점(.)을 사용하여 문장을 마무리하십시오.
            5. 핵심 내용 위주로 3~4개의 문장으로 작성하고, 각 문장마다 줄바꿈을 적용하십시오.
            6. 원문에 없는 내용은 절대 추가하지 마십시오.
            
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
                        1. 원문 전체의 내용(인사말, 본문, 끝인사, 서명 등)을 빠짐없이 번역할 것.
                        2. 어떠한 경우에도 번역 결과물 외의 부연 설명(인사말 제외 안내, Note 등)은 절대 출력하지 말 것.
                        3. 원문의 레이아웃, 문단 구분, 리스트 형식을 그대로 보존하여 읽기 편하게 구성할 것.
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