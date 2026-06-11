<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>관리자 대시보드</title>

        <!-- Chart.js 라이브러리 -->
        <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

        <!-- sidebar css -->
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
        <style>
            /* 캘린더 출력할 div의 사이즈 조정 */
            #calendarbox {
                height:700px;
                width:80%
            }

            /* 대시보드 레이아웃 스타일 */
            .main-container {
                display: flex;
                flex-direction: column;
                gap: 24px;
            }
            
            /* 상단 퀵 현황 카드 */
            .card-row {
                display: flex;
                gap: 20px;
            }
            .summary-card {
                flex: 1;
                background: white;
                padding: 20px;
                border-radius: 12px;
                box-shadow: 0 4px 6px rgba(0,0,0,0.05);
                display: flex;
                flex-direction: column;
                gap: 8px;
            }
            .summary-card .title { font-size: 14px; color: #888; font-weight: 600; }
            .summary-card .value { font-size: 28px; font-weight: bold; color: #1e272e; }
            .summary-card .value.accent { color: #0984e3; }

            /* 차트 영역 레이아웃 */
            .chart-row {
                display: flex;
                gap: 20px;
            }
            .chart-box {
                background: white;
                padding: 24px;
                border-radius: 12px;
                box-shadow: 0 4px 15px rgba(0,0,0,0.05);
                box-sizing: border-box;
            }
            .chart-box.half { flex: 1; }
            .chart-box.third { flex: 1.5; }
            .chart-box h3 { margin-top: 0; margin-bottom: 20px; font-size: 18px; color: #2f3542; }
            
            /* 차트 크기 고정을 위한 컨테이너 */
            .chart-wrapper {
                position: relative;
                width: 100%;
                height: 300px;
            }
        </style>
        
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            <div class="main-content">
            
                <div class="card-row">
                <div class="summary-card">
                    <span class="title">미승인 결재 건수</span>
                    <span class="value accent">5 건</span>
                </div>
                <div class="summary-card">
                    <span class="title">오늘 전사 출근율</span>
                    <span class="value">92%</span>
                </div>
                <div class="summary-card">
                    <span class="title">이번 달 입/퇴사자</span>
                    <span class="value">3명 / 1명</span>
                </div>
                <div class="summary-card">
                    <span class="title">미체결 근로계약서</span>
                    <span class="value" style="color: #d63031;">2 건</span>
                </div>
            </div>

            <div class="chart-row">
                
                <div class="chart-box half">
                    <h3>오늘 근태 현황</h3>
                    <div class="chart-wrapper">
                        <canvas id="attendanceChart"></canvas>
                    </div>
                </div>
                
                <div class="chart-box third">
                    <h3>부서별 평균 연차 소진율 (%)</h3>
                    <div class="chart-wrapper">
                        <canvas id="vacationChart"></canvas>
                    </div>
                </div>
                
            </div>
        </div>

        <script th:inline="javascript">
        // 1. 근태 현황 도넛 차트 (Doughnut)
        const ctxAttendance = document.getElementById('attendanceChart').getContext('2d');
        new Chart(ctxAttendance, {
            type: 'doughnut',
            data: {
                labels: ['정상출근', '지각', '조퇴', '휴가/휴무', '결근'],
                datasets: [{
                    data: [
                        [[${todayTa.normalCount}]],
                        [[${todayTa.lateCount}]],
                        [[${todayTa.halfCount}]],
                        [[${todayTa.leaveCount}]],
                        [[${todayTa.absentCount}]]
                        ], // 임시 데이터 (나중에 DB값 매핑)
                    backgroundColor: [
                        '#2ed573', // 정상출근 (초록)
                        '#ffa502', // 지각 (주황)
                        '#eccc68', // 조퇴 (노랑)
                        '#1e90ff', // 휴가 (파랑)
                        '#ff4757'  // 결근 (빨강)
                    ],
                    borderWidth: 2
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                plugins: {
                    legend: {
                        position: 'right' // 범례를 오른쪽에 배치
                    }
                }
            }
        });

        // 2. 부서별 연차 소진율 막대 차트 (Bar)
        const ctxVacation = document.getElementById('vacationChart').getContext('2d');
        new Chart(ctxVacation, {
            type: 'bar',
            data: {
                labels: ['인사팀', '개발팀', '기획팀', '영업팀', '디자인팀', '재무팀'], // 부서명
                datasets: [{
                    label: '소진율 (%)',
                    data: [65, 42, 55, 78, 38, 50], // 임시 소진율 데이터
                    backgroundColor: 'rgba(9, 132, 227, 0.8)', // accent-blue 색상 활용
                    borderColor: '#0984e3',
                    borderWidth: 1,
                    borderRadius: 5 // 막대 끝을 둥글게
                }]
            },
            options: {
                responsive: true,
                maintainAspectRatio: false,
                scales: {
                    y: {
                        beginAtZero: true,
                        max: 100 // 백분율이므로 최댓값 100 고정
                    }
                },
                plugins: {
                    legend: {
                        display: false // 단일 데이터이므로 범례 숨김
                    }
                }
            }
        });
    </script>
    </body>
    
</html>