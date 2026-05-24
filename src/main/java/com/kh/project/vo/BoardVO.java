package com.kh.project.vo;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Alias("board")
public class BoardVO {
    
    private int idx, sabun;
    private String title, content, file, created, updated;

}
