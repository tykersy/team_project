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
    
    private int sabun, deptno;
    private String saname, pwd, sajob, sahire, saemail, satel, saaddr;
    private String sazipcode;
    private String saretire;
    private String sastatus;

    private String dname; // join용 

    private String onlineStatus; // 온라인 상태 확인

    private long base_pay;

}
