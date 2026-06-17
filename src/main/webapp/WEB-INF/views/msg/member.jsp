<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

            <link rel="stylesheet" href="/css/messenger/member.css">

            <div class="profile-box">
                <div class="section-title">내 프로필</div>

                <c:forEach var="vo" items="${list}">
                    <c:if test="${vo.sabun == sabun}">
                        <div class="member-item-my-profile">
                            <div class="profile-circle">${fn:substring(vo.saname,0,1)}</div>
                            <div class="member-info">
                                <div class="member-name">${vo.saname}</div>
                                <div class="member-dept">${vo.dname}</div>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
            </div>

            <div class="member-box">
                <div class="section-title">멤버 목록</div>

                <c:forEach var="vo" items="${list}">
                    <c:if test="${vo.sabun != sabun}">
                        <div class="member-item" onclick="toggleMemberMenu(this)">

                            <div class="member-top">
                            <div class="profile-circle">${fn:substring(vo.saname,0,1)}</div>

                            <div class="member-info">
                                <div class="member-name">${vo.saname}</div>
                                <div class="member-dept">${vo.dname}</div>
                            </div>
                            </div>

                            <div class="member-menu">
                                <button onclick="event.stopPropagation(); openChat('${vo.sabun}')"><div>🗨️</div>메시지</button>
                                <button onclick="event.stopPropagation(); viewProfile('${vo.sabun}')"><div>👤</div>프로필 보기</button>
                            </div>

                        </div>

                    </c:if>
                </c:forEach>
            </div>
            <div id="profileModal" class="profile-modal">
                <div class="profile-card">
                    <button class="profile-close" onclick="closeProfile()">×</button>

                    <div class="profile-big-circle" id="profileInitial"></div>
                    <div>
                    <span class="profile-name" id="profileName"></span> <span class="profile-job" id="profileJob"></span>
                    </div>
                    <div class="profile-dept" id="profileDept"></div>
                    

                    <div class="profile-info">
                        <div>📧 <span id="profileEmail"></span></div>
                        <div>📞 <span id="profileTel"></span></div>
                    </div>

                    <button class="profile-chat-btn" id="profileChatBtn">메시지 보내기</button>
                </div>
            </div>
            <script>
                function toggleMemberMenu(item){

                    const menu = item.querySelector(".member-menu");

                    document.querySelectorAll(".member-menu").forEach(m => {
                        if(m !== menu){
                            m.classList.remove("open");
                        }
                    });

                    menu.classList.toggle("open");
                }
                function viewProfile(sabun) {
                    fetch("msg_profile.do?sabun=" + sabun)
                        .then(res => res.json())
                        .then(data => {
                            document.getElementById("profileInitial").innerText = data.saname.substring(0, 1);
                            document.getElementById("profileName").innerText = data.saname;
                            document.getElementById("profileDept").innerText = data.dname;
                            document.getElementById("profileJob").innerText = data.sajob;
                            document.getElementById("profileEmail").innerText = data.saemail;
                            document.getElementById("profileTel").innerText = data.satel;

                            document.getElementById("profileChatBtn").onclick = function () {
                                openChat(data.sabun);
                                closeProfile();
                            };

                            document.getElementById("profileModal").classList.add("open");
                        });
                }

                function closeProfile() {
                    document.getElementById("profileModal").classList.remove("open");
                }
            </script>