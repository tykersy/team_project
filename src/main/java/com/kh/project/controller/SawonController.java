package com.kh.project.controller;

import java.util.HashMap;
import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import com.kh.project.dao.DeptDAO;
import com.kh.project.dao.JobPositionDAO;
import com.kh.project.dao.SawonDAO;
import com.kh.project.dao.SleaveDAO;
import com.kh.project.vo.DeptVO;
import com.kh.project.vo.JobPositionVO;
import com.kh.project.vo.DcalendarVO;
import com.kh.project.vo.SawonVO;
import com.kh.project.vo.SleaveVO;

import jakarta.servlet.http.HttpSession;

import com.kh.project.common.PwdSecurity;

import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RequestBody;



@Controller
@RequiredArgsConstructor
public class SawonController {

    @Autowired
    HttpSession session;
    
    //사원DAO
    private final SawonDAO sawonDao;
    //부서DAO
    private final DeptDAO deptDao;
    //암호화 컴포넌트
    private final PwdSecurity pwdSecurity;
    //연차DAO
    private final SleaveDAO sleaveDao;
    //직급DAO
    private final JobPositionDAO jobDao;

    //전체 사원 목록
    @GetMapping("/sawon_list.do")
    public String sawonList( Model model ) {
        
        List<SawonVO> list = sawonDao.sawonList();
        model.addAttribute("list", list);
        return "/sawon/sawon_list";
    }


    //사원 추가 폼
    @GetMapping("/sawonAdd")
    public String sawonAddForm(Model model){
        
        //부서 번호조회를 위해 부서 전체
        List<DeptVO> dept = deptDao.selectAll();
        model.addAttribute("dept", dept);

        return "sawon/sawon_add";
    }

    //사원 추가
    @PostMapping("/sawonAdd")
    @ResponseBody
    public Map<String, Integer> sawonAdd(SawonVO vo){

        //사용자가 입력한 비밀번호 암호화
        String currPwd = pwdSecurity.pwdEncoding(vo.getPwd());

        //암호화 된 비밀번호 VO에 삽입
        vo.setPwd(currPwd);

        //db에 추가 됐으면 1 아니라면 0
        int result = sawonDao.sawonInsert(vo);

        Map<String, Integer> map = new HashMap<>();
        map.put("result", result);

        return map;
    }


    @GetMapping("/dcal_insert.do")
    public String dcalendarForm( Model model){

        int sabun = (int)session.getAttribute("user");

        SawonVO vo = sawonDao.sawonView(sabun); 
        LocalDate today = LocalDate.now();

        model.addAttribute("today", today);
        model.addAttribute("vo", vo);

        return"calendar/calendar_dcal_insert_form";
    }

    @GetMapping("/scal_insert.do")
    public String scalendarForm( Model model){

        int sabun = (int)session.getAttribute("user");
        
        SawonVO vo = sawonDao.sawonView(sabun);
        LocalDate today = LocalDate.now();

        model.addAttribute("today", today);
        model.addAttribute("vo", vo);

        return"calendar/calendar_scal_insert_form";
    }
    
    
    //사원별 정보 열람 페이지
    @GetMapping("/sawon_view.do")
    public String sawonLeave( Model model , int sabun ){

        SleaveVO vo = sleaveDao.sawonLeave(sabun);
        SawonVO sawon = sawonDao.sawonView(sabun);
        model.addAttribute("vo", vo);
        model.addAttribute("sawon", sawon);
        return "/sawon/sawon_view";
    }

    //사원 삭제
    @GetMapping("/admin_sawon_delete")
    @ResponseBody
    public Map<String, Integer> sawonDelete( int sabun ){

        int res = sawonDao.sawonDelete(sabun);

        Map<String, Integer> map = new HashMap<>(); 
        map.put("result", res);

        return map;
    }

    //사원 정보 수정폼으로 이동
    @GetMapping("/admin_sawon_modify")
    public String sawonModify( Model model , int sabun){

        //수정할 사원 정보 불러오기 (사원 상세보기를 위한 sawonView함수 재활용)
        SawonVO sawon = sawonDao.sawonView(sabun);
        //부서 선택을 위한 부서목록
        List<DeptVO> deptList = deptDao.selectAll();
        //직급 변경 선택을 위한 직급목록
        List<JobPositionVO> jobList = jobDao.allJob();

        System.out.println(jobList);
        
        //바인딩 및 포워딩
        model.addAttribute("sawon", sawon);
        model.addAttribute("deptList", deptList);
        model.addAttribute("jobList", jobList);
        return "/sawon/sawon_modify_form";

    }

    //변경할 비밀번호와 현재 비밀번호의 중복 여부 체크
    @PostMapping("/admin_check_pwd")
    @ResponseBody
    public Map<String, String> checkPwd(SawonVO vo, String new_pwd, String ori_pwd ) {
        
        boolean res = pwdSecurity.pwdDecoding(new_pwd, ori_pwd);

        String resStr;
        if( !res ){
            //기존 비밀번호와 새 비밀번호가 일치하지 않아 변경 가능
            resStr = "possible";
        }else{
            //기존 비밀번호와 새로 입력받은 비밀번호가 일치해서 변경 불가능
            resStr = "impossible";
        }
        
        Map<String, String> map = new HashMap<>();
        map.put("result", resStr);
        return map;
    }
    
    //관리자용 사원 정보 변경
    @PostMapping("/admin_sawon_modify")
    @ResponseBody
    public Map<String, Integer> modifySawonInfo( SawonVO vo, String new_pwd ){

        //새로 입력받은 비밀번호 암호화
        String securedPwd = pwdSecurity.pwdEncoding(new_pwd);
        vo.setPwd(securedPwd);

        int res = sawonDao.sawonUpdate(vo);

        Map<String, Integer> map = new HashMap<>();
        map.put("result", res);

        return map;

    }
}
