package com.kh.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.project.dao.DcalendarDAO;
import com.kh.project.dao.DeptDAO;
import com.kh.project.vo.DeptVO;
import com.kh.project.vo.ScheduleDTO;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;


@Controller
@RequiredArgsConstructor
public class DcalendarController {
    
    private final DcalendarDAO dcalendarDao;
    private final DeptDAO deptDao;

    @GetMapping("/manager_calendar.do")
    public String calendarMain( Model model ){

        List<DeptVO> dept_list = deptDao.selectAll();

        model.addAttribute("dept_list", dept_list);
        return "/manager_calendar/schedule_list";

    }

    @GetMapping("/schedule_deptSchedule.do")
    @ResponseBody
    public Map<String, Object> deptSchedule( int deptno ) {
        
        List<ScheduleDTO> list = dcalendarDao.selectDept(deptno);
        
        Map<String, Object> map = new HashMap<>();
        map.put("list", list); 
        map.put("deptno", deptno);

        return map;
    }
    
    //입력받은 일정 DB에 저장하기
    @PostMapping("/schedule_insert.do")
    @ResponseBody
    public Map<String, String> insertSchedule( ScheduleDTO dto ){

        Map<String, String> map = new HashMap<>();

        int res = dcalendarDao.insert(dto); 

        if(res > 0) {
            map.put("status", "success");
        } else {
            map.put("status", "fail");
        }

        return map;
    }

    //모든 부서 스케쥴 조회
    @GetMapping("/schedule_all.do")
    @ResponseBody
    public Map<String, Object> allSchedule (){

        List<ScheduleDTO> list = dcalendarDao.selectAll();

        Map<String, Object> map = new HashMap<>();
        map.put("list", list);

        return map;

    }

    //부서명 검색
    @GetMapping("/schedule_search.do")
    @ResponseBody
    public Map<String, List<DeptVO>> searchDept( String search_name ){

        System.out.println(search_name);
        List<DeptVO> dlist = deptDao.searchDept( search_name );

        Map<String, List<DeptVO>> map = new HashMap<>();
        map.put("dlist", dlist);

        return map; 

    }

}
