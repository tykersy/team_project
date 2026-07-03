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

       /* 폰트 및 사이즈 툴바 항목에 실제 이름/숫자 표시 */
        .ql-snow .ql-picker.ql-size .ql-picker-label::before,
        .ql-snow .ql-picker.ql-size .ql-picker-item::before {
            content: attr(data-value) !important;
        }
        .ql-snow .ql-picker.ql-font .ql-picker-label::before,
        .ql-snow .ql-picker.ql-font .ql-picker-item::before {
            content: attr(data-value) !important;
        }

        /* 폰트 스타일 매핑 */
        .ql-font-malgun-gothic { font-family: 'Malgun Gothic', sans-serif; }
        .ql-font-nanum-gothic { font-family: 'Nanum Gothic', sans-serif; }
        .ql-font-serif { font-family: serif; }
        .ql-font-monospace { font-family: monospace; }

        /* 사이즈 스타일 매핑 */
        .ql-size-10 { font-size: 10px; }
        .ql-size-12 { font-size: 12px; }
        .ql-size-14 { font-size: 14px; }
        .ql-size-16 { font-size: 16px; }
        .ql-size-18 { font-size: 18px; }
        .ql-size-20 { font-size: 20px; }

        #editor-container .ql-editor { font-size: 14px; line-height: 1.6; }
        /* 폰트 선택창 너비 확장 (긴 폰트 이름도 다 보이게 설정) */
        .ql-snow .ql-picker.ql-font {
            min-width: 130px !important; 
        }
        .ql-snow .ql-picker.ql-font .ql-picker-options {
            min-width: 130px !important;
        }

        /* 사이즈 선택창 너비 조절 */
        .ql-snow .ql-picker.ql-size {
            min-width: 60px !important;
        }
        .ql-snow .ql-picker.ql-size .ql-picker-options {
            min-width: 60px !important;
        }
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
    // 1. 폰트와 사이즈 설정 (중요: false 제거)
    const Font = Quill.import('formats/font');
    Font.whitelist = ['malgun-gothic', 'nanum-gothic', 'serif', 'monospace']; 
    Quill.register(Font, true);

    const Size = Quill.import('formats/size');
    Size.whitelist = ['10', '12', '14', '16', '18', '20'];
    Quill.register(Size, true);

    // 2. 에디터 생성
    const quill = new Quill('#editor-container', {
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

    // 3. 수정 페이지 데이터 로드 개선
    const originContent = document.getElementById('origin-content');
    if (originContent && originContent.value) {
        // setTimeout을 사용하여 에디터 인스턴스가 완전히 준비된 후 데이터 삽입
        setTimeout(() => {
            // dangerouslyPasteHTML은 스타일이 포함된 HTML을 Quill 형식(Delta)으로 해석합니다.
            quill.clipboard.dangerouslyPasteHTML(originContent.value);
        }, 0);
    }

    // 4. 전송 로직
    function submitForm() {
        document.getElementById('content').value = quill.root.innerHTML;
        document.getElementById('updateForm').submit(); 
    }
</script>
</body>
</html>