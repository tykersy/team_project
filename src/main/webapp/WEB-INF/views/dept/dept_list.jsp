<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

    <head>

    </head>
    <body>
        <table border="1">
            <thead>
                <tr>
                    <th>부서번호</th>
                    <th>부서이름</th>
                    <th>부서전화</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="dept" items="${list}">
                    <tr>
                        <td>${dept.deptno}</td>
                        <td>${dept.dname}</td>
                        <td>${dept.dtel}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </body>
    
</html>