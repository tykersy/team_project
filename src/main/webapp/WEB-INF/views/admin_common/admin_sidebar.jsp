<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<aside class="sidebar">
    <div class="logo">🔗 Linked</div>

    <nav class="sidebar-menu">
        <div class="menu-group">
            <a href="/admin_main.do" class="sidebar-item active">HOME</a>
        </div>

        <div class="menu-group dropdown">
            <div class="sidebar-item">인사/조직 관리</div>
            <ul class="submenu">
                <li><a href="/sawon_list.do">사원 정보 관리</a></li>
                <li><a href="/admin_hr">부서/직급 관리</a></li>
            </ul>
        </div>

        <div class="menu-group dropdown">
            <div class="sidebar-item">근태/휴가 관리</div>
            <ul class="submenu">
                <li><a href="/admin_main.do/today_ta">일일 근태 현황</a></li>
                <li><a href="/admin_leave">휴가/연차 관리</a></li>
                <li><a href="/admin_calendar">캘린더</a></li>
            </ul>
        </div>

        <div class="menu-group dropdown">
            <div class="sidebar-item">전자결재 & 계약</div>
            <ul class="submenu">
                <li><a href="">결재 대기 문서</a></li>
                <li><a href="">전자 계약 관리</a></li>
            </ul>
        </div>

        <div class="menu-group dropdown">
            <div class="sidebar-item">급여/정산 관리</div>
            <ul class="submenu">
                <li><a href="/admin_TA_confirm_main">근태 정산 마감</a></li>
            </ul>
        </div>

        <div class="menu-group">
            <a href="/admin/board/list" class="sidebar-item">공지사항</a>
        </div>
        <div class="menu-group">
            <a href="/admin/system/list" class="sidebar-item">시스템 관리</a>
        </div>
    </nav>

    <div class="admin-section">
        <a href="/home" class="admin-btn">직원HOME</a>
    </div>
</aside>