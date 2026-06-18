<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:forEach var="room" items="${chatRooms}" varStatus="status">
    <div class="chat-room" data-room-id="${room.room_id}" onclick="openChatRoom(${room.room_id})">
        <div class="profile-circle">${fn:substring(room.room_name,0,1)}</div>

        <div class="chat-info">
            <div class="chat-top">
                <span class="chat-name">${room.room_name}</span>
                <span class="chat-time">${room.last_message_time}</span>
            </div>

            <div class="chat-bottom">
                <span class="chat-last-msg">${fn:escapeXml(room.last_message)}</span>
                
                <span id="chat-liked" class="chat-liked-${status.index}" onclick="chat_like(event,${room.room_id}, ${status.index})">
                    <c:if test="${room.liked}">
                        ❤️
                    </c:if>
                    <c:if test="${not room.liked}">
                        🤍
                    </c:if>
                </span>

            </div>
        </div>
    </div>
</c:forEach>