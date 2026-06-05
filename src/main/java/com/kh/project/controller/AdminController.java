package com.kh.project.controller;

import org.springframework.stereotype.Controller;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;


@Controller
@RequiredArgsConstructor
public class AdminController {
    
    @GetMapping("/admin_main.do")
    public String toMain() {
        
        return "/admin_main/main";
    }
    

}
