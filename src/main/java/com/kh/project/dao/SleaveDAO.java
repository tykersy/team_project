package com.kh.project.dao;

import java.util.List;
import java.util.Map;

import com.kh.project.vo.SleaveLogVO;
import com.kh.project.vo.SleaveVO;

public interface SleaveDAO {
    
    SleaveVO sawonLeave( int sabun );

    //연차 추가
    int sleaveInsert (int sabun);

    //사원 연차 사용 조회
    List<SleaveLogVO> sleaveLogSelect(int sabun);

    //사원 연차 사용 신청
    int sleave_logApplyInsert(SleaveLogVO vo);

    //사원 연차 사용
    int sleaveApplyUpdate(SleaveLogVO vo);

    // [추가] 오늘 날짜 기준으로 휴가 중인 사원 목록 조회
    List<Map<String, Object>> getDeptVacationList(String today);

    //[추가] 승인 대기건
    int countPendingLeaves();

    //최근 승인 완료된 연차 5개 정보 조회
    List<SleaveLogVO> selectApprovedLeaves();

    //오늘 승인 완료된 연차 갯수 조회
    int countAporovedLeaves();

    //오늘 휴가중인 인원
    int countOnLeaveToday();

    //승인 대기중인 휴가 리스트 조회
    List<SleaveLogVO> selectpendingList();
}
