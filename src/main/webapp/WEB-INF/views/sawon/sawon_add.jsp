<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>[Linked : 사원 추가]</title>
        <link rel="stylesheet" href="/css/user/sawon_add.css">

        <%-- 카카오 도로명 검색을 위한 API 호출 --%>
        <script src="//t1.kakaocdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
        <script>
            function addr(){
                new kakao.Postcode({
                    oncomplete: function(data) {
                        // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분입니다.

                        //도로명 주소
                        let addr = document.getElementById("saaddr");
                        //우편 번호
                        let sazipcode = document.getElementById("sazipcode");
                        
                        sazipcode.value = data.zonecode;
                        addr.value = data.roadAddress;
                    }
                }).open();
            }
        </script>
        <script>
            
            function send(f){
                let sabun = f.sabun.value; //사번
                let saname= f.saname.value; //이름
                let pwd = f.pwd.value; //비밀번호
                let sahire = f.sahire.value; //입사일
                let saemail = f.saemail.value; //이메일
                let satel = f.satel.value; //전화번호
                let sazipcode = f.sazipcode.value; //우편번호
                let saaddr = f.saaddr.value; //도로명 주소

                //유효성 검사
                if(sabun == ''){alert("사번을 입력해 주세요."); return;}
                if(saname == ''){alert("이름을 입력해 주세요."); return;}
                if(pwd == ''){alert("비밀번호를 입력해 주세요."); return;}
                if(sahire == ''){alert("입사일을 입력해 주세요."); return;}
                if(saemail == ''){alert("이메일을 입력해 주세요."); return;}

                //이메일 유효성 검사를 위한 정규식
                const regEmail = /^[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i
                if(!regEmail.test(saemail)){alert("이메일 형식을 잘 못 입력하셨습니다."); return;}

                if(satel == ''){alert("전화번호를 입력해 주세요."); return;}

                //전화번호 유효성 검사를 위한 정규식
                const regtel = /^01([0|1|6|7|8|9])*-([0-9]{3,4})*-([0-9]{4})$/;
                if(!regtel.test(satel)){alert("전화번호를 정확하게 입력해주세요."); return;}

                if(saaddr == '' || sazipcode == ''){alert("주소를 입력해 주세요."); return;}

                let formData = new FormData(f);

                fetch("/admin/sawon_add", { method:"post" , body : formData})
                    .then(res => res.json())
                    .then(data => {
                        if(data.result == 1){
                            alert("등록이 완료되었습니다.");
                            location.href = "/admin/sawon_list";
                        }else{
                            alert("등록이 실패했습니다.");
                            return;
                        }
                    });
            }
        </script>
    </head>
    <body>

        <h2>사원추가</h2>
        <form>
            <table>
                <tr>
                    <th>사번</th>
                    <td>
                        <input name="sabun" type="number" value="${newSabun}" readonly="readonly" style="background-color: lightgray;"/>
                    </td>
                </tr>
                <tr>
                    <th>이름</th>
                    <td>
                        <input name="saname" />
                    </td>
                </tr>
                <tr>
                    <th>부서</th>
                    <td>
                        <select name="deptno">
                            <c:forEach var="dept" items="${dept}">
                                <option value="${dept.deptno}">${dept.dname}</option>
                            </c:forEach>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>비밀번호</th>
                    <td>
                        <input name="pwd" type="password"/>
                    <td>
                </tr>
                <tr>
                    <th>직급</th>
                    <td>
                        <select name="sajob">
                            <option value="사장">사장</option>
                            <option value="부장">부장</option>
                            <option value="차장">차장</option>
                            <option value="과장">과장</option>
                            <option value="대리">대리</option>
                            <option value="주임">주임</option>
                            <option value="사원">사원</option>
                        </select>
                    </td>
                </tr>
                <tr>
                    <th>입사일</th>
                    <td>
                        <input type="date" name="sahire" />
                    </td>
                </tr>
                <tr>
                    <th>이메일</th>
                    <td>
                        <input name="saemail" type="email"/>
                    </td>
                </tr>
                <tr>
                    <th>전화번호</th>
                    <td>
                        <input name="satel" />
                    </td>
                </tr>
                <tr>
                    <th>우편 번호</th>
                    <td>
                        <input name="sazipcode" id="sazipcode" readonly="readonly" />
                        <input type="button" value="주소 검색" 
                               onclick="addr()" />
                    </td>
                </tr>
                <tr>
                    <th>도로명 주소</th>
                    <td>
                        <input name="saaddr" id="saaddr" size="35" readonly="readonly" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <input type="button" value="추가"
                               onclick="send(this.form)"/>
                    </td>
                </tr> 
            </table>
        </form>
    </body>
</html>