package com.kh.project.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.project.dao.SawonDAO;
import com.kh.project.vo.SawonVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MsgController {
    
    private final SawonDAO sawondao;

    @Autowired
    HttpSession session;

    @GetMapping("/msg_member.do")
    public String msgMember(Model model){

        if(session.getAttribute("user") == null){
            return "redirect:/login";
        }

        int sabun = (int)session.getAttribute("user");

        List<SawonVO> list = sawondao.member_list();

        model.addAttribute("sabun", sabun);
        model.addAttribute("list", list);

        return "msg/member";
    }

}
