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

        // 1. KPI 데이터 (승인 대기 건수 DB 연동, 교육 이수는 기존 5 유지)
        model.addAttribute("approval", sleaveDao.countPendingLeaves());
        model.addAttribute("vacation", 12);
        model.addAttribute("overallGoal", "국내시장 점유율 15% → 25%로 확대"); 
        model.addAttribute("edu", 5);

        // 2. 공지사항 데이터
        model.addAttribute("boardList", boardDao.getBoardList());

        // 3. 팀원 일정 데이터 (로그인한 사원의 실제 부서 번호 기준 오늘 일정 조회)
        int deptNo = 10; // 로그인 정보가 없을 시 기본 부서 번호
        if (sabun != null) {
            try {
                SawonVO sawon = sawonDao.sawonView(sabun); 
                if (sawon != null) {
                    deptNo = sawon.getDeptno();
                }
            } catch (Exception e) {
                System.err.println("사원 정보 조회 오류: " + e.getMessage());
            }
        }
        
        try {
            // 전체 조회(selectDept) 대신 오늘 당일 일정만 조회하는 메서드(selectDeptToday)로 변경 적용
            List<CalendarVO> scheduleList = calendarDAO.selectDeptToday(deptNo); 
            model.addAttribute("scheduleList", scheduleList); 
        } catch (Exception e) {
            System.err.println("대시보드 일정 조회 오류: " + e.getMessage());
        }

        // 4. 부서별 휴가 현황 데이터 추가 (오늘 날짜 기준)
        String todayStr = LocalDate.now().toString();
        List<Map<String, Object>> deptVacationList = sleaveDao.getDeptVacationList(todayStr);
        model.addAttribute("deptVacationList", deptVacationList);

        return "dashboard/main";
    }
}