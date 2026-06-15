package com.kh.project.controller;

import java.time.LocalDate;
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