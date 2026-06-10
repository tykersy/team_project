<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 수정</title>
    <link rel="stylesheet" href="/css/sidebar.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/board.css"> 
</head>
<body>
<div class="layout">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
    <main class="main-content">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="dashboard-container">
            <div class="panel" style="width: 100%;">
                <h2>📢 공지사항 수정</h2>
                
                <form action="/board/update" method="post">
                    <input type="hidden" name="idx" value="${board.idx}">

                    <table class="board-table">
                        <tr>
                            <th width="15%">제목</th>
                            <td>
                                <input type="text" name="title" value="${board.title}" style="width: 100%; padding: 10px;" required>
                            </td>
                        </tr>
                        <tr>
                            <th>작성자</th>
                            <td>${board.saname} (${board.sabun})</td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td>
                                <textarea name="content" rows="15" style="width: 100%; padding: 10px;" required>${board.content}</textarea>
                            </td>
                        </tr>
                    </table>

                    <div style="text-align: right; margin-top: 30px;">
                        <button type="button" onclick="location.href='/board/detail?idx=${board.idx}'" class="btn-custom btn-secondary">취소</button>
                        <button type="submit" class="btn-custom btn-primary">완료</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
</body>
</html>