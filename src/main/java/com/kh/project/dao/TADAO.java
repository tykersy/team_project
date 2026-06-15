package com.kh.project.dao;

import java.util.List;
import java.util.Map;

import com.kh.project.vo.SalaryClosedVO;
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

    //관리자 메인페이지 오늘 근태 현황
    Map<String, Integer> totalAllTa();

    //관리자 근태 마감 처리를 위한 근태정보 불러오기
    SalaryClosedVO selectTaConfirm(Map<String, Object> map);

} 