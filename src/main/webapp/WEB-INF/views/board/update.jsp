<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 수정</title>
    <link rel="stylesheet" href="/css/sidebar.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/board.css"> 

    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"></script>

    <style>
        /* 에디터 높이 조정 */
        #editor-container { height: 300px; background-color: #fff; }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
    <main class="main-content">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="dashboard-container">
            <div class="panel" style="width: 100%;">
                <h2>📢 공지사항 수정</h2>
                
                <form action="/board/update" method="post" id="updateForm">
                    <input type="hidden" name="idx" value="${board.idx}">
                    <input type="hidden" name="content" id="content">

                    <table class="board-table">
                        <tr>
                            <th width="15%">제목</th>
                            <td>
                                <input type="text" name="title" value="${board.title}" style="width: 100%; padding: 10px;" required>
                            </td>
                        </tr>
                        <tr>
                            <th>작성자</th>
                            <td>${board.saname} (${board.sabun})</td>
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
                        <button type="button" onclick="location.href='/board/detail?idx=${board.idx}'" class="btn-custom btn-secondary">취소</button>
                        <button type="submit" class="btn-custom btn-primary">완료</button>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    // Quill 에디터 초기화
    var quill = new Quill('#editor-container', {
        theme: 'snow',
        modules: {
            toolbar: [
                [{ 'font': [] }],
                [{ 'size': ['small', false, 'large', 'huge'] }],
                ['bold', 'italic', 'underline', 'strike'],
                [{ 'color': [] }, { 'background': [] }],
                ['clean']
            ]
        }
    });

    // 페이지 로딩 시 기존 DB에 저장된 HTML 밀어넣기
    var savedHtml = document.getElementById('origin-content').value;
    quill.root.innerHTML = savedHtml;

    // 수정 완료 버튼 클릭 시 유효성 검사 및 데이터 이동
    document.getElementById('updateForm').addEventListener('submit', function(e) {
        var contentHtml = quill.root.innerHTML;
        
        if (quill.getText().trim() === '') {
            alert('내용을 입력해주세요.');
            e.preventDefault();
            return;
        }

        document.getElementById('content').value = contentHtml;
    });
</script>

</body>
</html>