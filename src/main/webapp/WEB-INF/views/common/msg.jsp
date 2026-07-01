<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <link rel="stylesheet" href="/css/messenger/msg.css">
        <link rel="stylesheet" href="/css/messenger/chatRoom.css">

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
                            if (currentRoomId && data.roomId === currentRoomId) {
                                appendMessage(data);
                            }
                            updateChatRoomPreview(data);
                        } else if (data.type === 'system') {
                            if (currentRoomId && data.roomId === currentRoomId) {
                                appendSystemMessage(data.content);
                            }
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

            function hideDrawerMembers() {
                document.getElementById('drawerMembersPanel').classList.remove('open');
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

            function showLeaveConfirm() {
                let overlay = document.getElementById('leaveConfirmOverlay');
                if (overlay) overlay.classList.add('open');
            }

            function closeLeaveConfirm() {
                let overlay = document.getElementById('leaveConfirmOverlay');
                if (overlay) overlay.classList.remove('open');
            }

            

            /* ── 그룹채팅 멤버 선택 모달 ── */
            let memberSelectData = [];
            let selectedMembers = [];

            function openMemberChattingModal() {
                selectedMembers = [];
                document.getElementById('memberSelectSearch').value = '';
                document.getElementById('memberSelectModal').classList.add('open');

                fetch("/msg_member.do")
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

            /* ── 채팅방 초대 모달 ── */
            let inviteData = [];
            let inviteSelected = [];
            let inviteExistingMembers = [];

            function inviteMember() {
                toggleChatMorePanel();
                inviteSelected = [];

                fetch("/msg_chatRoom/members/" + currentRoomId)
                    .then(res => res.json())
                    .then(existingSabuns => {
                        inviteExistingMembers = existingSabuns;
                        document.getElementById('inviteSearch').value = '';
                        document.getElementById('inviteModalOverlay').classList.add('open');
                        document.getElementById('inviteConfirmBtn').disabled = true;

                        fetch("msg_member.do")
                            .then(res => res.text())
                            .then(html => {
                                let parser = new DOMParser();
                                let doc = parser.parseFromString(html, 'text/html');
                                let items = doc.querySelectorAll('.member-item');

                                inviteData = [];
                                items.forEach(item => {
                                    let name = item.querySelector('.member-name')?.textContent?.trim() || '';
                                    let dept = item.querySelector('.member-dept')?.textContent?.trim() || '';
                                    let onclick = item.querySelector('button')?.getAttribute('onclick') || '';
                                    let sabunMatch = onclick.match(/openChat\('(\d+)'\)/);
                                    let sabun = sabunMatch ? parseInt(sabunMatch[1]) : 0;
                                    if (sabun && sabun !== MY_SABUN) {
                                        inviteData.push({ sabun: sabun, name: name, dept: dept });
                                    }
                                });
                                renderInviteList(inviteData);
                            });
                    });
            }

            function closeInviteModal() {
                document.getElementById('inviteModalOverlay').classList.remove('open');
            }

            function renderInviteList(list) {
                let html = '';
                list.forEach(m => {
                    let isExisting = inviteExistingMembers.includes(m.sabun);
                    let isSelected = isExisting || inviteSelected.some(s => s.sabun === m.sabun);
                    let cls = 'member-select-item' + (isSelected ? ' selected' : '') + (isExisting ? ' disabled' : '');
                    let click = isExisting ? '' : ' onclick="toggleInviteSelect(' + m.sabun + ',\'' + escapeHtml(m.name) + '\',\'' + escapeHtml(m.dept) + '\')"';

                    html += '<div class="' + cls + '"' + click + '>'
                         +  '  <div class="member-select-check">' + (isSelected ? '&#10003;' : '') + '</div>'
                         +  '  <div class="profile-circle">' + escapeHtml(m.name.charAt(0)) + '</div>'
                         +  '  <div class="member-select-info">'
                         +  '    <div class="member-name">' + escapeHtml(m.name) + '</div>'
                         +  '    <div class="member-dept">' + escapeHtml(m.dept) + '</div>'
                         +  '  </div>'
                         +  '</div>';
                });
                document.getElementById('inviteMemberList').innerHTML = html;
            }

            function toggleInviteSelect(sabun, name, dept) {
                let idx = inviteSelected.findIndex(m => m.sabun === sabun);
                if (idx >= 0) inviteSelected.splice(idx, 1);
                else inviteSelected.push({ sabun: sabun, name: name, dept: dept });

                let keyword = document.getElementById('inviteSearch').value;
                renderInviteList(filterByKeyword(inviteData, keyword));
                document.getElementById('inviteConfirmBtn').disabled = inviteSelected.length === 0;
            }

            function filterInviteList(keyword) {
                renderInviteList(filterByKeyword(inviteData, keyword));
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

            function confirmInviteMembers() {
                let sabuns = inviteSelected.map(m => m.sabun);
                let names = inviteSelected.map(m => m.name).join(', ');
                closeInviteModal();

                fetch("/msg_chatRoom/invite/" + currentRoomId, {
                    method: 'POST',
                    headers: { 'Content-Type': 'application/json' },
                    body: JSON.stringify(sabuns)
                })
                .then(res => res.json())
                .then(data => {
                    if (data && ws && ws.readyState === WebSocket.OPEN) {
                        ws.send(JSON.stringify({
                            type: 'system',
                            roomId: currentRoomId,
                            content: names + '님이 초대되었습니다.'
                        }));
                    }
                });
            }
        </script>
        