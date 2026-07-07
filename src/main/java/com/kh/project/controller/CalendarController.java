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
import com.kh.project.dao.SawonDAO;
import com.kh.project.vo.DcalendarVO;
import com.kh.project.vo.ScalendarVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CalendarController {

    private final CalendarDAO calendardao;
    private final SawonDAO sawondao;

    @Autowired
    HttpSession session;
    
    @GetMapping("/calendar_calendarmain")
    public String calendarMain(Integer year, Integer month, Model model){

        int sabun = (int)session.getAttribute("user");

        boolean isLeader = calendardao.isLeader(sabun) > 0;
    
        LocalDate today = LocalDate.now();

        if (year == null) year = today.getYear();
        if (month == null) month = today.getMonthValue();

        LocalDate firstDay = LocalDate.of(year, month, 1);

        int lastDay = firstDay.lengthOfMonth();

        int startBlank = firstDay.getDayOfWeek().getValue() % 7;

        LocalDate prev = firstDay.minusMonths(1);
        LocalDate next = firstDay.plusMonths(1);

        int deptno = calendardao.selectDeptnoBySabun(sabun);
        String sajob = sawondao.selectSajob(sabun);

        LocalDate monthStart = LocalDate.of(year, month, 1);
        LocalDate monthEnd = monthStart.withDayOfMonth(monthStart.lengthOfMonth());

        Map<String, Object> param = new HashMap<>();
        param.put("deptno", deptno);
        param.put("sabun", sabun);
        param.put("monthStart", monthStart.toString());
        param.put("monthEnd", monthEnd.toString());

        List<DcalendarVO> dcalList;
            if (sabun == 1) {
                dcalList = calendardao.selectDcalAllByMonth(param);
            } else {
                dcalList = calendardao.selectDcalByDeptno(param);
            }
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

        LocalDate prevMonth = firstDay.minusMonths(1);
        int prevLastDay = prevMonth.lengthOfMonth();

        int totalCell = startBlank + lastDay;
        int endBlank = totalCell % 7 == 0 ? 0 : 7 - (totalCell % 7);

        model.addAttribute("isLeader", isLeader);

        model.addAttribute("sajob", sajob);
        model.addAttribute("prevLastDay", prevLastDay);
        model.addAttribute("endBlank", endBlank);

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

    @PostMapping("/delete_schedule.do")
    @ResponseBody
    public Map<String, Object> deleteSchedule(int idx, String type){

        Map<String, Object> map = new HashMap<>();

        int loginSabun = (int) session.getAttribute("user");

        int writerSabun = 0;

        if(type.equals("dcal")){
            writerSabun = calendardao.selectDcalWriter(idx);
        }else{
            writerSabun = calendardao.selectScalWriter(idx);
        }

        if(loginSabun != writerSabun){
            map.put("status", "forbidden");
            return map;
        }

        int res = 0;

        if(type.equals("dcal")){
            res = calendardao.deleteDcal(idx);
        }else{
            res = calendardao.deleteScal(idx);
        }

        map.put("status", res > 0 ? "success" : "fail");

        return map;
    }

    @GetMapping("/schedule_modify.do")
    public String modifyForm(int idx,
                            String type,
                            Model model){

        if(type.equals("dcal")){

            DcalendarVO vo =
                calendardao.selectOneDcal(idx);

            model.addAttribute("vo", vo);

            return "calendar/dcal_modify_form";
        }

        ScalendarVO vo =
            calendardao.selectOneScal(idx);

        model.addAttribute("vo", vo);

        return "calendar/scal_modify_form";
    }

    @PostMapping("/update_dschedule.do")
    @ResponseBody
    public Map<String,Object> updateDschedule(DcalendarVO vo){

        Map<String,Object> map = new HashMap<>();

        int res = calendardao.updateDcal(vo);

        map.put("status",
                res > 0 ? "success" : "fail");

        return map;
    }

    @PostMapping("/update_sschedule.do")
    @ResponseBody
    public Map<String,Object> updateSschedule(ScalendarVO vo){

        Map<String,Object> map = new HashMap<>();

        int res = calendardao.updateScal(vo);

        map.put("status",
                res > 0 ? "success" : "fail");

        return map;
    }

}
