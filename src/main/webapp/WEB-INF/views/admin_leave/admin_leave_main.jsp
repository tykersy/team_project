<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
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
                                <th>신청일</th><th>사번</th><th>이름</th><th>부서</th>
                                <th>종료</th><th>사용일</th><th>일수</th><th>사유</th><th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <tr>
                                <td>2026-06-11</td><td>1001</td><td>홍길동</td><td>개발부</td>
                                <td>annual</td><td>2026-06-15</td><td>1.0</td><td>개인 사정</td>
                                <td>
                                    <button class="btn-approve" onclick="">승인</button>
                                    <button class="btn-reject" onclick="">반려</button>
                                </td>
                            </tr>
                        </tbody>
                    </table>
                </div>

                <div class="section-container">
                    <div class="section-header-inline">
                        <div class="section-title">✅ 결재 완료 히스토리</div>
                        <div class="search-filter-group">
                            <input type="text" placeholder="사원명 검색...">
                            <button class="btn-pdf-download">📄 PDF 내역 다운로드</button>
                        </div>
                    </div>
                    <table class="data-table history-table">
                        </table>
                </div>
            </div>
        </div>
    </body>
    
</html>