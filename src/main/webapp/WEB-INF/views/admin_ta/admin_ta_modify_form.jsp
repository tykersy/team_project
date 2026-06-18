<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>직원 근태 기록 수정</title>
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
        <link rel="stylesheet" href="/css/admin/today_ta.css">

        <script>
            // 수정 데이터 일괄 서버 전송 함수
            function saveAllChanges() {
                if(!confirm("변경 내용을 저장하시겠습니까?")) return;

                let form = document.getElementById('taUpdateForm');
                let formData = new FormData(form);

                // URLSearchParams를 이용하여 폼 데이터를 전송에 적합한 쿼리 스트링으로 가공
                let urlEncoded = new URLSearchParams(formData).toString();

                fetch("/admin/salary/update_ta_list", {
                    method: "POST",
                    headers: { "Content-Type": "application/x-www-form-urlencoded" },
                    body: urlEncoded
                })
                .then(res => res.json())
                .then(data => {
                    if(data === true) {
                        alert("근태 기록이 성공적으로 수정되었습니다.");
                        location.reload();
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
            <div class="main-content">
                
                <div class="detail-header">
                    <h2>${sawon.saname} ${sawon.sajob} 근태 상세 및 수정 <span style="font-size: 16px; color: #64748b;">(사번: ${param.sabun} / 정산월: ${param.ym})</span></h2>
                    <div>
                        <button type="button" class="btn-back" onclick="history.back();">뒤로가기</button>
                        <button type="button" class="btn-save-all" onclick="saveAllChanges()">근태 수정사항 저장</button>
                    </div>
                </div>

                <form id="taUpdateForm">
                    <input type="hidden" name="sabun" value="${param.sabun}">
                    <input type="hidden" name="ym" value="${param.ym}">
                    
                    <table class="data-table">
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
                                        <td colspan="5" style="text-align: center; padding: 30px; color: #999;">
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
                                                <input type="hidden" name="taList[${status.index}].day" value="${ta.day}">
                                            </td>
                                            <td>
                                                <input type="time" class="input-time" name="taList[${status.index}].checkin" value="${ta.checkin}">
                                            </td>
                                            <td>
                                                <input type="time" class="input-time" name="taList[${status.index}].checkout" value="${ta.checkout}">
                                            </td>
                                            <td>
                                                <select class="select-status" name="taList[${status.index}].status">
                                                    <option value="normal" ${ta.status eq 'normal' ? 'selected' : ''}>정상</option>
                                                    <option value="late" ${ta.status eq 'late' ? 'selected' : ''}>지각</option>
                                                    <option value="absent" ${ta.status eq 'absent' ? 'selected' : ''}>결근</option>
                                                    <option value="leave" ${ta.status eq 'leave' ? 'selected' : ''}>휴가</option>
                                                    <option value="half" ${ta.status eq 'half' ? 'selected' : ''}>반차</option>
                                                </select>
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