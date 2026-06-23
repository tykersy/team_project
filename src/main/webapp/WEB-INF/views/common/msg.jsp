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

        <!-- 멤버 선택 모달 (채팅방 만들기) -->
        <div class="member-select-modal" id="memberSelectModal">
            <div class="member-select-card">
                <div class="member-select-header">
                    <span>대화 상대 선택</span>
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

                <!-- 채팅방 이름 설정 단계 -->
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

        <script>

            let isOpen = false;
            let memberLoaded = false;
            let chatRoomLoaded = false;
            let currentRoomId = null;
            let ws = null;
            let roomListType = "";

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
                    roomListType = "msg_chatting";
                    loadChatRoomList();
                }else if(index === 2){
                    roomListType = "msg_like";
                    loadLikedChatRoomList();
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
            
            function loadLikedChatRoomList(){
                currentRoomId = null;
                fetch("msg_LikedChatRoomList")
                    .then(res => res.text())
                    .then(html => {
                        document.getElementById("msg_like").innerHTML = html;
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
                        document.getElementById(roomListType).innerHTML = html;
                        var msgBox = document.getElementById('chatMessages');
                        if (msgBox) msgBox.scrollTop = msgBox.scrollHeight;
                    });
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

                let html = '<div class="chat-bubble '+ (data.senderSabun === MY_SABUN ? 'mine' : 'other')+'">';
                if (data.senderSabun !== MY_SABUN) {
                    html += '<div class="msg-sender">' + escapeHtml(data.senderName) + '</div>';
                }
                console.log(data)
                html += '<div class="msg-text">' + escapeHtml(data.content) + '</div></div>';
                html += '<div class="chat-msg-sent_at">' + escapeHtml(data.sentTime) + '</div>';
                
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

            /* ── + 버튼 서랍 메뉴 토글 ── */
            function toggleChatMorePanel() {
                let overlay = document.getElementById('chatDrawerOverlay');
                let drawer = document.getElementById('chatDrawer');
                if (overlay && drawer) {
                    overlay.classList.toggle('open');
                    drawer.classList.toggle('open');
                }
            }

            function inviteMember() {
                toggleChatMorePanel();
                // TODO: 초대 로직 구현
                console.log('초대하기 - roomId:', currentRoomId);
            }

            function showLeaveConfirm() {
                let overlay = document.getElementById('leaveConfirmOverlay');
                if (overlay) overlay.classList.add('open');
            }

            function closeLeaveConfirm() {
                let overlay = document.getElementById('leaveConfirmOverlay');
                if (overlay) overlay.classList.remove('open');
            }

            function leaveChatRoom(roomId) {
                closeLeaveConfirm();
                toggleChatMorePanel();
                
                fetch("/msg_chatRoom/leave/"+roomId+"?sabun="+MY_SABUN)
                    .then(res => res.json())
                    .then(data => {
                        if(data){
                            console.log("채팅방 나가기 성공");
                            msgSwitchTab(1);
                        }else{
                            console.log("채팅방 나가기 실패");
                        }
                    });

            }

            /* 채팅방 즐겨찾기 */
            async function chat_like(event,roomId,index){
                event.stopPropagation();

                await fetch("msg_chatRoomList/liked?roomId="+roomId+"&sabun="+MY_SABUN)
                    .then(res => res.text())
                    .then(html => {
                        document.querySelectorAll('.chat-liked-'+index).forEach((b, i) => {
                            b.innerText = html;
                        });
                    });
            }

            /* ── 멤버 선택 모달 ── */
            let memberSelectData = [];
            let selectedMembers = [];

            function openMemberChattingModal() {
                selectedMembers = [];
                document.getElementById('memberSelectSearch').value = '';
                document.getElementById('memberSelectModal').classList.add('open');

                fetch("msg_member.do")
                    .then(res => res.text())
                    .then(html => {
                        let parser = new DOMParser();
                        let doc = parser.parseFromString(html, 'text/html');
                        let items = doc.querySelectorAll('.member-item');

                        memberSelectData = [];
                        items.forEach(item => {
                            let name = item.querySelector('.member-name')?.textContent?.trim() || '';
                            let dept = item.querySelector('.member-dept')?.textContent?.trim() || '';
                            let onclick = item.querySelector('button')?.getAttribute('onclick') || '';
                            let sabunMatch = onclick.match(/openChat\('(\d+)'\)/);
                            let sabun = sabunMatch ? parseInt(sabunMatch[1]) : 0;
                            if (sabun && sabun !== MY_SABUN) {
                                memberSelectData.push({ sabun: sabun, name: name, dept: dept });
                            }
                        });

                        renderMemberSelectList(memberSelectData);
                        updateMemberSelectTags();
                    });
            }

            function closeMemberSelectModal() {
                document.getElementById('memberSelectModal').classList.remove('open');
            }

            function renderMemberSelectList(list) {
                let html = '';
                list.forEach(m => {
                    let isSelected = selectedMembers.some(s => s.sabun === m.sabun);
                    html += '<div class="member-select-item' + (isSelected ? ' selected' : '') + '"'
                         +  ' onclick="toggleMemberSelect(' + m.sabun + ',\'' + escapeHtml(m.name) + '\',\'' + escapeHtml(m.dept) + '\')">'
                         +  '  <div class="member-select-check">' + (isSelected ? '&#10003;' : '') + '</div>'
                         +  '  <div class="profile-circle">' + escapeHtml(m.name.charAt(0)) + '</div>'
                         +  '  <div class="member-select-info">'
                         +  '    <div class="member-name">' + escapeHtml(m.name) + '</div>'
                         +  '    <div class="member-dept">' + escapeHtml(m.dept) + '</div>'
                         +  '  </div>'
                         +  '</div>';
                });
                document.getElementById('memberSelectList').innerHTML = html;
            }

            function toggleMemberSelect(sabun, name, dept) {
                let idx = selectedMembers.findIndex(m => m.sabun === sabun);
                if (idx >= 0) {
                    selectedMembers.splice(idx, 1);
                } else {
                    selectedMembers.push({ sabun: sabun, name: name, dept: dept });
                }
                renderMemberSelectList(
                    filterByKeyword(memberSelectData, document.getElementById('memberSelectSearch').value)
                );
                updateMemberSelectTags();
            }

            function updateMemberSelectTags() {
                document.getElementById('memberSelectConfirm').disabled = selectedMembers.length < 2;
            }

            function filterMemberSelectList(keyword) {
                renderMemberSelectList(filterByKeyword(memberSelectData, keyword));
            }

            function filterByKeyword(list, keyword) {
                if (!keyword) return list;
                keyword = keyword.toLowerCase();
                return list.filter(m => m.name.toLowerCase().includes(keyword) || m.dept.toLowerCase().includes(keyword));
            }

            function showRoomNameStep() {
                document.getElementById('roomNameStep').style.display = 'flex';
                let defaultName = selectedMembers.map(m => m.name).join(', ');
                document.getElementById('roomNameInput').placeholder = defaultName;
                document.getElementById('roomNameInput').value = '';
                document.getElementById('roomNameInput').focus();
            }

            function backToMemberSelect() {
                document.getElementById('roomNameStep').style.display = 'none';
            }

            function confirmMemberSelect() {
                let sabuns = selectedMembers.map(m => m.sabun);
                let roomName = document.getElementById('roomNameInput').value.trim();
                if (!roomName) {
                    roomName = selectedMembers.map(m => m.name).join(', ');
                }
                closeMemberSelectModal();
                document.getElementById('roomNameStep').style.display = 'none';

                // sabuns, roomName을 사용해서 채팅방 생성 로직 구현
                console.log('선택된 멤버 sabun:', sabuns, '방 이름:', roomName);

                fetch("/make_group_room",{
                        method: 'POST',
                        headers: {
                            'Content-Type': 'application/json'
                        },
                        body: JSON.stringify(
                            {
                                "sabuns" : sabuns,
                                "room_name" : roomName
                            }
                        )
                    })
                    .then(res => res.json())
                    .then(data => {

                        msgSwitchTab(1);

                        openChatRoom(data.roomId);
                    });
            }

        </script>