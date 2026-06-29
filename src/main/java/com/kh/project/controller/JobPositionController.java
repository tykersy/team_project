package com.kh.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.project.dao.DeptDAO;
import com.kh.project.dao.JobPositionDAO;
import com.kh.project.dao.SawonDAO;
import com.kh.project.vo.JobPositionVO;
import com.kh.project.vo.SawonVO;

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
    @GetMapping("/admin/hr")
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

    @GetMapping("/admin/job_position")
    public String jobPositionMain(Model model){

        //직급별 사원 수 조회
        List<Map<String, String>> positionCnt = jobPositionDao.position_cnt();
        //직급 갯수 조회
        int jobCnt = jobPositionDao.job_cnt();
        //전체 직급 목록 조회
        List<JobPositionVO> jobList = jobPositionDao.allJob();
        //최근 충원 직급 조회
        List<SawonVO> cur_job = sawonDao.cur_upd_position();

        //바인딩 및 포워딩
        model.addAttribute("positionCnt", positionCnt);
        model.addAttribute("jobCnt", jobCnt);
        model.addAttribute("jobList", jobList);
        model.addAttribute("cur_job", cur_job); 

        return "admin_hr/admin_manage_job_position";

    }

    //직급 추가 전 직급명 중복 체크
    @GetMapping("/admin/add_job_position")
    @ResponseBody
    public Map<String, Object> add_idCheck( String job_id, String sajob ){

        JobPositionVO vo = new JobPositionVO();

        //방어코드
        if( job_id != null && !job_id.equals("") ) {
            int num_jobid = Integer.parseInt(job_id);
            vo.setJob_id(num_jobid);
        }else{
            vo.setJob_id(0);
        }
        vo.setSajob(sajob);
        
        
        JobPositionVO res = jobPositionDao.chId(vo);

        Map<String, Object> map = new HashMap<>();
        map.put("result", res);
        
        return map;

    }

    //직급 추가
    @PostMapping("/admin/add_job_position")
    @ResponseBody
    public Map<String, Integer> add_job_position( JobPositionVO vo ){

        int res = jobPositionDao.insert(vo);

        Map<String, Integer> map = new HashMap<>();
        map.put("result", res);

        return map;

    }

    //직급 정보 수정
    @PostMapping("/admin/update_job_position")
    @ResponseBody
    public Map<String, Object> updatePosition(JobPositionVO vo, String ori_job_id){

        System.out.println("=== 직급 수정 컨트롤러 진입 ===");
        System.out.println("기존 오리지널 ID (ori_job_id): " + ori_job_id);
        System.out.println("새로 변경할 ID (vo.getJob_id()): " + vo.getJob_id());
        System.out.println("새로 변경할 직급명 (vo.getSajob()): " + vo.getSajob());

        Map<String, Object> map = new HashMap<>();
        map.put("job_id", vo.getJob_id());
        map.put("sajob", vo.getSajob());
        map.put("ori_job_id", ori_job_id);

        int res = jobPositionDao.update(map);

        map.put("result", res);
        
        return map;

    }

    //직급 삭제
    @GetMapping("/admin/del_job_position")
    public String deleteJobPosition(int job_id){

        int res = jobPositionDao.delete(job_id);

        return "redirect:/admin/job_position";

    }

}
