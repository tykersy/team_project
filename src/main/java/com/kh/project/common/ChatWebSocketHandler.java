package com.kh.project.common;

import java.util.Map;
import java.util.concurrent.ConcurrentHashMap;

import org.springframework.stereotype.Component;
import org.springframework.web.socket.CloseStatus;
import org.springframework.web.socket.WebSocketSession;
import org.springframework.web.socket.handler.TextWebSocketHandler;

import com.kh.project.service.ChatService;

import lombok.RequiredArgsConstructor;
import tools.jackson.databind.ObjectMapper;
import tools.jackson.databind.node.ObjectNode;

@Component
@RequiredArgsConstructor
public class ChatWebSocketHandler extends TextWebSocketHandler {
    
    private final ChatService chatService;
    private final ObjectMapper objectMapper = new ObjectMapper();

   private final Map<Long, Map<Long, WebSocketSession>> roomSessions = new ConcurrentHashMap<>();
    @Override
    public void afterConnectionEstablished(WebSocketSession session){
        Long roomId = getRoomId(session);
        Long userId = getUserId(session);
        String name = getName(session);

        Map<Long, WebSocketSession> sessions =
                roomSessions.computeIfAbsent(roomId, k -> new ConcurrentHashMap<>());

        // ✅ 중복 접속 차단
        if (sessions.containsKey(userId)) {
            try {
                WebSocketSession oldSession = sessions.get(userId);
                if (oldSession != null && oldSession.isOpen()) {
                    oldSession.close(); // 기존 연결 끊기
                }
            } catch (Exception e) {
                System.out.println("기존 세션 종료 실패: " + e);
            }
        }

        sessions.put(userId, session);

        System.out.println("입장 : " + name + " / 방 : " + roomId);

        broadcastOnlineCount(roomId);
    }

    /* ── 연결 종료 시 ── */
    @Override
    public void afterConnectionClosed(WebSocketSession session, CloseStatus status) {
        Long roomId = getRoomId(session);
        Long userId = getUserId(session);
        String nickname = getName(session);

        Map<Long, WebSocketSession> sessions = roomSessions.get(roomId);

        if (sessions != null) {
            sessions.remove(userId);

            if (sessions.isEmpty()) {
                roomSessions.remove(roomId);
            }
        }

        System.out.println("퇴장: " + nickname + " / 방 " + roomId);

        broadcastOnlineCount(roomId);
    }

     /* ── 접속자 수 브로드캐스트 ── */
    private void broadcastOnlineCount(Long roomId) {
        try {
            Map<Long, WebSocketSession> sessions = roomSessions.get(roomId);

            int count = (sessions == null) ? 0 : sessions.size(); // = 접속 유저 수

            ObjectNode out = objectMapper.createObjectNode();
            out.put("type", "online");
            out.put("count", count);

            System.out.println("type : " + out.get("type")
                    + " / count : " + out.get("count"));

            // TODO: 실제 전송 로직 필요하면 추가
            // sendToRoom(roomId, out);

        } catch (Exception e) {
            System.out.println("접속자 수 오류 " + e);
        }
    }

    private Long getRoomId(WebSocketSession session){
        return (Long) session.getAttributes().get("roomId");
    }

    private Long getUserId(WebSocketSession session){
        return (Long) session.getAttributes().get("userId");
    }

    private String getName(WebSocketSession session){
        return (String) session.getAttributes().get("userName");
    }

}
