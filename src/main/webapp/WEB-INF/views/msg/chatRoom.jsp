<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<style>
    .chat-room-header {
        display: flex;
        align-items: center;
        padding: 10px 12px;
        border-bottom: 1px solid #eee;
    }
    .chat-back-btn {
        border: none;
        background: none;
        font-size: 18px;
        cursor: pointer;
        padding: 4px 8px;
    }
    .chat-room-title {
        font-weight: 600;
        margin-left: 8px;
        font-size: 15px;
    }
    .chat-messages {
        flex: 1;
        overflow-y: auto;
        padding: 12px;
        display: flex;
        flex-direction: column;
        gap: 6px;
        scrollbar-width: none;
    }
    .chat-messages::-webkit-scrollbar { display: none; }

    .chat-msg {
        max-width: 75%;
        display: flex;
        align-items: flex-end;
        gap: 4px;
    }
    .chat-msg.mine {
        align-self: flex-end;
        flex-direction: row-reverse;
    }
    .chat-msg.other {
        align-self: flex-start;
        flex-direction: row;
    }

    .chat-bubble {
        padding: 8px 12px;
        border-radius: 12px;
        font-size: 14px;
        word-break: break-word;
    }
    .chat-bubble.mine {
        background: #dcf8c6;
    }
    .chat-bubble.other {
        background: #f1f0f0;
    }

    .chat-msg-sent_at {
        font-size: 11px;
        color: #aaa;
        white-space: nowrap;
        margin-bottom: 2px;
    }
    .chat-msg .msg-sender {
        font-size: 11px;
        color: #888;
        margin-bottom: 2px;
    }
    .chat-msg .msg-text {
        font-size: 14px;
    }
    .chat-input-area {
        display: flex;
        padding: 8px;
        border-top: 1px solid #eee;
        gap: 6px;
    }
    .chat-input-area input {
        flex: 1;
        padding: 8px 12px;
        border: 1px solid #ddd;
        border-radius: 20px;
        outline: none;
        font-size: 14px;
    }
    .chat-input-area button {
        border: none;
        background: #4a90d9;
        color: #fff;
        padding: 8px 16px;
        border-radius: 20px;
        cursor: pointer;
        font-size: 14px;
    }
    .chat-input-area button:hover {
        background: #3a7bc8;
    }
</style>

<div style="display:flex; flex-direction:column; flex:1; min-height:0;">

    <div class="chat-messages" id="chatMessages">
        <c:forEach var="msg" items="${logs}">
            <div class="chat-msg ${msg.sender_sabun == sessionScope.user ? 'mine' : 'other'}">
                <div class="chat-bubble ${msg.sender_sabun == sessionScope.user ? 'mine' : 'other'}">
                    <c:if test="${msg.sender_sabun != sessionScope.user}">
                        <div class="msg-sender">${msg.saname}</div>
                    </c:if>
                    <div class="msg-text">${fn:escapeXml(msg.content)}</div>
                </div>
                <div class="chat-msg-sent_at">${msg.sent_at}</div>
            </div>
        </c:forEach>
    </div>

    <div class="chat-input-area">
        <input type="text" id="chatInput" placeholder="메시지를 입력하세요"
               onkeydown="if(event.key==='Enter') sendChatMessage();" />
        <button onclick="sendChatMessage()">전송</button>
    </div>
</div>

