<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <title>${date}</title>
        <style>
        body { font-family: Arial, sans-serif; padding: 20px; }
        .popup-header { border-bottom: 2px solid #333; padding-bottom: 10px; margin-bottom: 20px; }
        .schedule-item { border: 1px solid #ddd; padding: 15px; margin-bottom: 10px; border-radius: 5px; }
        .schedule-title { font-weight: bold; font-size: 16px; color: #0056b3; }
        .btn-close { background-color: #6c757d; color: white; border: none; padding: 10px 15px; cursor: pointer; border-radius: 3px; float: right; }
    </style>
    </head>

    <body>
        <div class="popup-header">
        <h2>📅 ${selectedDate} 일정 목록</h2>
        <p>선택 부서: 
            <c:if test="${deptno ne 1}">
                <strong>${dept.dname}</strong>
            </c:if>
            <c:if test="${deptno eq 1}">
                <string>전체 부서</string>
            </c:if>
        </p>
    </div>

    <div class="popup-content">
        <c:if test="${empty list}">
            <p style="text-align: center; color: #888; padding: 30px 0;">등록된 부서 일정이 없습니다.</p>
        </c:if>

        <c:forEach var="schedule" items="${list}">
            <div class="schedule-item">
                <div class="schedule-title">${schedule.title}</div>
                <div>🕒 시간: ${schedule.start} ~ ${schedule.end}</div>
                <c:if test="${not empty schedule.location}">
                    <div>📍 장소: ${schedule.location}</div>
                </c:if>
                <c:if test="${not empty schedule.state}">
                    <div>상태: [${schedule.state}]</div>
                </c:if>
            </div>
        </c:forEach>
    </div>

    <hr>
    <button type="button" class="btn-close" onclick="window.close();">닫기</button>
    </body>
    
</html>