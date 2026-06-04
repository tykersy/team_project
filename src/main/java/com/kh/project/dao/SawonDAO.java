package com.kh.project.dao;

import java.util.List;

import com.kh.project.vo.SawonVO;

public interface SawonDAO {

    //사원리스트조회
    List<SawonVO> sawonList(); 

    //사원별 정보 조회
    SawonVO sawonView( int sabun );

    //사원 추가
    int sawonInsert(SawonVO vo);

} 
