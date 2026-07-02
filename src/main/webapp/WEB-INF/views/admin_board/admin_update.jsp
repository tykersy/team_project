<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>[Linked : 공지사항]</title>
    <link rel="stylesheet" href="/css/admin/sidebar.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/board.css">
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"></script>
    <style>
        .board-table th { background-color: #F8FAFC !important; color: #475569 !important; text-align: center !important; font-weight: bold !important; border: 1px solid #e2e8f0; }
        .input-text { width: 98%; padding: 8px; border: 1px solid #e2e8f0; border-radius: 4px; }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp" />
    <main class="main-content">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        <div class="dashboard-container">
            <div class="content-card" style="width: 100%;">
                <h2 style="margin-bottom: 25px;">공지사항 수정</h2>
                <form action="/admin/board/update" method="post" id="updateForm">
                    <input type="hidden" name="idx" value="${board.idx}">
                    <input type="hidden" name="content" id="content">
                    <textarea id="origin-content" style="display: none;">${board.content}</textarea>
                    <table class="board-table">
                        <colgroup><col style="width: 15%;"><col style="width: 85%;"></colgroup>
                        <tr>
                            <th>제목</th>
                            <td>
                                <input type="text" name="title" value="${board.title}" class="input-text" required>
                            </td>
                        </tr>
                        <tr>
                            <th>작성 부서</th>
                            <td>${board.dept}</td>
                        </tr>
                        <tr>
                            <th>내용</th>
                            <td style="padding: 20px;">
                                <div id="editor-container" style="height: 400px; background-color: #fff;"></div>
                            </td>
                        </tr>
                    </table>
                    <div class="btn-container" style="display: flex; justify-content: center; gap: 10px; margin-top: 30px;">
                        <button type="button" onclick="submitForm()" class="btn-custom btn-primary">완료</button>
                        <a href="/admin/board/list" class="btn-custom btn-secondary" style="text-decoration:none;">취소</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>
<script>
    // 1. 폰트와 사이즈 설정
    var Font = Quill.import('formats/font');
    Font.whitelist = [false, 'malgun-gothic', 'nanum-gothic', 'serif', 'monospace']; 
    Quill.register(Font, true);

    var Size = Quill.import('formats/size');
    Size.whitelist = ['10', '12', '14', '16', '18', '20'];
    Quill.register(Size, true);

    // 2. 에디터 생성
    var quill = new Quill('#editor-container', {
        theme: 'snow',
        modules: {
            toolbar: [
                [{ 'font': Font.whitelist }],
                [{ 'size': Size.whitelist }],
                ['bold', 'italic', 'underline', 'strike'],
                [{ 'color': [] }, { 'background': [] }],
                [{ 'align': [] }],
                ['link', 'image'],
                ['clean']
            ]
        }
    });

    // 3. 수정 페이지인 경우에만 기존 데이터 로드
    var originContent = document.getElementById('origin-content');
    if (originContent) {
        quill.root.innerHTML = originContent.value;
    }

    // 4. 전송 로직
    function submitForm() {
        document.getElementById('content').value = quill.root.innerHTML;
        // 폼 ID가 writeForm인지 updateForm인지 확인 후 선택
        document.querySelector('form').submit(); 
    }
</script>
</body>
</html>