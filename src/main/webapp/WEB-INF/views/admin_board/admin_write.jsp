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
    <link rel="stylesheet" href="/css/admin/board-editor.css">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"></script>

    <style>
    /* 글쓰기 title 스타일적용 */
    .board-table th {
        background-color: #F8FAFC !important;
        color: #475569 !important;    
        text-align: center !important;
        font-weight: bold !important;
    }
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

                    <div class="btn-container" style="display: flex; justify-content: center; gap: 10px; margin-top: 30px;">
                        <button type="button" onclick="submitForm()" class="btn-custom btn-primary" style="cursor:pointer;">등록</button>
                        <a href="/admin/board/list" class="btn-custom btn-secondary" style="text-decoration:none;">취소</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    // 1. 폰트 설정
    var Font = Quill.import('formats/font');
    Font.whitelist = [false, 'malgun-gothic', 'nanum-gothic', 'serif', 'monospace']; 
    Quill.register(Font, true);

    // 2. 사이즈 설정
    var Size = Quill.import('formats/size');
    Size.whitelist = ['10', '12', '14', '16', '18', '20'];
    Quill.register(Size, true);

    // 3. 에디터 초기화 및 툴바 상세 설정
    var quill = new Quill('#editor-container', {
        theme: 'snow',
        modules: {
            toolbar: [
                [{ 'font': [false, 'malgun-gothic', 'nanum-gothic', 'serif', 'monospace'] }],
                [{ 'size': ['10', '12', '14', '16', '18', '20'] }], 
                [{ 'header': [1, 2, 3, false] }],
                ['bold', 'italic', 'underline', 'strike'],
                [{ 'color': [] }, { 'background': [] }],
                [{ 'align': [] }],
                ['link', 'image'],
                ['clean']
            ]
        }
    });

    // 4. 폼 전송
    function submitForm() {
        var contentField = document.getElementById('content');
        var quillContent = quill.root.innerHTML;
        
        if (quill.getText().trim() === '') {
            alert('내용을 입력해주세요.');
            return;
        }

        contentField.value = quillContent;
        document.getElementById('writeForm').submit();
    }
</script>

</body>
</html>