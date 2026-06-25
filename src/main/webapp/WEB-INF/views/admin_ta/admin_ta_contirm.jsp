<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>근태 정산 마감</title>
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
        <link rel="stylesheet" href="/css/admin/admin_ta.css">
        
        <script>
            // 페이지 로드 시 검색창에 값이 없다면 이번 달로 세팅
            window.onload = function() {
                let urlParams = new URLSearchParams(window.location.search);
                let ymParam = urlParams.get('ym');
                if(!ymParam) {
                    let today = new Date();
                    let month = String(today.getMonth() + 1).padStart(2, '0');
                    document.getElementById('target_ym').value = today.getFullYear() + '-' + month;
                }
            }

            // 특정 사원 한 명만 마감 처리
            function closeSingleAttendance(sabun, name) {

                //선택된 년월(ym)값 가져오기
                let ym = document.getElementById('target_ym').value;
                if(!confirm(`\${name} 사원의 \${ym} 근태를 마감하시겠습니까?\n마감 후 급여 정산이 가능합니다.`)) return;

                fetch("/admin/taclose", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                        // 맨 앞의 슬래시(/)를 제거하여 현재 페이지 위치 기준(상대경로)으로 호출을 일치 시킴
                    body: "ym=" + ym + "&sabun=" + sabun
                })
                .then(res => {
                    if(res) {
                        alert("성공적으로 마감되었습니다.");
                        location.reload();
                    } else { alert("마감 처리 중 오류가 발생했습니다."); }
                });
            }

            // 이달의 전체 사원 일괄 마감 처리
            function closeAllAttendance() {
                let ym = document.getElementById('target_ym').value;
                if(!confirm(`\${ym} 전체 사원의 근태를 일괄 마감하시겠습니까?\n이미 마감된 사원은 제외됩니다.`)) return;

                fetch("/admin/ta_close_all", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: `ym=\${ym}`
                })
                .then(res => {
                    if(res) {
                        alert("전체 마감 처리가 완료되었습니다.");
                        location.reload();
                    } else { alert("처리 중 오류가 발생했습니다."); }
                });
            }

            //사원 근태 기록 수정 버튼
            function modify_ta(sabun, saname){

                //유효성 체크
                if( sabun.trim() == "" || saname.trim() == "" ){
                    alert("사번이나 사원명이 올바르지 않습니다")
                    return;
                } 

                if( !confirm( saname+"사원의 근태 기록을 수정하시겠습니까?") ){
                    return;
                }

                location.href="/admin/today_ta/view?sabun="+sabun;

            }
        </script>
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            <div class="main-content">
                <div class="page-header">
                    <h2 class="page-title">월별 근태 정산 마감</h2>
                </div>

                <div class="filter-container">
                    <form action="/admin/ta_confirm?ym="+(this.form.ym.value) method="get" class="month-picker">
                        <label for="target_ym" style="font-weight: bold; color: #444;">정산 대상 년월:</label>
                        <input type="month" id="target_ym" name="ym" value="${selectedYm}">
                        <button type="submit" class="btn-search">조회</button>
                    </form>
                    <div>
                        <button type="button" class="btn-all-close" onclick="closeAllAttendance()">이달의 근태 전체 마감 확정</button>
                    </div>
                </div>

                <div class="status-card-wrapper">
                    <div class="status-card pending">
                        <h3>마감 대기 대상</h3>
                        <p class="count">${waitCnt}명</p>
                    </div>
                    <div class="status-card approved">
                        <h3>마감 완료 인원</h3>
                        <p class="count">${completeCnt}명</p>
                    </div>
                </div>

                <div class="section-container">
                    <div class="section-title">${selectedYm} 근태 정산 대상자 목록</div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>사원번호</th>
                                <th>이름</th>
                                <th>부서</th>
                                <th>총 평일(기준)</th>
                                <th>실제 출근일</th>
                                <th>결근(무급)</th>
                                <th>연차 사용</th>
                                <th>연장근무(시간)</th>
                                <th>마감 상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty attendanceList}">
                                    <tr>
                                        <td colspan="9" style="text-align: center; padding: 30px; color: #999;">
                                            해당 월에 조회된 근태 대상자가 없습니다.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="emp" items="${attendanceList}">
                                        <tr>
                                            <td>${emp.sabun}</td>
                                            <td><strong>${emp.saname}</strong></td>
                                            <td>${emp.dname}</td>
                                            <td>${emp.standard_days}일</td>
                                            <td><span style="color:#2563eb; font-weight:bold;">${emp.worked_days}일</span></td>
                                            <td><span style="color:#dc2626; font-weight:bold;">${emp.absence_days}일</span></td>
                                            <td>${emp.leave_days}일</td>
                                            <td>${emp.overtime_hours}시간</td>
                                            <td>
                                                <c:choose>
                                                    <c:when test="${emp.status == '완료'}">
                                                        <span class="badge-complete">마감 완료</span>
                                                    </c:when>
                                                    <c:otherwise>
                                                        <button type="button" class="btn-status-wait" 
                                                            onclick="closeSingleAttendance('${emp.sabun}', '${emp.saname}')">
                                                            마감
                                                        </button>
                                                        <button type="button" class="btn-status-modify" 
                                                            onclick="modify_ta('${emp.sabun}','${emp.saname}')">
                                                            수정
                                                        </button>
                                                    </c:otherwise>
                                                </c:choose>
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
    </body>
    
</html>