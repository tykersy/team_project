<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!DOCTYPE html>
        <html>

        <head>

            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/calendar/scal_insert.css">
            <link rel="stylesheet" href="/css/dashboard.css"> 

            <script>
                function send(f) {

                    let title = f.title.value.trim();
                    let sabun = f.sabun.value;
                    let startdate = f.start_date.value;
                    let enddate = f.end_date.value;

                    if (title === "") {
                        alert("일정을 입력하세요.");
                        return;
                    }

                    if (startdate === "") {
                        alert("시작일을 선택하세요.");
                        return;
                    }

                    if (enddate === "") {
                        alert("종료일을 선택하세요.");
                        return;
                    }

                    if (startdate > enddate) {
                        alert("종료일은 시작일보다 빠를 수 없습니다.");
                        return;
                    }

                    let formData = new FormData(f);

                    fetch("update_sschedule.do", {
                        method: "POST",
                        body: formData
                    })
                        .then(res => res.json())
                        .then(data => {

                            if (data.status === "success") {
                                alert("일정이 저장되었습니다.");
                                location.href = "calendar_calendarmain";
                            } else {
                                alert("저장 실패");
                            }

                        });
                }
            </script>
        </head>

        <body>
            <div class="layout">
                <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
                <div class="main-content">
                    <jsp:include page="/WEB-INF/views/common/header.jsp" />
                    <div CLASS="schedule-page">
                        <form>
                            <div class="form-box">
                                <input type="hidden" name="scal_idx" value="${vo.scal_idx}" />
                                <div class="form-header">
                                    <button type="button" onclick="history.back()">X</button>
                                    <span>개인 일정</span>
                                    <button type="button" onclick="send(this.form)">수정</button>
                                </div>
                                <div>

                                    <table class="schedule-table">
                                        <tr>
                                            <th>일정</th>
                                            <td colspan="3">
                                                <input name="title" value="${vo.title}" placeholder="일정을 입력하세요" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>
                                                <span>사번</span>
                                            </th>
                                            <td colspan="3">
                                                <input name="sabun" value="${vo.sabun}" readonly />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>시작</th>
                                            <td>
                                                <input type="date" name="start_date"
                                                    value="${vo.start_date.substring(0,10)}" />
                                            </td>
                                            <th>종료</th>
                                            <td>
                                                <input type="date" name="end_date"
                                                    value="${vo.end_date.substring(0,10)}" />
                                            </td>
                                        </tr>
                                        <tr>
                                            <th>내용</th>
                                            <td colspan="3">
                                                <input name="content" placeholder="설명" value="${vo.content}" />
                                            </td>
                                        </tr>
                                    </table>
                                </div>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </body>

        </html>