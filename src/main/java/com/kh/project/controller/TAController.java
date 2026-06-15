package com.kh.project.controller;

import java.text.DateFormat;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.project.dao.TADAO;
import com.kh.project.vo.SalaryClosedVO;
import com.kh.project.vo.TAVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class TAController {

    private final TADAO tadao;

    @Autowired
    HttpSession session;

    @GetMapping("/ta_main.do")
    public String taMain(Model model) {

        if(session.getAttribute("user") == null){
            return "redirect:/login";
        }

        int sabun = (Integer)session.getAttribute("user");

        TAVO today = tadao.selectToday(sabun);
        List<TAVO> list = tadao.selectList(sabun);

        model.addAttribute("today", today);
        model.addAttribute("list", list);

        return "ta/ta_main";
    }

    @PostMapping("/checkin.do")
    @ResponseBody
    public Map<String, Object> checkIn() {

        Map<String, Object> map = new HashMap<>();

        if(session.getAttribute("user") == null){
            map.put("result", "login");
            return map;
        }

        int sabun = (Integer)session.getAttribute("user");

        TAVO today = tadao.selectToday(sabun);

        if (today != null) {
            map.put("result", "already");
            return map;
        }

        int res = tadao.checkIn(sabun);

        if (res > 0) {
            map.put("result", "yes");
        } else {
            map.put("result", "no");
        }

        return map;
    }

    @PostMapping("/checkout.do")
    @ResponseBody
    public Map<String, Object> checkOut() {

        Map<String, Object> map = new HashMap<>();

        if(session.getAttribute("user") == null){
            map.put("result", "login");
            return map;
        }

        int sabun = (Integer)session.getAttribute("user");

        TAVO today = tadao.selectToday(sabun);

        if (today == null) {
            map.put("result", "not_checkin");
            return map;
        }

        if (today.getCheckout() != null) {
            map.put("result", "already");
            return map;
        }

        int res = tadao.checkOut(sabun);

        if (res > 0) {
            map.put("result", "yes");
        } else {
            map.put("result", "no");
        }

        return map;
    }

    //근태 정산/마감 메인 페이지
    @GetMapping("/admin_TA_confirm_main")
    public String adminTAMain( String ym, Model model ){

        //선택된 ym(년월)이 없다면 오늘날짜 기준으로 세팅
        if( ym == null || ym.equals("") ){
            ym = "2026-06"; //임시 작성, 수정필요!!!!!!!!!
        }
        
        //-------------------------------DB연동후에는 실제DB정보 불러와서 사용
        List<Map<String, Object>> dummyList = new ArrayList();

        Map<String, Object> emp1 = new HashMap<>();
        emp1.put("sabun", "2024001");
        emp1.put("saname", "김민수");
        emp1.put("dname", "경영팀");
        emp1.put("standard_days", 22); // 해당 월 평일 총 일수
        emp1.put("worked_days", 21);
        emp1.put("absence_days", 1);   // 무급 결근 1일 발생 -> 나중에 월급 차감용
        emp1.put("leave_days", 0);
        emp1.put("overtime_hours", 5); // 연장근무 5시간 -> 나중에 연장수당용
        emp1.put("status", "대기");     // 마감 상태
        dummyList.add(emp1);

        Map<String, Object> emp2 = new HashMap<>();
        emp2.put("sabun", "2024002");
        emp2.put("saname", "이영희");
        emp2.put("dname", "개발팀");
        emp2.put("standard_days", 22);
        emp2.put("worked_days", 20);
        emp2.put("absence_days", 0);
        emp2.put("leave_days", 2);     // 연차 사용 2일 (출근으로 인정)
        emp2.put("overtime_hours", 12);
        emp2.put("status", "완료");
        dummyList.add(emp2);

        //-------------------------------DB연동후에는 실제DB정보 불러와서 사용

        // 3. JSP 화면으로 데이터 토스
        model.addAttribute("attendanceList", dummyList); //정산 대상자 목록
        model.addAttribute("selectedYm", ym); //선택 년월
        model.addAttribute("waitCnt", 1); //마감 대기자 수
        model.addAttribute("completeCnt", 1); //마감 완료자 수

        return "admin_ta/admin_ta_contirm";
    }

    //근태 마감 처리 함수(fetch사용)
    @PostMapping("/admin_ta_confirm")
    @ResponseBody
    public Map<String, Object> closeAttendance( int sabun, String ym ){

        //결과를 담을 map생성
        Map<String, Object> map = new HashMap<>();
        map.put("ym", ym);
        map.put("sabun", sabun);

        SalaryClosedVO vo = tadao.selectTaConfirm(map);

        return map;

    }

}