package com.kh.project.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.project.dao.SawonDAO;
import com.kh.project.dao.SleaveDAO;
import com.kh.project.vo.SawonVO;
import com.kh.project.vo.SleaveLogVO;
import com.kh.project.vo.SleaveVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class SleaveController {
    
    private final SleaveDAO sleaveDao;

    //관리자 : 연차 관리 메인페이지
    @GetMapping("/admin_leave")
    public String admingLeaveMain( Model model ){
        
        //미승인 상태 연차 갯수 조회
        int pendingCnt = sleaveDao.countPendingLeaves();
        //오늘 승인 완료된 연차 갯수 조회
        int approvedCnt = sleaveDao.countAporovedLeaves();
        //오늘 휴가중인 사원 수
        int onLeaveCnt = sleaveDao.countOnLeaveToday();
        //부서별 휴가 인원
        LocalDate todayLocal = LocalDate.now(); //오늘 날짜 String 타입으로 변환후 파라미터로 보내기
        String today = todayLocal.format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        List<Map<String, Object>> deptOnLeavelist = sleaveDao.getDeptVacationList(today); 


        //미승인 휴가 리스트 조회
        List<SleaveLogVO> pendingList = sleaveDao.selectpendingList();
        //최근 승인 완료된 연차 리스트 5개 조회
        List<SleaveLogVO> approvedList = sleaveDao.selectApprovedLeaves();
        
        //바인딩 및 포워딩
        model.addAttribute("pendingCnt", pendingCnt);
        model.addAttribute("approvedCnt", approvedCnt);
        model.addAttribute("onLeaveCnt", onLeaveCnt);
        model.addAttribute("deptOnLeavelist", deptOnLeavelist);
        model.addAttribute("pendingList", pendingList);
        model.addAttribute("approvedList", approvedList);

        return "admin_leave/admin_leave_main";

    }

}
