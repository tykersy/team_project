package com.kh.project.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.project.dao.BoardDAO;
import com.kh.project.vo.BoardVO;

@Controller
@RequestMapping("/admin/board") //URL 주소는 계층형으로
public class AdminBoardController {

    private final BoardDAO boardDAO;

    public AdminBoardController(BoardDAO boardDAO) {
        this.boardDAO = boardDAO;
    }

    // 1. 관리자용 목록 보기
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
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", (int) Math.ceil((double) boardDAO.getTotalCount(map) / limit));
        model.addAttribute("keyword", keyword);
        
        // 관리자용 리스트 페이지 (admin_board 폴더 아래)
        return "admin_board/admin_list"; 
    }

    // 2. 글쓰기 폼
    @GetMapping("/write") 
    public String writeForm() { 
        return "admin_board/admin_write"; // 관리자용 작성 페이지
    }
    
    // 글쓰기 처리
    @PostMapping("/write") 
    public String writePro(BoardVO board) { 
        if (board.getSabun() == 0) board.setSabun(1001); 
        boardDAO.insertBoard(board); 
        return "redirect:/admin/board/list"; 
    }

    // 3. 상세 보기
    @GetMapping("/detail") 
    public String boardDetail(@RequestParam("idx") int idx, Model model) {
    // 조회수 증가 (필요한 경우)
    boardDAO.incrementViews(idx); 
    
    // 데이터 가져오기
    BoardVO board = boardDAO.getBoard(idx);
    model.addAttribute("board", board); 
    return "admin_board/admin_detail"; 
    }
    
    // 4. 수정
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
    
    // 5. 삭제
    @GetMapping("/delete") 
    public String deleteBoard(@RequestParam("idx") int idx) { 
        boardDAO.deleteBoard(idx); 
        return "redirect:/admin/board/list"; 
    }
}