<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title></title>
        <link rel="stylesheet" href="/css/user/mypage.css">
        <link rel="stylesheet" href="/css/dashboard.css">
        <link rel="stylesheet" href="/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/toastui-calendar.min.css" />
        <script src="${pageContext.request.contextPath}/js/toastui-calendar.min.js"></script>
        
    </head>
    <body>
        <div class="layout">
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
        <main class="main-content">
        <jsp:include page="/WEB-INF/views/common/header.jsp" />
        
        <div class="container">
        <div class="page-title">마이페이지</div>
        <div class="page-sub"></div>

        <div class="tabs">
            <button class="tab-btn active" onclick="switchTab(0)"> 내 프로필 </button>
            <button class="tab-btn" onclick="switchTab(1)"> 출 / 퇴근</button>
            <button class="tab-btn" onclick="switchTab(2)"> 급여</button>
            <button class="tab-btn" onclick="switchTab(3)"> 근태현황</button>
            <button class="tab-btn" onclick="switchTab(4)"> 연차</button>
        </div>
        
        <!-- ─────────────────────────────── TAB 1: 내프로필 ─── -->
        <div class="panel active" id="panel-0">
            <div class="card">
                <div class="card-title"><span class="dot"></span>계약 정보</div>
                <div class="info-grid">
                    <div class="info-item"><label>성명</label><div class="val">${info.saname}</div></div>
                    <div class="info-item"><label>사번</label><div class="val mono">${info.sabun}</div></div>
                    <div class="info-item"><label>소속 부서</label><div class="val">${info.dname}</div></div>
                    <div class="info-item"><label>직위</label><div class="val">${info.sajob}</div></div>
                    <div class="info-item"><label>입사일</label><div class="val mono">${info.sahire}</div></div>
                    <div class="info-item"><label>계약 기간</label><div class="val mono">2024. 03. 04 ~ 2026. 03. 03</div></div>
                </div>
            </div>
        
            <div class="card">
            <div class="card-title"><span class="dot"></span>근로 조건</div>
            <div class="info-grid">
                <div class="info-item"><label>소정 근로시간</label><div class="val">주 40시간</div></div>
                <div class="info-item"><label>근무 요일</label><div class="val">월 ~ 금</div></div>
                <div class="info-item"><label>출근 시간</label><div class="val mono">09:00</div></div>
                <div class="info-item"><label>퇴근 시간</label><div class="val mono">18:00</div></div>
                <div class="info-item"><label>기본급</label><div class="val mono"><fmt:formatNumber value="${info.sapay}" pattern="#,###" /> 원</div></div>
                <div class="info-item"><label>연봉</label><div class="val mono"><fmt:formatNumber value="${info.sapay*12}" pattern="#,###" /> 원</div></div>
            </div>
            </div>
        
            

            <div class="card">
                <div class="card-title"><span class="dot"></span>보안</div>
                <div class="info-grid">
                    <div class="info-item">
                        <label>비밀번호</label>
                        <div class="val">
                            <a href="#" class="pw-edit-link" onclick="openPwModal(); return false;">수정</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        
        <!-- ─────────────────────────────── TAB 2: 출/퇴근 ─── -->
        <div class="panel" id="panel-1">
        
            <div class="card">
            <div class="card-title"><span class="dot"></span>이번 달 요약 (${today})</div>
            <div class="time-summary">
                <div class="time-stat"><span class="num">${userTotalTA.total_work_time}</span><span class="lbl">총 근무시간 (h)</span></div>
                <div class="time-stat"><span class="num">${userTotalTA.work_day}</span><span class="lbl">출근일수</span></div>
                <div class="time-stat"><span class="num">${userTotalTA.overtime}</span><span class="lbl">초과 근무 (h)</span></div>
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
                    <c:forEach var="taList" items="${userTaList}">
                        <tr>
                            <td class="label">${taList.day}</td>
                            <td>${taList.checkin}</td>
                            <td>${taList.checkout}</td>
                            <td>${taList.working_time}</td>
                            <td>
                                <span class="tag ${taList.status}">
                                    <c:choose>
                                        <c:when test="${taList.status eq 'late'}">지각</c:when>
                                        <c:when test="${taList.status eq 'normal'}">정상</c:when>
                                        <c:otherwise>기타</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                    <%-- <tr><td class="label">05. 26 (금)</td><td>09:00</td><td>19:30</td><td>10h 30m</td><td><span class="tag normal">정상</span></td></tr>
                    <tr><td class="label">05. 23 (목)</td><td>09:22</td><td>18:00</td><td>8h 38m</td><td><span class="tag late">지각</span></td></tr>
                    <tr><td class="label">05. 22 (수)</td><td>09:00</td><td>18:00</td><td>8h 00m</td><td><span class="tag normal">정상</span></td></tr>
                    <tr><td class="label">05. 21 (화)</td><td>09:00</td><td>18:00</td><td>8h 00m</td><td><span class="tag normal">정상</span></td></tr>
                    <tr><td class="label">05. 20 (월)</td><td>—</td><td>—</td><td>—</td><td><span class="tag absent">결근</span></td></tr>
                    <tr><td class="label">05. 17 (금)</td><td>08:50</td><td>17:55</td><td>9h 05m</td><td><span class="tag early">조기출근</span></td></tr>
                    <tr><td class="label">05. 16 (목)</td><td>09:00</td><td>18:00</td><td>8h 00m</td><td><span class="tag normal">정상</span></td></tr>
                    <tr><td class="label">05. 15 (수)</td><td>09:05</td><td>18:10</td><td>8h 55m</td><td><span class="tag normal">정상</span></td></tr>
                    <tr><td class="label">05. 14 (화)</td><td>09:00</td><td>18:00</td><td>8h 00m</td><td><span class="tag normal">정상</span></td></tr> --%>
                </tbody>
            </table>
            </div>
        </div>
        
        <!-- ─────────────────────────────── TAB 3: 급여 ─── -->
        <div class="panel" id="panel-2">
        
            <div class="card">
            <div class="salary-hero">
                <div class="month">${today} 급여</div>
                <div class="amount"><fmt:formatNumber value="${info.sapay}" pattern="#,###" /></div>
                <div class="unit"> 원 (실수령액)</div>
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

                <%-- 네비게이션 --%>
                <div class="cal-header">
                    <div class="cal-title" id="calTitle"></div>
                </div>

                <%-- TUI Calendar 컨테이너 --%>
                <div id="tuiCal" style="height:580px;"></div>

                <%-- 범례 --%>
                <div class="legend">
                    <div class="legend-item"><div class="legend-dot" style="background:rgba(34,197,94,0.5)"></div>정상출근</div>
                    <div class="legend-item"><div class="legend-dot" style="background:rgba(245,158,11,0.5)"></div>지각</div>
                    <div class="legend-item"><div class="legend-dot" style="background:rgba(239,68,68,0.4)"></div>결근</div>
                    <div class="legend-item"><div class="legend-dot" style="background:rgba(99,102,241,0.5)"></div>휴가</div>
                </div>
            </div>
        
            <div class="card">
            <div class="card-title"><span class="dot"></span>연간 근태 현황</div>
            <table>
                <thead>
                <tr><th>월</th><th>정상</th><th>지각</th><th>결근</th><th>조기출근</th><th>총 근무(h)</th></tr>
                </thead>
                <tbody>
                <c:forEach var="monthTA" items="${yearlyTA}" >
                    <tr>
                        <td class="label">${monthTA.month}월</td>
                        <td>${monthTA.normalCount}</td>
                        <td>${monthTA.lateCount}</td>
                        <td>0</td>
                        <td>0</td>
                        <td>${monthTA.totalWorkTime}</td>
                    </tr>
                </c:forEach>
                </tbody>
            </table>
            </div>
        </div>

            <!-- 5 연차 탭 -->

            <div class="panel" id="panel-4">

                <!-- 연차 잔여 현황 카드 -->
                <div class="card">
                    <div class="card-title"><span class="dot"></span>사용 가능 연차 현황</div>
                    <div class="leave-summary">
                        <div class="leave-stat">
                            <div class="leave-icon annual">📅</div>
                            <div class="leave-lbl">연차</div>
                            <div class="leave-num">${sleave.annual} 일</div>
                        </div>
                        <div class="leave-stat">
                            <div class="leave-icon mc">🏥</div>
                            <div class="leave-lbl">병가</div>
                            <div class="leave-num">${sleave.mc} 일</div>
                        </div>
                        <div class="leave-stat">
                            <div class="leave-icon health">💊</div>
                            <div class="leave-lbl">보건</div>
                            <div class="leave-num">${sleave.health} 일</div>
                        </div>
                        <div class="leave-stat">
                            <div class="leave-icon etc">📋</div>
                            <div class="leave-lbl">기타</div>
                            <div class="leave-num">${sleave.etc} 일</div>
                        </div>
                    </div>
                </div>

                <!-- 연차 신청 버튼 -->
                <div class="card">
                    <div class="card-title"><span class="dot"></span>연차 신청</div>
                    <div style="text-align:right; margin-bottom: 12px;">
                        <button class="btn-apply" onclick="openLeaveModal()">+ 연차 신청</button>
                    </div>

                    <!-- 신청 이력 테이블 -->
                    <table>
                        <thead>
                            <tr>
                                <th>신청일</th>
                                <th>종류</th>
                                <th>사용일자</th>
                                <th>일수</th>
                                <th>사유</th>
                                <th>상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty leaveLogList}">
                                    <tr><td colspan="6" style="text-align:center; color:#888;">신청 내역이 없습니다.</td></tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="log" items="${leaveLogList}">
                                        <tr>
                                            <td class="label"><fmt:formatDate value="${log.created_at}" pattern="MM. dd"/></td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${log.leave_type eq 'annual'}">연차</c:when>
                                                    <c:when test="${log.leave_type eq 'mc'}">병가</c:when>
                                                    <c:when test="${log.leave_type eq 'health'}">보건</c:when>
                                                    <c:otherwise>기타</c:otherwise>
                                                </c:choose>
                                            </td>
                                            <td>${log.use_date}</td>
                                            <td>${log.use_days} 일</td>
                                            <td>${log.reason}</td>
                                            <td>
                                                <c:if test="${log.approve}" >
                                                    <span class="tag normal">승인완료</span>
                                                </c:if>
                                                <c:if test="${not log.approve}" >
                                                    <span class="tag absent">승인중</span>
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>

                    

                </div>
            </div>

        </div>
        </main>
        </div>
        
        
        <%@ include file="passwordModal.jsp" %>
        <%@ include file="leaveModal.jsp" %>

        <script>
            // ── 탭 전환 ──
            function switchTab(idx) {
                document.querySelectorAll('.tab-btn').forEach((b, i) => {
                    b.classList.toggle('active', i === idx);
                });
                document.querySelectorAll('.panel').forEach((p, i) => {
                    p.classList.toggle('active', i === idx);
                });
            }

            const taData = JSON.parse('${taJson}');

            const styleMap = {
                normal : { label: '정상출근', bg: 'rgba(34,197,94,0.15)',  border: '#16a34a', text: '#15803d' },
                late   : { label: '지각',    bg: 'rgba(245,158,11,0.15)', border: '#d97706', text: '#b45309' },
                absent : { label: '결근',    bg: 'rgba(239,68,68,0.12)',  border: '#dc2626', text: '#b91c1c' },
                leave  : { label: '휴가',    bg: 'rgba(99,102,241,0.15)', border: '#6366f1', text: '#4338ca' },
                half   : { label: '반차',    bg: 'rgba(99,102,241,0.10)', border: '#a5b4fc', text: '#6366f1' }
            };

            const taMap = {};
            taData.forEach(function(item) { taMap[item.date] = item.status; });

            const now          = new Date();
            const currentYear  = now.getFullYear();
            const currentMonth = now.getMonth();

            function pad(n) { return String(n).padStart(2, '0'); }

            function renderCal() {
                document.getElementById('calTitle').textContent =
                    currentYear + '년 ' + (currentMonth + 1) + '월';

                const container = document.getElementById('tuiCal');
                container.innerHTML = '';

                const table = document.createElement('table');
                table.style.cssText = 'width:100%; border-collapse:collapse; table-layout:fixed;';

                // 요일 헤더
                const thead = document.createElement('thead');
                const headRow = document.createElement('tr');
                ['일','월','화','수','목','금','토'].forEach(function(d, i) {
                    const th = document.createElement('th');
                    th.textContent = d;
                    var color = (i === 0) ? '#dc2626' : (i === 6) ? '#6366f1' : '#6b7280';
                    th.style.cssText =
                        'padding:10px 0;' +
                        'font-size:12px;' +
                        'font-weight:600;' +
                        'color:' + color + ';' +
                        'text-align:center;' +
                        'border-bottom:2px solid #e5e7eb;';
                    headRow.appendChild(th);
                });
                thead.appendChild(headRow);
                table.appendChild(thead);

                const firstDay = new Date(currentYear, currentMonth, 1).getDay();
                const lastDate = new Date(currentYear, currentMonth + 1, 0).getDate();

                const tbody = document.createElement('tbody');
                let day = 1;
                let row = document.createElement('tr');

                for (let i = 0; i < firstDay; i++) {
                    row.appendChild(makeEmptyCell());
                }

                while (day <= lastDate) {
                    if (row.children.length === 7) {
                        tbody.appendChild(row);
                        row = document.createElement('tr');
                    }

                    const dateStr = currentYear + '-' + pad(currentMonth + 1) + '-' + pad(day);
                    const status  = taMap[dateStr];
                    const s       = status ? styleMap[status] : null;
                    const dow     = (firstDay + day - 1) % 7;
                    const isToday = now.getDate() === day;

                    const td = document.createElement('td');
                    td.style.cssText =
                        'height:76px;' +
                        'vertical-align:top;' +
                        'padding:6px;' +
                        'border:1px solid #f0f0f0;' +
                        'background:' + (s ? s.bg : 'transparent') + ';' +
                        (s ? 'border-left:3px solid ' + s.border + ';' : '');

                    // 날짜 숫자
                    const dateNum = document.createElement('div');
                    dateNum.textContent = day;
                    var numColor;
                    if (isToday)       numColor = '#fff';
                    else if (dow === 0) numColor = '#dc2626';
                    else if (dow === 6) numColor = '#6366f1';
                    else if (s)         numColor = s.text;
                    else                numColor = '#374151';

                    dateNum.style.cssText =
                        'font-size:13px;' +
                        'font-weight:' + (isToday ? '800' : '500') + ';' +
                        'color:' + numColor + ';' +
                        'width:24px;height:24px;' +
                        'line-height:24px;' +
                        'text-align:center;' +
                        'border-radius:50%;' +
                        'background:' + (isToday ? '#2563eb' : 'transparent') + ';' +
                        'margin-bottom:5px;';
                    td.appendChild(dateNum);

                    // 상태 배지
                    if (s) {
                        const badge = document.createElement('div');
                        badge.textContent = s.label;
                        badge.style.cssText =
                            'font-size:11px;' +
                            'font-weight:600;' +
                            'color:' + s.text + ';' +
                            'background:white;' +
                            'border:1px solid ' + s.border + ';' +
                            'border-radius:4px;' +
                            'padding:2px 5px;' +
                            'display:inline-block;' +
                            'white-space:nowrap;';
                        td.appendChild(badge);
                    }

                    row.appendChild(td);
                    day++;
                }

                while (row.children.length < 7) {
                    row.appendChild(makeEmptyCell());
                }
                tbody.appendChild(row);
                table.appendChild(tbody);
                container.appendChild(table);
            }

            function makeEmptyCell() {
                const td = document.createElement('td');
                td.style.cssText = 'height:76px;border:1px solid #f0f0f0;background:#fafafa;';
                return td;
            }

            function calPrev() {}
            function calNext() {}

            renderCal();
        </script>
    </body>
</html>