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

    //id,직급명 중복체크
    JobPositionVO chId(JobPositionVO vo);

    //직급 추가
    int insert( JobPositionVO vo );

    //직급 정보 수정
    int update(Map<String, Object> map);
    
    //직급 삭제
    int delete(int job_id);
}
