<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항</title>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    <link rel="stylesheet" href="/css/admin/sidebar.css">
    <style>
        /* 전체 레이아웃: 사이드바 + 메인 본문 */
        body { margin: 0; display: flex; min-height: 100vh; background-color: #f4f7f9; font-family: sans-serif; }
        .sidebar-wrapper { width: 240px; flex-shrink: 0; }
        .main-content { flex: 1; padding: 40px; }
        
        /* 2번째 사진처럼 라운딩 없이 평평한 테이블 스타일 */
        h1 { text-align: center; margin-bottom: 30px; }
        .board-table { width: 100%; border-collapse: collapse; background: white; }
        .board-table th { background-color: #1E3A8A; color: white; padding: 15px; text-align: center; }
        .board-table td { padding: 15px; border-bottom: 1px solid #eee; text-align: center; }
        
        /* 하단 검색 및 버튼 */
        .controls { display: flex; justify-content: center; align-items: center; gap: 10px; margin-top: 20px; }
        .search-area { border: 1px solid #ccc; padding: 5px 10px; display: flex; align-items: center; background: white; }
        .search-area input { border: none; outline: none; padding: 5px; width: 180px; }
        .btn-write { background: #1E3A8A; color: white; padding: 8px 20px; text-decoration: none; font-weight: bold; }
        
        /* 관리 버튼 */
        .btn-sm { padding: 4px 10px; text-decoration: none; font-size: 12px; color: white; border: none; cursor: pointer; }
        .btn-blue { background: #3b82f6; }
        .btn-red { background: #ef4444; }
    </style>
</head>
<body>
    <div class="sidebar-wrapper">
        <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp" />
    </div>

    <main class="main-content">
        <h1>공지사항</h1>
        <table class="board-table">
            <thead>
                <tr>
                    <th>No</th><th>제목</th><th>작성자</th><th>작성일자</th><th>조회수</th><th>관리</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="board" items="${boardList}">
                    <tr>
                        <td>${board.idx}</td>
                        <td style="text-align: left; padding-left: 15px;">
                            <a href="/admin/board/detail?idx=${board.idx}" style="text-decoration:none; color:#333;">${board.title}</a>
                        </td>
                        <td>${board.saname}</td>
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

        <div class="controls">
            <form action="/admin/board/list" method="get" class="search-area">
                <input type="text" name="keyword" value="${keyword}" placeholder="Search">
                <button type="submit" style="border:none; background:none; cursor:pointer;"><i class="fa-solid fa-magnifying-glass"></i></button>
            </form>
            <a href="/admin/board/write" class="btn-write">글쓰기</a>
        </div>
    </main>
</body>
</html>