package com.kh.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.scheduling.annotation.Scheduled;
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

    @GetMapping("/admin_calendar")
    public String calendarMain( Model model ){

        List<DeptVO> dept_list = deptDao.selectAll();

        model.addAttribute("dept_list", dept_list);
        return "/admin_calendar/schedule_list";

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

    //일정 상세보기 팝업창
    @GetMapping("/schedule_view.do")
    public String toDetailView( int deptno, String date, Model model ){

        List<ScheduleDTO> list;

        //부서번호가 1일 때 ( 전체 부서 스케쥴 상세보기 )
        if( deptno == 1 ){
            list = dcalendarDao.detailViewAll(date);
        }else{

            //선택된 부서가 1개인 경우
            //파라미터로 받은 부서번호, 해당날짜 map에 담아서 파라미터로 보내기
            Map<String, Object> map = new HashMap<>();
            map.put("deptno", deptno);
            map.put("date", date);

            list = dcalendarDao.detailView(map);

            //jsp에서 부서명을 사용하기 위해 부서 번호로 부서정보 가져오기
            DeptVO dept = deptDao.selectOne(deptno);
            model.addAttribute("dept", dept);
        }

        //파라미터로 받은 부서정보와 날짜를 바인딩
        model.addAttribute("deptno", deptno);
        model.addAttribute("date", date);
        model.addAttribute("list", list);

        return "/admin_calendar/schedule_detail_view";

    }

}
