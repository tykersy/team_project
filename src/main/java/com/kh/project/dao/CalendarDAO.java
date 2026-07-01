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

    int selectDcalWriter(int dcal_idx);

    int selectScalWriter(int scal_idx);

    int deleteDcal(int dcal_idx);

    int deleteScal(int scal_idx);

    DcalendarVO selectOneDcal(int dcal_idx);

    ScalendarVO selectOneScal(int scal_idx);   
    
    int updateDcal(DcalendarVO vo);

    int updateScal(ScalendarVO vo);

    // [추가] 대시보드 오늘 일정 조회용 메서드
    List<CalendarVO> selectDeptToday(int deptno);

    int isLeader(int sabun);
    
} 