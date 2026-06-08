package com.kh.project.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.project.dao.DeptDAO;
import com.kh.project.dao.TADAO;
import com.kh.project.vo.DeptVO;

import jakarta.websocket.OnClose;


@Controller
@RequiredArgsConstructor
public class AdminController {

    private final TADAO tadao;
    private final DeptDAO deptdao;
    
    @GetMapping("/admin_main.do")
    public String toMain() {
        
        return "/admin_main/main";
    }

    //일일 근태 현황 페이지
    @GetMapping("/admin_main.do/today_ta")
    public String todayTA(Model model){ //Integer를 사용 하면 null 체크 가능

        List<DeptVO> deptList = deptdao.selectAll(); 

        List<Map<String, Object>> list = tadao.selectDeptTA(1);
        
        model.addAttribute("deptList", deptList);
        model.addAttribute("deptTA", list);

        return "admin_ta/admin_today_ta";
    }

    @GetMapping("/admin_main.do/today_ta/data")
    @ResponseBody
    public List<Map<String, Object>> loadTA(Integer deptno){
        return tadao.selectDeptTA(deptno);
    }
    

}
