<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>이달의 급여 대장</title>
    <link rel="stylesheet" href="/css/admin/sidebar.css">
    <link rel="stylesheet" href="/css/admin/main.css">
    <style>
        .ledger-table th { background-color: #f1f5f9; color: #334155; }
        .text-right { text-align: right; font-variant-numeric: tabular-nums; }
        .total-row { background-color: #f8fafc; font-weight: bold; }
    </style>
</head>
<body>
    <div class="manager-container">
        <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
        
        <div class="main-content">
            <div class="page-header">
                <h2 class="page-title">이달의 급여 대장 (정산 내역)</h2>
            </div>

            <div class="section-container">
                <div class="section-title">2026-06 지급 대장 명세</div>
                <table class="data-table ledger-table">
                    <thead>
                        <tr>
                            <th>사번</th>
                            <th>이름</th>
                            <th>기본급(지급)</th>
                            <th>연장수당</th>
                            <th>식대</th>
                            <th>4대보험 공제</th>
                            <th>소득세</th>
                            <th>실지급액 (Net)</th>
                            <th>상태</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="sal" items="${salaryList}">
                            <tr>
                                <td>${sal.sabun}</td>
                                <td><strong>${sal.saname}</strong></td>
                                <td class="text-right"><fmt:formatNumber value="${sal.base_pay}" type="number"/>원</td>
                                <td class="text-right"><fmt:formatNumber value="${sal.overtime_pay}" type="number"/>원</td>
                                <td class="text-right"><fmt:formatNumber value="${sal.meal_pay}" type="number"/>원</td>
                                <td class="text-right" style="color:#dc2626;">
                                    <fmt:formatNumber value="${sal.national_pension + sal.health_insurance + sal.long_term_care + sal.employment_insurance}" type="number"/>원
                                </td>
                                <td class="text-right" style="color:#dc2626;">
                                    <fmt:formatNumber value="${sal.income_tax + sal.local_income_tax}" type="number"/>원
                                </td>
                                <td class="text-right" style="color:#16a34a; font-weight:bold;">
                                    <fmt:formatNumber value="${sal.net_pay}" type="number"/>원
                                </td>
                                <td><span class="badge-complete">${sal.status}</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>
</body>
</html>