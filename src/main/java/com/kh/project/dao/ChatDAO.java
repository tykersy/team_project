package com.kh.project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.kh.project.vo.ChatMessageVO;
import com.kh.project.vo.ChatRoomVO;

@Mapper
public interface ChatDAO {

    public int insertChatLog(ChatMessageVO vo);

    public List<ChatMessageVO> selectRecentLogs(int room_id, int limit);

    public List<ChatMessageVO> selectLogsBefore(int room_id, Long lastLogId, int limit);

    //채팅방 목록
    public List<ChatRoomVO> selectListChatRoom(int sabun);

    // 특정 방의 멤버 sabun 목록 조회
    public List<Integer> selectRoomMemberSabuns(int room_id);

}
