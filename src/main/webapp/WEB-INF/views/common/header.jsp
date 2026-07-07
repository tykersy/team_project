<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page import="com.kh.project.vo.SawonVO" %>
<%@ page import="com.kh.project.dao.UserDAO" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>

<%
    // 1. 세션에서 사용자 정보를 가져오되, DB 부하를 줄이기 위해 세션 캐싱 사용
    Object sessionUser = session.getAttribute("user");
    SawonVO loginMember = (SawonVO) session.getAttribute("loginMember");

    if (sessionUser != null && loginMember == null) {
        try {
            int sabun = Integer.parseInt(sessionUser.toString());
            // 스프링 컨텍스트에서 DAO 빈 가져오기
            WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
            UserDAO userDao = wac.getBean(UserDAO.class);
            
            // 사원 정보 조회 및 세션 저장 (매번 DB 조회하지 않음)
            loginMember = userDao.selectUser(sabun);
            session.setAttribute("loginMember", loginMember);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    pageContext.setAttribute("loginMember", loginMember);
%>

<style>
    .header-profile-box {
        display: flex !important;
        align-items: center !important;
        gap: 10px !important;
        white-space: nowrap !important;
    }
    .header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        padding: 0 40px;
        height: 70px;
    }
    .header-right {
        display: flex;
        align-items: center;
        gap: 16px;
        margin-left: auto;
    }
</style>

<header class="header">
    <div class="header-right">
        <!-- 관리자 또는 CEO 권한 확인 -->
        <c:if test="${loginMember.sajob == '관리자' || loginMember.sajob == 'CEO'}">
            <a href="/admin" class="admin-link">관리자</a>
        </c:if>

        <div class="header-profile-box">
            <c:choose>
                <c:when test="${not empty loginMember}">
                    <a href="/mypage" style="display: contents;">
                        <span class="profile-text" style="font-size: 0.95rem; font-weight: 500; color: #1e293b;">
                            ${loginMember.saname}님
                        </span>
                        <div class="profile-circle" style="margin: 0; width: 36px; height: 36px; border-radius: 50%; background-color: #e2e8f0; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; border: 1px solid #cbd5e1;">
                            🧑‍💻
                        </div>
                    </a>
                    <a href="#" onclick="openModal('로그아웃','정말 로그아웃하시겠습니까?', function(){ location.href='/logout' } )" class="admin-link">
                        로그아웃
                    </a>
                </c:when>
                
                <c:otherwise>
                    <a href="/login" class="login_href" style="display: contents">
                        <span class="profile-text" style="font-size: 0.95rem; color: #94a3b8; font-weight: 500;">
                            로그인 필요
                        </span>
                        <div class="profile-circle" style="maigin: 0; width: 36px; height: 36px; border-radius: 50%; background-color: #f1f5f9; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; color: #cbd5e1;">
                            👤
                        </div>
                    </a>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/common/modal.jsp" />
</header>