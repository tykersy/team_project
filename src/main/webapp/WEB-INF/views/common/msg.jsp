<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        height:60px;
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

    /*마우스 스크롤*/
    .msg_content{
        flex: 1;
        overflow-y: auto;
        scrollbar-width: none; /* Firefox */
        -ms-overflow-style: none; /* IE */
    }

    .msg_content::-webkit-scrollbar{
        display: none;
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
        <button class="msg_bar-btn" onclick="msgSwitchTab(0)"><div>👥</div>멤버</button>
        <button class="msg_bar-btn" onclick="msgSwitchTab(1)"><div>🗨️</div>채팅</button>
        <button class="msg_bar-btn" onclick="msgSwitchTab(2)"><div>⭐</div>즐겨찾기</button>
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

    const isLogin = ${sessionScope.user != null};

    let isOpen   = false;
    let memberLoaded = false;
    /* ── 열기/닫기 토글 ── */
    window.toggleMessenger = function () {

        if (!isLogin) {
            alert("로그인이 필요합니다.");
            location.href = "/login";
            return;
        }
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
    function msgSwitchTab(index){
        document.querySelectorAll('.msg_tab').forEach((b, i) => {
            b.classList.toggle('active', i === index);
        });
    }

</script>
