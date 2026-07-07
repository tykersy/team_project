package com.kh.project.vo;

import lombok.Data;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import org.apache.ibatis.type.Alias;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Alias("board")
public class BoardVO {
    private int idx, sabun, views;
    private String saname, title, content, file, created, updated;
    private String dept; 
    
    // 팀장 이름 필드 추가
    private String leader_name; 
}