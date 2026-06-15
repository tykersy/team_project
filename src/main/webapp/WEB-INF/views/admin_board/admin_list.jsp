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
    <title>공지사항 관리</title>
    <link rel="stylesheet" href="/css/sidebar.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/board.css"> 
</head>
<body>

<div class="layout">
    <%-- 관리자용 사이드바/헤더로 경로 확인하세요 --%>
    <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/WEB-INF/views/admin_common/admin_header.jsp" />

        <div class="dashboard-container">
            <div class="panel" style="width: 100%;">
                <h1 style="text-align: center;">공지사항 관리</h1>

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
                                <%-- 관리자용 상세 페이지 경로로 수정 --%>
                                <td><a href="/admin/board/detail?idx=${board.idx}">${board.title}</a></td>
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
                
                <div style="display: flex; justify-content: space-between; align-items: center; margin: 30px 0;">
                    <div style="width: 100px;"></div> 
                    
                    <%-- 검색 폼 경로 수정 --%>
                    <form action="/admin/board/list" method="get" style="display: flex; align-items: center; border: 1px solid #ccc; padding: 0 10px; width: 300px; height: 35px; background: white;">
                        <input type="text" name="keyword" value="${keyword}" placeholder="Search" style="border: none; outline: none; width: 100%; height: 100%; padding: 5px;">
                        <button type="submit" style="border: none; background: none; cursor: pointer;">🔍</button>
                    </form>

                    <%-- 관리자 전용 글쓰기 버튼 --%>
                    <a href="/admin/board/write" style="padding: 8px 20px; background-color: #333; color: #fff; text-decoration: none; font-weight: bold;">글쓰기</a>
                </div>

                <%-- 페이징 영역 (중복 forEach 제거) --%>
                <div style="text-align: center; margin-bottom: 30px;">
                    <a href="/admin/board/list?page=${currentPage > 1 ? currentPage - 1 : 1}&keyword=${keyword}" style="text-decoration: none; color: #333; margin: 0 10px;">&lt;</a>
                    
                    <c:forEach begin="1" end="${totalPages}" var="i">
                        <c:choose>
                            <c:when test="${currentPage == i}">
                                <a href="/admin/board/list?page=${i}&keyword=${keyword}" style="margin: 0 8px; text-decoration: none; color: #000; font-weight: bold;">${i}</a>
                            </c:when>
                            <c:otherwise>
                                <a href="/admin/board/list?page=${i}&keyword=${keyword}" style="margin: 0 8px; text-decoration: none; color: #888;">${i}</a>
                            </c:otherwise>
                        </c:choose>
                    </c:forEach>
                    
                    <a href="/admin/board/list?page=${currentPage < totalPages ? currentPage + 1 : totalPages}&keyword=${keyword}" style="text-decoration: none; color: #333; margin: 0 10px;">&gt;</a>
                </div>            
            </div> 
        </div> 
    </main>
</div> 
</body>
</html>