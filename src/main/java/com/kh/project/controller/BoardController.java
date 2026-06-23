package com.kh.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import com.kh.project.common.GeminiService;

import com.kh.project.dao.BoardDAO;
import com.kh.project.vo.BoardVO;

@Controller
@RequestMapping("/board")
public class BoardController {

    private final BoardDAO boardDAO;
    private final GeminiService geminiService;

    // 생성자 주입 방식
    @Autowired
    public BoardController(BoardDAO boardDAO, GeminiService geminiService) {
        this.boardDAO = boardDAO;
        this.geminiService = geminiService;
    }

    // 1. 공지사항 게시판 목록보기
    @GetMapping("/list")
    public String noticeList(
            @RequestParam(defaultValue = "1") int page, 
            @RequestParam(required = false) String keyword, 
            Model model) {
        
        int limit = 10;
        int offset = (page - 1) * limit;

        Map<String, Object> map = new HashMap<>();
        map.put("offset", offset);
        map.put("limit", limit);
        map.put("keyword", keyword);

        List<BoardVO> list = boardDAO.getBoardList(map);
        int totalCount = boardDAO.getTotalCount(map);
        int totalPages = (int) Math.ceil((double) totalCount / limit);

        model.addAttribute("boardList", list);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("keyword", keyword);
        
        return "board/list";
    }

    // 2. 상세 보기
    @GetMapping("/detail") 
    public String boardDetail(@RequestParam("idx") int idx, Model model) {
        boardDAO.incrementViews(idx);
        model.addAttribute("board", boardDAO.getBoard(idx));
        return "board/detail";
    }

    // 3. 제미나이 요약, 번역 기능
    @PostMapping("/ai-process")
    @ResponseBody
    public Map<String, String> processAi(@RequestBody Map<String, String> params) {
        String content = params.get("content");
        String type = params.get("type"); // "summary" or "translate"
        
        String prompt = "summary".equals(type) 
            ? "다음 게시글 내용을 3줄로 요약해줘: " + content
            : "다음 내용을 영어로 번역해줘: " + content;
            
        String result = geminiService.generate(prompt);
        
        Map<String, String> response = new HashMap<>();
        response.put("result", result);
        return response;
    }
}