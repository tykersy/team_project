<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/calendar/calendar_main.css" />
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
            <link rel="stylesheet" href="/css/dashboard.css"> 
        </head>

        <body>
            <!--상단 바-->
            <div class="layout">
                <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
                <div class="main-content">
                    <jsp:include page="/WEB-INF/views/common/header.jsp" />
                    <div style="margin: 20px 0;">
                        <div>
                            <div class="calendar-header">
                                <a href="calendar_calendarmain?year=${prevYear}&month=${prevMonth}">◀</a>
                                <a href="javascript:void(0)" class="head-ym" onclick="openDateBox()" style="font-weight: bold;">${year}.${month}</a>
                                <a href="calendar_calendarmain?year=${nextYear}&month=${nextMonth}">▶</a>
                            </div>
                            <!--일정 추가-->
                            <div>
                                <div class="bottom-menu" id="bottomMenu">
                                    <c:if test="${isLeader}">
                                        <button onclick="location.href='dcal_insert.do'">
                                            <span>부서일정 추가</span>
                                        </button>
                                    </c:if>

                                    <button onclick="location.href='scal_insert.do'">
                                        <span>개인일정 추가</span>
                                    </button>
                                </div>
                                <div>
                                    <button class="bottom-btn" onclick="insertSchedule()" id="bottomBtn">
                                        ☰ </button>
                                </div>
                            </div>
                            
                        </div>
                        <div class="calendar-legend">
                            <div class="legend-item">
                                <span class="legend-color dcal-color"></span>
                                <span>부서 일정</span>
                            </div>

                            <div class="legend-item">
                                <span class="legend-color scal-color"></span>
                                <span>개인 일정</span>
                            </div>
                        </div>
                        <div>
                            <table class="calendar-table">
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
                                        <!--달력 앞부분 공백 채우기-->
                                        <c:forEach begin="1" end="${startBlank}" var="i">
                                            <td class="other-month">
                                                ${prevLastDay - startBlank + i}
                                            </td>
                                        </c:forEach>

                                        <c:forEach var="day" begin="1" end="${lastDay}">
                                            <c:set var="cellIndex" value="${startBlank + day}" />

                                            <td>
                                                <div class="day-number">
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
                                                </div>
                                                <!-- 부서 일정 -->
                                                <c:forEach var="dvo" items="${dcalList}">

                                                    <c:if test="${day >= dvo.viewStartDay &&
                                                day <= dvo.viewEndDay}">

                                                        <div class="dcal-item" onclick="openDcalDetail(
                                                '${dvo.dcal_idx}',
                                                '${dvo.title}',
                                                '${dvo.start_date}',
                                                '${dvo.end_date}',
                                                '${dvo.content}',
                                                '${dvo.sabun}'
                                            )">
                                                            ${dvo.title}
                                                        </div>

                                                    </c:if>

                                                </c:forEach>

                                                <!-- 개인 일정 -->
                                                <c:forEach var="svo" items="${scalList}">

                                                    <c:if test="${day >= svo.viewStartDay &&
                                                day <= svo.viewEndDay}">

                                                        <div class="scal-item" onclick="openScalDetail(
                                                '${svo.scal_idx}',
                                                '${svo.title}',
                                                '${svo.start_date}',
                                                '${svo.end_date}',
                                                '${svo.content}',
                                                '${svo.sabun}'
                                            )">
                                                            ${svo.title}
                                                        </div>

                                                    </c:if>

                                                </c:forEach>
                                            </td>

                                            <c:if test="${cellIndex % 7 == 0}">
                                    </tr>
                                    <tr>
                                        </c:if>
                                        </c:forEach>
                                        <!--달력 뒷부분 공백 채우기-->
                                        <c:if test="${cellIndex % 7 != 0}">
                                            <c:forEach begin="1" end="${endBlank}" var="i">
                                                <td class="other-month">
                                                    ${i}
                                                </td>
                                            </c:forEach>
                                        </c:if>
                                    </tr>
                                </tbody>
                            </table>
                        </div>

                        
                    </div>

                    <jsp:include page="/WEB-INF/views/calendar/calendar_date_modal.jsp" />
                    <jsp:include page="/WEB-INF/views/calendar/calendar_detail_modal.jsp" />
                    <jsp:include page="/WEB-INF/views/common/msg.jsp" />
                </div>
            </div>

            <script>
                const loginSabun = ${sabun};
            </script>

            <script src="${pageContext.request.contextPath}/js/calendar/calendar_main.js"></script>

        </body>

        </html>