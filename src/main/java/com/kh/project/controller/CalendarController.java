package com.kh.project.controller;

import java.time.LocalDate;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.project.dao.CalendarDAO;
import com.kh.project.vo.DcalendarVO;
import com.kh.project.vo.ScalendarVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class CalendarController {

    private final CalendarDAO calendardao;
    
    @GetMapping("/calendar_calendarmain")
    public String calendarMain(Integer year, Integer month, Model model){
        
        List<DcalendarVO> dcal = calendardao.selectDcal();
        List<ScalendarVO> scal = calendardao.selectScal();
    
        LocalDate today = LocalDate.now();

        if (year == null) year = today.getYear();
        if (month == null) month = today.getMonthValue();

        LocalDate firstDay = LocalDate.of(year, month, 1);

        int lastDay = firstDay.lengthOfMonth();

        int startBlank = firstDay.getDayOfWeek().getValue() % 7;

        LocalDate prev = firstDay.minusMonths(1);
        LocalDate next = firstDay.plusMonths(1);

        model.addAttribute("dcal", dcal);
        model.addAttribute("scal", scal);

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

}
