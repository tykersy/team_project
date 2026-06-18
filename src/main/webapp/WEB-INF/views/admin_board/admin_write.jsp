<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // 간단한 로그인 세션 체크
    if (session.getAttribute("user") == null) {
        response.sendRedirect("/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 작성 (관리자)</title>
    <link rel="stylesheet" href="/css/admin/sidebar.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/board.css">
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"></script>
    <style>
        .board-table th { width: 15%; text-align: center; vertical-align: middle; }
        .board-table td { padding: 10px; }
        .input-text { width: 98%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        #editor-container { height: 300px; background-color: #fff; }
    </style>
</head>
<body>

<div class="layout">
    <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="dashboard-container">
            <div class="panel" style="width: 100%;">
                <h2 style="margin-bottom: 20px;">공지사항 작성</h2>
                
                <form action="/admin/board/write" method="post" id="writeForm">
                    <input type="hidden" name="content" id="content">

                    <table class="board-table">
                        <tbody>
                            <tr>
                                <th>제목</th>
                                <td><input type="text" name="title" class="input-text" required></td>
                            </tr>
                            <tr>
                                <th>작성 부서</th>
                                <td><c:out value="${member.dname}" default="부서 정보 없음" /></td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td>
                                    <div id="editor-container"></div>
                                </td>
                            </tr>
                        </tbody>
                    </table>

                    <div style="margin-top: 20px; display: flex; justify-content: flex-end; gap: 8px;">
                        <button type="submit" class="btn-custom btn-primary">등록</button>
                        <a href="/admin/board/list" class="btn-custom btn-secondary">취소</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    
    var quill = new Quill('#editor-container', {
        theme: 'snow',
        modules: {
            toolbar: [
                [{ 'header': [1, 2, 3, false] }],
                ['bold', 'italic', 'underline', 'strike'],
                [{ 'color': [] }, { 'background': [] }],
                [{ 'align': [] }],
                ['link', 'image'],
                ['clean']
            ]
        }
    });

    document.getElementById('writeForm').addEventListener('submit', function(e) {
        document.getElementById('content').value = quill.root.innerHTML;
        if (quill.getText().trim() === '') {
            alert('내용을 입력해주세요.');
            e.preventDefault();
        }
    });
</script>

</body>
</html>