package com.kh.project.dao;


import java.util.List;
import java.util.Map;

import com.kh.project.vo.CalendarVO;
import com.kh.project.vo.DcalendarVO;
import com.kh.project.vo.ScalendarVO;

public interface CalendarDAO {
    
    int insertDcal(DcalendarVO vo);

    int insertScal(ScalendarVO vo);

    int selectDeptnoBySabun(int sabun);

    List<DcalendarVO> selectDcalByDeptno(Map<String, Object> map);

    List<ScalendarVO> selectScalBySabun(Map<String, Object> map);

    List<CalendarVO> selectDept(int deptNo); 
    
} 