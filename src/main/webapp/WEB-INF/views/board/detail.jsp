<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>[Linked : 공지사항]</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board.css">
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
                    <span>작성일: ${fn:substring(board.created, 0, 10)}</span>
                </div>
                
                <hr style="margin: 20px 0; border: 0; border-top: 1px solid #e5e7eb;">
                
                <div class="post-content" style="min-height: 300px; padding: 10px 0; word-break: break-all;">
                    <c:out value="${board.content}" escapeXml="false" />
                </div>

                <div class="ai-box">

                    <div class="ai-toolbar">

                        <!-- AI 기능 -->
                        <select id="aiType" class="ai-select">
                            <option value="summary">🤖 AI 요약</option>
                            <option value="translate">🌍 AI 번역</option>
                        </select>

                        <!-- 번역 언어 -->
                        <select id="language" class="ai-select">
                            <option value="영어">English</option>
                            <option value="일본어">日本語</option>
                            <option value="중국어">中文</option>
                            <option value="프랑스어">Français</option>
                            <option value="독일어">Deutsch</option>
                            <option value="스페인어">Español</option>
                        </select>

                        <button
                            type="button"
                            onclick="callAi()"
                            class="btn-custom btn-primary">
                            실행
                        </button>

                    </div>

                    <div id="ai-result">
                        AI 기능을 선택한 후 실행 버튼을 눌러주세요.
                    </div>

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
function callAi() {

    const content = document.querySelector(".post-content").innerText;
    const resultDiv = document.getElementById("ai-result");

    const type = document.getElementById("aiType").value;
    const language = document.getElementById("language").value;

    const button = document.querySelector(".btn-primary");
    const selects = document.querySelectorAll(".ai-select");

    button.disabled = true;
    selects.forEach(s => s.disabled = true);

    resultDiv.innerText = "AI가 분석 중입니다... 잠시만 기다려주세요.";

    fetch("/board/ai-process", {
        method: "POST",
        headers: {
            "Content-Type":"application/json"
        },
        body: JSON.stringify({
            content: content,
            type: type,
            language: language
        })
    })
    .then(res => res.json())
    .then(data => {
        resultDiv.innerText = data.result;
    })
    .catch(err => {
        console.error(err);
        resultDiv.innerText = "처리 중 오류가 발생했습니다.";
    })
    .finally(() => {
        button.disabled = false;
        selects.forEach(s => s.disabled = false);

        // AI 요약 상태면 언어 선택 다시 비활성화
        toggleLanguage();
    });
}

const aiType = document.getElementById("aiType");
const language = document.getElementById("language");

function toggleLanguage() {
    language.disabled = (aiType.value === "summary");
}

aiType.addEventListener("change", toggleLanguage);
toggleLanguage();

</script>
</body>
</html>