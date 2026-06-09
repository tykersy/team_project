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
                        <h2>GOOD MORNING 👋🏻</h2>
                        <p>오늘도 좋은 하루 되세요.</p>
                    </div>
                    <button class="check-btn">출근하기</button>
                </section>

                <section class="kpi-grid">
                    <div class="kpi-card">
                        <p>승인 대기</p>
                        <h3>${approval}</h3>
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
                    
                    <div class="kpi-card">
                        <p>전체 목표</p>
                        <h3>${overallGoal}</h3>
                    </div>

                    <div class="kpi-card">
                        <p>수강 대상 교육</p>
                        <div class="kpi-list-content">
                            <c:forEach var="e" items="${eduList}">
                                <div class="kpi-list-item">
                                    <span class="edu-dot ${e.type == '법정' ? 'dot-orange' : 'dot-yellow'}"></span>
                                    <span class="edu-title">${e.title}</span>
                                </div>
                            </c:forEach>
                            <c:if test="${empty eduList}">
                                <p class="empty-text">모든 교육을 이수하셨습니다!</p>
                            </c:if>
                        </div>
                    </div>
                </section>

                <section class="bottom-grid">
                    <div class="panel">
                        <h3>오늘 일정</h3>
                        <div class="calendar-list" style="margin-top: 20px;">
                            <c:forEach var="s" items="${scheduleList}">
                                <div class="calendar-item" style="margin-bottom: 16px; padding-bottom: 8px; border-bottom: 1px solid #f1f5f9;">
                                    <span class="schedule-title" style="font-weight: bold; color: #333;">${s.title}</span>
                                    <span class="schedule-time" style="float: right; color: #2563eb; font-size: 0.9rem;">${s.start_date}</span>
                                </div>
                            </c:forEach>
                            <c:if test="${empty scheduleList}">
                                <p style="color: #94a3b8; text-align: center; margin-top: 40px; font-size: 0.95rem;">📢 예정된 부서 일정이 없습니다.</p>
                            </c:if>
                        </div>
                    </div>

                    <div class="panel">
                        <h3>공지사항</h3>
                        <div class="notice-list" style="margin-top: 20px;">
                            <c:forEach var="b" items="${boardList}">
                                <div class="notice-item" style="margin-bottom: 16px; padding-bottom: 8px; border-bottom: 1px solid #eee;">
                                    <a href="/board/detail?idx=${b.idx}" style="text-decoration: none; color: inherit; display: inline-block; max-width: 70%; overflow: hidden; text-overflow: ellipsis; white-space: nowrap;">
                                        <span class="notice-title" style="font-weight: bold;">${b.title}</span>
                                    </a>
                                    <span class="notice-date" style="float: right; color: #888;">${b.created}</span>
                                </div>
                            </c:forEach>
                            <c:if test="${empty boardList}">
                                <p style="color: #999; text-align: center; margin-top: 40px;">등록된 공지사항이 없습니다.</p>
                            </c:if>
                        </div>
                    </div>
                </section>

            </div>
        </main>
    </div>

</body>
</html>