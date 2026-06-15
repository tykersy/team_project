package com.kh.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.project.dao.BoardDAO;
import com.kh.project.vo.BoardVO;

@Controller
@RequestMapping("/board")
public class BoardController {

    private final BoardDAO boardDAO;

    public BoardController(BoardDAO boardDAO) {
        this.boardDAO = boardDAO;
    }

    // 1. 공지사항 게시판 목록보기 (페이징 + 검색 적용)
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
}