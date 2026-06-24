package com.kh.project.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.kh.project.vo.ChatMessageVO;
import com.kh.project.vo.ChatRoomVO;
import com.kh.project.vo.SawonVO;

@Mapper
public interface ChatDAO {

    public int insertChatLog(ChatMessageVO vo);

    public List<ChatMessageVO> selectRecentLogs(int room_id, int limit);

    public List<ChatMessageVO> selectLogsBefore(int room_id, Long lastLogId, int limit);

    //채팅방 목록
    public List<ChatRoomVO> selectListChatRoom(int sabun);

    // 특정 방의 멤버 sabun 목록 조회
    public List<Integer> selectRoomMemberSabuns(int room_id);

    //채팅방 즐겨찾기를 위한 조회
    public boolean selectRoomLikedCheck(int room_id, int sabun);

    //채팅방 즐겨찾기
    public int updateChatRoomLiked(int room_id, int sabun, boolean liked);

    //즐겨찾기 해놓은 채팅방 조회
    public List<ChatRoomVO> selectListLikedChatRoom(int sabun);
    Integer findOneRoom(@Param("mySabun") int mySabun,
                        @Param("targetSabun") int targetSabun);

    void createRoom(ChatRoomVO room);

    void insertChatMember(@Param("roomId") int roomId,
                        @Param("sabun") int sabun);

    // 1:1 채팅방 나가기 전 이름 저장
    public int updateRoomNameBeforeLeave(int room_id, int sabun);

    //채팅방 나가기
    public boolean deleteUserRoomLeave(int room_id, int sabun);

    // 시스템 메시지 저장
    public int insertSystemLog(int room_id, String content);

    // 채팅방에 들어와 있는 유저 리스트
    public List<SawonVO> selectRoomSawonList(int room_id);

}
