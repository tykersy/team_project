package com.kh.project.vo;

import java.time.LocalDate;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@AllArgsConstructor
@NoArgsConstructor
@Data
@Alias("chatMsg")
public class ChatMessageVO {
    private int message_id, room_id;
    private Integer sender_sabun;
    private String content, saname;
    private LocalDate sent_at;
}
