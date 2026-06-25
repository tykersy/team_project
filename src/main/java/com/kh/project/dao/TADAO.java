package com.kh.project.dao;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import com.kh.project.vo.SalaryClosedVO;
import com.kh.project.vo.SalaryLedgerVO;
import com.kh.project.vo.SleaveLogVO;
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

    //관리자 사원별 해당 연월 근태 불러오기
    List<SalaryClosedVO> getAllMonthlyTA(String ym);

    int insertClosedAttendance(SalaryClosedVO vo);

    int insertSalaryLedger(SalaryLedgerVO vo);

    //해당 년월의 근태 마감 여부 확인
    String alreadyApproved(Map<String, Object> map);

    //해당 사원의 근태기록 수정
    boolean updateTaReport(TAVO ta);

    //관리자 메인페이지 부서별 연차 소진율
    List<Map<String, Object>> selectDeptAnnualUseAvg();

    //관리자 메인페이지 출근율
    Double selectTodayCommuteAvg();

    //관리자 메인페이지 퇴사자
    int selectMonthLeaveSawon(LocalDate date);

    //관리자 메인페이지 입사자 조회
    int selectMonthJoinedSawon(LocalDate date);

} 