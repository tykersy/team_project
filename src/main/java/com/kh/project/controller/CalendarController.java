package com.kh.project.controller;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.project.dao.CalendarDAO;
import com.kh.project.vo.DcalendarVO;
import com.kh.project.vo.ScalendarVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CalendarController {

    private final CalendarDAO calendardao;

    @Autowired
    HttpSession session;
    
    @GetMapping("/calendar_calendarmain")
    public String calendarMain(Integer year, Integer month, Model model){

        if(session.getAttribute("user") == null){
            return "redirect:/login";
        }

        int sabun = (int)session.getAttribute("user");
    
        LocalDate today = LocalDate.now();

        if (year == null) year = today.getYear();
        if (month == null) month = today.getMonthValue();

        LocalDate firstDay = LocalDate.of(year, month, 1);

        int lastDay = firstDay.lengthOfMonth();

        int startBlank = firstDay.getDayOfWeek().getValue() % 7;

        LocalDate prev = firstDay.minusMonths(1);
        LocalDate next = firstDay.plusMonths(1);

        int deptno = calendardao.selectDeptnoBySabun(sabun);

        LocalDate monthStart = LocalDate.of(year, month, 1);
        LocalDate monthEnd = monthStart.withDayOfMonth(monthStart.lengthOfMonth());

        Map<String, Object> param = new HashMap<>();
        param.put("deptno", deptno);
        param.put("sabun", sabun);
        param.put("monthStart", monthStart.toString());
        param.put("monthEnd", monthEnd.toString());

        List<DcalendarVO> dcalList = calendardao.selectDcalByDeptno(param);
        List<ScalendarVO> scalList = calendardao.selectScalBySabun(param);

        for(DcalendarVO vo : dcalList){

            LocalDate start =
                LocalDate.parse(vo.getStart_date().substring(0, 10));

            LocalDate end =
                LocalDate.parse(vo.getEnd_date().substring(0, 10));

            vo.setViewStartDay(
                start.isBefore(monthStart) ? 1 : start.getDayOfMonth()
            );

            vo.setViewEndDay(
                end.isAfter(monthEnd) ? monthEnd.getDayOfMonth() : end.getDayOfMonth()
            );
        }

        for(ScalendarVO vo : scalList){

            LocalDate start =
                LocalDate.parse(vo.getStart_date().substring(0, 10));

            LocalDate end =
                LocalDate.parse(vo.getEnd_date().substring(0, 10));

            vo.setViewStartDay(
                start.isBefore(monthStart) ? 1 : start.getDayOfMonth()
            );

            vo.setViewEndDay(
                end.isAfter(monthEnd) ? monthEnd.getDayOfMonth() : end.getDayOfMonth()
            );
        }

        model.addAttribute("sabun", sabun);
        model.addAttribute("deptno", deptno);
        model.addAttribute("dcalList", dcalList);
        model.addAttribute("scalList", scalList);

        model.addAttribute("todayYear", today.getYear());
        model.addAttribute("todayMonth", today.getMonthValue());
        model.addAttribute("todayDay", today.getDayOfMonth());

        model.addAttribute("year", year);
        model.addAttribute("month", month);
        model.addAttribute("lastDay", lastDay);
        model.addAttribute("startBlank", startBlank);

        model.addAttribute("prevYear", prev.getYear());
        model.addAttribute("prevMonth", prev.getMonthValue());
        model.addAttribute("nextYear", next.getYear());
        model.addAttribute("nextMonth", next.getMonthValue());

        return "calendar/calendar_main";
    }

    @PostMapping("insert_dschedule.do")
    @ResponseBody
    public Map<String, Object> insertDschedule(DcalendarVO vo){

        Map<String, Object> map = new HashMap<>();

         int res = calendardao.insertDcal(vo);

        if(res > 0){
            map.put("status", "success");
        }else{
            map.put("status", "fail");
        }

        return map; 

    }

    @PostMapping("insert_sschedule.do")
    @ResponseBody
        public Map<String, Object> insertsschedule(ScalendarVO vo){

        Map<String, Object> map = new HashMap<>();

         int res = calendardao.insertScal(vo);

        if(res > 0){
            map.put("status", "success");
        }else{
            map.put("status", "fail");
        }

        return map; 

    }

}
