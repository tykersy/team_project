<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // 관리자 세션 체크
    Boolean isAdmin = (Boolean)session.getAttribute("isAdmin");
    if (isAdmin == null || !isAdmin) {
        response.sendRedirect("/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세 (관리자)</title>
    <link rel="stylesheet" href="/css/sidebar.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/board.css"> 

    <script>
    function deletePost(idx) {
        if (confirm("정말 삭제하시겠습니까?")) {
            location.href = "/admin/board/delete?idx=" + idx;
        }
    }
    </script>
</head>
<body>
<div class="layout">
    <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp" />
    <main class="main-content">
        <jsp:include page="/WEB-INF/views/admin_common/admin_header.jsp" />

        <div class="dashboard-container">
            <div class="panel" style="width: 100%;">
                <h2 style="margin-bottom: 15px;">${board.title}</h2>
                <div class="post-info" style="display: flex; justify-content: flex-end; gap: 10px; color: #666; margin-bottom: 15px;">
                    <span>작성 부서: ${board.dept}</span>
                    <span>|</span>
                    <span>작성일: ${board.created}</span>
                </div>
                
                <hr style="margin: 20px 0; border: 0; border-top: 1px solid #e5e7eb;">
                
                <%-- 데이터가 없을 경우를 대비해 빨간 테두리(디버깅용) 추가 --%>
                <div class="post-content" style="min-height: 300px; padding: 10px; word-break: break-all; border: 1px solid #eee;">
                    <c:choose>
                        <c:when test="${not empty board.content}">
                            <c:out value="${board.content}" escapeXml="false" />
                        </c:when>
                        <c:otherwise>
                            <p style="color: red;">내용이 없습니다. (DB 확인 필요)</p>
                        </c:otherwise>
                    </c:choose>
                </div>
                
                <hr style="margin: 20px 0; border: 0; border-top: 1px solid #e5e7eb;">
                
                <div style="text-align: right; margin-top: 20px; display: flex; justify-content: flex-end; gap: 10px;">
                    <a href="/admin/board/update?idx=${board.idx}" style="padding: 8px 20px; background-color: #ffc107; color: #000; text-decoration: none; font-weight: bold;">수정</a>
                    <a href="#" onclick="deletePost(${board.idx}); return false;" style="padding: 8px 20px; background-color: #dc3545; color: #fff; text-decoration: none; font-weight: bold;">삭제</a>
                    <a href="/admin/board/list" style="padding: 8px 20px; background-color: #6c757d; color: #fff; text-decoration: none;">목록으로</a>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>