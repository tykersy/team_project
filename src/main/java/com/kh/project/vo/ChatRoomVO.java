package com.kh.project.vo;

import java.time.LocalDate;

import org.apache.ibatis.type.Alias;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Alias("chatRoom")
public class ChatRoomVO {
    private int room_id;
    private String room_type, room_name; // room_type 채팅방 종류 (ONE=1:1채팅, GROUP=단체채팅)
    private LocalDate created_at;
}
