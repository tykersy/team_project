<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>조직 관리 시스템</title>

        <link rel="stylesheet" href="/css/admin/sidebar.css"/>
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

            .main-content {
                background: #f4f6f9;
            }

            /* 공통 카드 */
            .dashboard-card,
            .kpi-card {
                background: #fff;
                border-radius: 16px;
                padding: 20px;
                border: 1px solid #e5e7eb;
                box-shadow: 0 2px 8px rgba(0,0,0,.04);
            }

            /* KPI */
            .kpi-grid {
                display: grid;
                grid-template-columns: repeat(3, 1fr);
                gap: 20px;
                margin-bottom: 24px;
            }

            .kpi-card {
                text-align: center;
            }

            .kpi-title {
                display: block;
                color: #6b7280;
                font-size: 14px;
                margin-bottom: 12px;
            }

            .kpi-card strong {
                font-size: 36px;
                color: #111827;
                font-weight: 700;
            }

            /* 차트 */
            .chart-grid {
                display: grid;
                grid-template-columns: 1fr 1fr;
                gap: 20px;
                margin-bottom: 24px;
            }

            .chart-grid .dashboard-card {
                min-height: 320px;
            }

            /* 하단 */
            .bottom-grid {
                display: grid;
                grid-template-columns: 320px 1fr;
                gap: 20px;
            }

            /* 카드 헤더 */
            .card-header {
                margin-bottom: 20px;
            }

            .card-header h3 {
                font-size: 18px;
                font-weight: 600;
                color: #111827;
            }

            /* Quick Menu */
            .quick-menu {
                display: flex;
                flex-direction: column;
                gap: 15px;
            }

            .quick-menu button {
                height: 46px;
                border: none;
                border-radius: 10px;
                background: #111827;
                color: white;
                cursor: pointer;
                font-size: 15px;
                font-weight: 500;
                transition: .2s;
            }

            .quick-menu button:hover {
                background: #19243a;
            }

            /* 조직도 */
            .org-preview {
                background: #f8fafc;
                border-radius: 12px;
                padding: 20px;
                min-height: 250px;
            }

            .org-preview pre {
                margin: 0;
                font-size: 14px;
                line-height: 1.8;
                color: #374151;
                font-family: Consolas, monospace;
            }

            a{ color:white;
                text-decoration: none; }
        </style>

        <script>
            
        </script>
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp" />
            <div class="main-content">

                <!-- KPI -->
                <div class="kpi-grid">
                    <div class="kpi-card">
                        <span class="kpi-title">부서 수</span>
                        <strong>${deptCnt}</strong>
                    </div>

                    <div class="kpi-card">
                        <span class="kpi-title">직급 수</span>
                        <strong>${jobCnt}</strong>
                    </div>

                    <div class="kpi-card">
                        <span class="kpi-title">직원 수</span>
                        <strong>${sawonCnt}</strong>
                    </div>
                </div>

                <!-- 차트 영역 -->
                <div class="chart-grid">
                    <div class="dashboard-card">
                        <div class="card-header">
                            <h3>부서별 인원수</h3>
                        </div>

                        <div class="card-body">
                            <c:forEach var="d" items="${deptCntList}">
                                ${d.deptName} - ${d.sawonCount}명
                            </c:forEach>
                        </div>
                    </div>

                    <div class="dashboard-card">
                        <div class="card-header">
                            <h3>직급별 인원수</h3>
                        </div>

                        <div class="card-body">
                            <c:forEach var="p" items="${positionCnt}">
                                ${p.sajob} - ${p.cnt}명
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- 하단 영역 -->
                <div class="bottom-grid">

                    <div class="dashboard-card">
                        <div class="card-header">
                            <h3>Quick Menu</h3>
                        </div>

                        <div class="quick-menu">
                            <button><a href="/admin_deptlist">부서 관리</a></button>
                            <button><a href="/admin_job_position">직급 관리</a></button>
                            <button>조직도 관리</button>
                        </div>
                    </div>

                    <div class="dashboard-card">
                        <div class="card-header">
                            <h3>조직도 미리보기</h3>
                        </div>

                        <div class="org-preview">
            <pre>
            대표이사
            ├─ 경영지원본부
            │  ├─ 인사팀
            │  └─ 총무팀
            └─ 개발본부
            ├─ 개발1팀
            └─ 개발2팀
            </pre>
                        </div>
                    </div>

                </div>

            </div>
        </div>
    </body>
    
</html>