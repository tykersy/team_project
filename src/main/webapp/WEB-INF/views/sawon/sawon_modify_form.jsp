<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="/css/admin/sawon_modify_form.css"/>
        <link rel="stylesheet" href="/css/admin/sidebar.css" />

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
                      
                        break;

                    }
                }

                //직급 미리 설정해두기
                let sajobSelect = document.getElementById("empPosition")
                let sajob = "${sawon.sajob}";
                let job_list = [ '관리자', '부장', '차장', '과장', '대리', '주임', '사원' ];
                for( let i = 0; i < job_list.length; i++ ){
                    if( job_list[i] == sajob ){

                        sajobSelect.value = job_list[i];
                        return;
                    }
                }

            }

            function modify(f){

                let saname = f.saname.value;
                let deptno = f.deptno.value;

                let sabun = f.sabun.value;
                let new_pwd = f.new_pwd.value;
                let sajob = f.sajob.value;
                let sahire = f.sahire.value;
                let saemail = f.saemail.value;
                let satel = f.satel.value;
                let sazipcode = f.sazipcode.value;
                let saaddr = f.saaddr.value;

                //이전에 유효성 체크 후 경고창을 띄웠다면 초기화
                document.getElementById("error_saname").innerHTML = "";
                document.getElementById("error_sahire").innerHTML= "";
                document.getElementById("error_saemail").innerHTML= "";
                document.getElementById("error_satel").innerHTML= "";
                document.getElementById("error_sazipcode").innerHTML= "";
                document.getElementById("error_saaddr").innerHTML= "";

                //유효성 체크
                if( saname == '' ){
                    alert("이름을 입력해주세요")
                    document.getElementById("error_saname").innerHTML = 
                        "이름을 입력해주세요"
                    return;
                }

                if( sahire == '' ){
                    alert("입사일을 선택해주세요")
                    document.getElementById("error_sahire").innerHTML=
                        "입사일을 선택해주세요"
                    return;
                }

                if( saemail == '' ){
                    alert("이메일을 입력해주세요")
                    document.getElementById("error_saemail").innerHTML=
                        "이메일 주소를 입력해주세요"
                    return;
                }

                if( satel == '' ){
                    alert("전화번호를 입력해주세요")
                    document.getElementById("error_satel").innerHTML=
                        "전화번호를 입력해주세요"
                    return;
                }

                if( sazipcode == '' ){
                    alert("우편번호를 입력해주세요")
                    document.getElementById("error_sazipcode").innerHTML=
                        "우편번호를 입력해주세요"
                    return;
                }

                if( saaddr == '' ){
                    alert("주소를 입력해주세요")
                    document.getElementById("error_saaddr").innerHTML=
                        "주소를 입력해주세요"
                    return;
                }

                let formData = new FormData(f);

                //비밀번호를 입력(변경을 원할 때)했다면
                if( new_pwd != '' ){

                    //1.기존 비밀번호와 같은지 확인
                    fetch( "/admin/check_pwd", { method:'post', body:formData } )
                    .then( res => res.json() )
                    .then( data => {

                        if( data.result != 'possible' ){
                            alert("입력하신 비밀번호가 사용중인 비밀번호와 일치합니다. 다시 입력해주세요")
                            return;
                        }

                    } )

                }


                fetch( "/admin/sawon_modify", { method:"post", body:formData } )
                .then( res => res.json() )
                .then( data => {


                    if( data.result == 1 ){
                        alert(saname+"사원의 정보가 성공적으로 변경 되었습니다")
                        location.href="/admin/sawon_list";
                    }else{
                        alert(saname+"사원 정보 수정에 실패했습니다. 다시 시도해주세요")
                    }


                } )

            }
        </script>
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            
            <div class="main-content">
                <div class="page-title-section">
                    <h2 class="page-title">${sawon.saname} 사원 정보 수정</h2>
                    <p>관리자 권한으로 사원의 인사 정보를 수정합니다.</p>
                    <hr class="title-divider"/>
                </div>
                
                <form>
                    <div class="form-grid">
                        <input name="ori_pwd" type="hidden" value="${sawon.pwd}"/>
                        
                        <div class="form-group">
                            <label for="empId">사원번호 (변경 불가)</label>
                            <input id="empId" name="sabun" class="form-control" value="${sawon.sabun}" readonly>
                        </div>

                        <div class="form-group">
                            <label for="empName">사원명
                                <span id="error_saname" class="error-msg"></span>
                            </label>
                            <input id="empName" name="saname" class="form-control" value="${sawon.saname}" required>
                        </div>

                        <div class="form-group">
                            <label for="empPw">변경할 비밀번호
                                <span id="error_pwd" class="error-msg">※ 영문 대·소문자, 숫자, 특수문자 포함 8자 이상</span>
                            </label>
                            <input type="password" id="empPw" name="new_pwd" class="form-control" placeholder="변경 시에만 입력하세요">
                        </div>

                        <div class="form-group">
                            <label for="deptno">부서</label>
                            <c:if test="${sawon.deptno eq 1}">
                                <input class="form-control" placeholder="관리자" readonly="readonly"/>
                            </c:if>
                            <c:if test="${sawon.deptno ne 1}">
                                <select id="deptno" name="deptno" class="form-control" required>
                                    <c:forEach var="dept" items="${deptList}">
                                        <option value="${dept.deptno}" ${dept.deptno eq sawon.deptno ? 'selected' : ''}>${dept.dname}</option>
                                    </c:forEach>
                                </select>
                            </c:if>
                        </div>

                        <div class="form-group">
                            <label for="empPosition">직급</label>
                            <select id="empPosition" name="sajob" class="form-control">
                                <c:forEach var="job" items="${jobList}">
                                    <option value="${job.sajob}" ${job.sajob eq sawon.sajob ? 'selected' : ''}>${job.sajob}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label for="hireDate">입사일
                                <span id="error_sahire" class="error-msg"></span>
                            </label>
                            <input type="date" id="hireDate" name="sahire" class="form-control" value="${sawon.sahire}">
                        </div>

                        <div class="form-group">
                            <label for="email">이메일 주소
                                <span id="error_saemail" class="error-msg"></span>
                            </label>
                            <input type="email" id="email" name="saemail" class="form-control" value="${sawon.saemail}">
                        </div>

                        <div class="form-group">
                            <label for="phone">전화번호
                                <span id="error_satel" class="error-msg"></span>
                            </label>
                            <input type="tel" id="phone" name="satel" class="form-control" value="${sawon.satel}" placeholder="010-0000-0000">
                        </div>

                        <div class="form-group">
                            <label for="zipCode">우편번호
                                <span id="error_sazipcode" class="error-msg"></span>
                            </label>
                            <input id="zipCode" name="sazipcode" class="form-control" value="${sawon.sazipcode}">
                        </div>

                        <div class="form-group">
                            <label for="address">주소
                                <span id="error_saaddr" class="error-msg"></span>
                            </label>
                            <input id="address" name="saaddr" class="form-control" value="${sawon.saaddr}">
                        </div>

                        <div class="form-btn-group">
                            <input type="button" value="수정 완료" class="btn-submit" onclick="modify(this.form)"/>
                            <input type="button" value="뒤로가기" class="btn-back" onclick="history.back()"/>
                        </div>

                    </div>
                </form>
            </div>
        </div>
    </body>
    
</html>