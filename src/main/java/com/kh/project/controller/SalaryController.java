package com.kh.project.controller;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.project.dao.SalaryDAO;
import com.kh.project.dao.SawonDAO;
import com.kh.project.dao.TADAO;
import com.kh.project.vo.SalaryClosedVO;
import com.kh.project.vo.SalaryContractVO;
import com.kh.project.vo.SalaryLedgerVO;
import com.kh.project.vo.SawonVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class SalaryController {
    
    private final TADAO tadao;
    private final SalaryDAO salaryDao;
    private final SawonDAO sawonDao;

    //근태 마감 처리 (한명)
    @PostMapping("/admin_taclose")
    @ResponseBody
    public boolean closeEmployeeAttendance(String ym, String sabun){

        // 1. 해당 사원의 이달 근태 통계 실시간 조회 (우리가 방금 성공한 쿼리 호출)
        List<SalaryClosedVO> list = tadao.getAllMonthlyTA(ym);
        SalaryClosedVO sawon = null;

        //사번이 파라미터로 넘어오지 않았을 경우
        if( sabun == null || sabun.trim().isEmpty() || sabun.equals("") 
            || ym == null || ym.trim().isEmpty() ){
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

        //만약 list에 조회하려는 사원 정보가 없다면 진행xx
        if( sawon == null ){
            System.out.println("해당 사원의 근태 통계 데이터를 찾을 수 없습니다");
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

        //사원의 연봉계약 정보 가져오기
        SalaryContractVO contract = salaryDao.getContractBySabun(Integer.parseInt(sabun));

        //사원의 연봉에 따른 급여 계산
        long baseSalary = 0;
        long mealAllowance = 0; 

        if( contract != null ){
            //해당 사번의 계약서가 존재한다면
            baseSalary = contract.getBase_salary();
            mealAllowance = contract.getMeal_allowance();
        }else{
            //해당 사번의 계약서가 존재하지 않는다면
            System.out.println(sabun + "번 사원의 유효한 계약 정보가 없습니다. 기본 값으로 계산 됩니다.");
            baseSalary = 2500000; //최저 기본급 (***가능하면 시스템에서 수정 가능하게끔? 구현예정)
            mealAllowance = 200000; //기본 식대 설정 (***가능하면 시스템에서 수정 가능하게끔? 구현예정)
        }

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
        SalaryLedgerVO vo = new SalaryLedgerVO();

        vo.setPay_ym(ym);
        vo.setSabun(Integer.parseInt(sabun));
        //모든 값들은 소수점2자리까지만 사용하도록 값 수정
        vo.setBase_pay((int) baseSalary);
        vo.setOvertime_pay(((int) overtimePay));
        vo.setMeal_pay((int) mealAllowance);
        vo.setNational_pension((int) nationalPension);
        vo.setHealth_insurance((int) healthInsurance);
        vo.setLong_term_care((int) longTermCare);
        vo.setEmployment_insurance((int) employmentInsurance);
        vo.setIncome_tax((int) incomeTax);
        vo.setLocal_income_tax((int) localIncomeTax);
        vo.setNet_pay((int) netPay);

        //vo에 담은 정보를 insert하기위해서 insert메서드 호출
        tadao.insertSalaryLedger(vo);

        return true;
    }

    // 근태 마감 대기자 전부 마감하기
    @PostMapping("/admin_ta_close_all")
    @ResponseBody
    public boolean closeAllTA( String ym ){

        //만약 년월 정보가 넘어오지 않았을 경우
        if( ym == null || ym.trim().isEmpty() || ym.equals("") ){
            System.out.println("년 월 정보가 없습니다");
            return false;
        }

        //마감 대기중인 사원 리스트 불러오기
        List<SalaryClosedVO> attendancelist = tadao.getAllMonthlyTA(ym);

        //불러온 마감 대기중인 모든 사원들의 해당 년월(ym) 근태 마감하기!
        //1.근태 마감 테이블에 추가
        for( SalaryClosedVO sawon : attendancelist ){

            //나머지 컬럼 값 세팅 (일단 임시로 지정!!)
            int standardDays = 22; //기본 근무일수
            int workedDays = Integer.parseInt(String.valueOf(sawon.getWorked_days()));
            int overtimeHours = (int) Double.parseDouble(String.valueOf(sawon.getOvertime_hours()));
            int absenceDays = standardDays - workedDays;

            //마감 데이터 DB저장용 파라미터 값 입력
            sawon.setClosed_ym(ym);
            sawon.setStandard_days(standardDays);
            sawon.setAbsence_days(absenceDays);
            sawon.setLeave_days(0); //임시로 0 으로 줌

            tadao.insertClosedAttendance(sawon);

            //마감 DB에 정상적으로 데이터 입력 후 월급 명세서 DB에도 데이터 넣기

            //사원의 연봉계약 정보 가져오기
            SalaryContractVO contract = salaryDao.getContractBySabun(sawon.getSabun());

            //사원의 연봉에 따른 급여 계산
            long baseSalary = 0; 
            long mealAllowance = 0; 

            if( contract != null ){
                //해당 사번의 계약서가 존재한다면
                baseSalary = contract.getBase_salary();
                mealAllowance = contract.getMeal_allowance();
            }else{
                //해당 사번의 계약서가 존재하지 않는다면
                System.out.println(sawon.getSabun() + "번 사원의 유효한 계약 정보가 없습니다. 기본 값으로 계산 됩니다.");
                baseSalary = 2500000; //최저 기본급 (***가능하면 시스템에서 수정 가능하게끔? 구현예정)
                mealAllowance = 200000; //기본 식대 설정 (***가능하면 시스템에서 수정 가능하게끔? 구현예정)
            }

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
            SalaryLedgerVO vo = new SalaryLedgerVO();

            vo.setPay_ym(ym);
            vo.setSabun(sawon.getSabun());
            //모든 값들은 소수점2자리까지만 사용하도록 값 수정
            vo.setBase_pay((int) baseSalary);
            vo.setOvertime_pay(((int) overtimePay));
            vo.setMeal_pay((int) mealAllowance);
            vo.setNational_pension((int) nationalPension);
            vo.setHealth_insurance((int) healthInsurance);
            vo.setLong_term_care((int) longTermCare);
            vo.setEmployment_insurance((int) employmentInsurance);
            vo.setIncome_tax((int) incomeTax);
            vo.setLocal_income_tax((int) localIncomeTax);
            vo.setNet_pay((int) netPay);

            //vo에 담은 정보를 insert하기위해서 insert메서드 호출
            tadao.insertSalaryLedger(vo);

        }

        return true;

    }

    //전자 계약 추가 페이지로 이동
    @GetMapping("/admin_set_contract")
    public String setContractPage( Model model ){

        //전체 사원번호+이름 리스트 불러오기
        List<SawonVO> sawonList = sawonDao.sawonList();

        //바인딩 및 포워딩
        model.addAttribute("sawonList", sawonList);

        return "admin_salary/admin_set_contract";
    }

    //전자 계약 등록(추가)
    @PostMapping("/admin_register_contract")
    @ResponseBody
    public boolean registerContract(SalaryContractVO vo){

        System.out.println("계약 요청 사번 : " + vo.getSabun());
        System.out.println("기본급 : " + vo.getBase_salary());

        int res = salaryDao.insertContract(vo);

        //성공시 true, 실패시 false반환
        return res > 0;

    }

}
