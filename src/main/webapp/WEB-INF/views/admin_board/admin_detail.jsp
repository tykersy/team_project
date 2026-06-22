<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%
    // 권한 체크: 로그인이 되어 있는지 확인
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
                    <c:out value="${board.content}" escapeXml="false" />
                </div>
                
                <div style="margin-top: 20px; text-align: center;">
                    <a href="/admin/board/list" class="btn-custom btn-secondary" style="text-decoration:none;">취소</a>
                    <button type="button" class="btn-custom btn-primary" onclick="location.href='/admin/board/update?idx=${board.idx}'">수정</button>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>