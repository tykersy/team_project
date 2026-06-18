package com.kh.project.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.project.dao.SleaveDAO;
import com.kh.project.dao.UserDAO;
import com.kh.project.vo.CalendarDayVO;
import com.kh.project.vo.SawonVO;
import com.kh.project.vo.SleaveLogVO;
import com.kh.project.vo.SleaveVO;
import com.kh.project.vo.TAVO;
import com.kh.project.vo.UserVO;

import jakarta.servlet.http.HttpSession;

import com.kh.project.common.Calendar;
import com.kh.project.common.PwdSecurity;

import lombok.RequiredArgsConstructor;
import tools.jackson.databind.ObjectMapper;

@Controller
@RequiredArgsConstructor
public class UserController {

    //userDAO
    private final UserDAO userDao;
    //sleaveDAO
    private final SleaveDAO sleaveDAO;
    //암호화 복호화
    private final PwdSecurity pwdSecurity;
    //캘린더
    private final Calendar calendar;

    //세션으로 로그인 유무 확인 
    @Autowired
    private HttpSession session;

    //로그인 폼
    @GetMapping("/login")
    public String loginForm(){
        return "user/login";
    }

    //로그인
    @PostMapping("/login")
    @ResponseBody
    public Map<String, String> login(int sabun, String pwd){
        
        SawonVO sawonInfo = userDao.selectUser(sabun);
        //로그인 실패시 넘길 변수
        String result = "fail";


        //null이라면 존재하지 않는 사원으로 fail
        if(sawonInfo != null){
            //사용자가 입력한 비밀번호와 DB에 저장된 암호화된 비밀번호가 일치한지 판단
            if( pwdSecurity.pwdDecoding(pwd, sawonInfo.getPwd()) ){
                //사번 , 비밀번호 모두 일치시 succeed
                result = "succeed";
                
                //로그인 유무를 확인 하기 위한 세션 세팅
                session.setAttribute("user", sawonInfo.getSabun());
                
                session.setAttribute("userId",(long) sawonInfo.getSabun());
                session.setAttribute("userName", sawonInfo.getSaname());
                session.setAttribute("roomId", 1L);
            }else{
                //비밀번호 불일치
                result = "pwdFail";
            }
        }
        
        Map<String, String> map = new HashMap<>();
        map.put("result", result);

        return map;
    }

    //마이페이지
    @GetMapping("/mypage")
    public String mypage(Model model) throws Exception{
        
        //로그인되지 않거나 세션이 만료된 회원이 마이페이지 접근시 로그인 창으로 이동
        if(session.getAttribute("user") == null){
            return "redirect:/login";
        }

        //세션에 저장된 사번으로 유저 정보 조회
        int sabun = (int) session.getAttribute("user");
        
        //오늘 년/월을 구하여 포멧을 지정
        LocalDate now = LocalDate.now();

        Map<String, Object> monthlyTAMap = new HashMap<>();
        monthlyTAMap.put("sabun", sabun);
        monthlyTAMap.put("year", now.getYear());
        monthlyTAMap.put("month", now.getMonthValue()); 
        monthlyTAMap.put("orderBy", "desc");

        UserVO userInfo = userDao.userMyPage(sabun); // 사원 기본 정보
        List<TAVO> userTA = userDao.getMonthlyTA(monthlyTAMap); // 월 출/퇴근 조회
        Map<String,String> userTotalTA = userDao.userTotalTa(sabun); // 총 근무 시간, 일
        SleaveVO userSleave = sleaveDAO.sawonLeave(sabun); // 사원 연차 조회
        List<SleaveLogVO> userSleaveLog = sleaveDAO.sleaveLogSelect(sabun); //사원 연차 사용 조회
        
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy년 MM월");
        String today = now.format(formatter);

        model.addAttribute("info", userInfo);
        model.addAttribute("userTaList", userTA);
        model.addAttribute("userTotalTA", userTotalTA);
        model.addAttribute("today", today);
        model.addAttribute("sleave", userSleave);
        model.addAttribute("leaveLogList", userSleaveLog);
        

        return "user/mypage";
    }

