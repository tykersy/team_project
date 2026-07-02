package com.kh.project.dao;

import java.util.List;
import java.util.Map;

import com.kh.project.vo.SalaryContractVO;
import com.kh.project.vo.SalaryLedgerVO;

public interface SalaryDAO {
    
    // 해당 사번의 계약서 정보 조회
    SalaryContractVO getContractBySabun(int sabun);

    // 새로운 근로계약 정보 등록
    int insertContract(SalaryContractVO vo);

    //계약서 DB에 서명정보 추가하기
    int updateSignature(SalaryContractVO contract);

    //사원의 월급명세서 정보 조회
    List<SalaryLedgerVO> getLedgerbySabun(int sabun);

    //사원의 정산 완료된 월급명세서 정보 조회
    SalaryLedgerVO getLedgerinfo(Map<String, Object> map);

    //해당 년월 전체 월급 정산 대상 명세서 리스트
    List<SalaryLedgerVO> needConfirmLedgerList(String ym);

    //해당 년월 정산 대상 명세서 수
    int getCountLedgers(String ym);

    //해당 년월 정산 완료 명세서 수
    int getCountConfirmedLedgers(String ym);

    //월급 정산 마감
    int salaryStatusComplete(int salary_id);

    //필터별 계약서 갯수 조회
    Map<String, Object> getCountsContract();

    //해당 사원의 계약서 디테일 뷰
    SalaryContractVO getContractDetail(int sabun);

    //필터링 된 계약서 리스트 조회
    List<SalaryContractVO> getfilteredList(Map<String, Object> filter);

    //해당 월에 근태 마감된 인원
    int getCntClosed(String ym);

    //서명 대기중인 계약서 조회
    SalaryContractVO getPendingContract(int sabun);
}
