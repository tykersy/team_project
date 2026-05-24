package com.kh.project.controller;

import java.util.List;

import org.apache.ibatis.type.Alias;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.project.dao.DeptDAO;
import com.kh.project.vo.DeptVO;

import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
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


}
