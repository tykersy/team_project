<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>

    </head>

    <body>
        <h2>사원별 연차 관리 페이지</h2>

        <table border="1" align="center">
            <tr>
                <th>사번</th>
                <td>${vo.sabun}</td>
            </tr>    
            <tr>   
                <th>사원명</th>
                <td>${sawon.saname}</td>
            </tr> 
            <tr>
                <th>입사일</th>
                <td>${sawon.sahire}</td>
            </tr>
            <tr>
                <th>잔여연차</th>
                <td>${vo.annual}</td>
            </tr>
            <tr>
                <th>무급휴가</th>
                <td>${vo.unpaid}</td>
            </tr>
            <tr>
                <th>병가</th>
                <td>${vo.mc}</td>
            </tr>
            <tr>
                <th>Health</th>
                <td>${vo.health}</td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="button" value=""/>
                </td>
            </tr>
        </table>
    </body>
    
</html>