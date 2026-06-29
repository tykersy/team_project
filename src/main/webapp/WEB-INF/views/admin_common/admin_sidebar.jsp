<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<aside class="sidebar">
    <div class="logo">🔗 Linked</div>

    <nav class="sidebar-menu">
        <div class="menu-group">
            <a href="/admin/main" class="sidebar-item">HOME</a>
        </div>

        <div class="menu-group dropdown">
            <div class="sidebar-item">인사/조직 관리</div>
            <ul class="submenu">
                <li><a href="/admin/sawon_list">사원 정보 관리</a></li>
                <li><a href="/admin/deptlist">부서 관리</a></li>
                <li><a href="/admin/job_position">직급 관리</a></li>
            </ul>
        </div>

        <div class="menu-group dropdown">
            <div class="sidebar-item">근태/휴가 관리</div>
            <ul class="submenu">
                <li><a href="/admin/today_ta">근태 현황</a></li>
                <li><a href="/admin/leave">휴가/연차 관리</a></li>
                <li><a href="/admin/calendar">캘린더</a></li>
            </ul>
        </div>

        <div class="menu-group dropdown">
            <div class="sidebar-item">전자 계약 관리</div>
            <ul class="submenu">


                <li><a href="/admin/set_contract">전자 근로 계약 생성</a></li>
                <li><a href="/admin/admin_contract_list">전자 계약 현황</a></li>


            </ul>
        </div>

        <div class="menu-group dropdown">
            <div class="sidebar-item">급여/정산 관리</div>
            <ul class="submenu">
                <li><a href="/admin/admin/ta_confirm">근태 마감</a></li>
                <li><a href="/admin/admin/salary_confirm">급여 정산</a></li>
            </ul>
        </div>

        <div class="menu-group">
            <a href="/admin/board/list" class="sidebar-item">공지사항</a>
        </div>
        <div class="menu-group">


            <a href="${pageContext.request.contextPath}/admin/system_role" class="sidebar-item">시스템 관리</a>

        </div>
    </nav>

    <div class="admin-section">
        <a href="/home" class="admin-btn">직원 HOME</a>
    </div>
</aside>

<script>
    document.addEventListener("DOMContentLoaded", function() {
    let sidebar = document.querySelector(".sidebar");
    sidebar.classList.add("no-transition");

    let path = window.location.pathname;

    document.querySelectorAll("a.sidebar-item").forEach(function(link) {
        if (path.startsWith(link.getAttribute("href"))) {
            link.classList.add("active");
        }
    });

    document.querySelectorAll(".submenu li a").forEach(function(link) {
        if (path.startsWith(link.getAttribute("href"))) {
            link.classList.add("active");
            link.closest(".dropdown").classList.add("active");
        }
    });

    requestAnimationFrame(function() {
        requestAnimationFrame(function() {
            sidebar.classList.remove("no-transition");
        });
    });
});
</script>
