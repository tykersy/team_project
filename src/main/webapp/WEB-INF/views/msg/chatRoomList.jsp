<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<c:forEach var="room" items="${chatRooms}" varStatus="status">
    <div class="chat-room" data-room-id="${room.room_id}" onclick="openChatRoom(${room.room_id},'${room.room_type}')">
        <div class="profile-circle">${fn:substring(room.room_name,0,1)}</div>

        <div class="chat-info">
            <div class="chat-top">
                <span class="chat-name" title="${room.room_name}">
                <c:choose>
                    <c:when test="${fn:length(room.room_name) > 20}">
                        ${fn:substring(room.room_name, 0, 20)}...
                    </c:when>
                    <c:otherwise>
                        ${room.room_name}
                    </c:otherwise>
                </c:choose>
                </span>
                <span class="chat-time">${room.last_message_time}</span>
            </div>

            <div class="chat-bottom">
                <span class="chat-last-msg">
                <c:choose>
                    <c:when test="${fn:length(fn:escapeXml(room.last_message)) > 20}">
                        ${fn:substring(fn:escapeXml(room.last_message), 0, 20)}...
                    </c:when>
                    <c:otherwise>
                        ${fn:escapeXml(room.last_message)}
                    </c:otherwise>
                </c:choose>
                </span>
                
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