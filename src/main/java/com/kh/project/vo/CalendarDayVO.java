package com.kh.project.vo;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CalendarDayVO {
    private int    day;
    private String status;    // normal / late / absent / off / future / leave / half
    private String checkin;
    private String checkout;
}
