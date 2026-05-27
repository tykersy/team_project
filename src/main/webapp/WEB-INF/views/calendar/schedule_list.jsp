<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <style>
            /* 캘린더 출력할 div의 사이즈 조정 */
            #calendarbox {
                height:700px;
                width:100%
            }
        </style>
        <!-- toast ui 라이브러리 참조 & css참조 -->
        <meta charset="UTF-8">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/toastui-calendar.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/schedule_list.css"/>
        <script src="${pageContext.request.contextPath}/js/toastui-calendar.min.js"></script>

        <script>

            let calendar;
            // 부서번호를 저장할 변수
            let cur_deptno;

            window.onload = function() {

                let box = document.getElementById("calendarbox"); //캘린더를 출력할 div
                
                //캘린더가 생성되어 있지 않은 경우 캘린더 생성
                if(!calendar){
                calendar = new tui.Calendar(box, {

                    defaultView: 'month',
                    useFormPopup: true,
                    useDetailPopup: true,
                    gridSelection: true,
                    isReadOnly: true,
                    theme: {
                        common: {
                            border: '1px solid #e5e5e5',
                            backgroundColor: 'white',
                            holiday: { color: '#f5222d' },
                            saturday: { color: '#335fff' },
                            dayname: { color: '#333' },
                        },
                        month: {
                            dayname: { borderLeft: 'none', backgroundColor: 'var(--bg-light)' },
                        },
                    }

                }) 
                
                //날짜 클릭 이벤트 생성
                calendar.on( 'beforeCreateEvent', (eventData) => {

                    console.log("선택한 날짜 데이터:", eventData);

                    //유효성체크
                    if (!currentDeptNo) {
                        alert("부서를 먼저 선택해주세요.");
                        return;
                    }

                    //데이터 서버로 보낼 데이터
                    const saveData = {
                        deptno: cur_deptno,
                        title: eventData.title,
                        start: eventData.start.toISOString(),
                        end: eventData.end.toISOString(),
                        location: eventData.location || '',
                        state: eventData.state || 'Busy'
                    };

                    //DB저장을 위한 함수 호출
                    saveScheduleToDB(saveData);
                } )
            
            }

            }

            //관리자가 스케쥴에 입력한 일정을 DB에 저장하는 함수
            function saveScheduleToDB(saveData){ //saveDAta == 관리자가 입력한 일정의 정보

                fetch( "/insert_schedule.do", {

                    method:'post',
                    headers: {"Content-Type": "application/json",},
                    body: JSON.stringify(saveData) //saveData를 json형태로 변환

                } ).then( res => res.json() )
                   .then( data => {

                    if( data.status === "success" ){
                        alert("일정이 성공적으로 저장되었습니다")
                        
                        //일정 등록 성공 후 캘린더 갱신
                        calendar.createEvents([saveData]);
                    }else{
                        alert("시스템 오류로 일정 등록에 실패하였습니다");
                    }

                   } )

            }

            function dept_sawon( deptno ){

                currentDeptNo = deptno;

                fetch( "/dept_schedule.do?deptno="+deptno  )
                .then( res => res.json() )
                .then( data => {
                    
                    //불러온 데이터를 캘린더 규격에 맞게 설정
                    const events = data.list.map( item => {

                        return {
                            id : item.id,
                            calendarId : 'cal1',
                            title : item.title,
                            start : item.start,
                            end : item.end,
                            category : 'time'
                        };

                    } );
                    //캘린더에 일정 입력
                    calendar.createEvents(events);
                } )
                

            }
        </script>
    </head>

    <body>

        <h2>근무일정</h2>

        <div class="controls">
        <div class="dept-filters">
            <input type="button" value="전체부서" style="background-color: #57606f;" />
            <c:forEach var="dept" items="${dept_list}">
                <input type="button" value="${dept.dname}" onclick="dept_sawon('${dept.deptno}')"/>
            </c:forEach>
        </div>

        <div class="search-area">
            <form>
                <input name="search_name" placeholder="사원명 검색..."/>
                <input type="button" value="검색" onclick="send(this.form)"/>
            </form>
        </div>
    </div>

    <div id="calendarbox"></div>
        
    </body>
    
</html>