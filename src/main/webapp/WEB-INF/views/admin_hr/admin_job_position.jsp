<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="/css/admin/sidebar.css">

        <style>
            /* ──────────────────────────────
            ★ 세로 정렬을 가로 정렬로 바꿔주는 핵심 코드
            ────────────────────────────── */
            .manager-container {
                display: flex;       /* 자식인 사이드바와 main-content를 가로로 배치 */
                min-height: 100vh;   /* 화면 전체 높이 차지 */
                width: 100%;
            }

            .main-content {
                flex: 1;             /* 사이드바를 제외한 나머지 모든 가로 공간을 차지 */
                padding: 40px;       /* 여백을 이쪽으로 이동 */
                box-sizing: border-box;
            }

            /* ────────────────────────────── */

.dashboard-grid {
    display: grid;
    grid-template-columns: 1fr 1fr;
    gap: 24px;
    margin-bottom: 24px;
    align-items: start;
}

/* 인원 수 배지 */
.count-badge {
    display: inline-flex;
    align-items: center;
    justify-content: center;

    min-width: 56px;
    padding: 4px 12px;

    border-radius: 999px;

    background: #e0f2fe;
    color: #0369a1;

    font-size: 12px;
    font-weight: 700;
}

/* 요약 카드 */
.summary-card {
    background: #ffffff;
    border-radius: 12px;

    border: 1px solid #eaecf0;

    box-shadow:
        0 1px 3px rgba(0,0,0,.06),
        0 4px 16px rgba(0,0,0,.04);

    padding: 28px;

    text-align: center;
}

.summary-title {
    font-size: 14px;
    color: #6b7280;
    margin-bottom: 10px;
}

.table-card {
    background: #fff;
    border-radius: 12px;
    padding: 20px;

    border: 1px solid #eaecf0;

    box-shadow:
        0 1px 3px rgba(0,0,0,.06),
        0 4px 16px rgba(0,0,0,.04);

    min-height: 380px;
}
.summary-value {
    font-size: 40px;
    font-weight: 700;
    color: #1a56db;
    line-height: 1;
}

/* 직급명 컬럼 */
tbody td:first-child {
    font-weight: 600;
    color: #1a2035;
}

/* 모바일 */
@media (max-width: 900px) {
    .dashboard-grid {
        grid-template-columns: 1fr;
    }
}
        </style>
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            <div class="main-content">

    <div class="page-header">
        <h2 class="page-title">직급 관리</h2>
    </div>

    <div class="dashboard-grid">

        <div class="table-card">
            <table>
                <caption>직급 목록</caption>
                <tr>
                    <th>직급</th>
                </tr>
                <c:forEach var="job" items="${jobList}">
                    <tr>
                        <td>${job.sajob}</td>
                    </tr>
                </c:forEach>
            </table>
        </div>

        <div class="table-card">
            <table>
                <caption>직급별 인원 수</caption>
                <c:forEach var="count" items="${positionCnt}">
                    <tr>
                        <th>${count.sajob}</th>
                        <td>
                            <span class="count-badge">
                                ${count.cnt}명
                            </span>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>

    </div>

    <div class="summary-card">
            <div class="summary-title">전체 직급 수</div>
            <div class="summary-value">${jobCnt}명</div>
    </div>

</div>
        </div>
    </body>
    
</html>