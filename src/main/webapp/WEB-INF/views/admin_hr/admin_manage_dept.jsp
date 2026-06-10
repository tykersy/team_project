<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="/css/admin/sidebar.css">

<style>
    /* 기본 초기화 및 폰트 설정 */
    body {
        margin: 0;
        padding: 0;
        font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif;
        background-color: #f3f4f6;
        color: #1f2937;
    }

    /* ─── 레이아웃 구조 ─── */
    .manager-container {
        display: flex;       
        min-height: 100vh;
        width: 100%;
    }

    .main-content {
        flex: 1;             
        padding: 40px 45px;  /* 여백 적정 수준으로 조정 */
        box-sizing: border-box;
        max-width: 1400px;   /* [조정] 과하지 않게 딱 좋은 대시보드 표준 너비 */
        margin: 0;           
    }

    /* ─── 페이지 헤더 ─── */
    .page-header {
        margin-bottom: 32px; 
        border-bottom: 2px solid #e5e7eb;
        padding-bottom: 16px;
    }

    .page-title {
        font-size: 28px;    /* [조정] 너무 크지 않게 조절 (32px -> 28px) */
        font-weight: 700;
        color: #111827; 
        margin: 0;
    }

    /* ─── 대시보드 그리드 (테이블 배치) ─── */
    .dashboard-grid {
        display: grid;
        grid-template-columns: 2.2fr 1fr; 
        gap: 24px;          /* 간격 최적화 */
        margin-bottom: 24px;
    }

    /* ─── 카드 공통 스타일 ─── */
    .table-card, .summary-card {
        background: #ffffff; 
        border-radius: 14px; 
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
        padding: 28px;       /* [조정] 박스 볼륨감 적정화 (36px -> 28px) */
        box-sizing: border-box;
        border: 1px solid #e5e7eb;
    }

    /* ─── 테이블(Table) 디자인 ─── */
    table {
        width: 100%;
        border-collapse: collapse; 
        text-align: left;
    }

    caption {
        font-size: 20px;    /* [조정] (22px -> 20px) */
        font-weight: 600;
        color: #111827; 
        text-align: left;
        margin-bottom: 20px;
    }

    th, td {
        padding: 16px 20px; /* [조정] 위아래 줄간격을 딱 보기 좋은 황금비율로 조정 */
        font-size: 15px;    /* [조정] 본문 글씨 크기 최적화 (16px -> 15px) */
    }

    th {
        background-color: #f9fafb; 
        color: #4b5563;
        font-weight: 600;
    }

    tr:hover {
        background-color: #f9fafb; 
    }

    /* ─── 테이블 내 버튼(수정/삭제) 스타일 ─── */
    input[type="button"] {
        padding: 7px 14px;  
        border-radius: 7px;
        font-size: 13px;    
        font-weight: 500;
        cursor: pointer;
        border: 1px solid transparent;
        transition: all 0.2s;
        margin-right: 4px;
    }

    /* 수정 버튼 */
    input[type="button"][value="수정"] {
        background-color: #f3f4f6;
        color: #111827; 
        border: 1px solid #e5e7eb;
    }
    input[type="button"][value="수정"]:hover {
        background-color: #111827; 
        color: #ffffff;
        border-color: #111827;
    }

    /* 삭제 버튼 */
    input[type="button"][value="삭제"] {
        background-color: #fef2f2;
        color: #ef4444;
    }
    input[type="button"][value="삭제"]:hover {
        background-color: #ef4444;
        color: #ffffff;
    }

    /* ─── 부서별 인원수 배지 ─── */
    .count-badge {
        background-color: #111827; 
        color: #ffffff;
        padding: 5px 12px;  
        border-radius: 20px;
        font-size: 13px;    
        font-weight: 500;
        display: inline-block;
    }

    /* ─── 하단 요약 카드 (Summary Card) ─── */
    .summary-card {
        display: inline-block;
        min-width: 240px;   /* [조정] 하단 카드 크기 최적화 */
        margin-right: 20px;
        vertical-align: top;
    }

    .summary-title {
        font-size: 15px;    
        color: #6b7280;
        font-weight: 500;
        margin-bottom: 10px;
    }

    .summary-value {
        font-size: 32px;    /* [조정] 대형 숫자 크기 최적화 (36px -> 32px) */
        font-weight: 700;
        color: #111827; 
    }
</style>

    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            <div class="main-content">

    <div class="page-header">
        <h2 class="page-title">부서 관리</h2>
    </div>

    <div class="dashboard-grid">

        <div class="table-card">
            <table>
                <tr>
                    <th>부서번호</th>
                    <th>부서명</th>
                    <th>tel</th>
                    <th>setting</th>
                </tr>
                <c:forEach var="dept" items="${deptlist}">
                    <tr>
                        <td>${dept.deptno}</td>
                        <td>${dept.dname}</td>
                        <td>${dept.dtel}</td>
                        <td>
                            <input type="button" value="수정"/>
                            <input type="button" value="삭제"/>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>

        <div class="table-card">
            <table>
                <caption>부서별 인원 수</caption>
                <c:forEach var="count" items="${memberCnt}">
                    <tr>
                        <th>${count.deptName}</th>
                        <td>
                            <span class="count-badge">
                                ${count.sawonCount}명
                            </span>
                        </td>
                    </tr>
                </c:forEach>
            </table>
        </div>

    </div>

    <div class="summary-card">
            <div class="summary-title">전체 부서 수</div>
            <div class="summary-value">${deptcnt}</div>
    </div>

    <div class="summary-card">
        <div class="summary-title">최근 충원 부서</div>
        <c:if test="${ not empty cur_deptList }">
            <c:forEach var="cur" items="${cur_deptList}">
                <div class="summary-value">${cur.dname}</div>
            </c:forEach>
        </c:if>
        
    </div>

</div>
        </div>
    </body>
    
</html>