package com.kh.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Alias("user")
public class UserVO {
    private int sabun, deptno, sapay;
    private String saname, pwd, sajob, sahire, saemail, satel, saaddr;
    private String sazipcode;
    private String dname;
    private String day, checkin, checkout, working_time;
}
