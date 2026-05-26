<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>

        <script src="https://uicdn.toast.com/calendar/latest/toastui-calendar.min.js"></script>

        <script>
            

            function dept_sawon( deptno ){

                const targetDate = "2026-05-26"; // 조회할 날짜
            
                // 달력의 현재 날짜를 타겟 날짜로 이동
                calendar.setDate(targetDate);

                let formData = new FormData(deptno);

                fetch( "/dept_schedule.do", { method:'post', body: formData } )
                .then( res => res.json() )
                .then( data => {

                    

                } )
                

            }
        </script>

    </head>

    <body>

        <h2>근무일정</h2>

        <div>
            <form>
                <input name="search_name" placeholder="검색할 사원명을 입력하세요"/>
                <input type="button" value="검색" onclick="send(this.form)"/>
            </form>
        </div>

        <div>
            <input type="button" value="전체부서"/>
            <c:forEach var="dept" items="${dept_list}">
                <input type="button" value="${dept.dname}" onclick="dept_sawon('${dept.deptno}')"/>
            </c:forEach>
        </div>

        <div id="calendar">

        </div>

        <div>

        </div>
        
    </body>
    
</html>