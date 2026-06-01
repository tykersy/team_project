<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html>

    <head>
        <!-- sidebar css -->
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
        <style>
            /* 캘린더 출력할 div의 사이즈 조정 */
            #calendarbox {
                height:700px;
                width:80%
            }
        </style>
        <!-- toast ui 라이브러리 참조 & css참조 -->
        <meta charset="UTF-8">
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/toastui-calendar.min.css" />
        <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/schedule_list.css"/>
        <script src="${pageContext.request.contextPath}/js/toastui-calendar.min.js"></script>

        <script>

            let calendar;
            // 부서번호를 저장할 변수
            let cur_deptno;
            let isSearched = false; //부서명 검색 기능 사용 여부 확인

            window.onload = function() {

                let box = document.getElementById("calendarbox"); //캘린더를 출력할 div

                //캘린더가 생성되어 있지 않은 경우 캘린더 생성
                if(!calendar){
                calendar = new tui.Calendar(box, {

                    defaultView: 'month', //캘린더 방식
                    useFormPopup: false, //기본 팝업 설정 끄기
                    useDetailPopup: true, //스케쥴 디테일을 볼 수 있는 팝업
                    gridSelection: true,
                    isReadOnly: false,
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
                calendar.on( 'selectDateTime', (eventData) => {

                    console.log("선택한 날짜 데이터:", eventData);

                    //유효성체크
                    if (!cur_deptno) {
                        alert("부서를 먼저 선택해주세요.");
                        return;
                    }

                    //클릭한 날짜 데이터 가져오기
                    //eventData는 내부 객체라서 d.d.d 나 .toISOString()사용을 원칙으로 함
                    //한국 시간(KST) 기준 안정적인 yyyy-MM-dd 추출 방식
                    const offset = eventData.start.getTimezoneOffset() * 60000;
                    const localDate = new Date(eventData.start.getTime() - offset);
                    const clickedDate = localDate.toISOString().split('T')[0];

                    // Controller로 보낼 URL 생성 (파라미터 포함)
                    
                    const url = "/schedule_view.do?deptno="+cur_deptno
                                +"&date="+clickedDate;
                    
                    //미니 팝업 띄우기
                    window.open(url, 'scheduleDetailPopup', 
                                    'width=400, height=700, scrollbars=yes, resizable=no');
                } )
            
            }

            }

            //부서 버튼을 클릭하면 실행되는 함수
            function dept_sawon( deptno ){

                //전역 변수에 클릭한 부서번호를 저장
                cur_deptno = deptno;
                //부서명 클릭시 캘린더출력 div 보여주기
                if( isSearched ){
                let calendarbox = document.getElementById("calendarbox");
                calendarbox.style.display = '';
                
                isSearched = false;
                }

                fetch( "/schedule_deptSchedule.do?deptno="+deptno  )
                .then( res => res.json() )
                .then( data => {
                    
                    //기존 부서의 스케쥴 캘린더를 초기화(비우기)
                    calendar.clear();

                    //불러온 데이터를 캘린더 규격에 맞게 설정
                    const events = data.list.map( item => {

                        return {
                            id : item.id,
                            calendarId : 'cal1',
                            title : item.title,
                            start : item.start_date,
                            end : item.end_date,
                            category : 'time'
                        };

                    } );
                    //캘린더에 일정 입력
                    calendar.createEvents(events);
                } )
                

            }

            //모든부터 버튼 클릭 시 실행되는 함수
            function allSchedule(){

                //전체부서 스케쥴을 클릭 했다면 전역변수 cur_deptno 0으로 설정
                cur_deptno = 1;

                //부서명을 검색한 적이 있다면 검색 결과를 출력했던 div가리기
                let searchbox = document.getElementById("searchbox");
                searchbox.style.display = 'none';

                //부서명 클릭시 캘린더출력 div 보여주기
                if( isSearched ){
                let calendarbox = document.getElementById("calendarbox");
                calendarbox.style.display = 'block';

                isSearched = false;
                }

                fetch( "/schedule_all.do" )
                .then( res => res.json() )
                .then( data => {

                    //기존 부서의 스케쥴 캘린더를 초기화(비우기)
                    calendar.clear();

                    const events = data.list.map( item => {

                        return {
                            id : item.id,
                            calendarId : 'cal1',
                            title : item.title,
                            start : item.start_date,
                            end : item.end_date,
                            category : 'time'
                        };

                    } );
                    //캘린더에 일정 입력
                    calendar.createEvents(events);

                } )

            }

            //부서명으로 부서 검색시 호출되는 함수
            function search(f){

                let search_name = f.search_name.value; //검색어
                let calendarbox = document.getElementById("calendarbox"); //캘린더를 담는 div
                let searchbox = document.getElementById("searchbox"); //검색 결과를 담을 div
                let searchfor = document.getElementById("searchfor")

                //유효성 체크
                if( search_name == '' ){
                    alert("검색할 부서명을 입력하세요")
                    return;
                }

                isSearched = true;
                calendarbox.style.display = 'none';
                searchbox.style.display = 'block';

                fetch( "/schedule_search.do?search_name="+search_name )
                .then( res => res.json() )
                .then( data => {

                    console.log("서버가 보내준 데이터 확인:", data);

                    if( data.length === 0 ){
                        searchbox.innerHTML = "<p>검색 결과가 없습니다.</p>";
                    }else{
                        data.dlist.map(dept => {
                            searchbox.innerHTML += 
                                    `<input type="button" 
                                        value="${dept.dname}" 
                                        onclick="dept_sawon('${dept.deptno}')" 
                                        style="margin-right: 5px;"/>
                                    `;
                        });
                        
                    }

                } )

            }
        </script>
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            <div class="main-content">
            
            <h2>근무일정</h2>

            <div class="controls">
            <div class="dept-filters">
                <input type="button" value="전체부서" style="background-color: #57606f;" 
                        onclick="allSchedule()"/>
                <c:forEach var="dept" items="${dept_list}">
                    <input type="button" value="${dept.dname}" onclick="dept_sawon('${dept.deptno}')"/>
                </c:forEach>
            </div>

            <div class="search-area">
                <form>
                    <input name="search_name" placeholder="부서 검색"/>
                    <input type="button" value="검색" onclick="search(this.form)"/>
                </form>
            </div>
            </div>

            <div id="calendarbox"></div>
            <div id="searchbox"></div>
            </div>
        </div>
    </body>
    
</html>