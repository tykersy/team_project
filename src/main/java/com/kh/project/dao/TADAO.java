package com.kh.project.dao;

import java.util.List;
import java.util.Map;

import com.kh.project.vo.TAVO;

public interface TADAO {

    // 오늘 근태 조회
    TAVO selectToday(int sabun);

    // 출근
    int checkIn(int sabun);

    // 퇴근
    int checkOut(int sabun);

    // 근태 목록
    List<TAVO> selectList(int sabun);

    //관리자 페이지 부서별 근태 현황
    List<Map<String, Object>> selectDeptTA(int deptno);
    
} 