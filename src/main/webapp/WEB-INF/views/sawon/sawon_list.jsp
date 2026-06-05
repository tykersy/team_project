<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="/css/admin/sawon_list.css"/>
        <link rel="stylesheet" href="css/admin/sidebar.css" />

        <script>
            //사원 퇴사 처리
            function del(sabun, saname){

                //재확인
                if( !confirm(saname+"님을 퇴사처리 하시겠습니까?") ){
                    return;
                }

                //단순 사원 삭제는 getMapping
                fetch( "/admin_sawon_delete?sabun="+sabun )
                .then( res => res.json() )
                .then( data => {

                    if( data.result == 1 ){
                        alert( "정상적으로 삭제되었습니다" )
                        location.href="/sawon_list.do"
                        return;
                    }

                    alert( "삭제가 정상적으로 이루어지지 않았습니다. 다시 시도하세요" )

                } )
                
            }
        </script>
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            <div class="container">
            <h2>직원 관리 페이지</h2>

            <div class="btn-group">
                <input type="button" value="PDF다운로드"/>
                <input type="button" value="+사원 추가하기"
                    onclick="location.href='sawonAdd'"/>
            </div>

            <table border="1">
                <thead>
                    <tr>
                        <th>사원번호</th>
                        <th>사원명</th>
                        <th>부서번호</th>
                        <th>직급</th>
                        <th>입사일</th>
                        <th>비고</th>
                    </tr>
                </thead>

                <tbody>
                    <c:forEach var="vo" items="${list}">
                        <tr>
                            <td>${vo.sabun}</td>
                            <td>
                                <c:if test="${ vo.sabun ne '1' }">
                                    <a href="/sawon_view.do?sabun=${vo.sabun}">${vo.saname}</a>
                                </c:if>
                                <c:if test="${ vo.sabun eq '1'}">
                                    <span class="admin-text">${vo.saname}</span>
                                </c:if>
                            </td>
                            <td>${vo.deptno}</td>
                            <td>${vo.sajob}</td>
                            <td>${vo.sahire}</td>
                            <td>
                                <input type="button" value="수정" 
                                    onclick="location.href='/admin_sawon_modify?sabun=${vo.sabun}'"/>
                                <input type="button" value="퇴사" 
                                    onclick="del('${vo.sabun}', '${vo.saname}')"/>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
            </div>
        </div>
    </body>
    
</html>