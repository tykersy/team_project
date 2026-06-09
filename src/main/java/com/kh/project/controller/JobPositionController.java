package com.kh.project.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.project.dao.DeptDAO;
import com.kh.project.dao.JobPositionDAO;
import com.kh.project.dao.SawonDAO;
import com.kh.project.vo.JobPositionVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class JobPositionController {
    
    //직급DAO
    private final JobPositionDAO jobPositionDao;
    //부서DAO
    private final DeptDAO deptDao;
    //사원DAO
    private final SawonDAO sawonDao;

    //관리자-부서/직급 관리 페이지
    @GetMapping("/admin_hr")
    public String hrMain(Model model){

        //전체 직급 목록 조회
        List<JobPositionVO> jobList = jobPositionDao.allJob();
        //직급별 사원 수 조회
        List<Map<String, String>> positionCnt = jobPositionDao.position_cnt();
        //직급 갯수 조회
        int jobCnt = jobPositionDao.job_cnt();
        // 전체 부서 갯수 조회
        int deptCnt = deptDao.deptCnt();
        // 전체 사원 수 조회
        int sawonCnt = sawonDao.sawonCnt();
        //부서별 사원 수 조회
        List<Map<String, Object>> deptCntList = deptDao.deptCntList();

        //바인딩 및 포워딩
        model.addAttribute("jobList", jobList);
        model.addAttribute("positionCnt", positionCnt);
        model.addAttribute("jobCnt", jobCnt);
        model.addAttribute("deptCnt", deptCnt);
        model.addAttribute("sawonCnt", sawonCnt);
        model.addAttribute("deptCntList", deptCntList);

        return "admin_hr/admin_hr_main";

    }

    

}
