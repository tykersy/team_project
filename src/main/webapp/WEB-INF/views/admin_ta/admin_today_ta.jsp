<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>[Linked : 근태 현황]</title>
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
        <link rel="stylesheet" href="/css/admin/today_ta.css">
        <script>
            window.onload = () => {
                today_ta(1);
            }
            function today_ta(deptno){ // 부서별 근태현황
                fetch('/admin/today_ta/data?deptno=' + deptno)
                    .then(res => res.json())
                    .then(data =>{
                        let tbody = document.getElementById('ta-tbody');
                        tbody.innerHTML = data.map(d => `
                            <tr>
                                <td>
                                    <a href="/admin/today_ta/view?sabun=\${d.sabun}">\${d.saname}</a>
                                </td>
                                <td>\${d.sahire}</td>
                                <td class="tag normal">\${d.normalCount}</td>
                                <td class="tag leave">\${d.leaveCount}</td>
                                <td class="tag late">\${d.lateCount}</td>
                                <td class="tag absent">\${d.absentCount}</td>
                            </tr>
                        `).join('');
                    });
            }

        </script>
    </head>
    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            
            <div class="main-content">
                
                <div class="page-header">
                    <div class="title-area">
                        <h2>올해 근태 현황</h2>
                    </div>
                </div>

                <div class="controls-wrapper">
                    <div class="dept-filters">
                        <c:forEach var="dept" items="${deptList}">
                            <input type="button" value="${dept.dname}" onclick="today_ta(${dept.deptno})" />
                        </c:forEach>
                    </div>
                </div>
                
                <div class="content-card">
                    <table class="data-table">
                        <colgroup>
                            <col style="width: 16.66%;">
                            <col style="width: 16.66%;">
                            <col style="width: 16.66%;">
                            <col style="width: 16.66%;">
                            <col style="width: 16.66%;">
                            <col style="width: 16.66%;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>이름</th>
                                <th>입사일</th>
                                <th>정상</th>
                                <th>휴가/반차</th>
                                <th>지각</th>
                                <th>결근</th>
                            </tr>
                        </thead>
                        <tbody id="ta-tbody">
                            </tbody>
                    </table>
                </div>

            </div>
        </div>
    </body>
</html>