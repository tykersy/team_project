<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 관리</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/css/admin/sidebar.css">
    <link rel="stylesheet" href="/css/admin/admin_board.css">
</head>
<body>

<div class="layout">
    <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp" />
    
    <main class="main-content">
        <div class="content-card">
            <h1>공지사항</h1>
            
            <table class="board-table">
                <thead>
                    <tr>
                        <th width="8%">No</th>
                        <th width="35%">제목</th>
                        <th width="20%">작성 부서</th>
                        <th width="12%">작성일</th>
                        <th width="10%">조회수</th>
                        <th width="15%">관리</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="board" items="${boardList}">
                        <tr>
                            <td>${board.idx}</td>
                            <td title="${board.title}"><a href="/admin/board/detail?idx=${board.idx}" style="text-decoration:none; color:#333;">${board.title}</a></td>
                            <td>${board.dept}</td>
                            <td>${fn:substring(board.created, 0, 10)}</td>
                            <td>${board.views}</td>
                            <td>
                                <a href="/admin/board/update?idx=${board.idx}" class="btn-sm btn-blue">수정</a>
                                <a href="/admin/board/delete?idx=${board.idx}" class="btn-sm btn-red" onclick="return confirm('삭제하시겠습니까?');">삭제</a>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>

            <div class="action-row">
                <form action="/admin/board/list" method="get" class="search-box">
                    <input type="text" name="keyword" value="${keyword}" placeholder="Search">
                    <button type="submit" style="border:none; background:none; cursor:pointer;"><i class="fa-solid fa-magnifying-glass"></i></button>
                </form>
                <a href="/admin/board/write" class="btn-write">작성</a>
            </div>

            <div class="pagination-row">
                <a href="/admin/board/list?page=${currentPage > 1 ? currentPage - 1 : 1}&keyword=${keyword}">&lt;</a>
                <span>${currentPage}</span>
                <a href="/admin/board/list?page=${currentPage < totalPages ? currentPage + 1 : totalPages}&keyword=${keyword}">&gt;</a>
            </div>
        </div>
    </main>
</div>
</body>
</html>