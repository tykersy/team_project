package com.kh.project.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

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
import com.kh.project.vo.SawonVO;
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
        model.addAttribute("approval", sleaveDao.countPendingLeaves());
        model.addAttribute("vacation", 12);
        model.addAttribute("overallGoal", "국내시장 점유율 15% → 25%로 확대"); 
        model.addAttribute("boardList", boardDao.getBoardListAll());
        
        int deptNo = 10;
        if (sabun != null) {
            try {
                SawonVO sawon = sawonDao.sawonView(sabun); 
                if (sawon != null) { deptNo = sawon.getDeptno(); }
            } catch (Exception e) { System.err.println("사원 정보 조회 오류: " + e.getMessage()); }
        }
        try {
            List<CalendarVO> scheduleList = calendarDAO.selectDeptToday(deptNo); 
            model.addAttribute("scheduleList", scheduleList); 
        } catch (Exception e) { System.err.println("대시보드 일정 조회 오류: " + e.getMessage()); }

        String todayStr = LocalDate.now().toString();
        List<Map<String, Object>> deptVacationList = sleaveDao.getDeptVacationList(todayStr);
        model.addAttribute("deptVacationList", deptVacationList);

        return "dashboard/main";
    }
}