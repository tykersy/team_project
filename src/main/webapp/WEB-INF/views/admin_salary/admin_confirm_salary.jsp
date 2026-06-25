<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
        <link rel="stylesheet" href="/css/admin/admin_salary.css">
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            
            <div class="main-content">
                <div class="page-header">
                    <h1 class="page-title">급여 정산 관리</h1>
                </div>

                <div class="salary-status-wrapper">
                    <div class="status-card pending">
                        <h3>당월 정산 대기 건수</h3>
                        <div class="count">${countLedgers}건</div>
                    </div>
                    <div class="status-card completed">
                        <h3>당월 정산 완료 건수</h3>
                        <div class="count">${countConfirmedLedgers}건</div>
                    </div>
                </div>

                <div class="section-container">
                    <div class="section-header-inline">
                        <div class="section-title">${ym} 정산 대상 사원 명단</div>
                        <button type="button" class="btn-salary-action btn-batch" onclick="approveAllSalary()">선택 사원 일괄 정산확정</button>
                    </div>

                    <table class="data-table">
                        <thead>
                            <tr>
                                <th style="width: 40px;"><input type="checkbox" id="checkAll"></th>
                                <th>사번</th>
                                <th>사원</th>
                                <th>부서</th>
                                <th>지급 식대</th>
                                <th>총 지급액</th>
                                <th>정산 상태</th>
                                <th style="text-align: center;">액션</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="ledger" items="${ledgerList}">
                                <tr>
                                    <td>
                                        <c:if test="${ledger.status eq '대기'}">
                                            <input type="checkbox" name="salaryCheck" value="${ledger.salary_id}">
                                        </c:if>
                                    </td>
                                    <td><strong>${ledger.sabun}</strong></td>
                                    <td>${ledger.saname}</td>
                                    <td>${ledger.dname}</td>
                                    <td><fmt:formatNumber value="${ledger.meal_pay}" type="number"/> 원</td>
                                    <td><fmt:formatNumber value="${ledger.net_pay}" pattern="#,##0"/> 원</td>
                                    <td>
                                        <span class="badge ${ledger.status eq '대기' ? 'badge-pending' : 'badge-completed'}">
                                            ${ledger.status}
                                        </span>
                                    </td>
                                    <td style="text-align: center;">
                                        <c:if test="${ledger.status eq '대기'}">
                                            <button type="button" class="btn-salary-action" onclick="approveSalary('${ledger.salary_id}')">정산 확정</button>
                                            <button type="button" class="btn-salary-secondary" 
                                                data-sabun="${ledger.sabun}"
                                                data-saname="${ledger.saname}"
                                                data-base-pay="${ledger.base_pay}"
                                                data-meal-pay="${ledger.meal_pay}"
                                                data-overtime-pay="${ledger.overtime_pay}"
                                                data-national="${ledger.national_pension}"
                                                data-health="${ledger.health_insurance}"
                                                data-employment="${ledger.employment_insurance}"
                                                data-income-tax="${ledger.income_tax}"
                                                data-local-tax="${ledger.local_income_tax}"
                                                data-net-pay="${ledger.net_pay}"
                                                onclick="openSalaryModal(this)">상세보기
                                            </button>
                                        </c:if>
                                        <c:if test="${ledger.status eq '완료'}">
                                            <span style="color: #94A3B8; font-size: 13px;">마감 완료</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty ledgerList}">
                                <tr>
                                    <td colspan="8" style="text-align: center; color: #64748B; padding: 40px 0;">
                                        현재 정산 대상 사원이 존재하지 않습니다.
                                    </td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div> </div>
        </div>

        <div id="salaryModal" class="salary-modal">
            <div class="salary-modal-content">
                <button type="button" class="modal-close-btn" onclick="closeSalaryModal()">&times;</button>
                
                <div class="modal-title-wrapper">
                    <h3 id="modalTitle">급여 명세서 상세</h3>
                    <p id="modalSubTitle">사원 정보</p>
                </div>
                
                <div class="receipt-table">
                    <div class="receipt-row"><strong>항목</strong><strong>금액</strong></div>
                    <hr style="border: 0; border-top: 1px solid #E2E8F0; margin: 4px 0;">
                    <div class="receipt-row"><span class="name">기본급</span><span class="amt" id="mBasePay">0 원</span></div>
                    <div class="receipt-row"><span class="name">지급 식대</span><span class="amt" id="mMealPay">0 원</span></div>
                    <div class="receipt-row"><span class="name">초과근무수당</span><span class="amt" id="mOvertimePay">0 원</span></div>
                    
                    <div class="receipt-row deduct"><span class="name">국민연금</span><span class="amt" id="mNational">0 원</span></div>
                    <div class="receipt-row deduct"><span class="name">건강보험</span><span class="amt" id="mHealth">0 원</span></div>
                    <div class="receipt-row deduct"><span class="name">고용보험</span><span class="amt" id="mEmployment">0 원</span></div>
                    <div class="receipt-row deduct"><span class="name">소득세 (지방세 포함)</span><span class="amt" id="mTax">0 원</span></div>
                    
                    <div class="receipt-row total-row"><span class="name">실수령액</span><span class="amt" id="mNetPay">0 원</span></div>
                </div>
                
                <button type="button" class="btn-submit-contract" style="margin-top: 0;" onclick="closeSalaryModal()">확인</button>
            </div>
        </div>

    <script>
        // 체크박스 전체 선택/해제 기능
        document.getElementById('checkAll')?.addEventListener('change', function() {
            const checkboxes = document.querySelectorAll('input[name="salaryCheck"]');
            checkboxes.forEach(cb => cb.checked = this.checked);
        });

        // 개별 정산 확정 비동기 통신 처리
        function approveSalary(salaryId) {
            if(!confirm("해당 사원의 당월 급여 정산을 확정하시겠습니까?\n확정 후에는 수정이 불가능합니다.")) return;
            
            // Fetch API 등을 활용해 백엔드로 전송 (status를 '완료'로 업데이트하는 컨트롤러 호출)
            sendSalarySettlement([salaryId]);
        }

        // 선택 사원 일괄 정산 확정
        function approveAllSalary() {
            const checkedBoxes = document.querySelectorAll('input[name="salaryCheck"]:checked');
            
            //유효성 체크
            if(checkedBoxes.length === 0) {
                alert("정산 확정할 사원을 최소 한 명 이상 선택하세요.");
                return;
            }
            
            if(!confirm(`선택한 ${checkedBoxes.length}명 사원의 급여 정산을 일괄 확정하시겠습니까?`)) return;
            
            //선택된 명세서들을 map을 사용해 각각 정산 확정 시켜준다
            const salaryIds = Array.from(checkedBoxes).map(cb => cb.value);
            sendSalarySettlement(salaryIds);
        }

        // 비동기로 월급 정산 처리 하는 핵심 함수
        function sendSalarySettlement(ids) {
            // 백엔드 구현에 맞추어 ajax / fetch 구현 진행
            fetch( "/admin/salary_complete", {
                method:"POST",
                headers: {
                    "Content-Type": "application/json" // 🌟 이 헤더 설정이 반드시 필요합니다!
                },
                body:JSON.stringify(ids)
            } )
            .then(res => res.json())
            .then( data => {
                if( data.result ){
                    alert(data.msg);
                    location.reload();
                }else{
                    alert("실패 : " + data.msg);
                }
            })
        }

        // 숫자를 화폐 단위로 포맷팅하는 헬퍼 함수
        function formatWon(value) {
            let num = Number(value) || 0;
            return num.toLocaleString() + " 원";
        }

        // 모달 열기 및 데이터 동적 바인딩
        function openSalaryModal(element) {
            const dataset = element.dataset;
            const row = element.closest('tr'); // 버튼이 속한 행(tr) 찾기
    
            // 1. 헤더 사원 정보 세팅 
            const sabun = row.cells[1].innerText;
            const saname = row.cells[2].innerText;
            document.getElementById('modalSubTitle').innerText = saname + ' 사원 (' + sabun + ')';
                
            // 2. 지급 항목 데이터 매핑
            document.getElementById('mBasePay').innerText = formatWon(dataset.basePay);
            document.getElementById('mMealPay').innerText = formatWon(dataset.mealPay);
            document.getElementById('mOvertimePay').innerText = formatWon(dataset.overtimePay);
                
            // 3. 공제 항목 데이터 매핑
            document.getElementById('mNational').innerText = "-" + formatWon(dataset.national);
            document.getElementById('mHealth').innerText = "-" + formatWon(dataset.health);
            document.getElementById('mEmployment').innerText = "-" + formatWon(dataset.employment);
                
            // 소득세 + 지방소득세 합산 노출
            let totalTax = (Number(dataset.incomeTax) || 0) + (Number(dataset.localTax) || 0);
            document.getElementById('mTax').innerText = "-" + formatWon(totalTax);
                
            // 4. 최종 실수령액 매핑
            document.getElementById('mNetPay').innerText = formatWon(dataset.netPay);
                
            // 5. 모달 열기
            document.getElementById('salaryModal').style.display = 'flex';
        }

        // 모달 닫기
        function closeSalaryModal() {
            document.getElementById('salaryModal').style.display = 'none';
        }

        // 배경 클릭 시에도 모달이 닫히도록 설정
        window.onclick = function(event) {
            const modal = document.getElementById('salaryModal');
            if (event.target == modal) {
                modal.style.display = 'none';
            }
        }
    </script>
</body>
    
</html>