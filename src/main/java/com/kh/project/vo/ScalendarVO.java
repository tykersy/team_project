package com.kh.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Alias("scal")
public class ScalendarVO {
    
    private int sabun, scal_idx;
    private String start_date, end_date, title;

}
