<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <!DOCTYPE html>
        <html lang="ko">

        <head>
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
                                <h2>GOOD MORNING 👋</h2>
                                <p>오늘도 좋은 하루 되세요.</p>
                            </div>

                            <button class="check-btn">
                                출근하기
                            </button>

                        </section>

                        <section class="kpi-grid">

                            <div class="kpi-card">
                                <p>출근 인원</p>
                                <h3>${attend}</h3>
                            </div>

                            <div class="kpi-card">
                                <p>휴가 중</p>
                                <h3>${vacation}</h3>
                            </div>

                            <div class="kpi-card">
                                <p>승인 대기</p>
                                <h3>${approval}</h3>
                            </div>

                            <div class="kpi-card">
                                <p>총 근무시간</p>
                                <h3>${totalHours}</h3>
                            </div>

                        </section>

                        <section class="bottom-grid">

                            <div class="panel">
                                <h3>오늘 일정</h3>

                                <div class="calendar-list" style="margin-top: 15px;">
                                    <c:forEach var="s" items="${scheduleList}">
                                        <div class="calendar-item" style="margin-bottom: 12px; padding: 5px 0;">
                                            <span class="schedule-title"
                                                style="font-weight: bold; color: #333;">${s.title}</span>
                                            <span class="schedule-time"
                                                style="float: right; color: #2563eb; font-size: 0.9rem;">${s.start_date}</span>
                                            <hr style="border: 0.5px solid #f1f5f9; margin-top: 8px; margin-bottom: 0;">
                                        </div>
                                    </c:forEach>

                                    <c:if test="${empty scheduleList}">
                                        <p
                                            style="color: #94a3b8; text-align: center; margin-top: 30px; font-size: 0.95rem;">
                                            📢 예정된 부서 일정이 없습니다.</p>
                                    </c:if>
                                </div>
                            </div>

                            <div class="panel">
                                <h3>공지사항</h3>

                                <div class="notice-list">
                                    <c:forEach var="b" items="${boardList}">
                                        <div class="notice-item" style="margin-bottom: 10px;">
                                            <span class="notice-title" style="font-weight: bold;">${b.title}</span>
                                            <span class="notice-date"
                                                style="float: right; color: #888;">${b.created}</span>
                                            <hr style="border: 0.5px solid #eee; margin-top: 5px;">
                                        </div>
                                    </c:forEach>

                                    <c:if test="${empty boardList}">
                                        <p style="color: #999; text-align: center; margin-top: 20px;">등록된 공지사항이 없습니다.
                                        </p>
                                    </c:if>
                                </div>
                            </div>

                        </section>

                    </div>

                </main>

            </div>

        </body>

        </html>