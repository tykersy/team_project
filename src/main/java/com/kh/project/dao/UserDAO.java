package com.kh.project.dao;

import java.util.List;
import java.util.Map;

import com.kh.project.vo.SalaryContractVO;
import com.kh.project.vo.SawonVO;
import com.kh.project.vo.TAVO;
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

    // 마이페이지 근태 현황 조회
    List<Map<String, Object>> getYearlyTa(Map<String, Object> map);

    //
    List<TAVO> getMonthlyTA(Map<String, Object> info);

    //비밀번호 변경
    int changePW(UserVO vo);
}
