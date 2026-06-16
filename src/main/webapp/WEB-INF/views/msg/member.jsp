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
            </script>