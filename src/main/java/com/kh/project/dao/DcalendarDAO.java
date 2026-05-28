package com.kh.project.dao;

import java.util.List;

import com.kh.project.vo.DcalendarVO;
import com.kh.project.vo.ScheduleDTO;

public interface DcalendarDAO {
    
    //부서별 일정 불러오기
    List<ScheduleDTO> selectDept( int deptno );

    //입력받은 일정 등록
    int insert(ScheduleDTO dto);

    //전체 부서 스케쥴 조회
    List<ScheduleDTO> selectAll();
}
