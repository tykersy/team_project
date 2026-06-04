<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="/css/admin/sawon_modify_form.css"/>
        <link rel="stylesheet" href="css/admin/sidebar.css" />

        <script>

            window.onload = function(){

                //페이지 로딩 시 실행되는 영역
                //부서정보 미리 설정해두기
                let deptnoSelect = document.getElementById("deptno"); //부서선택상자
                let deptno = "${sawon.deptno}";
                let num_list = [ 1, 10, 20, 30, 40, 50 ];
                for( let i = 0; i < num_list.length; i++ ){
                    if( num_list[i] == deptno ){
                        deptnoSelect.value = num_list[i];
                        return;
                    }
                }

                //직급 미리 설정해두기
                let sajobSelect = document.getElementById("empPosition")
                let job_list = [ '관리자', '부장', '차장', '과장', '대리', '주임', '사원' ];
                for( let i = 0; i < job_list.length; i++ ){
                    if( job_list[i] == '${sawon.sajob}' ){
                        sajobSelect.value = job_list[i];
                        return;
                    }
                }

            }

            function modify(f){

                let saname = f.saname.value;
                let deptno = f.deptno.value;


                let formData = new FormData(f);

                fetch( "/admin_sawon_modify", { method:"post", body:formData } )
                .then( res => res.json() )
                .then( data => {



                } )

            }
        </script>
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            <div class="main-content">
                <div class="header">
                    <h2>${sawon.saname}사원 정보 수정</h2>
                    <p>관리자 권한으로 사원의 인사 정보를 수정합니다.</p>
                </div>
                <form>
                    <div class="form-grid">
                        <input name="ori_pwd" type="hidden" value="${sawon.pwd}"/>
                        <div class="form-group">
                            <label for="empId">사원번호 (변경 불가)</label>
                            <input id="empId" name="sabun" class="form-control" value="${sawon.sabun}" readonly>
                        </div>

                        <div class="form-group">
                            <label for="empName">사원명</label>
                            <input id="empName" name="saname" class="form-control" value="${sawon.saname}" required>
                        </div>

                        <div class="form-group">
                            <label for="empPw">현재 비밀번호</label>
                            <input type="password" id="empPw" name="pwd" class="form-control" placeholder="변경 시에만 입력하세요">
                        </div>

                        <div class="form-group">
                            <label for="empPw">변경할 비밀번호</label>
                            <input type="password" id="empPw" name="new_pwd" class="form-control" placeholder="변경 시에만 입력하세요">
                        </div>

                        <div class="form-group">
                            <label for="deptId">부서</label>
                            <c:if test="${sawon.deptno eq 1}">
                                <input class="form-control" placeholder="관리자" readonly="readonly"/>
                            </c:if>
                            <c:if test="${sawon.deptno ne 1}">
                            <select id="deptno" name="deptno" class="form-control" value="${sawon.deptno}" required>
                                <c:forEach var="dept" items="${deptList}">
                                    <option value="${dept.deptno}">${dept.dname}</option>
                                </c:forEach>
                            </select>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="empPosition">직급</label>
                            <select id="empPosition" name="sajob" class="form-control" value="${sawon.sajob}">
                                <c:forEach>
                                    <option value="ceo">ceo</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="salary">연봉 (원)</label>
                            <input type="number" id="salary" name="sapay" class="form-control" value="${sawon.sapay}">
                        </div>

                        <div class="form-group">
                            <label for="hireDate">입사일</label>
                            <input type="date" id="hireDate" name="sahire" class="form-control" value="${sawon.sahire}">
                        </div>

                        <div class="form-group">
                            <label for="email">이메일 주소</label>
                            <input type="email" id="email" name="saemail" class="form-control" value="${sawon.saemail}">
                        </div>

                        <div class="form-group">
                            <label for="phone">전화번호</label>
                            <input type="tel" id="phone" name="satel" class="form-control" value="${sawon.satel}" placeholder="010-0000-0000">
                        </div>

                        <div class="form-group">
                            <label for="zipCode">우편번호</label>
                            <input id="zipCode" name="sazipcode" class="form-control" value="${sawon.sazipcode}">
                        </div>

                        <div class="form-group">
                            <div class="form-group">
                                <label for="address">주소</label>
                                <input id="address" name="saaddr" class="form-control" value="${sawon.saaddr}">
                            </div>
                        </div>

                        <div class="btn-group">
                            <input type="button" value="수정"
                                onclick="modify(this.form)"/>
                            <input type="button" value="뒤로가기" onclick="history.back()"/>
                        </div>

                    </div>
                </form>
            </div>
        </div>
    </body>
    
</html>