package com.kh.project.controller;


import java.text.DateFormat;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.YearMonth;
import java.time.format.DateTimeFormatter;
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
import com.kh.project.dao.SalaryDAO;
import com.kh.project.dao.SawonDAO;
import com.kh.project.dao.SleaveDAO;
import com.kh.project.dao.TADAO;

import com.kh.project.vo.SalaryClosedVO;
import com.kh.project.vo.SawonVO;
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
    
    private final SawonDAO sawonDao;

    private final SleaveDAO sleavedao;

    private final SalaryDAO salarydao;

    @Autowired
    HttpSession session;

    @GetMapping("/ta_main.do")
    public String taMain(@RequestParam(required = false) String month, Model model) {

        int sabun = (Integer)session.getAttribute("user");

        //오늘 년/월을 구하여 포멧을 지정
        LocalDate now = LocalDate.now();

        if(month == null || month.equals("")){
            month = now.format(DateTimeFormatter.ofPattern("yyyy-MM"));
        }

        Map<String, Object> monthlyTAMap = new HashMap<>();
        monthlyTAMap.put("sabun", sabun);
        monthlyTAMap.put("year", now.getYear());

        Map<String, Object> taMap = new HashMap<>();
        taMap.put("sabun", sabun);
        taMap.put("month", month);

        TAVO today = tadao.selectToday(sabun);
        List<TAVO> list = tadao.selectListByMonth(taMap);
        List<String> monthList = tadao.selectMonthList(sabun);
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
        model.addAttribute("monthList", monthList);
        model.addAttribute("selectedMonth", month);
        model.addAttribute("yearlyTA", yearlyTa);
        model.addAttribute("taJson", mapper.writeValueAsString(taJson));

        return "ta/ta_main";
    }

    @PostMapping("/checkin.do")
    @ResponseBody
    public Map<String, Object> checkIn() {

        Map<String, Object> map = new HashMap<>();

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
    @GetMapping("/admin/ta_confirm")
    public String adminTAMain( String ym, Model model ){

        //선택된 ym(년월)이 없다면 오늘날짜 기준으로 세팅
        if( ym == null || ym.equals("") ){
            ym = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));
        }

        //전체 사원별 해당 년월 TA리스트 불러오기
        List<SalaryClosedVO> attendanceList = tadao.getAllMonthlyTA(ym);

        // 2. 이번 달(ym기준)의 총 평일 수 설정 (보통 주말 제외 21일 ~ 22일)
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM"); //데이트 타입으로 파싱
        YearMonth yearMonth = YearMonth.parse(ym, formatter); //yearmonth객체로 파싱

        LocalDate startOfMonth = yearMonth.atDay(1); //해당 월의 시작일 반환
        LocalDate endOfNextMonth = yearMonth.atEndOfMonth().plusDays(1); //해당 월의 마지막 날짜+1

        //월~금요일 카운트
        int standardDays = (int)startOfMonth.datesUntil(endOfNextMonth)
                        .map(LocalDate::getDayOfWeek)
                        .filter(day -> day != DayOfWeek.SATURDAY && day != DayOfWeek.SUNDAY)
                        .count();

        for(SalaryClosedVO emp : attendanceList ) {
            // DB에서 세어온 실제 출근일수 꺼내기
            int workedDays = Integer.parseInt(String.valueOf(emp.getWorked_days()));
            
            // [결근일수 계산] = 기준일수 - 실제출근일수
            int absenceDays = standardDays - workedDays;
            if(absenceDays < 0) absenceDays = 0; // 혹시 주말 출근 등으로 출근일이 더 많으면 0일 처리
            
            // 3. 계산된 값들을 다시 attendanceList 주입
            emp.setStandard_days(standardDays);
            emp.setAbsence_days(absenceDays);
            
            //sleave_log에서 해당 사원의 이번달 연차 사용 일수 조회
            Map<String, Object> map = new HashMap<>();
            map.put("ym", ym);
            map.put("sabun", emp.getSabun());

            int leaveCnt = sleavedao.getCountPendingTa(map);

            emp.setLeave_days(leaveCnt); 
            emp.setStatus("대기");
        }
        //마감 완료 인원 조회
        int completeCnt = salarydao.getCntClosed(ym);
        //마감 완료된 TA리스트 조회
        List<SalaryClosedVO> confirmedTAList = salarydao.getConfirmedList(ym);

        // 3. 바인딩 및 포워딩
        // model.addAttribute("attendanceList", dummyList); //정산 대상자 목록
        model.addAttribute("selectedYm", ym); //선택 년월
        model.addAttribute("waitCnt", attendanceList.size()); //마감 대기자 수
        model.addAttribute("completeCnt", completeCnt); //마감 완료자 수
        model.addAttribute("confirmedTAList", confirmedTAList); //이달 마감 근태 리스트

        model.addAttribute("attendanceList", attendanceList); //마감 대기 근태 리스트

        return "admin_ta/admin_ta_contirm";
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

    //근태 정보 수정페이지
    @GetMapping("/admin/ta_modify_form")
    public String taModifyForm(int sabun, String ym, Model model){

        if( ym == null ){
            
            //만약 년월 정보가 없다면
            return "redirect:/admin/today_ta/view";

        }

        Map<String, Object> info = new HashMap<>();
        int year;
        int month;

        //년월 정보가 넘어오지 않았다면 (현재 년월로 조회)
        if( ym == null || ym.equals("") || ym.trim().equals("")){

            year = LocalDate.now().getYear();
            month = LocalDate.now().getMonthValue();

            //view.jsp에서 오늘 기준 년월을 뿌려주기 위해 ym에 값 넣어주기
            ym = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));

        }else{ //만약 년월 정보가 넘어왔다면(근태 수정중이라면)

            //해당 년월의 해당직원의 근태 정보만 불러오기
            year = Integer.parseInt(ym.split("-")[0]);
            month = Integer.parseInt(ym.substring(5,7));
        }

        info.put("year", year);
        info.put("month", month);
        info.put("sabun", sabun);
        info.put("orderBy", "desc");

        //해당 사원의 해당 년월 출근기록
        List<TAVO> userTAList = userDao.getMonthlyTA(info);
        //해당 사원의 이름
        SawonVO sawon = sawonDao.selectSawon(sabun);

        model.addAttribute("userTaList",userTAList);
        model.addAttribute("ym", ym);
        model.addAttribute("sawon", sawon);

        return "admin_ta/admin_ta_modify_form";

    }

    //근태 기록 수정
    @PostMapping("/admin/update_ta_list")
    @ResponseBody
    public boolean updateTAReport(String ym, TAVO ta){

        //확인용
        System.out.println("수정할 대상 사번 : " + ta.getSabun() );
        System.out.println("수정할 행 개수 : " + ta.getUserTaList().size());

        boolean res = tadao.updateTaReport(ta);

        return res;

    }

}