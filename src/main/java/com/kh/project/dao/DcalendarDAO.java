package com.kh.project.dao;

import java.util.List;

import com.kh.project.vo.DcalendarVO;
import com.kh.project.vo.ScheduleDTO;

public interface DcalendarDAO {
    
    //부서별 일정 불러오기
    List<ScheduleDTO> selectDept( int deptno );

}
