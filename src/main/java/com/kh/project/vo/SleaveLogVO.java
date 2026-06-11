package com.kh.project.vo;

import java.time.LocalDate;
import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("sleavelog")
public class SleaveLogVO {
    private Long log_id; //index
    private int sabun; 
    private String leave_type, reason;
    private double use_days; // 연차 사용 개수
    private boolean approve; // 연차 승인 여부 
    private Date created_at;
    private LocalDate use_date;

    //관리자 휴가 승인을 메뉴를 위해 추가해야하는 필드
    private String saname; //사원명
    private String dname; //부서명
}
