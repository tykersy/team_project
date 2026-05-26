<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


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

    <!-- Sidebar -->
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <!-- Main -->
    <main class="main-content">

        <!-- Header -->
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <!-- Dashboard Content -->
        <div class="dashboard-container">

            <!-- 출퇴근 카드 -->
            <section class="attendance-card">

                <div>
                    <h2>GOOD MORNING 👋</h2>
                    <p>오늘도 좋은 하루 되세요.</p>
                </div>

                <button class="check-btn">
                    출근하기
                </button>

            </section>

            <!-- KPI 카드 -->
            <section class="kpi-grid">

                <div class="kpi-card">
                    <p>출근 인원</p>
                    <h3>128</h3>
                </div>

                <div class="kpi-card">
                    <p>휴가 중</p>
                    <h3>12</h3>
                </div>

                <div class="kpi-card">
                    <p>승인 대기</p>
                    <h3>7</h3>
                </div>

                <div class="kpi-card">
                    <p>총 근무시간</p>
                    <h3>1,284h</h3>
                </div>

            </section>

            <!-- 하단 -->
            <section class="bottom-grid">

                <div class="panel">
                    <h3>오늘 일정</h3>
                </div>

                <div class="panel">
                    <h3>공지사항</h3>
                </div>

            </section>

        </div>

    </main>

</div>

</body>
</html>

