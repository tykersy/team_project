<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    // 권한 체크
    Object userObj = session.getAttribute("user");
    if (userObj == null || (int)userObj != 1) {
        response.sendRedirect("/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세</title>
    <link rel="stylesheet" href="/css/admin/sidebar.css">
    <link rel="stylesheet" href="/css/admin/main.css">
    <link rel="stylesheet" href="/css/board.css">
</head>
<body>
<div class="manager-container">
    <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp" />
    <main class="main-content">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        <div class="dashboard-container">
            <div class="panel" style="padding: 20px;">
                <h2>${board.title}</h2>
                <div style="margin-bottom: 20px; color: #666;">
                    작성자: ${board.saname} | 작성일: ${fn:substring(board.created, 0, 10)}
                <div style="min-height: 200px; padding: 15px; background: #fdfdfd; border: 1px solid #eee;">
                    ${board.content}
                </div>
                <div style="margin-top: 20px; text-align: center;">
                    <a href="/admin/board/list" class="action-btn" style="background:#666; color:white; padding:10px;">목록</a>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>