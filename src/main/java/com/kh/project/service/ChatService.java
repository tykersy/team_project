package com.kh.project.service;

import java.util.Collections;
import java.util.List;

import org.springframework.stereotype.Service;

import com.kh.project.dao.ChatDAO;
import com.kh.project.vo.ChatMessageVO;

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

    public List<ChatMessageVO> getRecentLogs(int room_id){
        List<ChatMessageVO> logs = chatdao.selectRecentLogs(room_id, 100);
        Collections.reverse(logs);
        return logs;
    }

    public List<ChatMessageVO> getMoreLogs(int room_id, Long lastLogId){
        List<ChatMessageVO> logs = chatdao.selectLogsBefore(room_id, lastLogId, 50);
        Collections.reverse(logs);
        return logs;
    }
}
