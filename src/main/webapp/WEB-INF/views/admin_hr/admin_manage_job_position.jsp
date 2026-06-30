<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/main.css">
        <link rel="stylesheet" href="/css/admin/modal.css"/>
        <link rel="stylesheet" href="/css/admin/job_position.css"/>

        <script>
            // 직급 추가 모달 열기
            function openModal() {
                const modal = document.getElementById("jobModal");
                const form = document.getElementById("modalForm");

                document.getElementById("modalTitle").innerText = "새 직급 등록";
                document.getElementById("submitBtn").value = "등록하기";
                
                form.dataset.mode = "insert"; 

                // 입력창 상태 초기화 (배경색 흰색)
                document.getElementById("job_id").style.backgroundColor = "#EEEEEE";

                modal.style.display = "flex";
            }

            // 모달 닫기 (등록/수정 공통 사용)
            function closeModal() {
                const modal = document.getElementById("jobModal");
                modal.style.display = "none"; 

                // 모달 닫힐 때 폼 입력값 및 배경색 원상복구
                const form = document.getElementById("modalForm");
                form.reset(); 
                document.getElementById("job_id").style.backgroundColor = "#EEEEEE";
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
                
                document.getElementById("job_id").style.backgroundColor = "#EEEEEE";
                
                modal.style.display = "flex";
            } 
            
           
            function send(f){
                let job_id = f.job_id.value.trim();
                let sajob = f.sajob.value.trim();
                let mode = f.dataset.mode; //등록인지 수정인지 구별

                //유효성 체크

                if( sajob === '' ){
                    alert("직급명을 입력하세요.");
                    return;
                }

                //button모드가 수정(update)일 때
                if(mode === "update") {
                    let formData = new FormData(f); 
                    formData.set("job_id", job_id);
                    formData.set("sajob", sajob);

                    //직급명 유효성 체크(null이면 사용가능, null이 아니면 불가능)
                    fetch( "/admin/update_job_position?job_id="+job_id+"&sajob="+sajob )
                    .then(res => res.json())
                    .then(data => {

                        if( data.result != null ){
                            alert("이미 존재하는 직급입니다.")
                            return;
                        }

                        //직급 정보 수정 로직
                        fetch("/admin/update_job_position", { method: "POST", body: formData })
                        .then(res => res.json())
                        .then(data => {
                            if(data.result.sajob != sajob) {
                                alert("직급 정보가 수정되었습니다.");
                                closeModal();
                                location.href = "/admin/job_position";
                            } else {
                                alert("수정에 실패했습니다.");
                            }
                        })
                        .catch(err => {
                            console.error("수정 중 서버 에러 발생:", err);
                            alert("서버 통신 중 오류가 발생했습니다.");
                        });
                        return; // 수정 로직이 끝나면 아래 등록 로직이 실행 안 되도록 반드시 차단

                    })   
                }

                //버튼이 등록일 때 동일한 직급명 체크
                if(mode === "insert") {
                    
                    //직급명 중복확인
                    fetch( "/admin/add_job_position?sajob="+sajob )
                    .then( res => res.json() )
                    .then( data => {
                        if( data.result == null ){ 
                            //result가 null이면 새로 추가 가능한 직급(추가 로직 실행)
                            let formData = new FormData(f);

                            fetch( "/admin/add_job_position", { method:"POST", body:formData } )
                            .then( res => res.json() )
                            .then( postData => {
                                if( postData.result == 1 ){
                                    alert("직급이 정상적으로 추가되었습니다.");
                                    closeModal();
                                    location.href="/admin/job_position";
                                }
                            } );
                        } else { 
                            alert("이미 사용중인 직급명입니다. 다시 작성해주세요.");
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

                location.href="/admin/del_job_position?job_id="+job_id+
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
                </div>

                <div class="btn-group">
                    <input type="button" value="+ 직급 추가하기" onclick="openModal()"/> </div>
                
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
                            <input type="text" id="job_id" name="job_id" readonly="readonly">
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