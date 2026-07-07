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
    <title>[Linked : 공지사항 작성]</title>
    <link rel="stylesheet" href="/css/admin/sidebar.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/board.css">
    <link rel="stylesheet" href="/css/admin/board-editor.css">
    <link href="https://fonts.googleapis.com/css2?family=Nanum+Gothic&display=swap" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.snow.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/quill@2.0.2/dist/quill.js"></script>

    <style>
    /* 1. 테이블 스타일 (관리자/사용자 공통) */
    .board-table th { background-color: #F8FAFC !important; color: #475569 !important; text-align: center !important; font-weight: bold !important; border: 1px solid #e2e8f0; }
    .input-text { width: 98%; padding: 8px; border: 1px solid #e2e8f0; border-radius: 4px; }

    /* 2. Quill 툴바 스타일 (이 부분을 페이지마다 직접 넣어주세요) */
    .ql-snow .ql-picker.ql-font .ql-picker-label::before,
    .ql-snow .ql-picker.ql-font .ql-picker-item::before { content: attr(data-value) !important; }
    .ql-snow .ql-picker.ql-size .ql-picker-label::before,
    .ql-snow .ql-picker.ql-size .ql-picker-item::before { content: attr(data-value) !important; }

    .ql-snow .ql-picker.ql-font { min-width: 120px !important; }
    .ql-snow .ql-picker.ql-size { min-width: 60px !important; }

    /* 3. 폰트/사이즈 클래스 매핑 (실제 적용용) */
    .ql-font-malgun-gothic { font-family: 'Malgun Gothic', sans-serif; }
    .ql-font-nanum-gothic { font-family: 'Nanum Gothic', sans-serif; }
    .ql-size-10 { font-size: 10px; }
    .ql-size-12 { font-size: 12px; }
    .ql-size-14 { font-size: 14px; }
    .ql-size-16 { font-size: 16px; }
    .ql-size-18 { font-size: 18px; }
    .ql-size-20 { font-size: 20px; }

    /* 4. 에디터 높이 및 기본 글자 크기 */
    #editor-container .ql-editor { font-size: 14px; line-height: 1.6; min-height: 300px; }
    </style>
    
</head>

<body>

<div class="layout">
    <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp" />

    <main class="main-content">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="dashboard-container">
            <div class="panel" style="width: 100%;">
                <h2 style="margin-bottom: 25px;">공지사항 작성</h2>
                
                <form action="/board/write" method="post" id="writeForm">
                    <input type="hidden" name="content" id="content">

                    <table class="board-table">
                        <tbody>
                            <tr>
                                <th>제목</th>
                                <td><input type="text" name="title" class="input-text" required></td>
                            </tr>
                            <tr>
                                <th>작성 부서</th>
                                <td><c:out value="${loginMember.dname}" default="부서 정보 없음" /></td>
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
                        <a href="/board/list" class="btn-custom btn-secondary" style="text-decoration:none;">취소</a>
                    </div>
                </form>
            </div>
        </div>
    </main>
</div>

<script>
    const fontList = ['malgun-gothic', 'nanum-gothic', 'serif', 'monospace'];
    const sizeList = ['10', '12', '14', '16', '18', '20'];

    const Font = Quill.import('formats/font');
    Font.whitelist = fontList;
    Quill.register(Font, true);

    const Size = Quill.import('formats/size');
    Size.whitelist = sizeList;
    Quill.register(Size, true);

    const quill = new Quill('#editor-container', {
        theme: 'snow',
        modules: {
            toolbar: [
                [{ 'font': fontList }],
                [{ 'size': sizeList }],
                ['bold', 'italic', 'underline', 'strike'],
                [{ 'color': [] }, { 'background': [] }],
                [{ 'align': [] }],
                ['link', 'image'],
                ['clean']
            ]
        }
    });

    function submitForm() {
        const contentField = document.getElementById('content');
        if (quill.getText().trim() === '' && quill.getContents().ops.length === 1) {
            alert('내용을 입력해주세요.');
            return;
        }
        contentField.value = quill.root.innerHTML;
        document.getElementById('writeForm').submit();
    }
</script>

</body>
</html>