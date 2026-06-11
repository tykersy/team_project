package com.kh.project.controller;

import java.time.LocalDate;
import java.util.HashMap;
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
import com.kh.project.dao.UserDAO;
import com.kh.project.vo.DeptVO;
import com.kh.project.vo.TAVO;

import jakarta.websocket.OnClose;


@Controller
@RequiredArgsConstructor
public class AdminController {

    private final TADAO tadao;
    private final DeptDAO deptdao;
    private final UserDAO userdao;
    
    @GetMapping("/admin_main.do")
    public String toMain(Model model) {

        Map<String, Integer> todayTa = tadao.totalAllTa();
        model.addAttribute("todayTa", todayTa);
        
        return "/admin_main/main";
    }

    //일일 근태 현황 페이지
    @GetMapping("/admin_main.do/today_ta")
    public String todayTA(Model model){ //Integer를 사용 하면 null 체크 가능

        List<DeptVO> deptList = deptdao.selectAll(); 
        
        model.addAttribute("deptList", deptList);

        return "admin_ta/admin_today_ta";
    }

    //부서별 근태 현황 페이지
    @GetMapping("/admin_main.do/today_ta/data")
    @ResponseBody
    public List<Map<String, Object>> loadTA(Integer deptno){
        return tadao.selectDeptTA(deptno);
    }

    //사원 근태 현황
    @GetMapping("/admin_main.do/today_ta/view")
    public String sawonTaView(Model model, int sabun){
        Map<String, Object> info = new HashMap<>();
        int year = LocalDate.now().getYear();
        info.put("sabun", sabun);
        info.put("year", year);
        info.put("orderBy", "desc");

        List<TAVO> userTAList = userdao.getMonthlyTA(info);
        model.addAttribute("userTaList",userTAList);

        return "admin_ta/admin_ta_view";
    }


    
    

}
