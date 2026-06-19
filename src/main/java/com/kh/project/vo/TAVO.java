package com.kh.project.vo;


import java.util.List;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Alias("ta")
public class TAVO {
    
    private int sabun; 
    private String day, checkin, checkout, saname;
    private String status , working_time;

    private List<TAVO> userTaList;
}
