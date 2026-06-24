<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                 <link rel="stylesheet" href="/css/dashboard.css"> 
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
                <link rel="stylesheet" href="/css/org_chart/dept_chart.css"> 
            </head>

            <body>
                <div class="layout">
                    <jsp:include page="/WEB-INF/views/common/sidebar.jsp" />
                    <div class="main-content">
                        <jsp:include page="/WEB-INF/views/common/header.jsp" />

                        <div class="org-page">

                            <div class="org-header">
                                <div>
                                    <h1>조직도</h1>
                                    <p>우리 회사의 조직과 구성원을 한눈에 확인하세요.</p>
                                </div>

                                <input type="text" class="org-search" placeholder="이름, 직책, 부서 검색">
                            </div>

                            <div class="ceo-wrap">
                                <c:forEach var="chart" items="${chartList}">
                                    <c:if test="${chart.sabun == 1}">
                                        <div class="ceo-card">
                                            <div class="ceo-circle">
                                                ${fn:substring(chart.saname,0,1)}
                                            </div>

                                            <div class="ceo-info">
                                                <span>대표이사</span>
                                                <strong>${chart.saname}</strong>
                                                <p>${chart.sajob}</p>
                                            </div>
                                        </div>
                                    </c:if>
                                </c:forEach>
                            </div>
                            <div class="org-wrap">

                                <!--이전에 출력한 부서번호 저장-->
                                <c:set var="prevDeptno" value="-1" />

                                <c:forEach var="dept" items="${chartList}">

                                    <c:if test="${dept.deptno != prevDeptno}">

                                        <div class="dept-box">

                                            <div class="dept-head">
                                                <h3>${dept.dname}</h3>
                                                <span>☎ ${dept.dtel}</span>
                                            </div>

                                            <div class="member-list">

                                                <c:forEach var="emp" items="${chartList}">
                                                    <c:if test="${emp.deptno == dept.deptno && emp.sabun != 1}">
                                                        <div class="member-card">
                                                            <div class="member-circle">
                                                                ${fn:substring(emp.saname,0,1)}
                                                            </div>

                                                            <div class="member-info">
                                                                <strong>${emp.saname}</strong>
                                                                <span>${emp.sajob}</span>
                                                            </div>
                                                        </div>
                                                    </c:if>
                                                </c:forEach>

                                            </div>
                                        </div>

                                        <c:set var="prevDeptno" value="${dept.deptno}" />

                                    </c:if>

                                </c:forEach>

                            </div>

                        </div>
                    </div>
                </div>

            </body>

            </html>