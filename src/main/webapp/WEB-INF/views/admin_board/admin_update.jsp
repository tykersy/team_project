<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%
    // [권한 체크 수정] 로그인 여부만 확인하도록 변경
    Object userObj = session.getAttribute("user");
    if (userObj == null) {
        response.sendRedirect("/login");
        return;
    }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 수정(관리자용)</title>
    <link rel="stylesheet" href="/css/admin/sidebar.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/board.css"> 
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"></script>
    <style> #editor-container { height: 300px; background-color: #fff; } </style>
</head>
<body>
<div class="layout">
    <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp" />
    <main class="main-content">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="dashboard-container">
            <div class="panel" style="width: 100%;">
                <h2>공지사항 수정</h2>
                <form action="/admin/board/update" method="post" id="updateForm">
                    <input type="hidden" name="idx" value="${board.idx}">
                    <input type="hidden" name="content" id="content">
                    <table class="board-table">
                        <tr>
                            <th width="15%">제목</th>
                            <td><input type="text" name="title" value="${board.title}" style="width: 100%; padding: 10px;" required></td>
                        </tr>
                        <tr>
                            <th>작성 부서</th>
                            <td>${board.dept}</td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td>
                                <textarea id="origin-content" style="display: none;">${board.content}</textarea>
                                <div id="editor-container"></div>
                            </td>
                        </tr>
                    </table>
                    <div style="text-align: right; margin-top: 30px;">
                        <button type="button" onclick="location.href='/admin/board/detail?idx=${board.idx}'" class="btn-custom btn-secondary">취소</button>
                        <button type="submit" class="btn-custom btn-primary">완료</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
<script>
    // [에디터 기능 추가] 툴바 옵션 설정
    var toolbarOptions = [
        [{ 'header': [1, 2, 3, false] }],
        ['bold', 'italic', 'underline', 'strike'],        
        [{ 'color': [] }, { 'background': [] }],          
        [{ 'align': [] }],                                
        [{ 'list': 'ordered'}, { 'list': 'bullet' }],     
        ['link', 'image'],                                
        ['clean']                                         
    ];

    var quill = new Quill('#editor-container', { 
        modules: {
            toolbar: toolbarOptions
        },
        theme: 'snow' 
    });

    quill.root.innerHTML = document.getElementById('origin-content').value;

    document.getElementById('updateForm').addEventListener('submit', function(e) {
        document.getElementById('content').value = quill.root.innerHTML;
        if (quill.getText().trim() === '') { 
            alert('내용을 입력해주세요.'); 
            e.preventDefault(); 
        }
    });
</script>
</body>
</html>