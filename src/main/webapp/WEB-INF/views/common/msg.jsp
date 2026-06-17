<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <style>
            /* ── Footer 트리거 버튼 ── */
            footer {
                position: fixed;
                bottom: 0;
                right: 2.5%;
                width: 400px;
                font-size: 16px;
                border: 1px solid #ccc;
                border-bottom: none;
                border-radius: 30px 30px 0 0;
                background: #fff;
                cursor: pointer;
                user-select: none;
                z-index: 999;
                box-shadow: 0 -2px 8px rgba(0, 0, 0, 0.08);
                transition: background 0.15s;
            }

            footer:hover {
                background: #f5f7fa;
            }

            .msg_span {
                display: flex;
                align-items: center;
                gap: 6px;
                padding: 10px 30px;
            }

            .msg_span img {
                width: 22px;
                padding-top: 0;
            }

            .msg_dash {
                margin-left: auto;
                width: 32px;
                /* 클릭 영역 */
                height: 32px;
                /* 클릭 영역 */
                position: relative;
                cursor: pointer;
                display: flex;
                align-items: center;
                justify-content: center;
            }

            .msg_dash::before {
                content: "";
                width: 16px;
                /* 실제 선 길이 */
                height: 2px;
                /* 실제 선 두께 */
                background: #333;
                border-radius: 2px;
            }

            .msg_header {
                border-bottom: 1px solid #ccc;
            }

            .msg_bar {
                display: flex;
            }

            .msg_bar-btn {
                flex: 1;
                border: none;
                border-bottom: 1px solid #ccc;
                border-right: 1px solid #ccc;
                height: 60px;
            }

            .msg_bar-btn:hover {
                cursor: pointer;
                background: #f0f0f058;
            }

            .msg_bar-btn:last-child {
                border-right: none;
            }

            .msg_tab {
                display: none;
            }

            .msg_tab.active {
                display: block;
                flex: 1;
                overflow-y: auto;
                scrollbar-width: none;
            }

            .msg_tab.active::-webkit-scrollbar { display: none; }

            /* 채팅탭은 flex 레이아웃 (입력창 하단 고정) */
            #msg_chatting.active {
                display: flex;
                flex-direction: column;
                overflow: hidden;
            }

            /*마우스 스크롤*/
            .msg_content {
                flex: 1;
                display: flex;
                flex-direction: column;
                overflow: hidden;
            }

            .msg_content::-webkit-scrollbar {
                display: none;
            }

            /* ── 슬라이드업 모달 ── */
            #messengerModal {
                position: fixed;
                bottom: -650px;
                /* 숨김 초기값 */
                right: 2.5%;
                width: 400px;
                height: 650px;
                background: #fff;
                border: 1px solid #d0d5dd;
                border-radius: 30px 30px 0 0;
                box-shadow: 0 -4px 24px rgba(0, 0, 0, 0.12);
                z-index: 1000;
                display: flex;
                flex-direction: column;
                transition: bottom 0.3s cubic-bezier(0.4, 0, 0.2, 1);
                overflow: hidden;
            }

            #messengerModal.open {
                bottom: 0;
            }

            .chat-room-list {
                display: flex;
                flex-direction: column;
            }

            .chat-room {
                display: flex;
                padding: 12px;
                border-bottom: 1px solid #eee;
                cursor: pointer;
                transition: background .15s;
            }

            .chat-room:hover {
                background: #f7f7f7;
            }

            .chat-profile {
                width: 50px;
                height: 50px;
                border-radius: 50%;
                object-fit: cover;
            }

            .chat-info {
                flex: 1;
                margin-left: 10px;
            }

            .chat-top,
            .chat-bottom {
                display: flex;
                justify-content: space-between;
                align-items: center;
            }

            .chat-name {
                font-weight: 600;
            }

            .chat-time {
                font-size: 12px;
                color: #999;
            }

            .chat-last-msg {
                color: #666;
                font-size: 14px;
                margin-top: 4px;
            }

            .chat-badge {
                min-width: 20px;
                height: 20px;
                border-radius: 10px;
                background: #ff3b30;
                color: white;
                font-size: 12px;
                text-align: center;
                line-height: 20px;
                padding: 0 6px;
            }
            .profile-circle{
                width:42px;
                height:42px;
                margin-top:6px;
                border-radius:50%;
                background:#e9eef7;
                color:#1c2f57;
                display:flex;
                align-items:center;
                justify-content:center;
                font-weight:700;
                font-size:17px;
            }
        </style>
        <c:if test="${not empty sessionScope.user}">
            <footer id="messengerTrigger" onclick="toggleMessenger()">
                <span class="msg_span">
                    <img src="/img/msg.png" alt="메신저" />
                    <span>Linked Messenger</span>
                </span>
            </footer>
        </c:if>




        <div id="messengerModal" role="dialog" aria-label="메신저">
            <div class="msg_header">
                <span class="msg_span">
                    <img src="/img/msg.png" alt="메신저" />
                    <span>Linked Messenger</span>
                    <span class="msg_dash" onclick="closeMessenger()"></span>
                </span>
            </div>

            <div class="msg_bar">
                <button class="msg_bar-btn" onclick="msgSwitchTab(0)">
                    <div>👥</div>멤버
                </button>
                <button class="msg_bar-btn" onclick="msgSwitchTab(1)">
                    <div>🗨️</div>채팅
                </button>
                <button class="msg_bar-btn" onclick="msgSwitchTab(2)">
                    <div>⭐</div>즐겨찾기
                </button>
            </div>
            <div class="msg_content">
                <div class="msg_tab active" id="msg_member">
                    <jsp:include page="/WEB-INF/views/msg/member.jsp" />
                </div>

                <div class="msg_tab" id="msg_chatting">
                    <jsp:include page="/WEB-INF/views/msg/chatRoomList.jsp" />
                </div>

                <div class="msg_tab" id="msg_like">
                    즐겨찾기 탭
                </div>
            </div>

        </div>

        <script>

            let isOpen = false;
            let memberLoaded = false;
            let chatRoomLoaded = false;
            let currentRoomId = null;
            let ws = null;

            let MY_SABUN = ${sessionScope.user};
            let MY_NAME = '${sessionScope.userName}';

            /* ── 열기/닫기 토글 ── */
            window.toggleMessenger = function () {
                isOpen = !isOpen;
                document.getElementById('messengerModal').classList.toggle('open', isOpen);
                if (isOpen && !memberLoaded) {
                    fetch("msg_member.do")
                        .then(res => res.text())
                        .then(html => {
                            document.getElementById("msg_member").innerHTML = html;
                            memberLoaded = true;
                        });
                }
            };
            window.closeMessenger = function () {
                isOpen = false;
                document.getElementById('messengerModal').classList.remove('open');
            };

            /* 탭 전환 토글 */
            function msgSwitchTab(index) {
                document.querySelectorAll('.msg_tab').forEach((b, i) => {
                    b.classList.toggle('active', i === index);
                });

                if (index === 1) {
                    loadChatRoomList();
                }
            }

            function loadChatRoomList() {
                currentRoomId = null;
                fetch("msg_chatRoomList")
                    .then(res => res.text())
                    .then(html => {
                        document.getElementById("msg_chatting").innerHTML = html;
                    });
            }

            /* ── 단일 WebSocket 연결 ── */
            (function () {
                let protocol = location.protocol === 'https:' ? 'wss:' : 'ws:';
                let WS_URL = protocol + '//' + location.host + '/chat';

                function connect() {
                    ws = new WebSocket(WS_URL);

                    ws.onopen = function () {
                        console.log('WebSocket 연결됨');
                    };

                    ws.onmessage = function (e) {
                        let data = JSON.parse(e.data);

                        if (data.type === 'chat') {
                            // 현재 열려있는 채팅방의 메시지면 화면에 추가
                            if (currentRoomId && data.roomId === currentRoomId) {
                                appendMessage(data);
                            }
                            // 채팅방 목록의 마지막 메시지 업데이트
                            updateChatRoomPreview(data);
                        }
                    };

                    ws.onclose = function () {
                        console.log("WebSocket 연결끊김, 5초 후 재연결");
                        setTimeout(connect, 5000);
                    };

                    ws.onerror = function () { ws.close(); };
                }
                connect();
            })();

            /* ── 채팅방 열기 ── */
            function openChatRoom(roomId) {
                currentRoomId = roomId;
                fetch("msg_chatRoom/" + roomId)
                    .then(res => res.text())
                    .then(html => {
                        document.getElementById("msg_chatting").innerHTML = html;
                        var msgBox = document.getElementById('chatMessages');
                        if (msgBox) msgBox.scrollTop = msgBox.scrollHeight;
                    });
            }

            /* ── 채팅방 목록으로 돌아가기 ── */
            function backToChatList() {
                loadChatRoomList();
            }

            /* ── 메시지 전송 ── */
            function sendChatMessage() {
                var input = document.getElementById('chatInput');
                var content = input.value.trim();
                if (!content || !ws || ws.readyState !== WebSocket.OPEN || !currentRoomId) return;

                ws.send(JSON.stringify({
                    type: 'chat',
                    roomId: currentRoomId,
                    content: content
                }));

                input.value = '';
            }

            /* ── 메시지를 채팅 화면에 추가 ── */
            function appendMessage(data) {
                let msgBox = document.getElementById('chatMessages');
                if (!msgBox) return;

                let div = document.createElement('div');
                div.className = 'chat-msg ' + (data.senderSabun === MY_SABUN ? 'mine' : 'other');

                let html = '';
                if (data.senderSabun !== MY_SABUN) {
                    html += '<div class="msg-sender">' + escapeHtml(data.senderName) + '</div>';
                }
                html += '<div class="msg-text">' + escapeHtml(data.content) + '</div>';
                div.innerHTML = html;

                msgBox.appendChild(div);
                msgBox.scrollTop = msgBox.scrollHeight;
            }

            /* ── 채팅방 목록에서 마지막 메시지 미리보기 업데이트 ── */
            function updateChatRoomPreview(data) {
                let roomEl = document.querySelector('.chat-room[data-room-id="' + data.roomId + '"]');
                if (!roomEl) return;
                let lastMsg = roomEl.querySelector('.chat-last-msg');
                if (lastMsg) {
                    lastMsg.textContent = data.content;
                }
            }

            /* ── HTML 이스케이프 ── */
            function escapeHtml(text) {
                let div = document.createElement('div');
                div.textContent = text;
                return div.innerHTML;
            }

        </script>