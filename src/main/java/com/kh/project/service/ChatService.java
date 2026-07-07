package com.kh.project.service;

import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Service;

import com.kh.project.dao.ChatDAO;
import com.kh.project.vo.ChatMessageVO;
import com.kh.project.vo.ChatRoomVO;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class ChatService {
    private final ChatDAO chatdao;

    public ChatMessageVO saveMessage(int room_id, int sender_sabun, String saname, String content){
        ChatMessageVO log = new ChatMessageVO();
        log.setRoom_id(room_id);
        log.setSender_sabun(sender_sabun);
        log.setSaname(saname);
        log.setContent(content);

        chatdao.insertChatLog(log);
        return log;
    }

    public void saveSystemMessage(int room_id, String content){
        chatdao.insertSystemLog(room_id, content);
    }

    public List<ChatMessageVO> getRecentLogs(int room_id){
        List<ChatMessageVO> logs = chatdao.selectRecentLogs(room_id, 50);
        Collections.reverse(logs);
        return logs;
    }

    public List<ChatMessageVO> getMoreLogs(int room_id, Long lastLogId){
        List<ChatMessageVO> logs = chatdao.selectLogsBefore(room_id, lastLogId, 50);
        Collections.reverse(logs);
        return logs;
    }

    // one 채팅방 생성
    public Integer makeOneRoom(int mySabun, int targetSabun){

        Integer roomId = chatdao.findOneRoom(mySabun, targetSabun);

        if(roomId != null){
            return roomId;
        }

        ChatRoomVO room = new ChatRoomVO();
        room.setRoom_type("ONE");

        chatdao.createRoom(room);

        roomId = room.getRoom_id();

        chatdao.insertChatMember(roomId, mySabun);
        chatdao.insertChatMember(roomId, targetSabun);

        return roomId;
    }

    // GROUP 채팅방 생성
    public Integer makeGroupRoom(List<Integer> sabuns, String room_name){
        ChatRoomVO room = new ChatRoomVO();
        room.setRoom_type("GROUP");
        room.setRoom_name(room_name);

        chatdao.createRoom(room);

        Integer roomId = room.getRoom_id();

        for(Integer sabun : sabuns){
            chatdao.insertChatMember(roomId, sabun);
        }

        return roomId;
    }
}
