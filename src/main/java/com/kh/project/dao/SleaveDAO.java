package com.kh.project.dao;

import java.util.List;

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

}
