<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
            <button class="tab-btn" onclick="switchTab(3)"> 연차</button>
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
                    <div class="info-item"><label>계약 기간</label><div class="val mono">수정필요함</div></div>
                </div>
            </div>
        
            <div class="card">
            <div class="card-title"><span class="dot"></span>근로 조건</div>
            <div class="info-grid">
                <div class="info-item"><label>소정 근로시간</label><div class="val">주 40시간</div></div>
                <div class="info-item"><label>근무 요일</label><div class="val">월 ~ 금</div></div>
                <div class="info-item"><label>출근 시간</label><div class="val mono">09:00 ( 수정필요함 )</div></div>
                <div class="info-item"><label>퇴근 시간</label><div class="val mono">18:00 ( 수정필요함 )</div></div>
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
            <!-- 서명 대기중인 근로계약건이 있을 경우에만 보여주게 설정할 예정(수정필요) -->
            <div class="card">
                <div class="card-title"><span class="dot"></span>서명 대기중인 근로계약건</div>
                <div class="info-grid">
                    <div class="info-item">
                        <label>계약서</label>
                        <div class="val"> 
                            <a href="/user_sign_contract?sabun=${info.sabun}" class="pw-edit-link">서명하기</a>
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
                            <!--날짜부분 시간 안나오게 수정-->
                            <td class="label">${taList.day}</td>
                            <td>${taList.checkin}</td>
                            <td>${taList.checkout}</td>
                            <td>${taList.working_time}</td>
                            <td>
                                <span class="tag ${taList.status}">
                                    <c:choose>
                                        <c:when test="${taList.status eq 'absent'}">결근</c:when>
                                        <c:when test="${taList.status eq 'half'}">반차</c:when>
                                        <c:when test="${taList.status eq 'leave'}">휴가</c:when>
                                        <c:when test="${taList.status eq 'late'}">지각</c:when>
                                        <c:when test="${taList.status eq 'normal'}">정상</c:when>
                                        <c:otherwise>기타</c:otherwise>
                                    </c:choose>
                                </span>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            </div>
        </div>
        
        <!-- ─────────────────────────────── TAB 3: 급여 ─── -->
        <div class="panel" id="panel-2">
        
            <div class="card">
            <div class="salary-hero">
                <div class="month">${today} 급여</div>
                <div class="amount"><fmt:formatNumber value="${userSalary.net_pay}" pattern="#,###" /></div>
                <div class="unit"> 원 (실수령액)</div>
            </div>
            <div class="salary-breakdown">
                <div class="breakdown-row"><span class="name">기본급</span><span class="amt"><fmt:formatNumber value="${userSalary.base_pay}" pattern="#,###"/></span></div>
                <div class="breakdown-row"><span class="name">초과근무수당</span><span class="amt"><fmt:formatNumber value="${userSalary.overtime_pay}" pattern="#,###"/></span></div>
                <div class="breakdown-row deduct"><span class="name">국민연금</span><span class="amt">-<fmt:formatNumber value="${userSalary.national_pension}" pattern="#,###"/></span></div>
                <div class="breakdown-row deduct"><span class="name">건강보험</span><span class="amt">-<fmt:formatNumber value="${userSalary.health_insurance}" pattern="#,###"/></span></div>
                <div class="breakdown-row deduct"><span class="name">고용보험</span><span class="amt">-<fmt:formatNumber value="${userSalary.employment_insurance}" pattern="#,###"/></span></div>
                <div class="breakdown-row deduct"><span class="name">소득세</span><span class="amt">-<fmt:formatNumber value="${userSalary.income_tax + userSalary.local_income_tax}" pattern="#,###"/></span></div>
                <div class="breakdown-row total"><span class="name">실수령액</span><span class="amt"><fmt:formatNumber value="${userSalary.net_pay}" pattern="#,###"/></span></div>
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

            <!-- 5 연차 탭 -->

            <div class="panel" id="panel-3">

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
        <jsp:include page="/WEB-INF/views/common/msg.jsp" />
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

            // ── URL 파라미터 확인 및 자동 탭 전환 ──
            window.addEventListener('DOMContentLoaded', function() {
            const urlParams = new URLSearchParams(window.location.search);
            const tab = urlParams.get('tab');

            // 'leave' 파라미터가 있다면 4번째 탭(인덱스 3)으로 전환
            if (tab === 'leave') {
                switchTab(3);
            }
            // 필요에 따라 다른 탭도 추가 가능
            // else if (tab === 'salary') { switchTab(2); }
        });
        </script>
    </body>
</html>