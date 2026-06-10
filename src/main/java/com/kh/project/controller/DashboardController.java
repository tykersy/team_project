package com.kh.project.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.project.dao.BoardDAO;
import com.kh.project.dao.CalendarDAO;
import com.kh.project.dao.SawonDAO;
import com.kh.project.dao.SleaveDAO;
import com.kh.project.dao.TADAO;
import com.kh.project.vo.CalendarVO;
import com.kh.project.vo.TAVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor; 

@Controller
@RequiredArgsConstructor
public class DashboardController {

    private final SawonDAO sawonDao;
    private final SleaveDAO sleaveDao;
    private final CalendarDAO calendarDAO;
    private final BoardDAO boardDao;
    private final TADAO tadao;

    @Autowired
    HttpSession session;
    
    @GetMapping({"/", "/home", "/dashboard"})
    public String dashboard(Model model) { 

        Integer sabun = (Integer)session.getAttribute("user");

        TAVO today = null;

        if(sabun != null){
            today = tadao.selectToday(sabun);
        }

        model.addAttribute("today", today);

        // 1. KPI 데이터 (예시 값)
        model.addAttribute("approval", 7);
        model.addAttribute("vacation", 12);
        model.addAttribute("overallGoal", "국내시장 점유율 15% → 25%로 확대"); 
        model.addAttribute("edu", 5);

        // 2. 공지사항 데이터
        model.addAttribute("boardList", boardDao.getBoardList());

        // 3. 팀원 일정 데이터 (CalendarDAO 사용)
        int testDeptNo = 10; 
        try {
            // Dcalendar 대신 CalendarVO 리스트 사용
            List<CalendarVO> scheduleList = calendarDAO.selectDept(testDeptNo); 
            model.addAttribute("scheduleList", scheduleList); 
        } catch (Exception e) {
            System.err.println("대시보드 일정 조회 오류: " + e.getMessage());
        }

        return "dashboard/main";
    }
}