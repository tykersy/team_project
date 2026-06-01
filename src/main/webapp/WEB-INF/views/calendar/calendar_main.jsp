<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/calendar/calendar_main.css"/>
    </head>
    <body>
        <!--상단 바-->
        <div class="calendar-header">
            <a href="calendar_calendarmain?year=${prevYear}&month=${prevMonth}">◀</a>
            <a href="javascript:void(0)" class="head-ym" 
                onclick="openDateBox()">${year}.${month}</a>
            <a href="calendar_calendarmain?year=${nextYear}&month=${nextMonth}">▶</a>
        </div>
        <div>
            <table border="1" align="center" class="calendar-table">
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
                        <c:forEach begin="1" end="${startBlank}">
                            <td></td>
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

                                        <div class="dcal-item"
                                             onclick="openDcalDetail(
                                                '${dvo.title}',
                                                '${dvo.start_date}',
                                                '${dvo.end_date}'
                                            )">
                                            ${dvo.title}
                                        </div>

                                    </c:if>

                                </c:forEach>

                                <!-- 개인 일정 -->
                                <c:forEach var="svo" items="${scalList}">

                                    <c:if test="${day >= svo.viewStartDay &&
                                                day <= svo.viewEndDay}">

                                        <div class="scal-item"
                                             onclick="openScalDetail(
                                                '${svo.title}',
                                                '${svo.start_date}',
                                                '${svo.end_date}'
                                            )">
                                            ${svo.title}
                                        </div>

                                    </c:if>

                                </c:forEach>
                            </td>

                            <c:if test="${cellIndex % 7 == 0}">
                                </tr><tr>
                            </c:if>
                        </c:forEach>
                        <!--달력 뒷부분 공백 채우기-->
                        <c:if test="${cellIndex % 7 != 0}">
                            <c:forEach begin="1" end="${7 - (cellIndex % 7)}">
                                <td class="empty-day"></td>
                            </c:forEach>
                        </c:if>
                    </tr>
                </tbody>
            </table>

            <!--일정 추가-->
            <div >
                <div class="bottom-menu" id="bottomMenu">
                    <button onclick="location.href='dcal_insert.do'">
                        <span>부서일정 추가</span>
                    </button>

                    <button onclick="location.href='scal_insert.do'">
                        <span>개인일정 추가</span>
                    </button>
                </div>
                <div>
                    <button class="bottom-btn" onclick = "insertSchedule()" id="bottomBtn">
                         + </button>
                </div>
            </div>
        </div>

        <!-- 날짜 선택 팝업 -->
        <div id="dateModal" class="modal">

            <div class="modal-content">

                <div class="modal-title">
                    날짜 선택
                </div>

                <div class="select-wrap">

                    <select id="year">
                        <c:forEach begin="2020" end="2035" var="y">
                            <option value="${y}"
                                <c:if test="${y == year}">selected</c:if>>
                                ${y}년
                            </option>
                        </c:forEach>
                    </select>

                    <select id="month">
                        <c:forEach begin="1" end="12" var="m">
                            <option value="${m}"
                                <c:if test="${m == month}">selected</c:if>>
                                ${m}월
                            </option>
                        </c:forEach>
                    </select>

                </div>
                <div>
                    <div class="btn-area">

                        <button onclick="closeModal()">
                            취소
                        </button>

                        <button onclick="moveDate()">
                            확인
                        </button>

                    </div>
                </div>

            </div>

        </div>
        
    <!--일정 상세보기 modal-->
        <div id="detailModal" class="detail-modal">

            <div class="detail-content">

                <div class="detail-title">
                    일정
                </div>

                <table class="detail-table">
                    <tr>
                        <th>일정</th>
                        <td id="detailTitle"></td>
                    </tr>

                    <tr>
                        <th>시작일</th>
                        <td id="detailStart"></td>
                    </tr>

                    <tr>
                        <th>종료일</th>
                        <td id="detailEnd"></td>
                    </tr>
                </table>

                <div class="detail-btn-area">
                    <button type="button" 
                            onclick="closeDetailModal()">
                        닫기
                    </button>
                </div>

            </div>

        </div>

        <script>
            function openDateBox(){
                document.getElementById("dateModal")
                        .style.display = "flex";
            }

            function closeModal(){
                document.getElementById("dateModal")
                        .style.display = "none";
            }

            function moveDate(){

                let year =
                document.getElementById("year").value;

                let month =
                document.getElementById("month").value;

                location.href =
                "calendar_calendarmain?year="+year+
                "&month="+month;
            }
            function insertSchedule(){
                const menu = document.getElementById("bottomMenu");
                const btn = document.getElementById("bottomBtn");

                menu.classList.toggle("active");

                if(menu.classList.contains("active")){
                    btn.innerText = "×";
                }else{
                    btn.innerText = "+";
                }
            }

            function openDcalDetail(title,start,end){

                document.getElementById("detailTitle").innerText = title;
                document.getElementById("detailStart").innerText = start;
                document.getElementById("detailEnd").innerText = end;

                document.getElementById("detailModal")
                        .style.display = "flex";
            }

            function openScalDetail(title,start,end){

                document.getElementById("detailTitle").innerText = title;
                document.getElementById("detailStart").innerText = start;
                document.getElementById("detailEnd").innerText = end;

                document.getElementById("detailModal")
                        .style.display = "flex";
            }

            function closeDetailModal(){

                document.getElementById("detailModal")
                        .style.display = "none";
            }

        </script>

    </body>
    
</html>