    @PostMapping("/mypage/changePw")
    @ResponseBody
    public Map<String, String> changePw(String newPw){
        Map<String,String> map = new HashMap<>();
        String result = "notLogin";

        //로그인되지 않거나 세션이 만료된 회원이 마이페이지 접근시 로그인 창으로 이동
        if(session.getAttribute("user") == null){
            map.put("result", result);
            return map;
        }

        //세션에 저장된 사번으로 유저 정보 조회
        int sabun = (int) session.getAttribute("user");

        //변경할 비밀번호 암호화
        String currPwd = pwdSecurity.pwdEncoding(newPw);

        UserVO vo = new UserVO();
        vo.setSabun(sabun);
        vo.setPwd(currPwd);

        int resultInt = userDao.changePW(vo);

        if(resultInt == 0){ //비밀번호 변경 실패
            result = "failure";
        }else{ // 비밀번호 변경 성공
            result = "success";
        }

        map.put("result", result);

        return map;

    }

    //로그아웃
    @GetMapping("/logout")
    public String logout(){
        session.removeAttribute("user");
        session.removeAttribute("loginMember");

        return "redirect:/dashboard";
    }

    // 연차 신청
    @PostMapping("/mypage/leaveApply")
    @ResponseBody
    public Map<String, String> userLeaveApply(SleaveLogVO logVo){
        Map<String, String> map = new HashMap<>();
        String resultStr = "login";

        //로그인되지 않거나 세션이 만료된 회원이 마이페이지 접근시 로그인 창으로 이동
        if(session.getAttribute("user") == null){
            map.put("result", resultStr);
            return map;
        }

        //세션에 저장된 사번불러오기
        int sabun = (int) session.getAttribute("user");

        logVo.setSabun(sabun);

        //연차 신청 가능 판단을 위한 조회
        SleaveVO leaveVO = sleaveDAO.sawonLeave(sabun);
        List<SleaveLogVO> leaveLogList = sleaveDAO.sleaveLogSelect(sabun);
        LocalDate startDate = logVo.getUse_date();
        LocalDate endDate = startDate.plusDays(
                logVo.getUse_days() == 0.5 ? 0 : (long)logVo.getUse_days());

        for(SleaveLogVO leavelog : leaveLogList){
            LocalDate existStart = leavelog.getUse_date();
            LocalDate existEnd   = existStart.plusDays(
                leavelog.getUse_days() == 0.5 ? 0 : (long) leavelog.getUse_days() - 1
            );
            // 겹침 조건: 신청시작 <= 기존종료 AND 신청종료 >= 기존시작
            if (!startDate.isAfter(existEnd) && !endDate.isBefore(existStart)) {
                map.put("result", "overlap");  // 날짜 중복
                return map;
            }
        }

        boolean leaveBool = false;
        switch (logVo.getLeave_type()) {
            case "annual": //연차 개수가 1개 이상이면 leaveBool를 true 로 만들어 연차 신청 가능
                if(leaveVO.getAnnual() >= logVo.getUse_days()) leaveBool = true;
                break;
            case "mc":
                if(leaveVO.getMc() >= logVo.getUse_days()) leaveBool = true;
                break;
            case "health":
                if(leaveVO.getHealth() >= logVo.getUse_days()) leaveBool = true;
                break;
            case "etc":
                if(leaveVO.getEtc() >= logVo.getUse_days()) leaveBool = true;
                break;
        }

        if(leaveBool){
            //sleave 테이블 반영
            int resultSleave = sleaveDAO.sleave_logApplyInsert(logVo);

            if(resultSleave == 0){ // 신청 실패
                map.put("result", "failure");
            }else{ // 신청 성공
                map.put("result", "success");
            }
        }else{
            map.put("result", "fail"); //연차 개수 부족
        }

        return map;

    }




    
}
