<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>공지사항 상세</title>
    <link rel="stylesheet" href="/css/sidebar.css">
    <link rel="stylesheet" href="/css/dashboard.css">
    <link rel="stylesheet" href="/css/board.css">
    <style>
        /* AI 결과창을 위한 스타일 추가 */
        #ai-result {
            margin-top: 10px;
            padding: 15px;
            border-left: 4px solid #007bff;
            background-color: #f1f3f5;
            white-space: pre-line;
            color: #333;
            font-weight: 500;
            line-height: 1.6;
            min-height: 50px;
        }
    </style>
</head>
<body>
<div class="layout">
    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
    <main class="main-content">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />

        <div class="dashboard-container">
            <div class="panel" style="width: 100%;">
                <h2 style="margin-bottom: 15px;">${board.title}</h2>
                
                <div class="post-info" style="display: flex; justify-content: flex-end; gap: 10px; color: #666; margin-bottom: 15px; align-items: center;">
                    <span>작성 부서: ${board.dept}</span>
                    <span>|</span>
                    <span>작성일: ${board.created}</span>
                </div>
                
                <hr style="margin: 20px 0; border: 0; border-top: 1px solid #e5e7eb;">
                
                <div class="post-content" style="min-height: 300px; padding: 10px 0; word-break: break-all;">
                    <c:out value="${board.content}" escapeXml="false" />
                </div>

                <div style="margin: 30px 0; padding: 15px; border: 1px solid #ddd; border-radius: 8px; background-color: #f9f9f9;">
                    <div style="margin-bottom: 10px;">
                        <button type="button" onclick="callAi('summary')" class="btn-custom btn-primary">AI 요약</button>
                        <button type="button" onclick="callAi('translate')" class="btn-custom btn-primary">번역하기</button>
                    </div>
                    <div id="ai-result">AI 기능을 사용하려면 버튼을 클릭하세요.</div>
                </div>
                            
                <hr style="margin: 20px 0; border: 0; border-top: 1px solid #e5e7eb;">
                
                <div style="text-align: center; margin-top: 20px;">
                    <a href="/board/list" class="btn-custom btn-secondary">목록으로</a>
                </div>
            </div>
        </div>
    </main>
</div>

<script>
    function callAi(type) {
        const content = document.querySelector('.post-content').innerText;
        const resultDiv = document.getElementById("ai-result");
        
        resultDiv.innerText = "AI가 분석 중입니다... 잠시만 기다려주세요.";

        fetch('/board/ai-process', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ content: content, type: type })
        })
        .then(response => response.json())
        .then(data => {
            resultDiv.innerText = data.result;
        })
        .catch(error => {
            resultDiv.innerText = "처리 중 오류가 발생했습니다. 다시 시도해 주세요.";
            console.error('Error:', error);
        });
    }
</script>
</body>
</html>