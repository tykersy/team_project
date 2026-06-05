<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="css/admin/sawon_view.css"/>
        <link rel="stylesheet" href="css/admin/sidebar.css" />
        <link rel="stylesheet" as="style" crossorigin href="https://cdn.jsdelivr.net/gh/orioncactus/pretendard@v1.3.9/dist/web/static/pretendard.css" />
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            <div class="sawon_container">
            <h2>사원별 관리 페이지</h2>

            <table>
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
                        <td><span class="leave-count badge-annual">${vo.annual} 일</span></td>
                    </tr>
                    <tr>
                        <th>기타휴가</th>
                        <td><span class="leave-count badge-unpaid">${vo.etc} 일</span></td>
                    </tr>
                    <tr>
                        <th>병가</th>
                        <td><span class="leave-count badge-mc">${vo.mc} 일</span></td>
                    </tr>
                    <tr>
                        <th>Health</th>
                        <td><span class="leave-count badge-health">${vo.health} 일</span></td>
                    </tr>
                <tr>
                    <td colspan="2" align="center">
                        <input type="button" value=""/>
                    </td>
                </tr>
            </table>
            </div>
        </div>
    </body>
    
</html>