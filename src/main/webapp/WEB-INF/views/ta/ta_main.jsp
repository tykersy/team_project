<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


        <!DOCTYPE html>
        <html>

        <head>
            <meta charset="UTF-8">
            <title>근태 관리</title>

            <script>
                function checkIn() {

                    fetch("checkin.do", {
                        method: "POST"
                    })
                        .then(res => res.json())
                        .then(data => {

                            if (data.result === "yes") {
                                alert("출근 처리되었습니다.");
                                location.reload();

                            } else if (data.result === "already") {
                                alert("이미 출근 처리되었습니다.");

                            } else if (data.result === "login") {
                                alert("로그인이 필요합니다.");
                                location.href = "login";

                            } else {
                                alert("출근 처리 실패");
                            }

                        });
                }

                function checkOut() {

                    fetch("checkout.do", {
                        method: "POST"
                    })
                        .then(res => res.json())
                        .then(data => {

                            if (data.result === "yes") {
                                alert("퇴근 처리되었습니다.");
                                location.reload();

                            } else if (data.result === "not_checkin") {
                                alert("출근 기록이 없습니다.");

                            } else if (data.result === "already") {
                                alert("이미 퇴근 처리되었습니다.");

                            } else if (data.result === "login") {
                                alert("로그인이 필요합니다.");
                                location.href = "login";

                            } else {
                                alert("퇴근 처리 실패");
                            }

                        });
                }
            </script>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
            <link rel="stylesheet" href="/css/dashboard.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ta/ta_main.css">

        </head>

        <body>
            <div class="layout">
                <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
                <div class="main-content">
                    <jsp:include page="/WEB-INF/views/common/header.jsp" />

                    <h2 class="ta-title">근태 관리</h2>
                    <div class="ta-card">
                        <c:choose>
                            <c:when test="${empty today}">
                                <button type="button" onclick="checkIn()">출근</button>
                            </c:when>

                            <c:when test="${empty today.checkout}">
                                <p>출근 시간 : ${today.checkin}</p>
                                <button type="button" onclick="checkOut()">퇴근</button>
                            </c:when>

                            <c:otherwise>
                                <p>오늘 근무 완료</p>
                                <p>출근 시간 : ${today.checkin}</p>
                                <p>퇴근 시간 : ${today.checkout}</p>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <h3>근태 기록</h3>

                    <table class="ta-table">
                        <tr>
                            <th>날짜</th>
                            <th>출근</th>
                            <th>퇴근</th>
                        </tr>   

                        <c:forEach var="vo" items="${list}">
                            <tr>
                                <td>${vo.day}</td>
                                <td>${vo.checkin}</td>
                                <td>${vo.checkout}</td>
                            </tr>
                        </c:forEach>
                    </table>
                </div>
            </div>

        </body>

        </html>