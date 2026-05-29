package com.kh.project.controller;

import java.util.HashMap;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.project.dao.DeptDAO;
import com.kh.project.dao.SawonDAO;

import com.kh.project.vo.DeptVO;
import com.kh.project.vo.DcalendarVO;
import com.kh.project.vo.SawonVO;
import com.kh.project.common.PwdSecurity;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
@RequiredArgsConstructor
public class SawonController {
    
    //사원DAO
    private final SawonDAO sawonDao;
    //부서DAO
    private final DeptDAO deptDao;
    //암호화 컴포넌트
    private final PwdSecurity pwdSecurity;

    //전체 사원 목록
    @GetMapping("/sleave.do")
    public String sawonList( Model model ) {
        
        List<SawonVO> list = sawonDao.sawonList();
        model.addAttribute("list", list);
        return "/sawon/sawon_list";
    }


    //사원 추가 폼
    @GetMapping("/sawonAdd")
    public String sawonAddForm(Model model){
        
        //부서 번호조회를 위해 부서 전체
        List<DeptVO> dept = deptDao.selectAll();
        model.addAttribute("dept", dept);

        return "/sawon/sawon_add";
    }

    //사원 추가
    @PostMapping("/sawonAdd")
    @ResponseBody
    public Map<String, Integer> sawonAdd(SawonVO vo){

        //사용자가 입력한 비밀번호 암호화
        String currPwd = pwdSecurity.pwdEncoding(vo.getPwd());

        //암호화 된 비밀번호 VO에 삽입
        vo.setPwd(currPwd);

        //db에 추가 됐으면 1 아니라면 0
        int result = sawonDao.sawonInsert(vo);

        Map<String, Integer> map = new HashMap<>();
        map.put("result", result);

        return map;
    }


    @GetMapping("/dcal_insert.do")
    public String dcalendarForm(int sabun, Model model){

        SawonVO vo = sawonDao.sawonView(sabun); 
        LocalDate today = LocalDate.now();

        model.addAttribute("today", today);
        model.addAttribute("vo", vo);

        return"calendar/calendar_dcal_insert_form";
    }
    
    
}
