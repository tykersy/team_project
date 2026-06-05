package com.kh.project.common;

import org.springframework.security.crypto.bcrypt.BCrypt;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Component;

@Component
public class PwdSecurity {
    private BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    //비밀번호 암호화
    public String pwdEncoding( String pwd ){
        String encodePwd = encoder.encode(pwd);
        return encodePwd;
    }

    //비밀번호 복호화
    public boolean pwdDecoding(String currPwd, String oriPwd){
        //currPwd : 암호화가 안된 현재 비번
        //oriPwd : DB에 저장된 암호화된 비번

        boolean isVaild = BCrypt.checkpw(currPwd, oriPwd);

        return isVaild;
    }
}
