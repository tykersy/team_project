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

    @GetMapping(value={"/", "/list.do"})
    public String deptList(Model model){

        List<DeptVO> list = deptdao.selectAll();

        model.addAttribute("list", list);

        return"dept/dept_list";

    } 
    
    // 조직도 화면을 보여주는 컨트롤러 메서드
    @GetMapping("/orgChart")
    public String showOrgChart(Model model) {
        // DB에서 부서별 사원 맵 리스트 가져오기
        List<Map<String, Object>> orgList = deptdao.getDeptOrgChart();
        
        model.addAttribute("orgList", orgList);
        
        return "dept/org_chart"; 
    }


}
