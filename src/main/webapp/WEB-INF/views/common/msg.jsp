<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="/css/messenger/msg.css">

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
                    fetch("/msg_member.do")
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
                fetch("/msg_chatRoomList")
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