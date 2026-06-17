package com.kh.project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.kh.project.vo.ChatMessageVO;

@Mapper
public interface ChatDAO {
    
    public int insertChatLog(ChatMessageVO vo);

    public List<ChatMessageVO> selectRecentLogs(int room_id, int limit);

    public List<ChatMessageVO> selectLogsBefore(int room_id, Long lastLogId, int limit);

}
