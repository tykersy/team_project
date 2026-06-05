package com.kh.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Alias("sawon")
public class SawonVO {
    
    private int sabun, deptno, sapay;
    private String saname, pwd, sajob, sahire, saemail, satel, saaddr;
    private String sazipcode;

}
