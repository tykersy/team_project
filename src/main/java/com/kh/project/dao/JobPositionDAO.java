package com.kh.project.dao;

import java.util.List;
import java.util.Map;

import com.kh.project.vo.JobPositionVO;

public interface JobPositionDAO {
    
    // 모든 직급 가져오기
    List<JobPositionVO> allJob();

    // 직급별 사원수 조회
    List<Map<String, String>> position_cnt();

    // 직급 갯수 조회
    int job_cnt();
}
