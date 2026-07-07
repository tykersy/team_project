package com.kh.project.controller;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.project.dao.DeptDAO;

@Controller
public class OrgChartController {
    
    @Autowired
    private DeptDAO deptDAO;

    @Autowired
    private SqlSession sqlSession;

    @GetMapping("/dept/org_chart")
    public String orgChart(Model model) {
        // DB에서 조회한 데이터를 리스트 형태로 가져옴
        List<Map<String, Object>> list = sqlSession.selectList("dept.selectOrgChart");
        model.addAttribute("orgList", list);
        return "dept/org_chart";
    }
}