package com.kh.project.controller;


import java.text.DateFormat;
import java.time.LocalDate;
import java.util.ArrayList;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.project.common.Calendar;
import com.kh.project.dao.TADAO;

import com.kh.project.vo.SalaryClosedVO;

import com.kh.project.dao.UserDAO;
import com.kh.project.vo.CalendarDayVO;

import com.kh.project.vo.TAVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;
import tools.jackson.databind.ObjectMapper;

@Controller
@RequiredArgsConstructor
public class TAController {

    private final TADAO tadao;

    //캘린더
    private final Calendar calendar;

    //userDAO
    private final UserDAO userDao;

    @Autowired
    HttpSession session;

    @GetMapping("/ta_main.do")
    public String taMain(Model model) {

        if(session.getAttribute("user") == null){
            return "redirect:/login";
        }

        int sabun = (Integer)session.getAttribute("user");

        //오늘 년/월을 구하여 포멧을 지정
        LocalDate now = LocalDate.now();

        Map<String, Object> monthlyTAMap = new HashMap<>();
        monthlyTAMap.put("sabun", sabun);
        monthlyTAMap.put("year", now.getYear());

        TAVO today = tadao.selectToday(sabun);
        List<TAVO> list = tadao.selectList(sabun);
        List<Map<String,Object>> yearlyTa = userDao.getYearlyTa(monthlyTAMap);

        // ── taJson 변환 (핵심 추가 부분) ──
        List<CalendarDayVO> calList = calendar.getCalendar(
            now.getYear(), now.getMonthValue()
        );

        List<Map<String, String>> taJson = calList.stream()
        .filter(d -> !d.getStatus().equals("off") && !d.getStatus().equals("future"))
        .map(d -> {
            Map<String, String> m = new HashMap<>();
            m.put("date", String.format("%d-%02d-%02d",
                now.getYear(), now.getMonthValue(), d.getDay()));
            m.put("status", d.getStatus());
            return m;
        })
        .collect(Collectors.toList());

        ObjectMapper mapper = new ObjectMapper();

        model.addAttribute("today", today);
        model.addAttribute("list", list);
        model.addAttribute("yearlyTA", yearlyTa);
        model.addAttribute("taJson", mapper.writeValueAsString(taJson));

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
        // List<Map<String, Object>> dummyList = new ArrayList();

        // Map<String, Object> emp1 = new HashMap<>();
        // emp1.put("sabun", "2024001");
        // emp1.put("saname", "김민수");
        // emp1.put("dname", "경영팀");
        // emp1.put("standard_days", 22); // 해당 월 평일 총 일수
        // emp1.put("worked_days", 21);
        // emp1.put("absence_days", 1);   // 무급 결근 1일 발생 -> 나중에 월급 차감용
        // emp1.put("leave_days", 0);
        // emp1.put("overtime_hours", 5); // 연장근무 5시간 -> 나중에 연장수당용
        // emp1.put("status", "대기");     // 마감 상태
        // dummyList.add(emp1);

        // Map<String, Object> emp2 = new HashMap<>();
        // emp2.put("sabun", "2024002");
        // emp2.put("saname", "이영희");
        // emp2.put("dname", "개발팀");
        // emp2.put("standard_days", 22);
        // emp2.put("worked_days", 20);
        // emp2.put("absence_days", 0);
        // emp2.put("leave_days", 2);     // 연차 사용 2일 (출근으로 인정)
        // emp2.put("overtime_hours", 12);
        // emp2.put("status", "완료");
        // dummyList.add(emp2);

        //-------------------------------DB연동후에는 실제DB정보 불러와서 사용

        //전체 사원별 해당 년월 TA리스트 불러오기
        List<SalaryClosedVO> attendanceList = tadao.getAllMonthlyTA(ym);

        // 2. 이번 달(예: 6월)의 총 평일 수 설정 (보통 주말 제외 21일 ~ 22일)
        int standardDays = 22;

        for(SalaryClosedVO emp : attendanceList ) {
            // DB에서 세어온 실제 출근일수 꺼내기
            int workedDays = Integer.parseInt(String.valueOf(emp.getWorked_days()));
            
            // [결근일수 계산] = 기준일수(22일) - 실제출근일수
            int absenceDays = standardDays - workedDays;
            if(absenceDays < 0) absenceDays = 0; // 혹시 주말 출근 등으로 출근일이 더 많으면 0일 처리
            
            // 3. 계산된 값들을 다시 attendanceList 주입
            emp.setStandard_days(standardDays);
            emp.setAbsence_days(absenceDays);
            
            // 연차 테이블(sleave_log) 연동 전이므로 임시로 leave_days도 0으로 입력해두기
            emp.setLeave_days(0); 
            emp.setStatus("대기");
        }

        // 3. 바인딩 및 포워딩
        // model.addAttribute("attendanceList", dummyList); //정산 대상자 목록
        model.addAttribute("selectedYm", ym); //선택 년월
        model.addAttribute("waitCnt", 1); //마감 대기자 수
        model.addAttribute("completeCnt", 1); //마감 완료자 수

        model.addAttribute("attendanceList", attendanceList);

        return "admin_ta/admin_ta_contirm";
    }

    //근태 마감 처리 함수(fetch사용)
    @PostMapping("/admin_taclose")
    @ResponseBody
    public Map<String, Object> closeAttendance( String sabun, String ym ){

        //사번이 파라미터로 넘어오지 않은경우 return
        if( sabun == null || sabun.equals("") ){
            System.out.println("사번 정보가 없습니다");
            return null;
        }

        //결과를 담을 map생성
        Map<String, Object> map = new HashMap<>();
        map.put("ym", ym);
        map.put("sabun", sabun);

        SalaryClosedVO vo = tadao.selectTaConfirm(map);
        map.put("status", "success");
        map.put("data", vo);

        return map;

    }


    @GetMapping("/ta_calendar.do")
    @ResponseBody
    public String taCalendar(int month) throws Exception {
        
        int year = LocalDate.now().getYear();

        List<CalendarDayVO> calList = calendar.getCalendar(year, month);

        List<Map<String, String>> taJson = calList.stream()
            .filter(d -> !d.getStatus().equals("off") && !d.getStatus().equals("future"))
            .map(d -> {
                Map<String, String> m = new HashMap<>();
                m.put("date", String.format("%d-%02d-%02d", year, month, d.getDay()));
                m.put("status", d.getStatus());
                return m;
            })
            .collect(Collectors.toList());

        ObjectMapper mapper = new ObjectMapper();
        return mapper.writeValueAsString(taJson);
    }

}