<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
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
        .btn-container { margin-top: 30px; padding-bottom: 50px; display: flex; justify-content: flex-end; gap: 10px; }
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

                    <div class="btn-container">
                        <button type="button" onclick="submitForm()" class="btn-custom btn-primary" style="cursor:pointer;">등록</button>
                        <a href="/admin/board/list" class="btn-custom btn-secondary" style="text-decoration:none;">취소</a>
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

    // 폼 강제 전송 함수
    function submitForm() {
        var contentField = document.getElementById('content');
        var quillContent = quill.root.innerHTML;
        
        // 1. 내용 유효성 검사
        if (quill.getText().trim() === '') {
            alert('내용을 입력해주세요.');
            return;
        }

        // 2. 내용 주입
        contentField.value = quillContent;

        // 3. 폼 제출
        console.log("폼 제출 시도...");
        document.getElementById('writeForm').submit();
    }
</script>

</body>
</html>