package com.kh.project.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.project.dao.SawonDAO;
import com.kh.project.dao.SleaveDAO;
import com.kh.project.vo.SawonVO;
import com.kh.project.vo.SleaveVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class SleaveController {
    
    private final SleaveDAO sleaveDao;
    private final SawonDAO sawonDao;

    //사원별 연차 관리 페이지
    @GetMapping("/sleave/arange.do")
    public String sawonLeave( Model model , int sabun ){

        SleaveVO vo = sleaveDao.sawonLeave(sabun);
        SawonVO sawon = sawonDao.sawonView(sabun);
        model.addAttribute("vo", vo);
        model.addAttribute("sawon", sawon);
        return "/sleave/sawon_leave";
    }    

}
