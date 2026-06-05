<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 게시판</title>
    
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
                <h2 style="display: inline-block;">📢 공지사항</h2>
                <a href="/board/write" class="write-btn">작성</a>

                <table class="board-table">
                    <thead>
                        <tr>
                            <th width="10%">번호</th>
                            <th width="35%">제목</th>
                            <th width="30%">작성자(부서명)</th>
                            <th width="25%">작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="board" items="${boardList}">
                            <tr>
                                <td>${board.idx}</td>
                                <td><a href="/board/detail?idx=${board.idx}">${board.title}</a></td>
                                <td>${board.saname} (${board.sabun})</td>
                                <td>${board.created}</td>
                            </tr>
                        </c:forEach> <c:if test="${empty boardList}">
                            <tr>
                                <td colspan="4" style="text-align: center; color: #888;">등록된 공지사항이 없습니다.</td>
                            </tr>
                        </c:if> </tbody>
                </table>
            </div>
        </div>

    </main>

</div>

</body>
</html>