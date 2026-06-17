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
                    채팅 탭
                </div>

                <div class="msg_tab" id="msg_like">
                    즐겨찾기 탭
                </div>
            </div>

        </div>

        <script>

            let isOpen = false;
            let memberLoaded = false;
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
            }

            var MY_USER_ID = ${ user };
            var MY_NICK = '${userName}';
            var FIRST_LOG_ID = null; // 더보기용: 현재 화면의 가장 오래된 logId

            (function () {
                var protocol = location.protocol === 'https:' ? 'wss:' : 'ws:';
                var WS_URL = protocol + '//' + location.host + '/chat/' + 1;
                var ws = null;
                var reconnectTimer = null;

                function connect() {
                    ws = new WebSocket(WS_URL);

                    ws.onopen = function () {
                        console.log('연결됨');
                    };

                    ws.onmessage = function (e) {
                        var data = JSON.parse(e.data);

                        if (data.type === 'chat') {
                            appendMessage(data);
                            scrollToBottom();
                        } else if (data.type === 'system') {
                            appendSystem(data.message);
                        } else if (data.type === 'online') {
                            console.log('접속자 ' + data.count + '명');
                        }
                    };

                    ws.onclose = function () {
                        console.log("연결끊김");
                        reconnectTimer = setTimeout(connect, 5000);
                    };

                    ws.onerror = function () { ws.close(); };
                }

                connect();

            })();
        </script>