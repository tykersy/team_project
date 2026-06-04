package com.kh.project.dao;

import java.util.List;
import java.util.Map;

import com.kh.project.vo.ScheduleDTO;

public interface DcalendarDAO {
    
    //부서별 일정 불러오기
    List<ScheduleDTO> selectDept( int deptno );

    //전체 부서 스케쥴 조회
    List<ScheduleDTO> selectAll();

    //부서&날짜별 일정 상세보기
    List<ScheduleDTO> detailView(Map<String, Object> map);

    //전체부서의 날짜별 일정 상세보기
    List<ScheduleDTO> detailViewAll(String date);
}
