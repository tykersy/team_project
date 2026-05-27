<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 공지사항 TEST용 -->
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>공지사항 테스트</title>
<style>
    /* 간단한 레이아웃 스타일 적용 */
    body {
        background: #F8FAFC;
        font-family: Pretendard, sans-serif;
        padding: 50px;
    }
    .notice-box {
        width: 500px;
        background: white;
        border-radius: 16px;
        padding: 24px;
        box-shadow: 0 4px 18px rgba(0, 0, 0, 0.03);
    }
    .box-header {
        display: flex;
        justify-content: space-between;
        align-items: center;
        margin-bottom: 16px;
    }
    .notice-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    .notice-list li a {
        display: flex;
        justify-content: space-between;
        align-items: center;
        text-decoration: none;
        color: #334155;
        padding: 12px 4px;
        border-bottom: 1px solid #F1F5F9;
        transition: 0.2s;
    }
    .notice-list li a:hover {
        color: #3B82F6;
        padding-left: 8px;
    }
    .notice-date {
        font-size: 13px;
        color: #94A3B8;
    }
</style>
</head>
<body>

    <div class="notice-box">
        <div class="box-header">
            <h3>📢 최근 공지사항 테스트</h3>
        </div>
        
        <ul class="notice-list">
            <c:forEach items="${noticeList}" var="notice">
                <li>
                    <a href="#">
                        <span class="notice-title">${notice.title}</span>
                        <span class="notice-date">${notice.writeDate}</span>
                    </a>
                </li>
            </c:forEach>
            
            <c:if test="${empty noticeList}">
                <li style="color:#94A3B8; text-align:center; padding: 20px 0;">등록된 공지사항이 없습니다.</li>
            </c:if>
        </ul>
    </div>

</body>
</html>