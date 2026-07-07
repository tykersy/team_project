<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>[Linked : 로그인]</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/login.css">
        <script>

            function enterkey(){
                if(window.event.keyCode == 13)
                    document.getElementById("loginBtn").click();
            }
            

            function login(f){
                let sabun = f.sabun.value;
                let pwd = f.pwd.value;

                //유효성 검사
                if(sabun == '' && pwd == ''){alert("모든칸에 입력해주세요."); return;}

                let formData = new FormData(f);

                fetch("/login",{ method:"post" , body : formData })
                    .then(res => res.json() )
                    .then(data =>{
                        if(data.result == "succeed"){
                            //로그인 성공
                            location.href = "/dashboard";
                        }else if(data.result == "pwdFail"){
                            //비밀번호 불일치
                            alert("비밀번호 또는 사번을 확인해주세요.");
                            return;
                        }else{
                            //사번 불일치
                            alert("존재하지않는 사원입니다.");
                            return;
                        }
                    });
            }
        </script>
    </head>
    <body>
        <!--상단 아이콘 클릭되게 변경-->
        <span class="logo-link" onclick="location.href='/'">Linked</span>
        <form>
            <h2>로그인</h2>
            <table>
                <tr>
                    <th>사번</th>
                    <td>
                        <input name="sabun" type="number" />
                    </td>
                </tr>
                <tr>
                    <th>비밀번호</th>
                    <td>
                        <input name="pwd" type="password" onkeyup="enterkey()" />
                    </td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <input type="button" value="로그인" id="loginBtn"
                               onclick="login(this.form)"/>
                    </td>
                </tr>
            </table>
        </form>
    </body>
</html>