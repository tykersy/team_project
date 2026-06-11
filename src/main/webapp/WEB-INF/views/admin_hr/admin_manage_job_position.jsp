<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/modal.css"/>

<style>
    /* 기본 초기화 및 폰트 설정 */
    body {
        margin: 0;
        padding: 0;
        font-family: 'Pretendard', -apple-system, BlinkMacSystemFont, system-ui, Roboto, sans-serif;
        background-color: #f3f4f6;
        color: #1f2937;
    }

    /* ─── 레이아웃 구조 ─── */
    .manager-container {
        display: flex;       
        min-height: 100vh;
        width: 100%;
    }

    .main-content {
        flex: 1;             
        padding: 40px 45px;  /* 여백 적정 수준으로 조정 */
        box-sizing: border-box;
        max-width: 1400px;   /* [조정] 과하지 않게 딱 좋은 대시보드 표준 너비 */
        margin: 0;           
    }

    /* ─── 페이지 헤더 ─── */
    .page-header {
        display: flex;
        justify-content: space-between; /* 타이틀은 왼쪽, 버튼은 오른쪽 끝 */
        align-items: center;            /* 세로 중앙 정렬 */
        margin-bottom: 32px; 
        border-bottom: 2px solid #e5e7eb;
        padding-bottom: 16px;
    }

    /* ─── 상단 추가 버튼 스타일 ─── */
    .page-header .btn-group input[type="button"] {
        padding: 10px 18px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s;
        
        /* 테마 포인트 컬러 적용 (#111827) */
        background-color: #111827; 
        color: #ffffff;
        border: 1px solid #111827;
    }

    .page-header .btn-group input[type="button"]:hover {
        background-color: #1f2937;
        border-color: #1f2937;
    }

    .page-title {
        font-size: 28px;    /* [조정] 너무 크지 않게 조절 (32px -> 28px) */
        font-weight: 700;
        color: #111827; 
        margin: 0;
    }

    /* ─── 대시보드 그리드 (테이블 배치) ─── */
    .dashboard-grid {
        display: grid;
        grid-template-columns: 2.2fr 1fr; 
        gap: 24px;          /* 간격 최적화 */
        margin-bottom: 24px;
    }

    /* ─── 카드 공통 스타일 ─── */
    .table-card, .summary-card {
        background: #ffffff; 
        border-radius: 14px; 
        box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.05), 0 2px 4px -1px rgba(0, 0, 0, 0.03);
        padding: 28px;       /* [조정] 박스 볼륨감 적정화 (36px -> 28px) */
        box-sizing: border-box;
        border: 1px solid #e5e7eb;
    }

    /* ─── 테이블(Table) 디자인 ─── */
    table {
        width: 100%;
        border-collapse: collapse; 
        text-align: left;
    }

    caption {
        font-size: 20px;    /* [조정] (22px -> 20px) */
        font-weight: 600;
        color: #111827; 
        text-align: left;
        margin-bottom: 20px;
    }

    th, td {
        padding: 16px 20px; /* [조정] 위아래 줄간격을 딱 보기 좋은 황금비율로 조정 */
        font-size: 15px;    /* [조정] 본문 글씨 크기 최적화 (16px -> 15px) */
    }

    th {
        background-color: #f9fafb; 
        color: #4b5563;
        font-weight: 600;
    }

    tr:hover {
        background-color: #f9fafb; 
    }

    /* ─── 테이블 내 버튼(수정/삭제) 스타일 ─── */
    input[type="button"] {
        padding: 7px 14px;  
        border-radius: 7px;
        font-size: 13px;    
        font-weight: 500;
        cursor: pointer;
        border: 1px solid transparent;
        transition: all 0.2s;
        margin-right: 4px;
    }

    /* 수정 버튼 */
    input[type="button"][value="수정"] {
        background-color: #f3f4f6;
        color: #111827; 
        border: 1px solid #e5e7eb;
    }
    input[type="button"][value="수정"]:hover {
        background-color: #111827; 
        color: #ffffff;
        border-color: #111827;
    }

    /* 삭제 버튼 */
    input[type="button"][value="삭제"] {
        background-color: #fef2f2;
        color: #ef4444;
    }
    input[type="button"][value="삭제"]:hover {
        background-color: #ef4444;
        color: #ffffff;
    }

    /* ─── 부서별 인원수 배지 ─── */
    .count-badge {
        background-color: #111827; 
        color: #ffffff;
        padding: 5px 12px;  
        border-radius: 20px;
        font-size: 13px;    
        font-weight: 500;
        display: inline-block;
    }

    /* ─── 하단 요약 카드 (Summary Card) ─── */
    .summary-card {
        display: inline-block;
        min-width: 240px;   /* [조정] 하단 카드 크기 최적화 */
        margin-right: 20px;
        vertical-align: top;
    }

    .summary-title {
        font-size: 15px;    
        color: #6b7280;
        font-weight: 500;
        margin-bottom: 10px;
    }

    .summary-value {
        font-size: 32px;    /* [조정] 대형 숫자 크기 최적화 (36px -> 32px) */
        font-weight: 700;
        color: #111827; 
    }
