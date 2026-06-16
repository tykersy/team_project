<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        box-shadow: 0 -2px 8px rgba(0,0,0,0.08);
        transition: background 0.15s;
    }
    footer:hover { background: #f5f7fa; }
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
    .msg_dash{
        margin-left: auto;
        width: 32px;      /* 클릭 영역 */
        height: 32px;     /* 클릭 영역 */
        position: relative;
        cursor: pointer;
        display: flex;
        align-items: center;
        justify-content: center;
    }
    .msg_dash::before {
        content: "";
        width: 16px;      /* 실제 선 길이 */
        height: 2px;      /* 실제 선 두께 */
        background: #333;
        border-radius: 2px;
    }
    .msg_header{
        border-bottom:1px solid #ccc;
    }
    .msg_bar{
        display:flex;
    }
    .msg_bar-btn{
        flex:1;
        border : none;
        border-bottom:1px solid #ccc;
        border-right: 1px solid #ccc;
        height:30px;
    }
    .msg_bar-btn:hover{
        cursor:pointer;
        background: #f0f0f058;
    }
    .msg_bar-btn:last-child{
        border-right: none;
    }

    .msg_tab{
        display:none;
    }

    .msg_tab.active{
        display:block;
    }


    /* ── 슬라이드업 모달 ── */
    #messengerModal {
        position: fixed;
        bottom: -650px;         /* 숨김 초기값 */
        right: 2.5%;
        width: 400px;
        height: 650px;
        background: #fff;
        border: 1px solid #d0d5dd;
        border-radius: 30px 30px 0 0;
        box-shadow: 0 -4px 24px rgba(0,0,0,0.12);
        z-index: 1000;
        display: flex;
        flex-direction: column;
        transition: bottom 0.3s cubic-bezier(0.4, 0, 0.2, 1);
        overflow: hidden;
    }
    #messengerModal.open { bottom: 0; }
</style>
<c:if test="${not empty sessionScope.user}">
    <footer id="messengerTrigger" onclick="toggleMessenger()">
        <span class="msg_span">
            <img src="/img/msg.png" alt="메신저" />
            <span>Linked Messenger</span>
        </span>
    </footer>


    <div id="messengerModal" role="dialog" aria-label="메신저">
        <div class="msg_header">
            <span class="msg_span">
                <img src="/img/msg.png" alt="메신저" />
                <span>Linked Messenger</span>
                <span class="msg_dash" onclick="closeMessenger()"></span>
            </span>
        </div>

        <div class="msg_bar">
            <button class="msg_bar-btn" onclick="msgSwitchTab(0)">멤버</button>
            <button class="msg_bar-btn" onclick="msgSwitchTab(1)">채팅</button>
            <button class="msg_bar-btn" onclick="msgSwitchTab(2)">즐겨찾기</button>
        </div>

        <div class="msg_content">
            <div class="msg_tab active" id="msg_member">
                멤버 탭
            </div>

            <div class="msg_tab" id="msg_chatting">
                채팅 탭
            </div>

            <div class="msg_tab" id="msg_like">
                즐겨찾기 탭
            </div>
        </div>
    </div>
</c:if>

<script>

    let isOpen   = false;
    /* ── 열기/닫기 토글 ── */
    window.toggleMessenger = function () {
        isOpen = !isOpen;
        document.getElementById('messengerModal').classList.toggle('open', isOpen);
    };
    window.closeMessenger = function () {
        isOpen = false;
        document.getElementById('messengerModal').classList.remove('open');
    };

    /* 탭 전환 토글 */
    function msgSwitchTab(index){
        document.querySelectorAll('.msg_tab').forEach((b, i) => {
            b.classList.toggle('active', i === index);
        });
    }

    var MY_USER_ID = ${user};
    var MY_NICK    = '${userName}';
    var FIRST_LOG_ID = null; // 더보기용: 현재 화면의 가장 오래된 logId

    (function () {
        var protocol = location.protocol === 'https:' ? 'wss:' : 'ws:';
        var WS_URL   = protocol + '//' + location.host + '/chat/' + 1;
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
