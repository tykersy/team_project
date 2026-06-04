<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 작성</title>
    <link rel="stylesheet" href="/css/sidebar.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/board.css">
    <style>
        /* 글쓰기 전용 미세 조정: 테이블이 목록 페이지처럼 깔끔하게 나오도록 함 */
        .board-table th { width: 15%; text-align: center; vertical-align: middle; }
        .board-table td { padding: 10px; }
        .input-text { width: 98%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        .textarea-content { width: 98%; height: 300px; padding: 8px; border: 1px solid #ddd; border-radius: 4px; resize: none; box-sizing: border-box; }
    </style>
</head>
<body>

<div class="layout">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="dashboard-container">
            <div class="panel" style="width: 100%;">
                <h2 style="margin-bottom: 20px;">📢 공지사항 작성</h2>
                
                <form action="/board/write" method="post">
                    <input type="hidden" name="sabun" value="1001">

                    <table class="board-table">
                        <tbody>
                            <tr>
                                <th>제목</th>
                                <td><input type="text" name="title" class="input-text" required></td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td><textarea name="content" class="textarea-content" required></textarea></td>
                            </tr>
                        </tbody>
                    </table>

                    <div style="margin-top: 20px; text-align: right;">
                        <button type="submit" class="write-btn">등록</button>
                        <a href="/board/list" class="write-btn" style="background-color: #666; text-decoration: none;">취소</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

</body>
</html>