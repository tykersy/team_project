package com.kh.project.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.project.dao.SawonDAO;
import com.kh.project.vo.SawonVO;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
@RequiredArgsConstructor
public class SawonController {
    
    private final SawonDAO sawonDao;

    //전체 사원 목록
    @GetMapping("/sleave.do")
    public String sawonList( Model model ) {
        
        List<SawonVO> list = sawonDao.sawonList();
        model.addAttribute("list", list);
        return "/sawon/sawon_list";
    }

    
    
}
