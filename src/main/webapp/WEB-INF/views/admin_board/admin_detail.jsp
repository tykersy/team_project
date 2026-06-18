<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    // [수정사항] 권한 체크 로직 변경
    // 사번이 1인지 확인하는 대신, 로그인이 되어 있는지(세션이 null이 아닌지)만 확인
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
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
                <div style="display: flex; justify-content: flex-end; align-items: center; margin-bottom: 20px; color: #666; border-bottom: 1px solid #eee; padding-bottom: 10px; font-size: 0.9em; gap: 15px;">
                <span><strong>작성 부서:</strong> ${board.dept}</span>
                <span><strong>작성일:</strong> ${fn:substring(board.created, 0, 10)}</span>
                </div>
                <div style="min-height: 200px; padding: 15px; background: #fdfdfd; border: 1px solid #eee;">
                    ${board.content}
                </div>
                <div style="margin-top: 20px; text-align: center;">
                    <a href="/admin/board/list" class="action-btn" style="background:#666; color:white; padding:10px; text-decoration:none;">목록</a>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>