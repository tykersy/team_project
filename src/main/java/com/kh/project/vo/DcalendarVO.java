package com.kh.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Alias("dcal")
public class DcalendarVO {
    
    private int deptno, sabun, dcal_idx;
    private String start_date, end_date, title;

}
