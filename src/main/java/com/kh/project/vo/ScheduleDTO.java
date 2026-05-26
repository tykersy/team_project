package com.kh.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("schedule")
public class ScheduleDTO {
    
    private int id, deptno;
    private String dname, title, start, end, calendarId;

}
