package com.kh.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("ledger")
public class SalaryLedgerVO {
    
    //급여 명세서 테이블

    private int salary_id, sabun, base_pay, finalBasePay, overtime_pay, meal_pay;
    private String pay_ym, saname, dname, status; //마감상태(기본:'대기')

    //공제 항목
    private int national_pension; //국민 연금
    private int health_insurance; //건강 보험
    private int long_term_care; //장기요양보험
    private int employment_insurance; //고용보험
    private int income_tax; //근로소득세
    private int local_income_tax; //지방소득세

    //최종합계액
    private int net_pay; //실지급액 (총지급액 - 총공제액)

}
