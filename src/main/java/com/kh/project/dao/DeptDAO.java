package com.kh.project.dao;

import java.util.List;
import java.util.Map;

import com.kh.project.vo.DeptVO;
import com.kh.project.vo.OrgChartVO;
import com.kh.project.vo.SawonVO;

public interface DeptDAO {
    
    //모든 부서 정보 출력
    List<DeptVO> selectAll();
    
    //관리자 근무일정 - 부서명 검색
    List<DeptVO> searchDept(String search_name);
    
    //관리자 근무일정 - 부서번호로 부서정보 불러오기
    DeptVO selectOne(int deptno);
    
    //조직도 관련 정보
    List<Map<String, Object>> getDeptOrgChart();

    //조직도 데이터를 로드하기 위한 메서드
    List<Map<String, Object>> getOrgChartData();

    //부서별 인원 조회
    Map<String,Object> memberCount();

    //총 부서 갯수 조회
    int deptCnt();

    //부서별 사원 수 조회
    List<Map<String, Object>> deptCntList();

    //부서 정보 수정
    int update(Map<String, Object> map);

    //부서번호, 부서명 중복체크
    DeptVO selectCheck (DeptVO vo);

    //부서 등록
    int insertDept(DeptVO vo);

    //부서 삭제
    int deleteDept(String dname);

    List<OrgChartVO> chartList();
}