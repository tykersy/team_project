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

import com.kh.project.dao.DeptDAO;
import com.kh.project.dao.SawonDAO;
import com.kh.project.vo.DeptVO;
import com.kh.project.vo.OrgChartVO;
import com.kh.project.vo.SawonVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class DeptController {
    
    //부서DAO
    private final DeptDAO deptdao;
    //사원DAO
    private final SawonDAO sawonDao;

    @Autowired
    HttpSession session;
    
    // 조직도 화면을 보여주는 컨트롤러 메서드
    @GetMapping("/org_chart")
    public String showOrgChart(Model model) {
        // DB에서 부서별 사원 맵 리스트 가져오기
        List<Map<String, Object>> orgList = deptdao.getDeptOrgChart();
        
        model.addAttribute("orgList", orgList);
        
        return "dept/org_chart"; 
    }

    @GetMapping("/api/orgList")
    @ResponseBody
    public List<Map<String, Object>> getOrgChartData() {
        
        return deptdao.getOrgChartData();
    }

    //관리자-부서 관리 페이지 
    @GetMapping("/admin/deptlist")
    public String adminDeptMain(Model model){

        //전체 부서 리스트 조회
        List<DeptVO> deptlist = deptdao.selectAll();
        //부서별 인원 조회
        List<Map<String, Object>> memberCnt = deptdao.deptCntList();
        //전체 부서 수 조회
        int deptCnt = deptdao.deptCnt();
        //최근 충원 부서 조회
        List<Map<String, Object>> cur_deptList = sawonDao.cur_upd_dept();

        //바인딩 및 포워딩
        model.addAttribute("deptlist", deptlist);
        model.addAttribute("memberCnt", memberCnt);
        model.addAttribute("deptcnt", deptCnt);
        model.addAttribute("cur_deptList", cur_deptList);

        return "admin_hr/admin_manage_dept";

    }

    //관리자-부서정보 수정
    @PostMapping("/admin/update_dept")
    @ResponseBody
    public Map<String, Object> updDept(DeptVO vo){

        int res = deptdao.update(vo);

        Map<String, Object> map = new HashMap<>();
        map.put("result", res);

        return map;

    }

    //관리자-부서 번호, 부서이름 중복체크
    @GetMapping("/admin/add_dept")
    @ResponseBody
    public Map<String, Object> check(DeptVO vo){

        DeptVO check = deptdao.selectCheck(vo);
        String result = "";
        if( check == null ){
            result = "can";
        }else{
            result = "cannot";
        }

        Map<String, Object> map = new HashMap<>();
        map.put("result", result);

        return map;

    }

    //관리자- 부서 등록
    @PostMapping("/admin/add_dept")
    @ResponseBody
    public Map<String, Object> insertDept( DeptVO vo ){

        int res = deptdao.insertDept(vo);

        Map<String, Object> map = new HashMap<>();
        map.put("result", res);

        return map;

    }

    //부서 삭제
    @GetMapping("/admin/delete_dept")
    @ResponseBody
    public Map<String, Integer> deleteDept( String dname ){

        int res = deptdao.deleteDept(dname);

        Map<String, Integer> map = new HashMap<>();
        map.put("result", res);

        return map;

    }

    //조직도
    @GetMapping("dept_chart.do")
    public String showChart(Model model){

        if(session.getAttribute("user") == null){
            return "redirect:/login";
        }

        List<OrgChartVO> chartList = deptdao.chartList();

        model.addAttribute("chartList", chartList);

        return"dept/dept_chart";
    }

    //부서 추가시 부서번호 자동 배정을 위한 로직
    @GetMapping("/admin/getDeptno")
    @ResponseBody
    public Map<String, Integer> getNewDeptno(){

        //제일 큰 수를 가진 deptno가져와 10을 추가
        int biggestDeptno = deptdao.getBiggestDeptno() + 10;

        Map<String, Integer> map = new HashMap<>();
        map.put("result", biggestDeptno);

        return map;

    }

}
