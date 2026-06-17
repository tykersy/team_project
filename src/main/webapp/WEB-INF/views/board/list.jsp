<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 게시판</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
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
                <h1 style="text-align: center;">공지사항</h1>

                <table class="board-table">
                    <thead>
                        <tr>
                            <th width="7%">No</th>
                            <th width="48%">제목</th>
                            <th width="15%">글쓴이</th>
                            <th width="20%">작성시간</th>
                            <th width="10%">조회수</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="board" items="${boardList}">
                            <tr>
                                <td>${board.idx}</td>
                                <td><a href="/board/detail?idx=${board.idx}">${board.title}</a></td>
                                <td>${board.saname}</td>
                                <td>${board.created}</td>
                                <td>${board.views}</td>
                            </tr>
                        </c:forEach> 
                        <c:if test="${empty boardList}">
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 20px;">등록된 공지사항이 없습니다.</td>
                            </tr>
                        </c:if> 
                    </tbody>
                </table>
                
                <div style="display: flex; justify-content: center; margin: 30px 0;">
                    <form action="/board/list" method="get" 
                          style="display: flex; align-items: center; border: 1px solid #ccc; padding: 0 15px; width: 300px; height: 40px; background: white;">
                        
                        <input type="text" name="keyword" value="${keyword}" placeholder="Search" 
                               style="border: none; outline: none; width: 100%; height: 100%; padding: 5px; font-size: 14px;">
                        
                        <button type="submit" style="border: none; background: none; cursor: pointer; color: #888; font-size: 16px;">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </button>
                    </form>
                </div>

                <div style="text-align: center; margin-bottom: 30px;">
                    <a href="/board/list?page=${currentPage > 1 ? currentPage - 1 : 1}&keyword=${keyword}" style="text-decoration: none; color: #333; margin: 0 10px;">&lt;</a>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${currentPage == i}">
                                <a href="/board/list?page=${i}&keyword=${keyword}" style="margin: 0 8px; text-decoration: none; color: #000; font-weight: bold;">${i}</a>
                            </c:when>
                            <c:otherwise>
                                <a href="/board/list?page=${i}&keyword=${keyword}" style="margin: 0 8px; text-decoration: none; color: #888;">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <a href="/board/list?page=${currentPage < totalPages ? currentPage + 1 : totalPages}&keyword=${keyword}" style="text-decoration: none; color: #333; margin: 0 10px;">&gt;</a>
                </div>            
            </div>
        <jsp:include page="/WEB-INF/views/common/msg.jsp" />
        </div> 
    </main>
</div> 
</body>
</html>