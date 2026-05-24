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
    
    private int deptno, sabun;
    private String day, title;

}
