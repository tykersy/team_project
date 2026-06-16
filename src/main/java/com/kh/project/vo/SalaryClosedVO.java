package com.kh.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("salaryclosed")
public class SalaryClosedVO{

    //월별 근태 정산 마감 테이블
    private String closed_ym; //정산 년월
    private int sabun; //사번
    private String saname;
    private String dname;
    private int standard_days; //해당 월 정상 출근 일수
    private int worked_days; //실제 출근 일수
    private int absence_days; //무급 결근 일수
    private int leave_days; //연차 사용 일수
    private int overtime_hours; //연장, 야간 근무 시간
    private String status; //현재 마감 상태 (대기, 완료 : 기본값은 '대기')
    private String updated_at; //최종 업데이트 일시

}