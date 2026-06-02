<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

    <head>

        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/calendar/scal_insert.css">

        <script>
            function send(f){

                let title = f.title.value.trim();
                let deptno = f.deptno.value;
                let sabun = f.sabun.value;
                let startdate = f.start_date.value;
                let enddate = f.end_date.value;

                if(title === ""){
                    alert("일정을 입력하세요.");
                    return;
                }

                if(startdate === ""){
                    alert("시작일을 선택하세요.");
                    return;
                }

                if(enddate === ""){
                    alert("종료일을 선택하세요.");
                    return;
                }

                if(startdate > enddate){
                    alert("종료일은 시작일보다 빠를 수 없습니다.");
                    return;
                }

                let formData = new FormData(f);

                fetch("insert_dschedule.do", {
                    method: "POST",
                    body: formData
                })
                .then(res => res.json())
                .then(data => {

                    if(data.status === "success"){
                        alert("일정이 저장되었습니다.");
                        location.href = "calendar_calendarmain";
                    }else{
                        alert("저장 실패");
                    }

                });
            }
        </script>
    </head>
    <body>
        <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
        <div class="schedule-page">
            <form>
                <div class="form-box">
                    <div class="form-header">
                        <button type = "button" onclick ="history.back()">x</button>
                        <span>부서 일정</span>
                        <button type="button" onclick = "send(this.form)">추가</button>
                    </div>
                    <div>

                        <table class="schedule-table">
                            <tr>
                                <th>일정</th>
                                <td colspan="3">
                                    <input name = "title" placeholder="일정을 입력하세요" />
                                </td>
                            </tr>
                            <tr>
                                <th>
                                    <span>부서번호</span>
                                </th>
                                <td>
                                    <input name = "deptno" value="${vo.deptno}" readonly />
                                </td>
                                <th>
                                    <span>사번</span>
                                </th>
                                <td>
                                    <input name= "sabun" value="${vo.sabun}" readonly />
                                </td>
                            </tr>
                            <tr>
                                <th>시작</th>
                                <td>
                                    <input type="date" name= "start_date" value="${today}"/>
                                </td>
                                <th>종료</th>
                                <td>
                                    <input type="date" name= "end_date" value = "${today}"/>
                                </td>
                            </tr>
                            <tr>
                                <th>내용</th>
                                <td colspan="3">
                                    <input name = "content" placeholder="설명" />
                                </td>
                            </tr>
                        </table>
                    </div>
                </div>
            </form>
        </div>
    </body>
    
</html>
