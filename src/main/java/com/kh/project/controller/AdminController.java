package com.kh.project.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.project.dao.DeptDAO;
import com.kh.project.dao.SawonDAO;
import com.kh.project.dao.TADAO;
import com.kh.project.dao.UserDAO;
import com.kh.project.vo.DeptVO;
import com.kh.project.vo.SawonVO;
import com.kh.project.vo.TAVO;

import lombok.RequiredArgsConstructor;


@Controller
@RequiredArgsConstructor
public class AdminController {

    private final TADAO tadao;
    private final DeptDAO deptdao;
    private final UserDAO userdao;
    private final SawonDAO sawondao;
    
    @GetMapping("/admin_main.do")
    public String toMain(Model model) {

        Map<String, Integer> todayTa = tadao.totalAllTa();
        model.addAttribute("todayTa", todayTa);
        
        return "/admin_main/main";
    }

    //일일 근태 현황 페이지
    @GetMapping("/admin_main.do/today_ta")
    public String todayTA(Model model){ //Integer를 사용 하면 null 체크 가능

        List<DeptVO> deptList = deptdao.selectAll(); 
        
        model.addAttribute("deptList", deptList);

        return "admin_ta/admin_today_ta";
    }

    //부서별 근태 현황 페이지
    @GetMapping("/admin_main.do/today_ta/data")
    @ResponseBody
    public List<Map<String, Object>> loadTA(Integer deptno){
        return tadao.selectDeptTA(deptno);
    }

    //사원 근태 현황
    @GetMapping("/admin_main.do/today_ta/view")
    public String sawonTaView(Model model, int sabun, String ym){

        Map<String, Object> info = new HashMap<>();
        int year;
        int month;

        //년월 정보가 넘어오지 않았다면 (현재 년월로 조회)
        if( ym == null || ym.equals("") || ym.trim().equals("")){

            year = LocalDate.now().getYear();
            month = LocalDate.now().getMonthValue();

            //view.jsp에서 오늘 기준 년월을 뿌려주기 위해 ym에 값 넣어주기
            ym = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));

        }else{ //만약 년월 정보가 넘어왔다면(근태 수정중이라면)

            //해당 년월의 해당직원의 근태 정보만 불러오기
            year = Integer.parseInt(ym.split("-")[0]);
            month = Integer.parseInt(ym.substring(5,7));
        }

        info.put("year", year);
        info.put("month", month);
        info.put("sabun", sabun);
        info.put("orderBy", "desc");

        //해당 사원의 해당 년월 출근기록
        List<TAVO> userTAList = userdao.getMonthlyTA(info);
        //해당 사원의 이름
        SawonVO sawon = sawondao.selectSawon(sabun);

        model.addAttribute("userTaList",userTAList);
        model.addAttribute("ym", ym);
        model.addAttribute("sawon", sawon);

        return "admin_ta/admin_ta_view";
    }


    
    

}
