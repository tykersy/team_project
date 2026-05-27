package com.kh.project.controller;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.project.dao.UserDAO;
import com.kh.project.vo.SawonVO;

import jakarta.servlet.http.HttpSession;

import com.kh.project.common.PwdSecurity;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class UserContorller {

    //userDAO
    private final UserDAO userDao;
    //암호화 복호화
    private final PwdSecurity pwdSecurity;

    //세션으로 로그인 유무 확인 
    @Autowired
    private HttpSession session;

    //로그인 폼
    @GetMapping("/login")
    public String loginForm(){
        return "/user/login";
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
    public String mypage(Model model){
        
        //세션에 저장된 사번으로 유저 정보 조회
        int sabun = (int) session.getAttribute("user");
        SawonVO userInfo = userDao.selectUser(sabun);

        model.addAttribute("info", userInfo);

        return "/user/mypage";
    }




    
}
