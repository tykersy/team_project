<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title></title>
        <link rel="stylesheet" href="/css/user/mypage.css">
        <link rel="stylesheet" href="/css/dashboard.css">
    </head>
    <body>
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        <div class="container">
        <div class="page-title">마이페이지</div>
        <div class="page-sub">근로 정보 및 급여 내역을 확인하세요</div>

        <div class="tabs">
            <button class="tab-btn active" onclick="switchTab(0)">📄 근로계약서</button>
            <button class="tab-btn" onclick="switchTab(1)">🕐 출 / 퇴근</button>
            <button class="tab-btn" onclick="switchTab(2)">💰 급여</button>
            <button class="tab-btn" onclick="switchTab(3)">📊 근태현황</button>
        </div>
        
        <!-- ─────────────────────────────── TAB 1: 근로계약서 ─── -->
        <div class="panel active" id="panel-0">
        
            <div class="card">
            <div class="card-title"><span class="dot"></span>계약 정보</div>
            <div class="info-grid">
                <div class="info-item"><label>성명</label><div class="val">${info.saname}</div></div>
                <div class="info-item"><label>사번</label><div class="val mono">${info.sabun}</div></div>
                <div class="info-item"><label>소속 부서</label><div class="val">개발팀</div></div>
                <div class="info-item"><label>직위</label><div class="val">${info.sajob}</div></div>
                <div class="info-item"><label>입사일</label><div class="val mono">${info.sahire}</div></div>
                <div class="info-item"><label>계약 기간</label><div class="val mono">2024. 03. 04 ~ 2026. 03. 03</div></div>
                <div class="info-item"><label>근무 형태</label><div class="val">정규직</div></div>
                <div class="info-item">
                <label>계약 상태</label>
                <div class="val">
                    <span class="status-chip active-contract">
                    <span class="pulse"></span>유효
                    </span>
                </div>
                </div>
            </div>
            </div>
        
            <div class="card">
            <div class="card-title"><span class="dot"></span>근로 조건</div>
            <div class="info-grid">
                <div class="info-item"><label>소정 근로시간</label><div class="val">주 40시간</div></div>
                <div class="info-item"><label>근무 요일</label><div class="val">월 ~ 금</div></div>
                <div class="info-item"><label>출근 시간</label><div class="val mono">09:00</div></div>
                <div class="info-item"><label>퇴근 시간</label><div class="val mono">18:00</div></div>
                <div class="info-item"><label>기본급</label><div class="val mono">3,200,000 원</div></div>
                <div class="info-item"><label>연봉</label><div class="val mono">38,400,000 원</div></div>
            </div>
            </div>
        
            <div class="card">
            <div class="card-title"><span class="dot"></span>계약서 문서</div>
            <div class="contract-doc">
                <div class="doc-info">
                <div class="doc-icon">📋</div>
                <div>
                    <div class="doc-name">근로계약서_김민준_2024.pdf</div>
                    <div class="doc-date">서명일 2024. 03. 02 &nbsp;·&nbsp; 전자서명 완료</div>
                </div>
                </div>
                <button class="btn-outline">다운로드</button>
            </div>
            </div>
        </div>
        
        <!-- ─────────────────────────────── TAB 2: 출/퇴근 ─── -->
        <div class="panel" id="panel-1">
        
            <div class="card">
            <div class="card-title"><span class="dot"></span>이번 달 요약 (2025년 5월)</div>
            <div class="time-summary">
                <div class="time-stat"><span class="num">168.5</span><span class="lbl">총 근무시간 (h)</span></div>
                <div class="time-stat"><span class="num">21</span><span class="lbl">출근일수</span></div>
                <div class="time-stat"><span class="num">3.5</span><span class="lbl">초과 근무 (h)</span></div>
            </div>
            </div>
        
            <div class="card">
            <div class="card-title"><span class="dot"></span>출 / 퇴근 기록</div>
            <table>
                <thead>
                <tr>
                    <th>날짜</th>
                    <th>출근</th>
                    <th>퇴근</th>
                    <th>근무시간</th>
                    <th>상태</th>
                </tr>
                </thead>
                <tbody>
                <tr><td class="label">05. 27 (월)</td><td>09:02</td><td>18:15</td><td>9h 13m</td><td><span class="tag normal">정상</span></td></tr>
                <tr><td class="label">05. 26 (금)</td><td>09:00</td><td>19:30</td><td>10h 30m</td><td><span class="tag normal">정상</span></td></tr>
                <tr><td class="label">05. 23 (목)</td><td>09:22</td><td>18:00</td><td>8h 38m</td><td><span class="tag late">지각</span></td></tr>
                <tr><td class="label">05. 22 (수)</td><td>09:00</td><td>18:00</td><td>8h 00m</td><td><span class="tag normal">정상</span></td></tr>
                <tr><td class="label">05. 21 (화)</td><td>09:00</td><td>18:00</td><td>8h 00m</td><td><span class="tag normal">정상</span></td></tr>
                <tr><td class="label">05. 20 (월)</td><td>—</td><td>—</td><td>—</td><td><span class="tag absent">결근</span></td></tr>
                <tr><td class="label">05. 17 (금)</td><td>08:50</td><td>17:55</td><td>9h 05m</td><td><span class="tag early">조기출근</span></td></tr>
                <tr><td class="label">05. 16 (목)</td><td>09:00</td><td>18:00</td><td>8h 00m</td><td><span class="tag normal">정상</span></td></tr>
                <tr><td class="label">05. 15 (수)</td><td>09:05</td><td>18:10</td><td>8h 55m</td><td><span class="tag normal">정상</span></td></tr>
                <tr><td class="label">05. 14 (화)</td><td>09:00</td><td>18:00</td><td>8h 00m</td><td><span class="tag normal">정상</span></td></tr>
                </tbody>
            </table>
            </div>
        </div>
        
        <!-- ─────────────────────────────── TAB 3: 급여 ─── -->
        <div class="panel" id="panel-2">
        
            <div class="card">
            <div class="salary-hero">
                <div class="month">2025년 5월 급여</div>
                <div class="amount">${info.sapay}</div>
                <div class="unit">원 (실수령액)</div>
            </div>
            <div class="salary-breakdown">
                <div class="breakdown-row"><span class="name">기본급</span><span class="amt">3,200,000</span></div>
                <div class="breakdown-row"><span class="name">초과근무수당</span><span class="amt">280,000</span></div>
                <div class="breakdown-row deduct"><span class="name">국민연금</span><span class="amt">-144,000</span></div>
                <div class="breakdown-row deduct"><span class="name">건강보험</span><span class="amt">-111,760</span></div>
                <div class="breakdown-row deduct"><span class="name">고용보험</span><span class="amt">-28,800</span></div>
                <div class="breakdown-row deduct"><span class="name">소득세</span><span class="amt">-15,440</span></div>
                <div class="breakdown-row total"><span class="name">실수령액</span><span class="amt">3,380,000</span></div>
            </div>
            </div>
        
            <div class="card salary-history">
            <div class="card-title"><span class="dot"></span>급여 내역</div>
            <table>
                <thead>
                <tr><th>지급월</th><th>지급일</th><th>총 지급액</th><th>공제액</th><th>실수령액</th></tr>
                </thead>
                <tbody>
                <tr><td class="label">2025. 05</td><td>05. 25</td><td>3,480,000</td><td>300,000</td><td style="color:var(--green)">3,180,000</td></tr>
                <tr><td class="label">2025. 04</td><td>04. 25</td><td>3,200,000</td><td>300,000</td><td style="color:var(--green)">2,900,000</td></tr>
                <tr><td class="label">2025. 03</td><td>03. 25</td><td>3,200,000</td><td>300,000</td><td style="color:var(--green)">2,900,000</td></tr>
                <tr><td class="label">2025. 02</td><td>02. 25</td><td>3,550,000</td><td>300,000</td><td style="color:var(--green)">3,250,000</td></tr>
                <tr><td class="label">2025. 01</td><td>01. 25</td><td>3,200,000</td><td>300,000</td><td style="color:var(--green)">2,900,000</td></tr>
                </tbody>
            </table>
            </div>
        </div>
        
        <!-- ─────────────────────────────── TAB 4: 근태현황 ─── -->
        <div class="panel" id="panel-3">
        
            <div class="card">
            <div class="card-title"><span class="dot"></span>이번 달 근태 요약</div>
            <div class="attend-grid">
                <div class="attend-stat"><span class="n green">21</span><span class="lbl">정상 출근</span></div>
                <div class="attend-stat"><span class="n yellow">2</span><span class="lbl">지각</span></div>
                <div class="attend-stat"><span class="n red">1</span><span class="lbl">결근</span></div>
                <div class="attend-stat"><span class="n blue">3</span><span class="lbl">조기 출근</span></div>
            </div>
            </div>
        
            <div class="card mini-cal">
            <div class="card-title"><span class="dot"></span>근태 캘린더</div>
            <div class="cal-header">
                <div class="cal-title">2025년 5월</div>
                <div class="cal-nav">
                <button>‹</button>
                <button>›</button>
                </div>
            </div>
            <div class="cal-grid">
                <div class="cal-day-head">일</div>
                <div class="cal-day-head">월</div>
                <div class="cal-day-head">화</div>
                <div class="cal-day-head">수</div>
                <div class="cal-day-head">목</div>
                <div class="cal-day-head">금</div>
                <div class="cal-day-head">토</div>
        
                <!-- Week 1: May 1 = Thursday -->
                <div class="cal-day empty"></div>
                <div class="cal-day empty"></div>
                <div class="cal-day empty"></div>
                <div class="cal-day empty"></div>
                <div class="cal-day work">1</div>
                <div class="cal-day work">2</div>
                <div class="cal-day off">3</div>
                <!-- Week 2 -->
                <div class="cal-day off">4</div>
                <div class="cal-day work">5</div>
                <div class="cal-day work">6</div>
                <div class="cal-day work">7</div>
                <div class="cal-day work">8</div>
                <div class="cal-day work">9</div>
                <div class="cal-day off">10</div>
                <!-- Week 3 -->
                <div class="cal-day off">11</div>
                <div class="cal-day work">12</div>
                <div class="cal-day work">13</div>
                <div class="cal-day work">14</div>
                <div class="cal-day work">15</div>
                <div class="cal-day work">16</div>
                <div class="cal-day off">17</div>
                <!-- Week 4 -->
                <div class="cal-day off">18</div>
                <div class="cal-day absent-day">19</div>
                <div class="cal-day absent-day">20</div>
                <div class="cal-day work">21</div>
                <div class="cal-day late-day">22</div>
                <div class="cal-day work">23</div>
                <div class="cal-day off">24</div>
                <!-- Week 5 -->
                <div class="cal-day off">25</div>
                <div class="cal-day work">26</div>
                <div class="cal-day today">27</div>
                <div class="cal-day off">28</div>
                <div class="cal-day off">29</div>
                <div class="cal-day off">30</div>
                <div class="cal-day off">31</div>
            </div>
            <div class="legend">
                <div class="legend-item"><div class="legend-dot" style="background:rgba(34,197,94,0.4)"></div>정상출근</div>
                <div class="legend-item"><div class="legend-dot" style="background:rgba(245,158,11,0.4)"></div>지각</div>
                <div class="legend-item"><div class="legend-dot" style="background:rgba(239,68,68,0.3)"></div>결근</div>
                <div class="legend-item"><div class="legend-dot" style="background:var(--accent)"></div>오늘</div>
            </div>
            </div>
        
            <div class="card">
            <div class="card-title"><span class="dot"></span>연간 근태 현황</div>
            <table>
                <thead>
                <tr><th>월</th><th>정상</th><th>지각</th><th>결근</th><th>조기출근</th><th>총 근무(h)</th></tr>
                </thead>
                <tbody>
                <tr><td class="label">1월</td><td>21</td><td>1</td><td>0</td><td>2</td><td>170.5</td></tr>
                <tr><td class="label">2월</td><td>19</td><td>0</td><td>0</td><td>3</td><td>158.0</td></tr>
                <tr><td class="label">3월</td><td>20</td><td>2</td><td>1</td><td>0</td><td>162.5</td></tr>
                <tr><td class="label">4월</td><td>22</td><td>0</td><td>0</td><td>1</td><td>176.0</td></tr>
                <tr><td class="label">5월</td><td>21</td><td>2</td><td>1</td><td>3</td><td>168.5</td></tr>
                </tbody>
            </table>
            </div>
        </div>
        
        </div>
        
        <script>
            function switchTab(idx) { // 마이페이지 탭 전환을 위한 스크립트
                document.querySelectorAll('.tab-btn').forEach((b, i) => {
                    b.classList.toggle('active', i === idx);
                });
                document.querySelectorAll('.panel').forEach((p, i) => {
                    p.classList.toggle('active', i === idx);
                });
            }
        </script>
    </body>
</html>