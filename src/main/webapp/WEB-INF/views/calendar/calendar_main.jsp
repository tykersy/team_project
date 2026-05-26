<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/calendar_main.css"/>
    </head>
    <body>
        <div class="calendar-header">
            <a href="calendar_calendarmain?year=${prevYear}&month=${prevMonth}">◀</a>
            ${year}.${month}
            <a href="calendar_calendarmain?year=${nextYear}&month=${nextMonth}">▶</a>
        </div>
        <div>
            <table border="1" class="calendar-table">
                <thead>
                    <tr>
                        <th style="color: red;">일</th>
                        <th>월</th>
                        <th>화</th>
                        <th>수</th>
                        <th>목</th>
                        <th>금</th>
                        <th style="color: blue;">토</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <c:forEach begin="1" end="${startBlank}">
                            <td></td>
                        </c:forEach>

                        <c:forEach var="day" begin="1" end="${lastDay}">
                            <c:set var="cellIndex" value="${startBlank + day}" />

                            <td>
                                <c:choose>
                                    <c:when test="${year == todayYear &&
                                                    month == todayMonth &&
                                                    day == todayDay}">

                                        <span class="today">${day}</span>
                                    </c:when>
                                    
                                    <c:when test="${cellIndex % 7 == 1}">
                                        <span class="sun">${day}</span>
                                    </c:when>

                                    <c:when test="${cellIndex % 7 == 0}">
                                        <span class="sat">${day}</span>
                                    </c:when>

                                    <c:otherwise>
                                        ${day}
                                    </c:otherwise>
                                </c:choose>
                            </td>

                            <c:if test="${cellIndex % 7 == 0}">
                                </tr><tr>
                            </c:if>
                        </c:forEach>
                    </tr>
                </tbody>
            </table>
        </div>
    </body>
    
</html>