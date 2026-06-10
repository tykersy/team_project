<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세</title>
    <link rel="stylesheet" href="/css/sidebar.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/board.css"> 

    <script>
    function deletePost(idx) {
        if (confirm("정말 삭제하시겠습니까?")) {
            location.href = "/board/delete?idx=" + idx;
        }
    }
    </script>
</head>
<body>
<div class="layout">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
    <main class="main-content">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="dashboard-container">
            <div class="panel" style="width: 100%;">
                <h2 style="margin-bottom: 15px;">${board.title}</h2>
                <div class="post-info" style="display: flex; justify-content: flex-end; gap: 10px; color: #666; margin-bottom: 15px;">
                    <span>작성자: ${board.saname}</span>
                    <span>|</span>
                    <span>작성일: ${board.created}</span>
                </div>
                
                <hr style="margin: 20px 0; border: 0; border-top: 1px solid #e5e7eb;">
                
                <div class="post-content" style="min-height: 300px; padding: 10px 0; white-space: pre-wrap; word-break: break-all;">${board.content}</div>
                
                <hr style="margin: 20px 0; border: 0; border-top: 1px solid #e5e7eb;">
                
                <div style="text-align: right; margin-top: 20px;">
                    <a href="/board/update?idx=${board.idx}" class="btn-custom btn-primary">수정</a>
                    <a href="#" onclick="deletePost(${board.idx}); return false;" class="btn-custom btn-danger">삭제</a>
                    <a href="/board/list" class="btn-custom btn-secondary">목록으로</a>
                </div>
            </div>
        </div>
    </main>
</div>
</body>
</html>