<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            <div class="main-content">
                <div class="contract-form-container">
                    <h2>사원 연봉 및 근로계약 설정</h2>
                    <form id="contractForm">
                        <div class="form-group">
                            <label for="sabun">사원</label>
                            <select>
                                <option value="">사원을 선택해주세요</option>
                                <c:forEach var="sawon" items="${sawonList}">
                                    <option name="sabun" value="${sawon.sabun}">${sawon.sabun}:${sawon.saname}</option>
                                </c:forEach>
                            </select>
                        </div>
                        
                        <div class="form-group">
                            <label for="base_salary">월 기본급 (원)</label>
                            <input type="number" id="base_salary" name="base_salary" value="3000000" required>
                        </div>
                        <div class="form-group">
                            <label for="meal_allowance">월 식대 (원)</label>
                            <input type="number" id="meal_allowance" name="meal_allowance" value="200000" required>
                        </div>
                        
                        <div class="form-group">
                            <label for="start_date">계약 시작일</label>
                            <input type="date" id="start_date" name="start_date" required>
                        </div>
                        <div class="form-group">
                            <label for="end_date">계약 종료일</label>
                            <input type="date" id="end_date" name="end_date" required>
                        </div>
                        
                        <button type="button" onclick="registerContract(this.form)">계약정보 등록</button>
                    </form>
                </div>
            </div>
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

            const formData = new FormData(f);
            
            // URLSearchParams를 이용해 폼 데이터를 Query String 형태로 변환 (컨트롤러 커맨드 객체 매핑용)
            const params = new URLSearchParams(formData);

            fetch('/admin/register_contract', {
                method: 'POST',
                headers: {
                    'Content-Type': 'application/x-www-form-urlencoded'
                },
                body: params
            })
            .then(response => response.json())
            .then(data => {
                if(data) {
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