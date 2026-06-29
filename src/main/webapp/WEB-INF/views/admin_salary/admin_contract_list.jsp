<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <meta charset="UTF-8">
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
        <link rel="stylesheet" href="/css/admin/contract_list.css">

        <title>전자 계약 현황</title>
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/> 
            
            <div class="main-content">
                <div class="page-title-section">
                    <h2>전자 계약 현황 관리</h2>
                    <p>전사 사원의 계약 체결 상태와 연봉 재계약 주기 대상자를 실시간 파악합니다.</p>
                    <hr class="title-divider"/>
                </div>

                <div class="contract-status-wrapper">
                    <div class="contract-card card-pending" onclick="filterBySummary('PENDING')">
                        <span class="card-label">서명 대기 중 문서</span>
                        <span class="card-value">${pending_count != null ? pending_count : 0} <span>건</span></span>
                    </div>
                    <div class="contract-card card-renewal" onclick="filterBySummary('RENEWAL')">
                        <span class="card-label">연봉 재계약 대상자 (1년 경과)</span>
                        <span class="card-value" style="color: #DC2626;">${renewal_count != null ? renewal_count : 0} <span>명</span></span>
                    </div>
                </div>

                <div class="filter-control-bar">
                    <form action="/admin/admin_contract_status" method="get" id="searchForm">
                        <div class="filter-group">
                            <select id="sortType" name="sortType" class="erp-select" onchange="handleSortChange(this.value)">
                                <option value="SABUN_ASC" ${filter.sortType eq 'SABUN_ASC' ? 'selected' : ''}>사번 순 보기</option>
                                <option value="DEPT" ${filter.sortType eq 'DEPT' ? 'selected' : ''}>부서 별 선택</option>
                            </select>
                            
                            <select id="deptSelect" name="deptno" class="erp-select" style="display: ${filter.sortType eq 'DEPT' ? 'inline-block' : 'none'};"
                                    onchange="handleDeptChange()">
                                <option value="">-- 부서 선택 --</option>
                                <c:forEach var="dept" items="${deptList}">
                                    <option value="${dept.deptno}" ${filter.deptno eq dept.deptno ? 'selected' : '' }>${dept.dname}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <input type="hidden" id="hiddenSaname" name="saname" value="${filter.saname}">
                    </form>

                    <div class="search-group">
                        <input type="text" id="searchName" name="saname" class="erp-input" placeholder="사원명 입력" value="${filter.saname}">
                        <button type="button" class="btn-search" onclick="submitSearch()">검색</button>
                    </div>
                </div>

                <div class="table-container">
                    <table class="erp-table">
                        <thead>
                            <tr>
                                <th>사원번호(사번)</th>
                                <th>사원명</th>
                                <th>부서</th>
                                <th>계약 시작일</th>
                                <th>계약 만료일</th>
                                <th>계약 상태</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="contract" items="${contractList}">
                                <tr>
                                    <td><strong>${contract.sabun}</strong></td>
                                    <td>
                                        <a class="link-emp-name" onclick="openContractDetail('${contract.sabun}')">
                                            ${contract.saname}
                                        </a>
                                    </td>
                                    <td>${contract.dname}</td>
                                    <td>${contract.start_date}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty contract.end_date}">
                                                ${contract.end_date}
                                            </c:when>
                                            <c:otherwise>
                                                <span style="color: #64748B; font-weight: 500;">기간계약없음 (정직원)</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${contract.signed_at ne null}">
                                                <span class="badge badge-signed">✓ 서명 완료</span>
                                            </c:when>
                                            <c:when test="${empty contract.contract_id || contract.contract_id eq 0}">
                                                <span class="badge badge-none" style="color: #64748B; background-color: #F1F5F9;">⚠️ 계약서 미발행</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge badge-unsigned">⏳ 서명 전</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty contractList}">
                                <tr>
                                    <td colspan="6" style="text-align: center; color: #94A3B8; padding: 40px 0;">조회된 전자 계약 데이터가 존재하지 않습니다.</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>

        <div id="contractDetailModal" class="contract-modal">
            <div class="contract-modal-content">
                <div style="display: flex; justify-content: space-between; align-items: center; border-bottom: 1px solid #E2E8F0; padding-bottom: 14px;">
                    <h3 style="margin: 0; color: #0F172A;">전자 계약서 상세 조회</h3>
                    <span style="font-size: 20px; color: #94A3B8; cursor: pointer;" onclick="closeContractModal()">&times;</span>
                </div>
                
                <div class="modal-grid">
                    <div class="grid-item"><label>사원 번호</label><span id="mdSabun">-</span></div>
                    <div class="grid-item"><label>사원 성명</label><span id="mdSaname">-</span></div>
                    <div class="grid-item"><label>소속 부서</label><span id="mdDname">-</span></div>
                    <div class="grid-item"><label>현재 계약 상태</label><span id="mdStatus">-</span></div>
                    <div class="grid-item" style="grid-column: span 2;"><label>계약 기간</label><span id="mdPeriod">-</span></div>
                    <div class="grid-item" style="grid-column: span 2;"><label>체결 연봉액 또는 주요 특약사항</label><span id="mdSalary">시스템 연동액 기준 준수</span></div>
                </div>
                
                <div style="margin-top: 24px; display: flex; justify-content: flex-end;">
                    <button type="button" class="btn-modal-close" style="padding: 10px 20px; background: #0F172A; color: #fff; border: none; border-radius: 8px; cursor: pointer;" onclick="closeContractModal()">닫기</button>
                </div>
            </div>
        </div>

        <script>
        // 부서 선택 조건 선택 (부서 별 선택일 때만 2차 select 박스 보여주기)
        function handleSortChange(value) {
            const deptSelect = document.getElementById('deptSelect');
            if (value === 'DEPT') {
                deptSelect.style.display = 'inline-block';
            } else {
                //선택조건이 부서별이 아닐 때
                deptSelect.style.display = 'none';
                deptSelect.value = ''; // 값 초기화
                document.getElementById('hiddenSaname').value=''; //검색어 초기화
                document.getElementById('searchForm').submit(); // 사번 순 선택 시 바로 제출
            }
        }

        // 2차 부서 셀렉트박스 변경 시 즉시 폼 서브밋
        function handleDeptChange() {
            document.getElementById('searchForm').submit();
        }

        // 상단 대시보드 요약카드 클릭 시 필터링 처리 가이드 함수
        function filterBySummary(type) {
            location.href = "/admin/admin_contract_status?filterType=" + type;
        }

        // 사원명 검색 버튼 클릭 시
        function submitSearch() {
            const name = document.getElementById('searchName').value;
            const sortType = document.getElementById('sortType').value;
            const deptno = document.getElementById('deptSelect').value;
            // hidden 인풋에 동기화 후 서브밋 (수정예정)
            document.getElementById('hiddenSaname').value = name;
            
            location.href = "/admin/admin_contract_status?sortType=" + sortType + "&deptno=" + deptno + "&saname=" + encodeURIComponent(name);
        }

        /* 🌟 비동기 데이터 뷰 바인딩 및 상세 모달 오픈 */
        function openContractDetail(sabun) {
            // 백엔드 CRUD 컨트롤러가 완성되면 fetch로 데이터 받아서 바인딩 예정****
            fetch('/admin/admin_contract_detail?sabun=' + sabun)
            .then(res => res.json())
            .then(data => {
                document.getElementById('mdSabun').innerText = data.contract.sabun;
                document.getElementById('mdSaname').innerText = data.contract.saname;
                document.getElementById('mdDname').innerText = data.contract.dname;
                document.getElementById('mdStatus').innerText = data.contract.signed_at !== null ? '✓ 서명 완료' : '⏳ 서명 전 대기';
                document.getElementById('mdPeriod').innerText = data.contract.start_date + ' ~ ' + (data.contract.end_date ? data.contract.end_date : '기간 제한 없음(정직원)');
                document.getElementById('contractDetailModal').style.display = 'flex';
            })
            .catch(err => {
                // 단건 조회가 아직 없는 초기 개발단계용 모달 테스트용 폴백 코드
                document.getElementById('mdSabun').innerText = sabun;
                document.getElementById('mdSaname').innerText = "임시 사원명";
                document.getElementById('contractDetailModal').style.display = 'flex';
            });
        }

        function closeContractModal() {
            document.getElementById('contractDetailModal').style.display = 'none';
        }
        </script>
    </body>
    
</html>