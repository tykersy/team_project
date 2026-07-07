<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>[Linked : ${sawon.saname} 근태 현황]</title>
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
        <link rel="stylesheet" href="/css/admin/ta_view.css">
    </head>
    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            <div class="main-content">
                
                <div class="detail-header">
                    <h2>
                        ${sawon.saname} ${sawon.sajob} 근태 현황
                    </h2>
                </div>
                
                <div class="ta-control-bar">
                    <form action="/admin/today_ta/view" method="get" class="search-form">
                        <input type="hidden" name="sabun" value="${param.sabun}">
                        <label for="search_ym">조회 년월:</label>
                        <input type="month" id="search_ym" name="ym" value="${ym}">
                        <button type="submit" class="btn-view">조회</button>
                    </form>

                    <c:if test="${approved == 'show'}">
                        <button type="button" class="btn-ta-modify" 
                                onclick="location.href='/admin/ta_modify_form?sabun=${sawon.sabun}&ym=${ym}'">
                            근태 정보 수정하기
                        </button>
                    </c:if>
                </div>

                <table class="data-table">
                    <colgroup>
                        <col style="width: 25%;">
                        <col style="width: 25%;">
                        <col style="width: 25%;">
                        <col style="width: 25%;">
                    </colgroup>
                    <thead>
                        <tr>
                            <th>날짜</th>
                            <th>출근</th>
                            <th>퇴근</th>
                            <th>비고</th> 
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="ta" items="${userTaList}">
                            <tr>
                                <td>${ta.day}</td>
                                <td>${ta.checkin}</td>
                                <td>${ta.checkout}</td>
                                <td class="tag ${ta.status}">
                                    <c:choose>
                                        <c:when test="${ta.status eq 'absent'}">결근</c:when> 
                                        <c:when test="${ta.status eq 'late'}">지각</c:when>
                                        <c:when test="${ta.status eq 'leave'}">휴가</c:when>
                                        <c:when test="${ta.status eq 'half'}">반차</c:when>
                                        <c:when test="${ta.status eq 'normal'}">정상</c:when>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>