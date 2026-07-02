<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>[Linked : 근태 기록 수정]</title>
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
        <link rel="stylesheet" href="/css/admin/ta_modify.css">

        <script>
            // 수정 데이터 일괄 서버 전송 함수
            function saveAllChanges() {
                if(!confirm("변경 내용을 저장하시겠습니까?")) return;

                let form = document.getElementById('taUpdateForm');
                let formData = new FormData(form);

                // URLSearchParams를 이용하여 폼 데이터를 전송에 적합한 쿼리 스트링으로 가공
                let urlEncoded = new URLSearchParams(formData).toString();

                fetch("/admin/update_ta_list", { 
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: urlEncoded
                })
                .then(res => res.json())
                .then(data => {
                    if(data === true) {
                        alert("근태 기록이 성공적으로 수정되었습니다.");
                        location.href="/admin/today_ta/view?sabun="+form.sabun.value;
                    } else {
                        alert("저장 중 오류가 발생했습니다.");
                    }
                })
                .catch(err => {
                    console.error(err);
                    alert("서버 통신 실패");
                });
            }
        </script>
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            
            <div class="container">
                
                <div class="page-header">
                    <div class="title-area">
                        <h2>근태 정보 수정</h2>
                        <p class="sub-info">
                            <strong>${sawon.saname} ${sawon.sajob}</strong> 
                            <span>(사번: ${param.sabun} / 정산월: ${param.ym})</span>
                        </p>
                    </div>
                    <div class="btn-group">
                        <button type="button" class="btn-secondary" onclick="history.back();">뒤로가기</button>
                        <button type="button" class="btn-primary" onclick="saveAllChanges()">근태 수정사항 저장</button>
                    </div>
                </div>

                <form id="taUpdateForm" class="content-card">
                    <input type="hidden" name="sabun" value="${param.sabun}">
                    <input type="hidden" name="ym" value="${param.ym}">
                    
                    <table class="data-table">
                        <colgroup>
                            <col style="width: 8%;">
                            <col style="width: 22%;">
                            <col style="width: 25%;">
                            <col style="width: 25%;">
                            <col style="width: 20%;">
                        </colgroup>
                        <thead>
                            <tr>
                                <th>번호</th>
                                <th>날짜</th>
                                <th>출근시간</th>
                                <th>퇴근시간</th>
                                <th>근태 상태(비고)</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:choose>
                                <c:when test="${empty userTaList}">
                                    <tr>
                                        <td colspan="5" class="no-data">
                                            해당 월에 등록된 상세 근태 기록이 없습니다.
                                        </td>
                                    </tr>
                                </c:when>
                                <c:otherwise>
                                    <c:forEach var="ta" items="${userTaList}" varStatus="status">
                                        <tr>
                                            <td>${status.count}</td>
                                            <td>
                                                ${ta.day}
                                                <input type="hidden" name="userTaList[${status.index}].day" value="${ta.day}">
                                            </td>
                                            <td>
                                                <input type="time" class="input-time" name="userTaList[${status.index}].checkin" value="${ta.checkin}">
                                            </td>
                                            <td>
                                                <input type="time" class="input-time" name="userTaList[${status.index}].checkout" value="${ta.checkout}">
                                            </td>
                                            <td class="select-status" name="userTaList[${status.index}].status">
                                                
                                               <c:if test="${ta.status eq 'normal'}">
                                                    정상
                                                </c:if>
                                                <c:if test="${ta.status eq 'late'}">
                                                    지각
                                                </c:if>
                                                <c:if test="${ta.status eq 'absent'}">
                                                    결근
                                                </c:if>
                                                <c:if test="${ta.status eq 'leave'}">
                                                    휴가
                                                </c:if>
                                                <c:if test="${ta.status eq 'half'}">
                                                    반차
                                                </c:if>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </c:otherwise>
                            </c:choose>
                        </tbody>
                    </table>
                </form>

            </div>
        </div>
    </body>
</html>