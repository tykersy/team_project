package com.kh.project.controller;

import java.util.HashMap;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import com.kh.project.dao.BoardDAO;
import com.kh.project.dao.UserDAO;
import com.kh.project.vo.BoardVO;
import com.kh.project.vo.SawonVO;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/admin/board")
public class AdminBoardController {

    @Autowired
    HttpSession session;

    private final BoardDAO boardDAO;
    private final UserDAO userDAO;

    public AdminBoardController(BoardDAO boardDAO, UserDAO userDAO) {
        this.boardDAO = boardDAO;
        this.userDAO = userDAO;
    }

    @GetMapping("/list")
    public String adminList(@RequestParam(defaultValue = "1") int page, 
                            @RequestParam(required = false) String keyword, 
                            Model model) {
        int limit = 10;
        int blockSize = 10;
        int offset = (page - 1) * limit;
        
        Map<String, Object> map = new HashMap<>();
        map.put("offset", offset);
        map.put("limit", limit);
        map.put("keyword", keyword);

        int totalCount = boardDAO.getTotalCount(map);
        int totalPages = (int) Math.ceil((double) totalCount / limit);
        
        int startPage = ((page - 1) / blockSize) * blockSize + 1;
        int endPage = startPage + blockSize - 1;
        if (endPage > totalPages) endPage = totalPages;

        model.addAttribute("boardList", boardDAO.getBoardList(map));
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("startPage", startPage);
        model.addAttribute("endPage", endPage);
        model.addAttribute("keyword", keyword);
        
        return "admin_board/admin_list"; 
    }

    @GetMapping("/write") 
    public String writeForm(Model model) { 
        Integer sabun = (Integer) session.getAttribute("user");
        // 1. 로그인 체크
        if (sabun == null) return "redirect:/login";
        // 2. 사원 정보 조회 (JOIN을 통해 dname 포함)
        SawonVO member = userDAO.selectUser(sabun);
        // 3. 권한 체크: 사번 1(사장) 또는 직급이 '팀장'인 경우만 접근 허용

        boolean isAuthorized = false;
        if(sabun == 1 || "팀장".equals(member.getSajob())){
            isAuthorized = true;
        }
        
        if (!isAuthorized) {
            return "redirect:/admin/board/list"; 
        }
        
        model.addAttribute("member", member);
        return "admin_board/admin_write"; 
    }
    
    @PostMapping("/write") 
    public String writePro(BoardVO board) { 
        // 세션에서 사번을 가져와서 board 객체에 강제로 설정
        Integer sabun = (Integer) session.getAttribute("user");
        board.setSabun(sabun);
        
        // 파일이 null인 경우 빈 문자열로 초기화 (에러 방지)
        if (board.getFile() == null) board.setFile("");
        
        boardDAO.insertBoard(board); 
        return "redirect:/admin/board/list"; 
    }

    @GetMapping("/detail") 
    public String boardDetail(@RequestParam("idx") int idx, Model model) {
        boardDAO.incrementViews(idx); 
        model.addAttribute("board", boardDAO.getBoard(idx)); 
        return "admin_board/admin_detail"; 
    }
    
    @GetMapping("/update") 
    public String updateForm(@RequestParam("idx") int idx, Model model) { 
        // 1. 세션에서 현재 로그인한 사번 가져오기
        Integer userObj = (Integer) session.getAttribute("user");
        
        // 2. 로그인 여부 확인
        if (userObj == null) {
            return "redirect:/login";
        }
        
        // 3. 권한 체크: 사번 1번 OR 2000번대(2000~2999)만 접근 허용
        boolean isAdmin = (userObj == 1) || (userObj >= 2000 && userObj < 3000);
        
        if (!isAdmin) {
            // 권한이 없으면 대시보드로 이동
            return "redirect:/dashboard/main"; 
        }

        // 4. 정상 권한일 경우 수정 폼 보여주기
        model.addAttribute("board", boardDAO.getBoard(idx)); 
        return "admin_board/admin_update"; 
    }
    
    @PostMapping("/update") 
    public String updatePro(BoardVO board) { 
        boardDAO.updateBoard(board); 
        return "redirect:/admin/board/detail?idx=" + board.getIdx(); 
    }
    
    @GetMapping("/delete") 
    public String deleteBoard(@RequestParam("idx") int idx) { 
        boardDAO.deleteBoard(idx); 
        return "redirect:/admin/board/list"; 
    }
}