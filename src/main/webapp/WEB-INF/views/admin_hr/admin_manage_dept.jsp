<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>

    <head>
        <title>[Linked : 부서 관리]</title>
        <link rel="stylesheet" href="/css/admin/sidebar.css">
        <link rel="stylesheet" href="/css/admin/modal.css"/>
        <link rel="stylesheet" href="/css/admin/main.css"/>
        <link rel="stylesheet" href="/css/admin/dept.css"/>

        <script>
            // 부서 추가 모달 열기
            function openModal() {
                const modal = document.getElementById("jobModal");
                const form = document.getElementById("modalForm");

                document.getElementById("modalTitle").innerText = "새 부서 등록";
                document.getElementById("submitBtn").value = "등록하기";
                
                form.dataset.mode = "insert"; 

                // 입력창 세팅 (부서번호는 회색배경/입력or변경불가능)
                document.getElementById("deptno").style.backgroundColor = "#E9ECEF";
                document.getElementById("deptno").readOnly = true;
                
                //10단위로 부서번호 자동 지정
                fetch("/admin/getDeptno")
                .then(res=>res.json())
                .then(data=>{
                    //가져온 지정된 부서번호를 deptno의 value로 주입
                    document.getElementById("deptno").value = data.result;
                })

                modal.style.display = "flex";
            }

            // 모달 닫기 (등록/수정 공통 사용)
            function closeModal() {
                const modal = document.getElementById("jobModal");
                modal.style.display = "none"; 

                // 모달 닫힐 때 폼 입력값 및 배경색 원상복구
                const form = document.getElementById("modalForm");
                form.reset(); 
                document.getElementById("deptno").style.backgroundColor = "#E9ECEF";
                document.getElementById("deptno").value = "";
            }

            //부서 정보 수정 모달 열기
            function openUpdModal(deptno, dname, dtel) {
                const modal = document.getElementById("jobModal");
                const form = document.getElementById("modalForm");
    
                // 1. 모달창 텍스트 및 서브밋 버튼 변경
                document.getElementById("modalTitle").innerText = "부서 정보 수정";
                document.getElementById("submitBtn").value = "수정하기";
                
                form.dataset.mode = "update"; //form 태그의 data 속성에 'update' 저장
                
                // 2. 넘겨받은 기존 데이터를 입력창에 채워넣기
                document.getElementById("deptno").value = deptno;
                document.getElementById("dname").value = dname;
                document.getElementById("dtel").value = dtel;

                // 부서번호 input타입을 readonly로 바꾸기
                document.getElementById("deptno").readOnly = true;
                
                document.getElementById("deptno").style.backgroundColor = "#E9ECEF";
                
                modal.style.display = "flex";
            } 

            function send(f){
                let deptno = f.deptno.value.trim();
                let dname = f.dname.value.trim();
                let dtel = f.dtel.value.trim();
                let mode = f.dataset.mode; //등록인지 수정인지 구별

                //유효성 체크
                if( deptno === '' ){
                    alert("부서 번호를 입력하세요.");
                    return;
                }

                if( dname === '' ){
                    alert("부서명을 입력하세요.");
                    return;
                }

                if( dtel === '' ){
                    alert("부서 전화번호를 입력하세요.")
                    return;
                }

                //button모드가 수정(update)일 때는 중복체크를 건너뜀
                if(mode === "update") {
                    let formData = new FormData(f);
                    formData.set("deptno", deptno); 
                    formData.set("dtel", dtel);

                    fetch("/admin/update_dept", { method: "POST", body: formData })
                    .then(res => res.json())
                    .then(data => {
                        if(data.result == 1) {
                            alert("부서 정보가 수정되었습니다.");
                            closeModal();
                            location.href = "/admin/deptlist";
                        } else {
                            alert("부서 정보 수정에 실패했습니다.");
                        }
                    })
                    .catch(err => {
                        console.error("수정 중 서버 에러 발생:", err);
                        alert("서버 통신 중 오류가 발생했습니다.");
                    });
                    return; // 수정 로직이 끝나면 아래 등록 로직이 실행 안 되도록 차단
                }

                //버튼이 등록일 때 동일한 부서명, 동일한 부서번호 체크
                if(mode === "insert") {
                    
                    fetch( "/admin/add_dept?deptno="+deptno+"&dname="+dname )
                    .then( res => res.json() )
                    .then( data => {
                        if( data.result == 'can' ){  //부서번호가 중복되지 않을 경우 if문 실행
                            
                            let formData = new FormData(f);
                            fetch( "/admin/add_dept", { method:"POST", body:formData } )
                            .then( res => res.json() )
                            .then( postData => {
                                if( postData.result == 1 ){
                                    alert("부서가 정상적으로 추가되었습니다.");
                                    closeModal();
                                    location.href="/admin/deptlist";
                                }
                            } );
                        } else { 
                            alert("이미 존재하는 부서번호 혹은 부서명입니다. 다시 작성해주세요.");
                        }
                    })
                    .catch(err => console.error("등록 중 에러:", err));
                }
            }

            function del(dname){

                if( !confirm("정말로 " +dname+"를 삭제하시겠습니까?") ){
                    return;
                }

                fetch( "/admin/delete_dept?dname="+dname )
                .then( res => res.json() )
                .then( data => {
                    if( data.result == 1 ){
                        alert(dname+"가 정상적으로 삭제 되었습니다.");
                        location.href="/admin/deptlist";
                    } else {
                        alert("부서 삭제 실패. 다시 시도해주세요");
                    }
                })
                .catch(err => console.error("삭제 중 에러:", err));
                    }
        </script>
    </head>

    <body>
        <div class="manager-container">
            <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
            <div class="main-content">

                <div class="page-header">
                    <h2 class="page-title">부서 관리</h2>
                </div>
                <div class="btn-group">
                    <input type="button" value="+ 부서 추가하기" onclick="openModal()"/> 
                </div>
                <div class="dashboard-grid">

                    <div class="table-card">
                        <table>
                            <tr>
                                <th>부서번호</th>
                                <th>부서명</th>
                                <th>tel</th>
                                <th>setting</th>
                            </tr>
                            <c:forEach var="dept" items="${deptlist}">
                                <tr>
                                    <td>${dept.deptno}</td>
                                    <td>${dept.dname}</td>
                                    <td>${dept.dtel}</td>
                                    <td>
                                        <c:if test="${dept.deptno ne 1}">
                                            <input type="button" value="수정"
                                                onclick="openUpdModal('${dept.deptno}','${dept.dname}', '${dept.dtel}')"/>
                                            <input type="button" value="삭제"
                                                onclick="del('${dept.dname}')"/>
                                        </c:if>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>

                    <div class="table-card">
                        <table>
                            <caption>부서별 인원 수</caption>
                            <c:forEach var="count" items="${memberCnt}">
                                <tr>
                                    <th>${count.deptName}</th>
                                    <td>
                                        <span class="count-badge">
                                            ${count.sawonCount}명
                                        </span>
                                    </td>
                                </tr>
                            </c:forEach>
                        </table>
                    </div>

                </div>

                <div class="summary-card">
                        <div class="summary-title">전체 부서 수</div>
                        <div class="summary-value">${deptcnt}</div>
                </div>

                <div class="summary-card">
                    <div class="summary-title">최근 충원 부서</div>
                    <c:if test="${ not empty cur_deptList }">
                        <c:forEach var="cur" items="${cur_deptList}">
                            <div class="summary-value">${cur.dname}</div>
                        </c:forEach>
                    </c:if>
                </div>
            </div>
        </div>

        <!-- 부서 모달창 -->
        <div id="jobModal" class="modal-overlay">
            <div class="modal-content-box">
                <div class="modal-header">
                    <h3 id="modalTitle">새 부서 등록</h3>
                    <span class="close-btn" onclick="closeModal()">&times;</span>
                </div>
                
                <form id="modalForm" method="post">
                    <div class="modal-body">
                        <div class="input-group">
                            <label for="deptno">부서번호</label>
                            <input type="text" id="deptno" name="deptno"  required>
                        </div>
                        <div class="input-group">
                            <label for="dname">부서명</label>
                            <input type="text" id="dname" name="dname" placeholder="예: oo부" required>
                        </div>
                        <div class="input-group">
                            <label for="dtel">부서 전화번호</label>
                            <input type="text" id="dtel" name="dtel" placeholder="예: xxx-xxx-xxxx" required>
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