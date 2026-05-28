package com.kh.project.dao;

import java.util.List;
import java.util.Map;

import com.kh.project.vo.SawonVO;
import com.kh.project.vo.UserVO;

public interface UserDAO {
    
    //사원 정보 조회
    SawonVO selectUser(int sabun);

    //마이페이지 조회
    UserVO userMyPage(int sabun);

    // 출 / 퇴근 조회
    List<UserVO> userTa(int sabun);

    // 총 출근시간 및 출근 일 수 조회
    Map<String, String> userTotalTa(int sabun);


}
