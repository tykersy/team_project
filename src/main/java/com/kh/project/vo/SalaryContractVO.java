package com.kh.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("contract")
public class SalaryContractVO {
    
    private int contract_id, sabun, base_salary, meal_allowance;
    private String start_date, end_date, created_at, signed_at;

}
