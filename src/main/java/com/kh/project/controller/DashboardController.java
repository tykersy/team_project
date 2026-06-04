package com.kh.project.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.project.dao.BoardDAO;
import com.kh.project.dao.DcalendarDAO;
// 연결할 DAO 부품들을 가져옵니다.
import com.kh.project.dao.SawonDAO;
import com.kh.project.dao.SleaveDAO;
import com.kh.project.vo.BoardVO;

@Controller
public class DashboardController {

    // 다른 DAO 부품들을 담아둘 변수 선언
    private final SawonDAO sawonDao;
    private final SleaveDAO sleaveDao;
    private final DcalendarDAO dcalendarDao;
    private final BoardDAO boardDao;

    public DashboardController(SawonDAO sawonDao, SleaveDAO sleaveDao, DcalendarDAO dcalendarDao, BoardDAO boardDao) {
        this.sawonDao = sawonDao;
        this.sleaveDao = sleaveDao;
        this.dcalendarDao = dcalendarDao;
        this.boardDao = boardDao;
    }
    
    @GetMapping({"/", "/home", "/dashboard"})
    public String dashboard(Model model) { 

        // 1. KPI 카드 데이터 세팅
        int approvalCount = 7;      // ${approval}
        int leaveCount = 12;        // ${vacation}
        String targetGoal = "국내시장 점유율 15% → 25%로 확대";  // ${overallGoal}
        int eduCount = 5;           // ${edu}

        model.addAttribute("approval", approvalCount);
        model.addAttribute("vacation", leaveCount);
        model.addAttribute("overallGoal", targetGoal); 
        model.addAttribute("edu", eduCount);           

        // 2. 공지사항 데이터 가져오기
        List<BoardVO> boardList = boardDao.getBoardList();
        System.out.println("========== 대시보드 공지사항 체크 ==========");
        if (boardList != null) {
            System.out.println("가져온 공지사항 개수: " + boardList.size());
        }
        System.out.println("=========================================");
        model.addAttribute("boardList", boardList);

        // 3. 팀원 일정 데이터 가져오기
        int testDeptNo = 10; 
        try {
            // dcalendarDao가 정상 작동하면 일정을 가져옵니다.
            var scheduleList = dcalendarDao.selectDept(testDeptNo); 
            model.addAttribute("scheduleList", scheduleList); 
        } catch (Exception e) {
            System.out.println("일정 조회 중 오류 발생 (DAO 체크 필요): " + e.getMessage());
        }

        return "dashboard/main";
    }
}