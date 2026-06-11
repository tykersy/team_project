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
                        <form class="schedule-card">
                            <input type="hidden" name="scal_idx" value="${vo.scal_idx}" />

                            <div class="schedule-header">

                                <div class="schedule-heading">
                                    <button type="button" class="back-btn" onclick="history.back()">
                                        ←
                                    </button>

                                    <div>
                                        <h2>개인 일정 수정</h2>
                                        <p>등록된 개인 일정을 수정하세요.</p>
                                    </div>
                                </div>

                                <div class="schedule-actions">
                                    <button type="button" class="cancel-btn" onclick="history.back()">
                                        취소
                                    </button>

                                    <button type="button" class="save-btn" onclick="send(this.form)">
                                        수정하기
                                    </button>
                                </div>

                            </div>

                            <div class="schedule-body">

                                <div class="form-group full">
                                    <label>일정명 <span>*</span></label>
                                    <input name="title" placeholder="일정을 입력하세요" value="${vo.title}" />
                                </div>

                                <div class="form-group">
                                    <label>사번 <span>*</span></label>
                                    <input name="sabun" value="${vo.sabun}" readonly />
                                </div>


                                <div class="form-row">
                                    <div class="form-group">
                                        <label>시작일 <span>*</span></label>
                                        <input type="date" name="start_date" value="${vo.start_date.substring(0,10)}" />
                                    </div>

                                    <div class="form-group">
                                        <label>종료일 <span>*</span></label>
                                        <input type="date" name="end_date" value="${vo.end_date.substring(0,10)}" />
                                    </div>
                                </div>

                                <div class="form-group full">
                                    <label>내용</label>
                                    <textarea name="content" placeholder="일정 내용을 입력하세요">${vo.content}</textarea>
                                </div>

                            </div>

                        </form>
                    </div>
                </div>
            </div>
        </body>

        </html>