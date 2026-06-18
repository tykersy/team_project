<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 관리</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/css/admin/sidebar.css">
    <style>
        .main-content { padding: 40px; }
        .main-content h1 { text-align: center; margin-bottom: 30px; }
        .main-content .board-table { width: 100%; border-collapse: collapse; background: white; margin-bottom: 30px; }
        .main-content .board-table th { background-color: #1E3A8A; color: white; padding: 15px; text-align: center; }
        .main-content .board-table td { padding: 15px; border-bottom: 1px solid #eee; text-align: center; }
        .main-content .btn-sm { padding: 6px 15px; text-decoration: none; font-size: 14px; color: white; border: none; cursor: pointer; border-radius: 6px; }
        .main-content .btn-blue { background: #3b82f6; }
        .main-content .btn-red { background: #ef4444; }
    </style>
</head>
<body>

<div class="layout" style="display: flex;">
    <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp" />
    
    <main class="main-content" style="flex: 1;">
        <h1>공지사항</h1>
        <table class="board-table">
            <thead>
                <tr>
                    <th width="6%">No</th>
                    <th width="27%">제목</th>
                    <th width="27%">작성 부서</th>
                    <th width="8%">작성일</th>
                    <th width="13%">조회수</th>
                    <th width="12%">관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="board" items="${boardList}">
                    <tr>
                        <td>${board.idx}</td>
                        <td style="text-align: left; padding-left: 15px;"><a href="/admin/board/detail?idx=${board.idx}">${board.title}</a></td>
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

        <div style="display: flex; justify-content: center; align-items: center; margin-bottom: 20px; position: relative;">
            <form action="/admin/board/list" method="get" style="border: 1px solid #ccc; padding: 5px 15px; display: flex; align-items: center; background: white; width: 300px;">
                <input type="text" name="keyword" value="${keyword}" placeholder="Search" style="border: none; outline: none; width: 100%; padding: 5px;">
                <button type="submit" style="border:none; background:none; cursor:pointer;"><i class="fa-solid fa-magnifying-glass"></i></button>
            </form>
            <a href="/admin/board/write" style="position: absolute; right: 0; background: #1E3A8A; color: white; padding: 8px 20px; text-decoration: none; font-weight: bold;">글쓰기</a>
        </div>

        <div style="text-align: center; margin-top: 20px; font-size: 18px;">
            <a href="/admin/board/list?page=${currentPage > 1 ? currentPage - 1 : 1}&keyword=${keyword}" style="text-decoration: none; color: #333; margin: 0 10px;">&lt;</a>
            <span style="font-weight: bold; margin: 0 10px;">${currentPage}</span>
            <a href="/admin/board/list?page=${currentPage < totalPages ? currentPage + 1 : totalPages}&keyword=${keyword}" style="text-decoration: none; color: #333; margin: 0 10px;">&gt;</a>
        </div>
    </main>
</div> 
</body>
</html>