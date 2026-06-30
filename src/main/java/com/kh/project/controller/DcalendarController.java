package com.kh.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.project.dao.DcalendarDAO;
import com.kh.project.dao.DeptDAO;
import com.kh.project.vo.DcalendarVO;
import com.kh.project.vo.DeptVO;
import com.kh.project.vo.ScheduleDTO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class DcalendarController {
    
    private final DcalendarDAO dcalendarDao;
    private final DeptDAO deptDao;

    @Autowired
    HttpSession session;

    @GetMapping("/admin/calendar")
    public String calendarMain(Model model) {

        List<DeptVO> dept_list = deptDao.selectAll();

        model.addAttribute("dept_list", dept_list);
        return "/admin_calendar/schedule_list";
    }

    @GetMapping("/admin/schedule_dept")
    @ResponseBody
    public Map<String, Object> deptSchedule(int deptno) {
        
        List<ScheduleDTO> list = dcalendarDao.selectDept(deptno);
        
        Map<String, Object> map = new HashMap<>();
        map.put("list", list); 
        map.put("deptno", deptno);

        return map;
    }

    // 모든 부서 스케쥴 조회
    @GetMapping("/admin/schedule_all")
    @ResponseBody
    public Map<String, Object> allSchedule() {

        List<ScheduleDTO> list = dcalendarDao.selectAll();

        Map<String, Object> map = new HashMap<>();
        map.put("list", list);

        return map;
    }

    // 부서명 검색
    @GetMapping("/admin/schedule_search")
    @ResponseBody
    public Map<String, List<DeptVO>> searchDept(String search_name) {

        System.out.println(search_name);
        List<DeptVO> dlist = deptDao.searchDept(search_name);

        Map<String, List<DeptVO>> map = new HashMap<>();
        map.put("dlist", dlist);

        return map; 
    }

    // 일정 상세보기 모달창
    @GetMapping("/admin/schedule_view")
    @ResponseBody
    public Map<String, Object> toDetailView(int deptno, String date, Model model) {

        List<ScheduleDTO> list;
        Map<String, Object> map = new HashMap<>();

        // 부서번호가 1일 때 ( 전체 부서 스케쥴 상세보기 )
        if (deptno == 1) {
            list = dcalendarDao.detailViewAll(date);
        } else {
            // 선택된 부서가 1인 경우 (전체 부서 일정 조회)
            // 파라미터로 받은 부서번호, 해당날짜 map에 담아서 파라미터로 보내기
            map.put("deptno", deptno);
            map.put("date", date);

            list = dcalendarDao.detailView(map);

            // jsp에서 부서명을 사용하기 위해 부서 번호로 부서정보 가져오기
            DeptVO dept = deptDao.selectOne(deptno);
            map.put("dept", dept);
        }

        // map에 list담기
        map.put("list", list);

        return map;
    }

    @PostMapping("/admin/schedule_insert")
    @ResponseBody
    public Map<String, Object> insertSchedule(DcalendarVO vo){
        int sabun = (Integer) session.getAttribute("user");
        vo.setSabun(sabun);
        
        int res = dcalendarDao.insertSchedule(vo);

        Map<String,Object> map = new HashMap<>();
        map.put("result", res>0?"success":"fail");

        return map;
    }

    @PostMapping("/admin/schedule_delete")
    @ResponseBody
    public Map<String, Object> deleteSchedule(int dcal_idx){
        int res = dcalendarDao.deleteSchedule(dcal_idx);

        Map<String, Object> map = new HashMap<>();
        map.put("result", res>0?"success":"fail");

        return map;
    }
}