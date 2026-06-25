<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>

            <script>
                function checkIn() {

                    fetch("checkin.do", {
                        method: "POST"
                    })
                        .then(res => res.json())
                        .then(data => {

                            if (data.result === "yes") {
                                alert("출근 처리되었습니다.");
                                location.reload();

                            } else if (data.result === "already") {
                                alert("이미 출근 처리되었습니다.");

                            } else if (data.result === "login") {
                                alert("로그인이 필요합니다.");
                                location.href = "login";

                            } else {
                                alert("출근 처리 실패");
                            }

                        });
                }

                function checkOut() {

                    fetch("checkout.do", {
                        method: "POST"
                    })
                        .then(res => res.json())
                        .then(data => {

                            if (data.result === "yes") {
                                alert("퇴근 처리되었습니다.");
                                location.reload();

                            } else if (data.result === "not_checkin") {
                                alert("출근 기록이 없습니다.");

                            } else if (data.result === "already") {
                                alert("이미 퇴근 처리되었습니다.");

                            } else if (data.result === "login") {
                                alert("로그인이 필요합니다.");
                                location.href = "login";

                            } else {
                                alert("퇴근 처리 실패");
                            }

                        });
                }
            </script>


            <meta charset="UTF-8">
            <title>Dashboard</title>

            <link rel="stylesheet" href="/css/sidebar.css">
            <link rel="stylesheet" href="/css/dashboard.css">
        </head>

        <body>

            <div class="layout">

                <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

                <main class="main-content">

                    <jsp:include page="/WEB-INF/views/common/header.jsp" />

                    <div class="dashboard-container">

                        <section class="attendance-card">
                            <div>
                                <h2>새로운 연결의 시작, Linked가 당신의 활기찬 오늘을 응원합니다!</h2>
                                <p>오늘 하루도 긍정 에너지로 가득한 하루 보내세요 🥰</p>
                            </div>
                            <div>
                                <c:choose>
                                    <c:when test="${empty today}">
                                        <button class="check-btn" onclick="checkIn()">출근하기</button>
                                    </c:when>

                                    <c:when test="${empty today.checkout}">
                                        <button class="check-btn" onclick="checkOut()">퇴근하기</button>
                                    </c:when>

                                    <c:otherwise>
                                        <button class="check-btn" onclick="location.href='/ta_main.do'">근무내역
                                            확인</button>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                        </section>

                        <section class="kpi-grid">
                            <div class="kpi-card">
                                <p>전체 목표</p>
                                <h3>${overallGoal}</h3>
                            </div>

                            <div class="kpi-card">
                                <p>승인 대기</p>
                                <a href="/mypage?tab=leave" style="text-decoration: none; color: inherit; display: block;">
                                    <h3>${approval}</h3>
                                </a>
                            </div>
                            
                            <div class="kpi-card">
                                <p>부서별 휴가 현황</p>
                                <div class="kpi-list-content">
                                    <c:forEach var="v" items="${deptVacationList}">
                                        <div class="kpi-list-item">
                                            <span class="dept-name">${v.deptName}</span>
                                            <span class="count-badge">현재 <strong>${v.count}</strong>명</span>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${empty deptVacationList}">
                                        <p class="empty-text">현재 휴가 중인 인원이 없습니다.</p>
                                    </c:if>
                                </div>
                            </div>


                        </section>

                        <section class="bottom-grid">

                            <div class="panel">
                                <h3>공지사항</h3>
                                <div class="notice-list" style="margin-top: 20px;">
                                    <c:forEach var="b" items="${boardList}">
                                        <div class="notice-item"
                                            style="margin-bottom: 16px; padding-bottom: 8px; border-bottom: 1px solid #eee;">
                                            <a href="/board/detail?idx=${b.idx}"
                                                style="text-decoration: none; color: inherit; display: inline-block; max-width: 70%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                                <span class="notice-title" style="font-weight: bold;">${b.title}</span>
                                            </a>
                                            <span class="notice-date"
                                                style="float: right; color: #888;">${b.created}</span>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${empty boardList}">
                                        <p style="color: #999; text-align: center; margin-top: 40px;">등록된 공지사항이 없습니다.
                                        </p>
                                    </c:if>
                                </div>
                            </div>

                            <div class="panel">
                                <h3>오늘 일정</h3>
                                <div class="calendar-list" style="margin-top: 20px;">
                                    <c:forEach var="s" items="${scheduleList}">
                                        <div class="calendar-item"
                                            style="margin-bottom: 16px; padding-bottom: 8px; border-bottom: 1px solid #f1f5f9;">
                                            <span class="schedule-title"
                                                style="font-weight: bold; color: #333;">${s.title}</span>
                                            <span class="schedule-time"
                                                style="float: right; color: #2563eb; font-size: 0.9rem;">${s.start_date}</span>
                                        </div>
                                    </c:forEach>
                                    <c:if test="${empty scheduleList}">
                                        <p
                                            style="color: #94a3b8; text-align: center; margin-top: 40px; font-size: 0.95rem;">
                                            📢 예정된 부서 일정이 없습니다.</p>
                                    </c:if>
                                </div>
                            </div>
                        </section>

                    </div>

                    <jsp:include page="/WEB-INF/views/common/msg.jsp" />
                    
                </main>
            </div>

        </body>

        </html>