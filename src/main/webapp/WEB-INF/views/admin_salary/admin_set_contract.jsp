<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
        <link rel="stylesheet" href="/css/admin/econtract.css">
    </head>

    <body>
    <div class="manager-container">
        <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
        
        <div class="main-content">
            <h2>사원 연봉 및 근로계약 설정</h2>
            
            <div class="dashboard-grid-layout">
                
                <div class="contract-form-container">
                    <form id="contractForm">
                        <div class="form-group full-width">
                            <label for="sabun">대상 사원 선택</label>
                            <select name="sabun">
                                <option value="">계약 대상을 선택해주세요</option>
                                <c:forEach var="sawon" items="${sawonList}">
                                    <option value="${sawon.sabun}">${sawon.sabun} : ${sawon.saname}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="form-grid-row">
                            <div class="form-group">
                                <label for="base_salary">월 기본급 (원)</label>
                                <input type="number" id="base_salary" name="base_salary" placeholder="연봉을 입력하세요">
                            </div>
                            <div class="form-group">
                                <label for="meal_allowance">월 식대 (원)</label>
                                <input type="number" id="meal_allowance" name="meal_allowance" placeholder="식대를 입력하세요">
                            </div>
                        </div>
                        
                        <div class="form-grid-row">
                            <div class="form-group">
                                <label for="start_date">계약 시작일</label>
                                <input type="date" id="start_date" name="start_date">
                            </div>
                            <div class="form-group">
                                <label for="end_date">계약 종료일 (정규직은 빈칸)</label>
                                <input type="date" id="end_date" name="end_date">
                            </div>
                        </div>
                        
                        <button type="button" class="btn-submit-contract" onclick="registerContract(this.form)">계약 정보 등록</button>
                    </form>
                </div>
                
                <div class="contract-status-container">
                    <div class="status-title">계약서 작성 유의사항</div>
                    <ul class="guide-list">
                        <li class="guide-item">
                            <strong>정보 확인 필수:</strong> 등록된 연봉 및 식대 정보는 전사 급여 정산 데이터와 실시간으로 연동되므로 정확하게 입력해야 합니다.
                        </li>
                        <li class="guide-item">
                            <strong>정규직 계약 형태:</strong> 계약 종료일(end_date)을 빈칸으로 두고 등록하면 자동으로 '기한의 정함이 없는 정규직 근로 계약'으로 체결됩니다.
                        </li>
                        <li class="guide-item">
                            <strong>소급 적용 안내:</strong> 계약 시작일이 지난 시점에 등록할 경우, 해당 월의 급여 처리에 소급분 반영 여부를 급여/정산 관리 탭에서 추가로 확인해 주세요.
                        </li>
                    </ul>
                </div>
                
            </div> </div>
    </div>

        <script>
        function registerContract(f) {

            let sabun = f.sabun.value;
            let start_date = f.start_date.value;
            let end_date = f.end_date.value;
            let base_salary = f.base_salary.value;
            let meal_allowance = f.meal_allowance.value;

            //유효성 체크
            if( sabun == null || sabun == "" ){
                alert("해당 계약 대상 사원을 선택하세요")
                return;
            }

            if( base_salary == "" || meal_allowance == "" ){
                alert("기본급, 식대 정보를 입력하세요")
                return;
            }

            if( start_date == null || start_date == "" ){
                alert("계약 시작일을 선택하세요")
                return;
            }

            if( end_date == null || end_date == "" ){
                
                if( !confirm( sabun + "번 사원의 계약형태가 정규직이 맞습니까?") ){
                    return;
                }
            }

            if( !confirm("사원 : "+sabun + "\n" +"기본급 : " + base_salary + "\n" 
                    + "식대 : " + meal_allowance + "\n" + "시작일 : " + start_date + "\n" 
                    + "계약 정보가 올바른지 확인해주세요"
            ) ){
                return;
            }

            const formData = new FormData(f);
            
            //정직원일 경우 end_date을 null로 비워서 전달
            if (end_date === "") {
                formData.delete("end_date");
            }

            // URLSearchParams를 이용해 폼 데이터를 Query String 형태로 변환 (컨트롤러 커맨드 객체 매핑용)
            const params = new URLSearchParams(formData);

            fetch('/admin_register_contract', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => response.json())
            .then(data => {
                if(data.res > 0) {
                    alert("계약 정보가 성공적으로 등록되었습니다.");
                } else {
                    alert("등록 실패. 사원번호나 기간을 확인하세요.");
                }
            })
            .catch(err => console.error("에러 발생:", err));
        }
        </script>
    </body>
    
</html>