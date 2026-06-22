package com.kh.project.dao;

import com.kh.project.vo.SalaryContractVO;

public interface SalaryDAO {
    
    // 해당 사번의 계약서 정보 조회
    SalaryContractVO getContractBySabun(int sabun);

    // 새로운 근로계약 정보 등록
    int insertContract(SalaryContractVO vo);

}
