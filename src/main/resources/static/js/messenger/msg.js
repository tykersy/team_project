


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

            /* ── 채팅방 열기 ── */
            let loadingMore = false;
            let noMoreLogs = false;

            function openChatRoom(roomId, room_type) {
                currentRoomId = roomId;
                loadingMore = false;
                noMoreLogs = false;

                fetch("msg_chatRoom/" + roomId + "?room_type=" + room_type)
                    .then(res => res.text())
                    .then(html => {
                        document.getElementById(roomListType).innerHTML = html;
                        var msgBox = document.getElementById('chatMessages');
                        if (msgBox) {
                            msgBox.scrollTop = msgBox.scrollHeight;
                            msgBox.addEventListener('scroll', onChatScroll);
                        }
                    });
            }

            function onChatScroll() {
                let msgBox = document.getElementById('chatMessages');
                if (!msgBox || loadingMore || noMoreLogs) return;
                if (msgBox.scrollTop > 50) return;

                let firstMsg = msgBox.querySelector('[data-msg-id]');
                if (!firstMsg) return;

                let lastLogId = firstMsg.getAttribute('data-msg-id');
                loadingMore = true;

                fetch("msg_chatRoom/" + currentRoomId + "/more?lastLogId=" + lastLogId)
                    .then(res => res.json())
                    .then(logs => {
                        if (logs.length === 0) {
                            noMoreLogs = true;
                            loadingMore = false;
                            return;
                        }

                        let prevHeight = msgBox.scrollHeight;
                        let fragment = document.createDocumentFragment();

                        logs.forEach(msg => {
                            let el;
                            if (msg.sender_sabun === null) {
                                el = document.createElement('div');
                                el.className = 'chat-system-msg';
                                el.setAttribute('data-msg-id', msg.message_id);
                                el.textContent = msg.content;
                            } else {
                                let isMine = msg.sender_sabun === MY_SABUN;
                                el = document.createElement('div');
                                el.className = 'chat-msg ' + (isMine ? 'mine' : 'other');
                                el.setAttribute('data-msg-id', msg.message_id);

                                let html = '<div class="chat-bubble ' + (isMine ? 'mine' : 'other') + '">';
                                if (!isMine) {
                                    html += '<div class="msg-sender">' + escapeHtml(msg.saname) + '</div>';
                                }
                                html += '<div class="msg-text">' + escapeHtml(msg.content) + '</div></div>';
                                html += '<div class="chat-msg-sent_at">' + (msg.sent_at || '') + '</div>';
                                el.innerHTML = html;
                            }
                            fragment.appendChild(el);
                        });

                        msgBox.insertBefore(fragment, msgBox.firstChild);
                        msgBox.scrollTop = msgBox.scrollHeight - prevHeight;
                        loadingMore = false;
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

            /* ── 시스템 메시지 표시 ── */
            function appendSystemMessage(text) {
                let msgBox = document.getElementById('chatMessages');
                if (!msgBox) return;

                let div = document.createElement('div');
                div.className = 'chat-system-msg';
                div.textContent = text;
                msgBox.appendChild(div);
                msgBox.scrollTop = msgBox.scrollHeight;
            }

            /* ── HTML 이스케이프 ── */
            function escapeHtml(text) {
                let div = document.createElement('div');
                div.textContent = text;
                return div.innerHTML;
            }

            /* ── 대화상대 목록 패널 ── */
            function showDrawerMembers() {
                document.getElementById('drawerMembersPanel').classList.add('open');
                // TODO: 여기서 멤버 목록을 가져와서 drawerMembersList에 렌더링
                fetch("/msg_chatRoom/members/list/"+ currentRoomId)
                    .then(res => res.json())
                    .then(data => {
                        let html = '';
                        data.forEach( e => {
                            html += '<div class="drawer-member-item">'
                            html +=    '<div class="profile-circle">'+ e.saname.substring(0, 1) +'</div><div>'
                            html +=        '<div class="drawer-member-name">'+ e.saname +'</div>'
                            html +=        '<div class="drawer-member-dept">'+ e.dname +'</div></div>'
                            if(e.sabun == MY_SABUN){
                                html += '<span class="drawer-member-me">나</span>'
                            }
                            html += '</div>'
                        });
                        
                        document.getElementById('drawerMembersList').innerHTML = html;
                    })
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

            function leaveChatRoom() {
                closeLeaveConfirm();
                toggleChatMorePanel();
                
                fetch("/msg_chatRoom/leave/"+currentRoomId+"?sabun="+MY_SABUN)
                    .then(res => res.json())
                    .then(data => {
                        if (data && ws && ws.readyState === WebSocket.OPEN) {
                            ws.send(JSON.stringify({
                                type: 'system',
                                roomId: currentRoomId,
                                content: MY_NAME + '님이 나가셨습니다.'
                            }));

                            msgSwitchTab(1);
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

            /* ── 그룹채팅 멤버 선택 모달 ── */
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