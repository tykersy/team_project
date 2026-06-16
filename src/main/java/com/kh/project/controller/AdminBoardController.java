package com.kh.project.controller;

import java.util.HashMap;
import java.util.Map;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.kh.project.dao.BoardDAO;
import com.kh.project.vo.BoardVO;

@Controller
@RequestMapping("/admin/board") // URL을 /admin/board로 통일
public class AdminBoardController {

    private final BoardDAO boardDAO;

    public AdminBoardController(BoardDAO boardDAO) {
        this.boardDAO = boardDAO;
    }

    // 목록: /admin/board/list 로 접속
    @GetMapping("/list")
    public String adminList(@RequestParam(defaultValue = "1") int page, 
                            @RequestParam(required = false) String keyword, 
                            Model model) {
        int limit = 10;
        int offset = (page - 1) * limit;
        Map<String, Object> map = new HashMap<>();
        map.put("offset", offset);
        map.put("limit", limit);
        map.put("keyword", keyword);

        model.addAttribute("boardList", boardDAO.getBoardList(map));
        model.addAttribute("totalPages", (int) Math.ceil((double) boardDAO.getTotalCount(map) / limit));
        model.addAttribute("currentPage", page);
        model.addAttribute("keyword", keyword);
        return "admin_board/admin_list"; 
    }

    // 글쓰기 폼
    @GetMapping("/write") 
    public String writeForm() { return "admin_board/admin_write"; }
    
    @PostMapping("/write") 
    public String writePro(BoardVO board) { 
        if (board.getSabun() == 0) board.setSabun(1001); 
        boardDAO.insertBoard(board); 
        return "redirect:/admin/board/list"; 
    }

    // 상세 보기
    @GetMapping("/detail") 
    public String boardDetail(@RequestParam("idx") int idx, Model model) {
        boardDAO.incrementViews(idx); 
        model.addAttribute("board", boardDAO.getBoard(idx)); 
        return "admin_board/admin_detail"; 
    }
    
    // 수정
    @GetMapping("/update") 
    public String updateForm(@RequestParam("idx") int idx, Model model) { 
        model.addAttribute("board", boardDAO.getBoard(idx)); 
        return "admin_board/admin_update"; 
    }
    
    @PostMapping("/update") 
    public String updatePro(BoardVO board) { 
        boardDAO.updateBoard(board); 
        return "redirect:/admin/board/detail?idx=" + board.getIdx(); 
    }
    
    // 삭제
    @GetMapping("/delete") 
    public String deleteBoard(@RequestParam("idx") int idx) { 
        boardDAO.deleteBoard(idx); 
        return "redirect:/admin/board/list"; 
    }
}