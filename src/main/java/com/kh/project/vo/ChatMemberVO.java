package com.kh.project.vo;

import java.time.LocalDate;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Alias("chatMember")
public class ChatMemberVO {
    private int room_id, sabun;
    private LocalDate joined_at;
}
