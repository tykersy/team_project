<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 작성</title>
    <link rel="stylesheet" href="/css/sidebar.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/board.css">
    
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"></script>

    <style>
        .board-table th { width: 15%; text-align: center; vertical-align: middle; }
        .board-table td { padding: 10px; }
        .input-text { width: 98%; padding: 8px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
        
        /* 에디터 높이 및 배경색 조정 */
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
                <h2 style="margin-bottom: 20px;">📢 공지사항 작성</h2>
                
                <form action="/board/write" method="post" id="writeForm">
                    <input type="hidden" name="sabun" value="1001">
                    <input type="hidden" name="content" id="content">

                    <table class="board-table">
                        <tbody>
                            <tr>
                                <th>제목</th>
                                <td><input type="text" name="title" class="input-text" required></td>
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
                        <a href="/board/list" class="btn-custom btn-secondary">취소</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    // Quill 에디터 초기화 (폰트, 사이즈, 굵기, 기울임, 글자색, 배경색 툴바 설정)
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

    // 폼 제출 직전 이벤트 가로채기
    document.getElementById('writeForm').addEventListener('submit', function(e) {
        // 에디터 내부의 HTML 코드를 가져옴
        var contentHtml = quill.root.innerHTML;
        
        // 공백 및 빈 태그 유효성 검사
        if (quill.getText().trim() === '') {
            alert('내용을 입력해주세요.');
            e.preventDefault(); // 제출 취소
            return;
        }

        // hidden input에 HTML 문자열 삽입
        document.getElementById('content').value = contentHtml;
    });
</script>

</body>
</html>