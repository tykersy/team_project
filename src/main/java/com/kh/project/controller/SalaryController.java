package com.kh.project.controller;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;

import com.kh.project.dao.TADAO;
import com.kh.project.vo.SalaryClosedVO;
import com.kh.project.vo.SalaryLedgerVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class SalaryController {
    
    private final TADAO tadao;

    public boolean closeEmployeeAttendance(String ym, String sabun){

        // 1. 해당 사원의 이달 근태 통계 실시간 조회 (우리가 방금 성공한 쿼리 호출)
        List<SalaryClosedVO> list = tadao.getAllMonthlyTA(ym);
        SalaryClosedVO sawon = null;

        //사번이 파라미터로 넘어오지 않았을 경우
        if( sabun == null || sabun == "" ){
            System.out.println("사번 정보가 없음");
            return false;
        }

        //근태 마감처리를 원하는 사원의 정보를 받아온다
        for( SalaryClosedVO s : list ){
            if( Integer.parseInt(sabun) == (s.getSabun()) ){
                sawon = s;
                break;
            }
        }

        //해당 사원의 정보가 없다면
        if( sawon == null ){
            return false;
        }

        //2. 기본 근태 정보 넣기 (1번과 동일)
        int standardDays = 22; //기본 근무일수
        int workedDays = Integer.parseInt(String.valueOf(sawon.getWorked_days()));
        int overtimeHours = (int) Double.parseDouble(String.valueOf(sawon.getOvertime_hours()));
        int absenceDays = standardDays - workedDays;
        
        //결근 일수 계산 값이 0보다 작을 때는 0으로 설정
        if( absenceDays < 0 ){
            absenceDays = 0;
        }

        //마감 데이터 DB저장용 파라미터 값 입력
        sawon.setClosed_ym(ym);
        sawon.setStandard_days(standardDays);
        sawon.setAbsence_days(absenceDays);
        sawon.setLeave_days(0); //임시로 0 으로 줌

        //세팅된 정보를 salary_closed_attendance테이블에 저장
        tadao.insertClosedAttendance(sawon);

        //사원의 연봉에 따른 급여 계산
        long baseSalary = 3000000; //기본급 300만원으로 가정 (임시데이터 사용해서 DB에서 불러와보기***)
        long mealAllowance = 200000; //식대 20만원으로 가정

        //결근 일수에 따른 기본급 차감 
        long absenceDeduction = (baseSalary / standardDays ) * absenceDays;
        long finalBasePay = baseSalary - absenceDeduction;

        //연장근무 수당 계산 (기본 시급의 1.5배)
        double hourlyWage = baseSalary / 209.0;
        long overtimePay = (long) (hourlyWage * 1.5 * overtimeHours);

        //과세 총액 (수당 포함 기본급)
        long totalTaxablePay = finalBasePay + overtimePay;

        //4대 보험 및 세금 공제 계산(2026년 기준)
        long nationalPension = (long) (totalTaxablePay * 0.045);     //국민연금 4.5%
        long healthInsurance = (long) (totalTaxablePay * 0.03545);   // 건강보험 3.545%
        long longTermCare = (long) (healthInsurance * 0.1295);       // 장기요양보험
        long employmentInsurance = (long) (totalTaxablePay * 0.009); // 고용보험 0.9%
        long incomeTax = (long) (totalTaxablePay * 0.015);           // 근로소득세 (약식 1.5%)
        long localIncomeTax = (long) (incomeTax * 0.1);
        
        long totalDeductions = nationalPension + healthInsurance + longTermCare
                                +employmentInsurance + incomeTax + localIncomeTax;

        //최종 실지급액 계산
        long netPay = (finalBasePay + overtimePay + mealAllowance) - totalDeductions;
        
        //계산된 모든 값들을 급여명세서 테이블에 넣기 위해 값 넣기
        SalaryLedgerVO vo = null;

        vo.setPay_ym(ym);
        vo.setSabun(Integer.parseInt(sabun));
        //모든 값들은 소수점2자리까지만 사용하도록 값 수정
        vo.setBase_pay(Integer.parseInt(String.format("%.2f", baseSalary)));
        vo.setOvertime_pay(Integer.parseInt(String.format("%.2f", overtimePay)));
        vo.setMeal_pay(Integer.parseInt(String.format("%.2f", mealAllowance)));
        vo.setNational_pension(Integer.parseInt(String.format("%.2f", nationalPension)));
        vo.setHealth_insurance(Integer.parseInt(String.format("%.2f", healthInsurance)));
        vo.setLong_term_care(Integer.parseInt(String.format("%.2f", longTermCare)));
        vo.setEmployment_insurance(Integer.parseInt(String.format("%.2f", employmentInsurance)));
        vo.setIncome_tax(Integer.parseInt(String.format("%.2f", incomeTax)));
        vo.setLocal_income_tax(Integer.parseInt(String.format("%.2f", localIncomeTax)));
        vo.setNet_pay(Integer.parseInt(String.format("%.2f", netPay)));

        //vo에 담은 정보를 insert하기위해서 insert메서드 호출
        tadao.insertSalaryLedger(vo);

        return true;
    }

}
