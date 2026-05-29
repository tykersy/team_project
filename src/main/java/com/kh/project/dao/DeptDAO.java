package com.kh.project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.kh.project.vo.DeptVO;

public interface DeptDAO {

    //모든 부서 정보 출력
    List<DeptVO> selectAll();

    //관리자 근무일정 - 부서명 검색
    List<DeptVO> searchDept(String search_name);

    //관리자 근무일정 - 부서번호로 부서정보 불러오기
    DeptVO selectOne(int deptno);

}