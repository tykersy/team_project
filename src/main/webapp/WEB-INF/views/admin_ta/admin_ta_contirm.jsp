<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <title>[Linked : 근태 마감]</title>
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

            // 조회 폼 제출 시 fetch로 비동기 조회 (기존 /admin/ta_confirm 매핑 재사용)
            function handleSearchSubmit(event) {
                event.preventDefault(); //서브밋방지
                reloadTAConfirm(); //선택된 ym에 따른 결과 조회 및 폼 설정
                return false;
            }

            //조회버튼 누를 경우 선택한 조건을 다시 로드
            function reloadTAConfirm() {
                const ym = document.getElementById('target_ym').value;

                fetch("/admin/ta_confirm?ym=" + encodeURIComponent(ym))
                .then(res => res.text())
                .then(html => {
                    const doc = new DOMParser().parseFromString(html, "text/html");

                    const newStatus = doc.getElementById("statusCardWrapper");
                    const newSection = doc.getElementById("sectionContainer");

                    if (newStatus) {
                        document.getElementById("statusCardWrapper").innerHTML = newStatus.innerHTML;
                    }
                    if (newSection) {
                        document.getElementById("sectionContainer").innerHTML = newSection.innerHTML;
                    }
                });
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

            // 마감 대기 목록 보기
            function showWaitList() {
                document.getElementById("waitListBody").style.display = "";
                document.getElementById("completeListBody").style.display = "none";
                document.getElementById("section-title").style.display="";
                document.getElementById("section-title-sec").style.display = "none";
                
                // 타이틀 텍스트 변경
                const selectedYm = document.getElementById('target_ym').value;
                document.getElementById("tableTitle").innerText = selectedYm + " 근태 정산 대상자 (대기) 목록";
            }

            // 마감 완료 목록 보기
            function showCompleteList() {
                document.getElementById("waitListBody").style.display = "none";
                document.getElementById("completeListBody").style.display = "";
                document.getElementById("section-title").style.display="none";
                document.getElementById("section-title-sec").style.display = "";
                
                // 타이틀 텍스트 변경
                const selectedYm = document.getElementById('target_ym').value;
                document.getElementById("tableTitle").innerText = selectedYm + " 근태 마감 완료자 목록";
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
                    <form action="/admin/ta_confirm" method="get" class="month-picker" autocomplete="off" onsubmit="return handleSearchSubmit(event)">
                        <label for="target_ym" style="font-weight: bold; color: #444;">정산 대상 년월:</label>
                        <input type="month" id="target_ym" name="ym" autocomplete="off" value="${selectedYm}" max="${selectedYm}">
                        <button type="submit" class="btn-search">조회</button>
                    </form>
                    <div>
                        <button type="button" class="btn-all-close" onclick="closeAllAttendance()">이달의 근태 전체 마감 확정</button>
                    </div>
                </div>

                <div class="status-card-wrapper" id="statusCardWrapper">
                    <!-- 마감 대기 대상 카드 (주황 포인트) -->
                    <div class="dashboard-card card-amber" onclick="showWaitList()">
                        <span class="card-label">마감 대기 대상</span>
                        <span class="card-value">${waitCnt != null ? waitCnt : 0} <span>명</span></span>
                    </div>
                    
                    <!-- 마감 완료 인원 카드 (초록 포인트) -->
                    <div class="dashboard-card card-emerald" onclick="showCompleteList()">
                        <span class="card-label">마감 완료 인원</span>
                        <span class="card-value">${completeCnt != null ? completeCnt : 0} <span>명</span></span>
                    </div>
                </div>

                <div class="section-container" id="sectionContainer">
                    <div id="section-title" class="section-title">${selectedYm} 근태 정산 대상자 목록</div>
                    <div id="section-title-sec" class="section-title">${selectedYm} 근태 정산 완료자 목록</div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width: 10%;">사원번호</th>
                                <th style="width: 9%;">이름</th>
                                <th style="width: 10%;">부서</th>
                                <th style="width: 11%;">총 평일(기준)</th>
                                <th style="width: 11%;">실제 출근일</th>
                                <th style="width: 11%;">결근(무급)</th>
                                <th style="width: 10%;">연차 사용</th>
                                <th style="width: 12%;">연장근무(시간)</th>
                                <th style="width: 16%;">마감 상태</th>
                            </tr>
                        </thead>
                        <tbody id="waitListBody">
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

                        <tbody id="completeListBody" style="display: none;">
                            <c:choose>
                                <c:when test="${empty confirmedTAList}">
                                    <tr>
                                        <td colspan="9" style="text-align: center; padding: 30px; color: #999;">
                                            해당 월에 마감 완료된 인원이 없습니다.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="emp" items="${confirmedTAList}">
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
                                                <!-- 이미 마감 완료된 상태이므로 배지만 표시 -->
                                                <span class="badge-complete">마감 완료</span>
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