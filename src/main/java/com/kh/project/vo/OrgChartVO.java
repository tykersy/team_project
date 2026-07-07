package com.kh.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Alias("orgchart")
public class OrgChartVO {

    private int deptno;
    private String dname;
    private String dtel;

    private int sabun;
    private String saname;
    private String sajob;

    private String saemail;
    private String satel;

    private String status;
    
}
