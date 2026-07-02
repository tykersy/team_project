<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html>

    <head>
        <title>[Linked : 휴가 / 연차]</title>
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
        <link rel="stylesheet" href="/css/admin/leave_main.css">

        <script>
            let searched = false;

            // 1. 모달창 열기
            function openRejectModal(log_id) {
                document.getElementById("modal_log_id").value = log_id; // 어떤 글을 반려할지 ID 저장
                document.getElementById("reject_reason").value = ""; // 기존에 썼던 글 초기화
                document.getElementById("rejectModal").classList.add("active"); // 모달 띄우기
            }

            // 2. 모달창 닫기
            function closeRejectModal() {
                document.getElementById("rejectModal").classList.remove("active"); // 모달 숨기기
            }

            // 3. 반려 데이터 서버로 전송
            function submitReject() {
                let log_id = document.getElementById("modal_log_id").value;
                let reason = document.getElementById("reject_reason").value;
                
                if(reason === "") {
                    alert("반려 사유를 반드시 입력해주세요.");
                    document.getElementById("reject_reason").focus();
                    return;
                }
                
                // 안전하게 전송하기 위해 POST 방식 비동기 통신 이용
                // URL과 파라미터명은 작성하시는 Controller 규격에 맞게 수정하세요.
                fetch("/admin/leave_reject?log_id="+log_id+"&reject_reason="+encodeURIComponent(reason))
                .then( data => data.json() )
                .then(res => {
                    if(res.result == 1) {
                        alert("반려 처리가 완료되었습니다.");
                        closeRejectModal();
                        location.reload(); // 성공 후 대기목록 갱신을 위해 페이지 새로고침
                    } else {
                        alert("서버 오류로 인해 반려 처리에 실패했습니다.");
                    }
                })
                .catch(err => {
                    console.error("에러:", err);
                    alert("통신 중 오류가 발생했습니다.");
                });
            }

            function search_history(){

                let search_name = document.getElementById("saname").value; //검색할 사원명

                if( search_name === '' ){
                    alert("검색할 사원명을 입력하세요")
                    return;
                }

                fetch( "/admin/leave_search_history?search_name="+search_name )
                .then( res => res.json() )
                .then( data => {

                    //사원명을 검색했다면 전역변수 searched를 true로 바꿔준다
                    searched = true;

                    let history_box = document.getElementById("history_content")
                    history_box.style.display = 'none';

                    //검색 결과를 담는 tbody
                    let search_result = document.getElementById("search_result")
                    search_result.style.display = 'table-row-group';

                    if( data.list == null || data.list == '' ){
                        //검색결과가 없을 때 보여줄 결과
                        search_result.innerHTML = `<tr><td colspan="8" style="text-align:center; padding:20px;">\${search_name}님에 대한 검색결과가 없습니다.</td></tr>`;
                    }else{
                        //받아온 데이터 출력문 작성하기
                        let html = "";

                        data.list.forEach(item => {
                            // 날짜 데이터가 밀리세컨드(타임스탬프)로 올 경우를 대비해 YYYY-MM-DD 변환
                            let dateStr = "";
                            if(item.created_at) {
                                let date = new Date(item.created_at);
                                dateStr = date.getFullYear() + '-' + 
                                          String(date.getMonth() + 1).padStart(2, '0') + '-' + 
                                          String(date.getDate()).padStart(2, '0');
                            }
                            let approveBadge = "";

                            if(item.approve == 1){
                                approveBadge = `<span class="status-badge approve">승인</span>`;
                            }else if(item.approve == 2){
                                approveBadge = `<span class="status-badge reject">반려</span>`;
                            }
                            html += `<tr>
                                <td>\${dateStr}</td>
                                <td>\${item.saname || ''}</td>
                                <td>\${item.dname || ''}</td>
                                <td>\${item.leave_type || ''}</td>
                                <td>\${item.use_date || ''}</td>
                                <td>\${item.use_days || 0}일</td>
                                <td>\${item.reason || ''}</td>
                                <td>\${approveBadge}</td>
                                </tr>`;
                            });

                        // 생성된 HTML 코드를 tbody 안에 집어넣기
                        search_result.innerHTML = html;
                    }

                } )

            }

            function reloadHistory(){
                location.reload();
            }
        </script>
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            <div class="main-content">

                <div class="page-header">
                    <h2 class="page-title">휴가 / 연차 결재 관리</h2>
                </div>

                <div class="status-card-wrapper">
                    <div class="status-card pending">
                        <h3>오늘의 미승인</h3>
                        <p class="count">${pendingCnt}건</p>
                    </div>
                    <div class="status-card approved">
                        <h3>오늘의 승인완료</h3>
                        <p class="count">${approvedCnt}건</p>
                    </div>
                    <div class="status-card active-leave">
                        <h3>오늘 휴가 중인 사원</h3>
                        <p class="count">${onLeaveCnt}명</p>
                    </div>
                </div>

                <div class="section-container">
                    <div class="section-title">휴가 승인 대기 목록</div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>신청일</th><th>이름</th><th>부서</th>
                                <th>휴가</th><th>사용일</th><th>일수</th><th>사유</th><th>관리</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="pend" items="${pendingList}">
                                <tr>
                                    <td><fmt:formatDate value="${pend.created_at}" pattern="yyyy-MM-dd"/></td>
                                    <td>${pend.saname}</td><td>${pend.dname}</td>
                                    <td>${pend.leave_type}</td><td>${pend.use_date}</td><td>${pend.use_days}</td>
                                    <td>${pend.reason}</td>
                                    <td>
                                        <button class="btn-approve" 
                                            onclick="location.href='/admin/leave_approval?log_id=${pend.log_id}'">승인</button>
                                        <button class="btn-reject" onclick="openRejectModal('${pend.log_id}')">반려</button>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

                <div class="section-container">
                    <div class="section-header-inline">
                        <div class="section-title">
                            <a>결재 완료 히스토리</a>
                        </div>
                        <div class="search-filter-group">
                            <input type="button" value="↻"
                                onclick="reloadHistory()">
                            <input type="text" id="saname" placeholder="사원명 검색...">
                            <input type="button" value="검색" 
                                onclick="search_history()"/>
                        </div>
                    </div>
                    <table class="data-table">
                        <thead>
                            <tr>
                                <th>신청일</th><th>이름</th><th>부서</th>
                                <th>휴가</th><th>사용일</th><th>일수</th><th>사유</th><th>승인</th>
                            </tr>
                        </thead>
                        <tbody id="history_content">
                            <c:forEach var="appr" items="${approvedList}">
                                <tr>
                                    <td><fmt:formatDate value="${appr.created_at}" pattern="yyyy-MM-dd"/></td>
                                    <td>${appr.saname}</td>
                                    <td>${appr.dname}</td>
                                    <td>${appr.leave_type}</td>
                                    <td>${appr.use_date}</td>
                                    <td>${appr.use_days}</td>
                                    <td>${appr.reason}</td>
                                    <td>
                                        <c:if test="${appr.approve == 1}">
                                            <span class="status-badge approve">승인</span>
                                        </c:if>
                                        <c:if test="${appr.approve == 2}">
                                            <span class="status-badge reject">반려</span>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>

                        <tbody id="search_result" style="display: none;">
                        </tbody>    
                    </table>
                </div>
            </div>
        </div>
    </body>
    <div id="rejectModal" class="modal-overlay">
    <div class="modal-content">
        <h3>반려 사유 입력</h3>
        <p>해당 휴가 신청을 반려하는 사유를 적어주세요.</p>
        
        <input type="hidden" id="modal_log_id">
        
        <textarea id="reject_reason" placeholder="반려 사유를 입력하세요... (최대 100자)"></textarea>
        
        <div class="modal-btn-group">
            <button type="button" class="btn-modal-cancel" onclick="closeRejectModal()">취소</button>
            <button type="button" class="btn-modal-submit" onclick="submitReject()">반려 확정</button>
        </div>
    </div>
</div>
</html>