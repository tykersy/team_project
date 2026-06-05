package com.kh.project.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.project.dao.DeptDAO;
import com.kh.project.vo.DeptVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class DeptController {
    
    private final DeptDAO deptdao;
    
    // 조직도 화면을 보여주는 컨트롤러 메서드
    @GetMapping("/org_chart")
    public String showOrgChart(Model model) {
        // DB에서 부서별 사원 맵 리스트 가져오기
        List<Map<String, Object>> orgList = deptdao.getDeptOrgChart();
        
        model.addAttribute("orgList", orgList);
        
        return "dept/org_chart"; 
    }

    //관리자-부서/조직 관리 메인페이지
    @GetMapping("/admin_dept_main")
    public String adminDeptMain(Model model){

        //부서별 인원 조회
        Map<String,Object> dMemberCount = deptdao.memberCount();

        model.addAttribute("dMemberCount", dMemberCount);

        return "admin/admin_dept_main";

    }

}
