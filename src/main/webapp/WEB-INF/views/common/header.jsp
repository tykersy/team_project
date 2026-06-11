<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ page import="com.kh.project.vo.SawonVO" %>
<%@ page import="com.kh.project.dao.UserDAO" %>
<%@ page import="org.springframework.web.context.support.WebApplicationContextUtils" %>
<%@ page import="org.springframework.web.context.WebApplicationContext" %>

<%
    // 1. 세션에서 컨트롤러가 저장한 사번("user")이 있는지 꺼내보기
    Object sessionUser = session.getAttribute("user");
    SawonVO loginMember = null;

    if (sessionUser != null) {
        try {
            // 세션에 든 사번을 숫자로 변환
            int sabun = Integer.parseInt(sessionUser.toString());
            
            // 2. 스프링 내부에서 팀원이 만든 userDAO 기능을 강제로 가져옴
            WebApplicationContext wac = WebApplicationContextUtils.getRequiredWebApplicationContext(request.getServletContext());
            UserDAO userDao = wac.getBean(UserDAO.class);
            
            // 3. 사번을 넣어서 해당 사원의 전체 정보(이름, 직급 등)를 실시간으로 가져옴
            loginMember = userDao.selectUser(sabun);
            
            // 4. 조회한 사원 정보를 JSP 화면에서 쓸 수 있도록 등록
            pageContext.setAttribute("loginMember", loginMember);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<style>
    .header-profile-box {
        display: flex !important;       /* 무조건 가로로 정렬 */
        align-items: center !important; /* 위아래 정중앙 맞춤 */
        gap: 10px !important;           /* 글자와 동그라미 사이 간격 10px */
        white-space: nowrap !important; /* 글자가 절대로 밑으로 안 깨지게 한 줄로 고정 */
    }

    /* 헤더 전체를 감싸는 컨테이너 */
    .header {
        display: flex;
        justify-content: space-between; /* 헤더 좌우 끝으로 배치 */
        align-items: center;
        padding: 0 40px;
        height: 70px;
    }

    /* 우측 영역 (알림, 관리자, 로그아웃 버튼 포함) */
    .header-right {
        display: flex;
        align-items: center;
        gap: 16px;
        margin-left: auto; 
    }
</style>

<header class="header">

    <!-- <div class="search-box">
        <input type="text" placeholder="검색" />
    </div> -->

    <div class="header-right">

      <c:if test="${loginMember.sajob == '관리자' || loginMember.sajob == 'CEO'}">
        <a href="/admin" class="admin-link">
          관리자
        </a>
      </c:if>

        <div class="header-profile-box">
            
            <c:choose>
                <c:when test="${not empty loginMember}">
                    <a href="/mypage" style="display: contents;">
                        <span class="profile-text" style="font-size: 0.95rem; font-weight: 500; color: #1e293b;">
                            ${loginMember.saname} ${loginMember.sajob}
                        </span>
                        <div class="profile-circle" style="width: 36px; height: 36px; border-radius: 50%; background-color: #e2e8f0; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; border: 1px solid #cbd5e1;">
                            🧑‍💻
                        </div>
                    </a>

                    <a href="#" onclick="openModal('로그아웃','정말 로그아웃하시겠습니까?', function(){ location.href='/logout' } )" class="admin-link">
                        로그아웃
                    </a>
                </c:when>
                
                <c:otherwise>

                    <!-- 로그인이 안 되어있거나 사번 정보가 없을 때 -->
                    <a href="/login" class="login_href" style="display: contents">
                        <span class="profile-text" style="font-size: 0.95rem; color: #94a3b8; font-weight: 500;">
                            로그인 필요
                        </span>
                        <div class="profile-circle" style="width: 36px; height: 36px; border-radius: 50%; background-color: #f1f5f9; display: flex; align-items: center; justify-content: center; font-size: 1.2rem; color: #cbd5e1;">
                            👤
                        </div>
                    </a>

                </c:otherwise>
            </c:choose>
        </div>
    </div>
    <jsp:include page="/WEB-INF/views/common/modal.jsp" />
</header>