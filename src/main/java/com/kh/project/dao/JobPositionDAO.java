package com.kh.project.dao;

import java.util.List;

import com.kh.project.vo.JobPositionVO;

public interface JobPositionDAO {
    
    // 모든 직급 가져오기
    List<JobPositionVO> allJob();

}
