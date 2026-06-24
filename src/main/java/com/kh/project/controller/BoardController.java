package com.kh.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.kh.project.common.GroqService;
import com.kh.project.dao.BoardDAO;
import com.kh.project.vo.BoardVO;

@Controller
@RequestMapping("/board")
public class BoardController {

    private static final Logger log = LoggerFactory.getLogger(BoardController.class);

    private final BoardDAO boardDAO;
    private final GroqService groqService;

    public BoardController(BoardDAO boardDAO, GroqService groqService) {
        this.boardDAO = boardDAO;
        this.groqService = groqService;
    }

    // 공지사항 목록
    @GetMapping("/list")
    public String noticeList(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) String keyword,
            Model model) {

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

        if (board == null) {
            return "redirect:/board/list";
        }

        boardDAO.incrementViews(idx);

        model.addAttribute("board", board);

        return "board/detail";
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
                당신은 한국 기업의 사내 공지사항을 작성하는 한국인 비서입니다.

                아래 공지사항을 요약하세요.

                [반드시 지킬 규칙]
                - 출력 언어는 한국어만 사용합니다.
                - 한글, 숫자, 일반 문장부호(. , ! ? ( ))만 사용할 수 있습니다.
                - 영어, 일본어, 중국어, 한자, 특수문자를 절대 포함하지 않습니다.
                - 외국어가 포함되면 반드시 자연스러운 한국어로 바꿉니다.
                - 원문에 없는 내용은 추가하지 않습니다.
                - 핵심 내용만 3~4개의 문장으로 작성합니다.
                - 문장마다 줄바꿈합니다.

                공지사항:
                %s
                """.formatted(content);
            break;

            case "translate":

            String language = params.get("language");

            if (language == null || language.isBlank()) {
                language = "영어";
            }

            prompt = """
                    아래 게시글을 자연스러운 %s로 번역해줘.
                    원래 의미는 유지하고 현지인이 읽기 자연스럽게 번역해줘.

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