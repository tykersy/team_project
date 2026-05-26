<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>

    </head>

    <body>
        <h2>직원 관리 페이지</h2>

        <div>
            <input type="button" value="PDF다운로드"/>
            <input type="button" value="+직원 추가하기"/>
        </div>

        <table border="1">
            <thead>
                <tr>
                    <th>사원번호</th>
                    <th>사원명</th>
                    <th>부서번호</th>
                    <th>직급</th>
                    <th>입사일</th>
                </tr>
            </thead>

            <tbody>
                <c:forEach var="vo" items="${list}">
                    <tr>
                        <td>${vo.sabun}</td>
                        <td>
                            <c:if test="${ vo.sabun ne '1' }">
                                <a href="/sleave/arange.do?sabun=${vo.sabun}">${vo.saname}</a>
                            </c:if>
                            <c:if test="${ vo.sabun eq '1'}">
                                ${vo.saname}
                            </c:if>
                        </td>
                        <td>${vo.deptno}</td>
                        <td>${vo.sajob}</td>
                        <td>${vo.sahire}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </body>
    
</html>