</style>

        <script>
            // 직급 추가 모달 열기
            function openModal() {
                const modal = document.getElementById("jobModal");
                const form = document.getElementById("modalForm");

                document.getElementById("modalTitle").innerText = "새 직급 등록";
                document.getElementById("submitBtn").value = "등록하기";
                
                form.dataset.mode = "insert"; 

                // 입력창 상태 초기화 (배경색 흰색)
                document.getElementById("job_id").style.backgroundColor = "#ffffff";

                modal.style.display = "flex";
            }

            // 모달 닫기 (등록/수정 공통 사용)
            function closeModal() {
                const modal = document.getElementById("jobModal");
                modal.style.display = "none"; 

                // 모달 닫힐 때 폼 입력값 및 배경색 원상복구
                const form = document.getElementById("modalForm");
                form.reset(); 
                document.getElementById("job_id").style.backgroundColor = "#ffffff";
            }

            //직급 정보 수정 모달 열기
            function openUpdModal(job_id, sajob) {
                const modal = document.getElementById("jobModal");
                const form = document.getElementById("modalForm");
    
                // 1. 모달창 텍스트 및 서브밋 버튼 변경
                document.getElementById("modalTitle").innerText = "직급 정보 수정";
                document.getElementById("submitBtn").value = "수정하기";
                
                form.dataset.mode = "update"; //form 태그의 data 속성에 'update' 저장
                
                // 2. 넘겨받은 기존 데이터를 입력창에 채워넣기
                document.getElementById("job_id").value = job_id;
                document.getElementById("sajob").value = sajob;

                // ++.기존 job_id를 form태그 안에 넣기
                form.ori_job_id.value = job_id;
                
                document.getElementById("job_id").style.backgroundColor = "#ffffff";
                
                modal.style.display = "flex";
            } 
            
           
            function send(f){
                let job_id = f.job_id.value.trim();
                let ori_job_id = f.ori_job_id.value.trim();
                let sajob = f.sajob.value.trim();
                let mode = f.dataset.mode; //등록인지 수정인지 구별

                //유효성 체크
                if( job_id === '' ){
                    alert("직급 ID를 입력하세요.");
                    return;
                }

                if( sajob === '' ){
                    alert("직급명을 입력하세요.");
                    return;
                }

                //button모드가 수정(update)일 때는 중복체크를 건너뜀
                if(mode === "update") {
                    let formData = new FormData(f);
                    formData.set("ori_job_id", ori_job_id); 
                    formData.set("job_id", job_id); // 사용자가 새로 바꾼 job_id가 있다면 담아서 전송

                    fetch("/admin_update_job_position", { method: "POST", body: formData })
                    .then(res => res.json())
                    .then(data => {
                        if(data.result == 1) {
                            alert("직급 정보가 수정되었습니다.");
                            closeModal();
                            location.href = "/admin_job_position";
                        } else {
                            alert("수정에 실패했습니다.");
                        }
                    })
                    .catch(err => {
                        console.error("수정 중 서버 에러 발생:", err);
                        alert("서버 통신 중 오류가 발생했습니다.");
                    });
                    return; // 수정 로직이 끝나면 아래 등록 로직이 실행 안 되도록 반드시 차단
                }

                //버튼이 등록일 때 동일한 직급명, 동일한 id체크
                if(mode === "insert") {
                    
                    fetch( "/admin_add_job_position?job_id="+job_id+"&sajob="+sajob )
                    .then( res => res.json() )
                    .then( data => {
                        if( data.result == null ){ 
                            let formData = new FormData(f);
                            fetch( "/admin_add_job_position", { method:"POST", body:formData } )
                            .then( res => res.json() )
                            .then( postData => {
                                if( postData.result == 1 ){
                                    alert("직급이 정상적으로 추가되었습니다.");
                                    closeModal();
                                    location.href="/admin_job_position";
                                }
                            } );
                        } else { 
                            alert("이미 존재하는 직급ID 혹은 직급명입니다. 다시 작성해주세요.");
                        }
                    })
                    .catch(err => console.error("등록 중 에러:", err));
                }
            }

            //직급 삭제 함수
            function del(job_id, sajob){

                if( !confirm("정말로 "+ sajob + "직급을 삭제하시겠습니까?") ){
                    return;
                }

                location.href="/admin_del_job_position?job_id="+job_id+
                    "&sajob="+sajob;

            }
        </script>
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            <div class="main-content">

                <div class="page-header">
                    <h2 class="page-title">직급 관리</h2>
                    <div class="btn-group">
                        <input type="button" value="+ 직급 추가하기" onclick="openModal()"/> </div>
                </div>

                <div class="dashboard-grid">

                    <div class="table-card">
                        <table>
                            <tr>
                                <th>직급ID</th>
                                <th>직급</th>
                                <th>setting</th>
                            </tr>
                            <c:forEach var="job" items="${jobList}">
                                <tr>
                                    <td>${job.job_id}</td>
                                    <td>${job.sajob}</td>
                                    <td>
                                        <input type="button" value="수정"
                                            onclick="openUpdModal('${job.job_id}', '${job.sajob}')"/>
                                        <input type="button" value="삭제"
                                            onclick="del('${job.job_id}', '${job.sajob}')"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>

                    <div class="table-card">
                        <table>
                            <caption>직급별 인원 수</caption>
                            <c:forEach var="position" items="${positionCnt}">
                                <tr>
                                    <th>${position.sajob}</th>
                                    <td>
                                        <span class="count-badge">
                                            ${position.cnt}명
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>

                </div>

                <div class="summary-card">
                        <div class="summary-title">전체 직급 수</div>
                        <div class="summary-value">${jobCnt}</div>
                </div>

                <div class="summary-card">
                    <div class="summary-title">최근 충원 직급</div>
                    <c:if test="${ not empty cur_job }">
                        <c:forEach var="cur" items="${cur_job}">
                            <div class="summary-value">${cur.sajob}</div>
                        </c:forEach>
                    </c:if>
                    
                </div>

            </div>
        </div>

        <!-- 직급 모달창 -->
        <div id="jobModal" class="modal-overlay">
            <div class="modal-content-box">
                <div class="modal-header">
                    <h3 id="modalTitle">새 직급 등록</h3>
                    <span class="close-btn" onclick="closeModal()">&times;</span>
                </div>
                
                <form id="modalForm" method="post">
                    <input name="ori_job_id" type="hidden"/>
                    <div class="modal-body">
                        <div class="input-group">
                            <label for="job_id">직급 ID</label>
                            <input type="text" id="job_id" name="job_id" placeholder="예: 09" required>
                        </div>
                        <div class="input-group">
                            <label for="sajob">직급명</label>
                            <input type="text" id="sajob" name="sajob" placeholder="예: 부장" required>
                        </div>
                    </div>
                    <div class="modal-footer">
                        <input type="button" class="btn-cancel" value="취소" onclick="closeModal()"/>
                        <input type="button" id="submitBtn" class="btn-submit"value="등록하기"
                                onclick="send(this.form)"/>
                    </div>
                </form>
            </div>
        </div>

    </body>
    
</html>