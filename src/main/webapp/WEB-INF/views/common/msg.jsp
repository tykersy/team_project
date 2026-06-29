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
                    <jsp:include page="/WEB-INF/views/msg/chatRoomList.jsp" />
                </div>
            </div>

        </div>

        <!-- 그룹채팅 멤버 선택 모달 -->
        <div class="member-select-modal" id="memberSelectModal">
            <div class="member-select-card">
                <div class="member-select-header">
                    <span id="memberSelectTitle">대화 상대 선택</span>
                    <button class="member-select-close" onclick="closeMemberSelectModal()">&times;</button>
                </div>
                <div class="member-select-search">
                    <input type="text" id="memberSelectSearch" placeholder="이름으로 검색"
                           oninput="filterMemberSelectList(this.value)" />
                </div>
                <div class="member-select-list" id="memberSelectList"></div>
                <div class="member-select-footer">
                    <button class="member-select-confirm" id="memberSelectConfirm"
                            onclick="showRoomNameStep()" disabled>선택 완료</button>
                </div>

                <div class="member-select-room-name" id="roomNameStep" style="display:none;">
                    <div class="member-select-header">
                        <span>채팅방 이름</span>
                        <button class="member-select-close" onclick="backToMemberSelect()">&times;</button>
                    </div>
                    <div class="room-name-body">
                        <input type="text" id="roomNameInput" placeholder="채팅방 이름을 입력하세요"
                               onkeydown="if(event.key==='Enter') confirmMemberSelect();" />
                        <p class="room-name-hint">미입력 시 멤버 이름으로 자동 설정됩니다.</p>
                    </div>
                    <div class="member-select-footer">
                        <button class="member-select-confirm" onclick="confirmMemberSelect()">만들기</button>
                    </div>
                </div>
            </div>
        </div>
        <script src="${pageContext.request.contextPath}/js/messenger/msg.js"></script>
        <script>
            let isOpen = false;
            let memberLoaded = false;
            let chatRoomLoaded = false;
            let currentRoomId = null;
            let ws = null;
            let roomListType = "";

            let MY_SABUN = ${sessionScope.user};
            let MY_NAME = '${sessionScope.userName}';
        </script>
        