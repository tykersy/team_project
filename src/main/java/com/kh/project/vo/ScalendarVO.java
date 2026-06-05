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
    private String start_date, end_date, title, content;

    //화면 출력용
    private int viewStartDay;
    private int viewEndDay;

}
