package com.kh.project.dao;

import java.util.List;

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
    
} 