package com.kh.project.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.kh.project.dao.BoardDAO;
import com.kh.project.vo.BoardVO;

@Controller
@RequestMapping("/board")
public class BoardController {

    private final BoardDAO boardDAO;

    // 생성자 주입
    public BoardController(BoardDAO boardDAO) {
        this.boardDAO = boardDAO;
    }

    // 1.공지사항 게시판 목록보기
    @GetMapping("/list")
    public String noticeList(Model model) {

        List<BoardVO> list = boardDAO.getBoardList();
        model.addAttribute("boardList", list);
        return "board/list";
    }

    // 2.공지사항 글쓰기 페이지로 이동
    @GetMapping("/write")
    public String writeForm() {
        return "board/write";
    }

    // 3.글쓰기 버튼 눌렀을 때 데이터 처리 방식 (post)
    @PostMapping("/write")
    public String writePro(BoardVO board) {
        // [테스트용 사번 세팅] 원래는 로그인 세션에서 사번을 꺼내와야 합니다.
        // 우선은 DB에 있는 1001번(김민수 사원)이 글을 쓴 것으로 임시 세팅해둘게요!
        if (board.getSabun() == 0) {
            board.setSabun(1001);
        }

        // DAO에게 "이 글 상자(board) 전달할 테니까 DB에 인서트해줘"라고 시킵니다.
        boardDAO.insertBoard(board);

        // 글쓰기가 끝나면 게시판 목록 화면으로 새로고침(이동)합니다.
        return "redirect:/board/list";
    }

    // 4. 공지사항 상세 보기
    @GetMapping("/detail")
    public String boardDetail(@RequestParam("idx") int idx, Model model) {
        boardDAO.incrementViews(idx);
        BoardVO board = boardDAO.getBoard(idx); 
        model.addAttribute("board", board);
        return "board/detail";
    }

    // 5. 수정 페이지 이동 (기존 데이터를 가져와서 폼에 채워줌)
    @GetMapping("/update")
    public String updateForm(@RequestParam("idx") int idx, Model model) {
        model.addAttribute("board", boardDAO.getBoard(idx));
        return "board/update"; 
    }

    // 6. 수정 처리 (수정 완료 버튼 눌렀을 때 DB 반영)
    @PostMapping("/update")
    public String updatePro(BoardVO board) {
        boardDAO.updateBoard(board);
        // 수정이 완료되면 해당 글의 상세 페이지로 다시 이동합니다.
        return "redirect:/board/detail?idx=" + board.getIdx();
    }

    // 7. 삭제 처리
    @GetMapping("/delete")
    public String deleteBoard(@RequestParam("idx") int idx) {
        boardDAO.deleteBoard(idx);
        return "redirect:/board/list";
    }

}