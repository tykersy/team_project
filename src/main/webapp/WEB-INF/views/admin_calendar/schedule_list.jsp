<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>


<!DOCTYPE html>
<html>

    <head>
        <!-- sidebar css -->
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
        <link rel="stylesheet" href="/css/admin/dcal.css">
        
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
                    useDetailPopup: false, //스케쥴 디테일을 볼 수 있는 팝업
                    gridSelection: true,
                    isReadOnly: false,
                    calendars: [ //부서별로 색깔 다르게 표시
                        {
                            id: 1,
                            name: '사장',
                            backgroundColor: '#111827', // 연한 블루
                            borderColor: '#000000',
                            color: '#FFFFFF'
                        },
                        {
                            id: 10,
                            name: '인사팀',
                            backgroundColor: '#3B82F6', // 연한 블루
                            borderColor: '#DBEAFE',
                            color: '#FFFFFF'
                        },
                        {
                            id: 20,
                            name: '경영팀',
                            backgroundColor: '#10B981', // 연한 그린
                            borderColor: '#D1FAE5',
                            color: '#FFFFFF'
                        },
                        {
                            id: 30,
                            name: '마케팅팀',
                            backgroundColor: '#FF0000', // 연한 레드
                            borderColor: '#FFE4E6',
                            color: '#FFFFFF'
                        },
                        {
                            id: 40,
                            name: '보안팀',
                            backgroundColor: '#7C3AED', // 연한 퍼플
                            borderColor: '#F5F3FF',
                            color: '#FFFFFF'
                        },
                        {
                            id: 50,
                            name: '개발팀',
                            backgroundColor: '#FF8C00', // 연한 그레이
                            borderColor: '#E06C00',
                            color: '#FFFFFF'
                        }
                    ],
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

                    //모달 날짜추가
                    document.getElementById("modalTargetDate").innerText = clickedDate;

                    // 모달을 위한 비동기fetch호출
                    fetch( "/admin/schedule_view?deptno="+cur_deptno+"&date="+clickedDate)
                    .then(res => res.json())
                    .then(data =>{
                        console.log("서버 응답 데이터:", data)

                        //리스트 출력할 컨테이너 가져오기
                        const listContainer = document.getElementById("scheduleListContainer");

                        if (!listContainer) {
                            console.error("scheduleListContainer 엘리먼트를 찾을 수 없습니다.");
                            return;
                        }
                        listContainer.innerHTML = ""; // 기존 목록 초기화

                        //scheudleList에 읽어온 정보 입력
                        const scheduleList = data.list || data;

                        //데이터 유무에 따라서 동적으로 값 넣기
                        if (!scheduleList || scheduleList.length === 0) {
                            listContainer.innerHTML = `
                                <div class="sch-no-data">
                                    <p>등록된 부서 일정이 없습니다.</p>
                                    </div>
                                    <div class="schedule-btn-area">
                                    <input type="button" class="schedule_insert_btn" value="일정 추가" onclick="openScheduleInsert()" />
                                    </div>
                            `;
                        } else {
                            let html = '<ul class="sch-list-group">';
                            scheduleList.forEach(item => {
                                // 백엔드 ScheduleDTO 필드명(title, content, dname 등)에 맞게 매핑
                                // 전체 부서 조회 시(deptno==1) 각 일정의 부서명을 뱃지로 달아주면 좋습니다.
                                const deptBadge = `<span class="sch-dept-badge">\${item.dname}</span>`;
                                const contentText = item.start_date && item.end_date ? `<p class="sch-item-content">\${item.start_date} ~ \${item.end_date}</p>` : '';

                                html += `
                                    <li class="sch-list-item">
                                        <div class="sch-item-header">
                                            <span class="sch-item-title">📌 \${item.title}</span>
                                            \${deptBadge}
                                        </div>
                                        \${contentText}
                                        <input type="button" value="일정 수정" onclick="openScheduleUpdate(\${item.dcal_idx})" />
                                        <input type="button" value="일정 삭제" onclick="deleteSchedule(\${item.dcal_idx})" />
                                        </li>
                                        
                                `;
                            });
                            html += 
                            '<div class="schedule-btn-area"><input type="button" class="schedule_insert_btn" value="일정 추가" onclick="openScheduleInsert()" /></div></ul>';

                            //html문장 주입
                            listContainer.innerHTML = html;
                        }

                        //모달 열기
                        document.getElementById("scheduleDetailModal").style.display = "flex";

                    })
                } )
            
            }

            allSchedule();

            }

            //모달 닫기
            function closeScheduleModal(){
                document.getElementById("scheduleDetailModal").style.display = "none";

                //캘린더 하이라이트 제거
                calendar.clearGridSelections();
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

                fetch( "/admin/schedule_dept?deptno="+deptno  )
                .then( res => res.json() )
                .then( data => {
                    
                    //기존 부서의 스케쥴 캘린더를 초기화(비우기)
                    calendar.clear();

                    //불러온 데이터를 캘린더 규격에 맞게 설정
                    const events = data.list.map( item => {

                        return {
                            id : item.dcal_idx,
                            calendarId : item.deptno,
                            title : item.title,
                            start : item.start_date,
                            end : item.end_date,
                            category : 'allday',
                            isAllday : true
                        };

                    } );
                    //캘린더에 일정 입력
                    calendar.createEvents(events);
                } )
                

            }

            //모든부서 버튼 클릭 시 실행되는 함수
            function allSchedule(){

                //전체부서 스케쥴을 클릭 했다면 전역변수 cur_deptno 1으로 설정
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

                fetch( "/admin/schedule_all" )
                .then( res => res.json() )
                .then( data => {

                    //기존 부서의 스케쥴 캘린더를 초기화(비우기)
                    calendar.clear();

                    const events = data.list.map( item => {

                        return {
                            id : item.dcal_idx,
                            calendarId : item.deptno,
                            title : item.title,
                            start : item.start_date,
                            end : item.end_date,
                            category : 'allday',
                            isAllday : true
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

                //유효성 체크
                if( search_name == '' ){
                    alert("검색할 부서명을 입력하세요")
                    return;
                }

                isSearched = true;
                calendarbox.style.display = 'none';
                searchbox.style.display = 'block';

                searchbox.innerHTML = "" //기존 검색결과 초기화

                fetch( "/admin/schedule_search?search_name="+search_name )
                .then( res => res.json() )
                .then( data => {

                    console.log("서버가 보내준 데이터 확인:", data);

                    // 결과가 비어있거나 dlist가 없는 경우 예외 처리
                    if( !data || !data.dlist || data.dlist.length === 0 ){
                        searchbox.innerHTML = 
                            '<div class="no-result-box"><strong>'+
                            search_name+'</strong><p>에 대한검색 결과가 없습니다.</p></div>'
                            
                    }else{

                        searchbox.innerHTML = `
                            <div class="search-result-header">

                                // 수정필요!!!!!!!!****
                                '<strong>${search_name}</strong>' 검색 결과 (총 ${data.dlist.length}건)
                            </div>
                            <div class="search-card-grid">`;

                        data.dlist.map( dept => {
                            
                            console.log(dept.dname)
                            searchbox.innerHTML += 
                                    '<div class="dept-search-card"><input type="button" value="'+dept.dname+
                                        '" onclick="dept_sawon(\'' + dept.deptno + '\')" style="margin: 20px 50px;"/>';
                        });
                        
                    }

                } )

            }
            //버튼 색 변경
            function selectDeptButton(btn) {

                document.querySelectorAll(".dept-filters input")
                    .forEach(item => item.classList.remove("active"));

                btn.classList.add("active");
            }

            //일정 추가
            function openScheduleInsert(){

                document.getElementById("scheduleDetailModal").style.display = "none";
                document.getElementById("scheduleForm").reset();
                document.getElementById("dcal_idx").value = "";

                const date = document.getElementById("modalTargetDate").innerText;

                document.getElementById("start_date").value = date;
                document.getElementById("end_date").value = date;

                document.getElementById("scheduleFormModal").style.display = "flex";
            }

            //일정추가 종료
            function closeScheduleFormModal(){
                document.getElementById("scheduleFormModal").style.display = "none";

                document.getElementById("scheduleDetailModal").style.display = "flex";
            }

            //일정 저장
            function saveSchedule(){
                const form = document.getElementById("scheduleForm");
                const formData = new FormData(form);

                const dcal_idx = document.getElementById("dcal_idx").value;
                const title = document.getElementById("title").value.trim();
                const startDate = document.getElementById("start_date").value;
                const endDate = document.getElementById("end_date").value;

                if(title === ""){
                    alert("제목을 입력하세요.");
                    return;
                }

                if(startDate === "" || endDate === ""){
                    alert("시작일과 종료일을 선택하세요.");
                    return;
                }

                if(startDate > endDate){
                    alert("종료일은 시작일보다 빠를 수 없습니다.");
                    return;
                }

                let url;
                let successMsg;

                if(dcal_Idx === ""){
                    // 추가
                    url = "/admin/schedule_insert";
                    successMsg = "일정이 추가되었습니다.";

                    // insert는 auto_increment라 dcal_idx 보내면 안 됨
                    formData.delete("dcal_idx");
                }else{
                    // 수정
                    url = "/admin/schedule_update";
                    successMsg = "일정이 수정되었습니다.";
                }

                fetch(url, {
                    method: "POST",
                    body: formData
                })
                .then(res => res.json())
                .then(data => {

                    if(data.result === "success"){
                        alert(successMsg);

                        document.getElementById("scheduleFormModal").style.display = "none";

                        if(cur_deptno == 1){
                            allSchedule();
                        }else{
                            dept_sawon(cur_deptno);
                        }

                    }else{
                        alert("저장 실패");
                    }
                });
            }

            //일정 수정
            function openScheduleUpdate(dcal_idx){

                fetch("/admin/schedule_one?dcal_idx=" + dcal_idx)
                .then(res => res.json())
                .then(vo => {
                    document.getElementById("dcal_idx").value = vo.dcal_idx;
                    document.getElementById("deptno").value = vo.deptno;
                    document.getElementById("title").value = vo.title;
                    document.getElementById("start_date").value = vo.start_date.substring(0, 10);
                    document.getElementById("end_date").value = vo.end_date.substring(0, 10);
                    document.getElementById("content").value = vo.content || "";

                    document.getElementById("scheduleDetailModal").style.display = "none";
                    document.getElementById("scheduleFormModal").style.display = "flex";
                });
            }

            function deleteSchedule(dcal_idx){
                if(!confirm("일정을 삭제하시겠습니까?")){
                    return;
                }
                fetch("/admin/schedule_delete?dcal_idx="+dcal_idx, {method: "POST"})
                .then(res=>res.json())
                .then(data=>{
                    if(data.result === "success"){
                        alert("삭제되었습니다.")
                        
                        closeScheduleModal();
                        location.reload();
                    }else{
                        alert("삭제실패")
                    }
                });
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
                <input type="button" value="전체부서" class="active"  
                        onclick="selectDeptButton(this); allSchedule()"/>
                <c:forEach var="dept" items="${dept_list}">
                    <input type="button" value="${dept.dname}" onclick="selectDeptButton(this); dept_sawon('${dept.deptno}')"/>
                </c:forEach>
            </div>

            <div class="search-area">
                <form>
                    <input name="search_name" placeholder="부서 검색"/>
                    <input type="button" value="검색" onclick="search(this.form)"/>
                </form>
            </div>
            </div>

            <div class="calendar-legend">
                <span class="legend-item"><i class="dot admin"></i>CEO</span>
                <span class="legend-item"><i class="dot hr"></i>인사팀</span>
                <span class="legend-item"><i class="dot mg"></i>경영팀</span>
                <span class="legend-item"><i class="dot mkt"></i>마케팅팀</span>
                <span class="legend-item"><i class="dot sec"></i>보안팀</span>
                <span class="legend-item"><i class="dot dev"></i>개발팀</span>
            </div>
            <div id="calendarbox"></div>
            <div id="searchbox"></div>
            </div>
        </div>

        <div id="scheduleDetailModal" class="schedule-modal-overlay" onclick="if(event.target == this) closeScheduleModal();">
            <div class="schedule-modal-content">
                <div class="sch-modal-header">
                    <h3>📅 일정 목록 (<span id="modalTargetDate"></span>)</h3>
                    <button type="button" class="sch-close-btn" onclick="closeScheduleModal()">&times;</button>
                </div>
                
                <div class="sch-modal-body" id="scheduleListContainer">
                    </div>
                
                <div class="sch-modal-footer">
                    <button type="button" class="btn-sch-close" onclick="closeScheduleModal()">확인</button>
                </div>
            </div>
        </div>

        <div id="scheduleFormModal" class="schedule-modal-overlay"
            style="display:none; z-index:100000;"  onclick="if(event.target==this) closeScheduleFormModal();">
            <div class="schedule-modal-content">
                <form id="scheduleForm">
                    <input type="hidden" name="dcal_idx" id="dcal_idx">
                    <div>
                        <label>부서</label>
                        <select name="deptno" id="deptno">
                            <c:forEach var="dept" items="${dept_list}">
                                <option value="${dept.deptno}">
                                    ${dept.dname}
                                </option>
                            </c:forEach>
                        </select>
                    </div>
                    <div>
                        <label>제목</label>
                        <input type="text" name="title" id="title">
                    </div>
                    <div>
                        <label>시작일</label>
                        <input type="date" name="start_date" id="start_date">
                    </div>
                    <div>
                        <label>종료일</label>
                        <input type="date" name="end_date" id="end_date">
                    </div>
                    <div>
                        <label>내용</label>
                        <textarea name="content" id="content"></textarea>
                    </div>
                    <div class="form-btn-area">
                        <button type="button" onclick="saveSchedule()">저장</button>
                        <button type="button" onclick="closeScheduleFormModal()">취소</button>
                    </div>
                </form>
            </div>
        </div>

        
    </body>
    
</html>