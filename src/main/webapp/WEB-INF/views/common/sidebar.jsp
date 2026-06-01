<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
    <!-- 사이드바 메뉴구성 -->

    <c:set var="uri" value="${pageContext.request.requestURI}" />

    <aside class="sidebar">
        
        <div class="logo">
            🔗Linked
        </div>

        <nav class="sidebar-menu">

            <a href="/dashboard" class="sidebar-item ${fn:contains(uri, '/dashboard') ? 'active' : ''}" >HOME</a>
            <a href="/org" class="sidebar-item ${fn:contains(uri, '/org') ? 'active' : ''}" >조직도</a>
            <a href="/board/list" class="sidebar-item ${fn:contains(uri, '/board/list') ? 'active' : ''}">공지사항</a>
            <a href="/calendar_calendarmain" class="sidebar-item ${fn:contains(uri, '/calendar_calendarmain') ? 'active' : ''}" >캘린더</a>
            <a href="/ta_main.do" class="sidebar-item ${fn:contains(uri, '/attendance') ? 'active' : ''}" >근태관리</a>
            <a href="/mypage" class="sidebar-item ${fn:contains(uri, '/mypage') ? 'active' : ''}">마이페이지</a>

        </nav>
        
        <div class="admin-section">

            <a href="/admin_main.do" class="admin-btn">⚙️관리자</a>

        </div>
    </aside>