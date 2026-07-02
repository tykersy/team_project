<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
            <!DOCTYPE html>
            <html>

            <head>
                <title>[Linked : 조직도]</title>
                <link rel="stylesheet" href="/css/dashboard.css">
                <link rel="stylesheet" href="${pageContext.request.contextPath}/css/sidebar.css">
                <link rel="stylesheet" href="/css/org_chart/dept_chart.css">

                <script>
                    function openOrgProfile(name, job, dept, email, tel) {
                        document.getElementById("orgProfileInitial").innerText = name.substring(0, 1);
                        document.getElementById("orgProfileName").innerText = name;
                        document.getElementById("orgProfileJob").innerText = job;
                        document.getElementById("orgProfileDept").innerText = dept;
                        document.getElementById("orgProfileEmail").innerText = email;
                        document.getElementById("orgProfileTel").innerText = tel;

                        document.getElementById("orgProfileModal").classList.add("open");
                    }

                    function closeOrgProfile() {
                        document.getElementById("orgProfileModal").classList.remove("open");
                    }

                    function searchOrgChart() {

                        const keyword = document.getElementById("orgSearch")
                            .value
                            .trim() 
                            .toLowerCase(); 

                        document.querySelectorAll(".dept-box, .member-card")
                            .forEach(el => el.classList.remove("focused"));

                        if (keyword === "") return;

                        let firstTarget = null;

                        document.querySelectorAll(".dept-box").forEach(dept => {

                            const deptText = dept.dataset.search.toLowerCase();

                            if (deptText.includes(keyword)) {

                                dept.classList.add("focused");

                                if (firstTarget == null) {
                                    firstTarget = dept;
                                }

                            } else {

                                dept.querySelectorAll(".member-card").forEach(member => {

                                    const memberText = member.dataset.search.toLowerCase();

                                    if (memberText.includes(keyword)) {

                                        member.classList.add("focused");

                                        if (firstTarget == null) {
                                            firstTarget = member;
                                        }

                                    }

                                });

                            }

                        });

                        if (firstTarget != null) {

                            firstTarget.scrollIntoView({
                                behavior: "smooth",
                                block: "center"
                            });

                            setTimeout(() => {
                                document.querySelectorAll(".dept-box, .member-card")
                                    .forEach(el => el.classList.remove("focused"));
                            }, 2000);

                        }

                    }
                    
                </script>

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

                                <div class="org-search-box">
                                    <input type="text" id="orgSearch" class="org-search" placeholder="이름, 직책, 부서 검색">
                                    <button type="button" class="org-search-btn" onclick="searchOrgChart()">🔍</button>
                                </div>
                            </div>

                            <div class="ceo-wrap">
                                <c:forEach var="chart" items="${chartList}">
                                    <c:if test="${chart.sabun == 1}">
                                        <div class="ceo-card" onclick="openOrgProfile(
                                                                '${chart.saname}',
                                                                '${chart.sajob}',
                                                                '${chart.dname}',
                                                                '${chart.saemail}',
                                                                '${chart.satel}'
                                                            )">
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

                                        <div class="dept-box" data-search="${dept.dname} ${dept.dtel}">

                                            <div class="dept-head">
                                                <h3>${dept.dname}</h3>
                                                <span>☎ ${dept.dtel}</span>
                                            </div>

                                            <div class="member-list">

                                                <c:forEach var="emp" items="${chartList}">
                                                    <c:if test="${emp.deptno == dept.deptno && emp.sabun != 1}">
                                                        <div class="member-card"
                                                            data-search="${emp.saname} ${emp.sajob} ${emp.dname} ${emp.saemail} ${emp.satel}"
                                                            onclick="openOrgProfile(
                                                                '${emp.saname}',
                                                                '${emp.sajob}',
                                                                '${emp.dname}',
                                                                '${emp.saemail}',
                                                                '${emp.satel}'
                                                            )">
                                                            <div class="member-circle">
                                                                ${fn:substring(emp.saname,0,1)}
                                                            </div>

                                                            <div class="member-info">
                                                                <strong>${emp.saname}</strong>
                                                                <!-- <span class="job-text">${emp.sajob}</span> -->
                                                                 <span class="job-text">
                                                                    <c:choose>
                                                                        <%-- 직급이 '팀장'이라면 아무것도 표시하지 않음 --%>
                                                                        <c:when test="${emp.sajob == '팀장'}">
                                                                            &nbsp;
                                                                        </c:when>
                                                                        <%-- 그 외의 직급은 정상 표시 --%>
                                                                        <c:otherwise>
                                                                            ${emp.sajob}
                                                                        </c:otherwise>
                                                                    </c:choose>
                                                                </span>

                                                                <span class="status-badge 
                                                                    ${emp.status == '휴가중' ? 'vacation' : 
                                                                    emp.status == '퇴근' ? 'off-work' : 
                                                                    emp.status == '근무중' ? 'working' : 'before-work'}">
                                                                    ${emp.status}
                                                                </span>
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
                        <div id="orgProfileModal" class="org-profile-modal">
                            <div class="org-profile-card">
                                <button type="button" class="org-profile-close" onclick="closeOrgProfile()">×</button>

                                <div class="org-profile-circle" id="orgProfileInitial"></div>

                                <h2 id="orgProfileName"></h2>
                                <p id="orgProfileJob"></p>

                                <div class="org-profile-info">
                                    <div>🏢 <span id="orgProfileDept"></span></div>
                                    <div>📧 <span id="orgProfileEmail"></span></div>
                                    <div>📞 <span id="orgProfileTel"></span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <script>
                    document.getElementById("orgSearch").addEventListener("keydown", function(e) {

                        if (e.key === "Enter") {
                            searchOrgChart();
                        }

                    });
                </script>

            </body>

            </html>