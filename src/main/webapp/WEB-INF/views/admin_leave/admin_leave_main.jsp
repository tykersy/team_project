<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
        <link rel="stylesheet" href="/css/admin/leave_main.css">
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            <div class="main-content">

                <div class="page-header">
                    <h2 class="page-title">휴가 / 연차 결재 관리</h2>
                </div>

                <div class="status-card-wrapper">
                    <div class="status-card pending">
                        <h3>오늘의 미승인</h3>
                        <p class="count">${pendingCnt}건</p>
                    </div>
                    <div class="status-card approved">
                        <h3>오늘의 승인완료</h3>
                        <p class="count">${approvedCnt}건</p>
                    </div>
                    <div class="status-card active-leave">
                        <h3>오늘 휴가 중인 사원</h3>
                        <p class="count">${onLeaveCnt}명</p>
                    </div>
                </div>

                <div class="section-container">
                    <div class="section-title">휴가 승인 대기 목록</div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>신청일</th><th>이름</th><th>부서</th>
                                <th>휴가</th><th>사용일</th><th>일수</th><th>사유</th><th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="pend" items="${pendingList}">
                                <tr>
                                    <td><fmt:formatDate value="${pend.created_at}" pattern="yyyy-MM-dd"/></td>
                                    <td>${pend.saname}</td><td>${pend.dname}</td>
                                    <td>${pend.leave_type}</td><td>${pend.use_date}</td><td>${pend.use_days}</td>
                                    <td>${pend.reason}</td>
                                    <td>
                                        <button class="btn-approve" 
                                            onclick="location.href='/admin_leave_approval?log_id=${pend.log_id}'">승인</button>
                                        <button class="btn-reject" onclick="">반려</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="section-container">
                    <div class="section-header-inline">
                        <div class="section-title">
                            <a>결재 완료 히스토리</a>
                        </div>
                        <div class="search-filter-group">
                            <input type="text" placeholder="사원명 검색...">
                            <input type="button" value="검색" />
                            <button class="btn-pdf-download">📄 PDF 내역 다운로드</button>
                        </div>
                    </div>
                    <table class="data-table history-table">
                        <thead>
                            <tr>
                                <th>신청일</th><th>이름</th><th>부서</th>
                                <th>휴가</th><th>사용일</th><th>일수</th><th>사유</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="appr" items="${approvedList}">
                                <tr>
                                    <td><fmt:formatDate value="${appr.created_at}" pattern="yyyy-MM-dd"/></td>
                                    <td>${appr.saname}</td>
                                    <td>${appr.dname}</td>
                                    <td>${appr.leave_type}</td>
                                    <td>${appr.use_date}</td>
                                    <td>${appr.use_days}</td>
                                    <td>${appr.reason}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </body>
    
</html>