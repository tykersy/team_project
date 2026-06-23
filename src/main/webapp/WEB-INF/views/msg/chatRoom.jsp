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
        padding: 8px;
        border-top: 1px solid #eee;
        gap: 6px;
    }
    .chat-input-area input {
        padding: 8px 12px;
        border: 1px solid #ddd;
        border-radius: 20px;
        outline: none;
        font-size: 14px;
        width: 100%;
        margin-bottom: 8px;
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
    .chat-button-area{
        display: flex;
    }
    .chat-send{
        margin-left : auto;
        width : 120px;
    }
    .chat-more{
        font-weight: bold;
        weight : 50px;
    }

    /* ── 서랍형 메뉴 ── */
    .chat-drawer-overlay {
        display: none;
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.3);
        z-index: 10;
    }
    .chat-drawer-overlay.open {
        display: block;
    }
    .chat-drawer {
        position: absolute;
        top: 0;
        right: -70%;
        width: 70%;
        height: 100%;
        background: #fff;
        z-index: 11;
        display: flex;
        flex-direction: column;
        transition: right 0.25s ease;
        box-shadow: -2px 0 8px rgba(0,0,0,0.1);
    }
    .chat-drawer.open {
        right: 0;
    }
    .chat-drawer-menu {
        flex: 1;
        overflow-y: auto;
        padding: 8px 0;
    }
    .chat-drawer-item {
        display: flex;
        align-items: center;
        gap: 12px;
        padding: 12px 18px;
        font-size: 14px;
        color: #333;
        cursor: pointer;
        border: none;
        background: none;
        width: 100%;
        text-align: left;
        transition: background 0.12s;
    }
    .chat-drawer-item:hover {
        background: #f5f5f5;
    }
    .chat-drawer-item .drawer-icon {
        width: 20px;
        text-align: center;
        font-size: 16px;
        color: #666;
        flex-shrink: 0;
    }
    .chat-drawer-divider {
        height: 1px;
        background: #eee;
        margin: 4px 0;
    }
    .chat-drawer-item.leave {
        color: #e74c3c;
    }
    .chat-drawer-item.leave .drawer-icon {
        color: #e74c3c;
    }

    /* ── 나가기 확인 모달 ── */
    .leave-confirm-overlay {
        display: none;
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        background: rgba(0,0,0,0.35);
        z-index: 20;
        align-items: center;
        justify-content: center;
    }
    .leave-confirm-overlay.open {
        display: flex;
    }
    .leave-confirm-box {
        background: #fff;
        border-radius: 16px;
        width: 260px;
        padding: 24px 20px 16px;
        text-align: center;
    }
    .leave-confirm-box p {
        font-size: 14px;
        color: #333;
        margin: 0 0 20px;
        line-height: 1.5;
    }
    .leave-confirm-btns {
        display: flex;
        gap: 8px;
    }
    .leave-confirm-btns button {
        flex: 1;
        height: 38px;
        border: none;
        border-radius: 10px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
    }
    .leave-cancel-btn {
        background: #f0f0f0;
        color: #333;
    }
    .leave-cancel-btn:hover {
        background: #e0e0e0;
    }
    .leave-ok-btn {
        background: #e74c3c;
        color: #fff;
    }
    .leave-ok-btn:hover {
        background: #d63031;
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
        <div>
            <input type="text" id="chatInput" placeholder="메시지를 입력하세요"
                onkeydown="if(event.key==='Enter') sendChatMessage();" />
        </div>
        <div class="chat-button-area">
            <button type="button" class="chat-more" onclick="toggleChatMorePanel()">+</button>
            <button class="chat-send" onclick="sendChatMessage()">전송</button>
        </div>
    </div>

    <!-- 서랍형 메뉴 -->
    <div class="chat-drawer-overlay" id="chatDrawerOverlay" onclick="toggleChatMorePanel()"></div>
    <div class="chat-drawer" id="chatDrawer">
        <div class="chat-drawer-menu">
            <button class="chat-drawer-item" onclick="inviteMember()">
                <span class="drawer-icon">👤</span> 대화상대 초대하기
            </button>
        </div>
        <div class="chat-drawer-divider"></div>
        <button class="chat-drawer-item leave" onclick="showLeaveConfirm()">
            <span class="drawer-icon">🚪</span> 채팅방 나가기
        </button>
    </div>

    <!-- 나가기 확인 모달 -->
    <div class="leave-confirm-overlay" id="leaveConfirmOverlay">
        <div class="leave-confirm-box">
            <p>채팅방을 나가시겠습니까?<br>대화 내용이 모두 삭제됩니다.</p>
            <div class="leave-confirm-btns">
                <button class="leave-cancel-btn" onclick="closeLeaveConfirm()">취소</button>
                <button class="leave-ok-btn" onclick="leaveChatRoom(${roomId})">나가기</button>
            </div>
        </div>
    </div>
</div>

