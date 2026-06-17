package com.kh.project.vo;

import java.time.LocalDate;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("chat")
public class ChatRoomVO {
    private int room_id, sabun;
    private String room_type, room_name; // room_type 채팅방 종류 (ONE=1:1채팅, GROUP=단체채팅)
    private LocalDate created_at, joined_at;
    private String last_message;
    private String last_message_time;
}
