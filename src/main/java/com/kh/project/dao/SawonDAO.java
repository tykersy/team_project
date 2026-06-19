package com.kh.project.dao;

import java.util.List;
import java.util.Map;

import com.kh.project.vo.SawonVO;

public interface SawonDAO {

    //사원리스트조회
    List<SawonVO> sawonList(); 

    //사번으로 사원 정보 조회
    SawonVO selectSawon(int sabun);

    //사원별 정보 조회
    SawonVO sawonView( int sabun );

    //사원 추가
    int sawonInsert(SawonVO vo);

    //사원 삭제
    int sawonDelete( int sabun );

    //사원 정보 수정
    int sawonUpdate( SawonVO vo );

    //전체 사원 수 조회
    int sawonCnt();

    //최근 입사 부서 조회
    List<Map<String, Object>> cur_upd_dept();

    //최근 입사 직급 조회
    List<SawonVO> cur_upd_position();

    //메신저 직원 조회
    List<SawonVO> member_list();

    SawonVO memberView(int sabun);

    String selectSajob(int sabun);

} 
