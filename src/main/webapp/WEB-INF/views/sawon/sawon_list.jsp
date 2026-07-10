<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>[Linked : 직원 관리]</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sawon_list.css"/>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/sidebar.css" />

    <script>
        // 사원 퇴사 처리
        function del(sabun, saname){
            if( !confirm(saname+"님을 퇴사처리 하시겠습니까?") ){
                return;
            }

            fetch( "/admin/sawon_delete?sabun="+sabun )
            .then( res => res.json() )
            .then( data => {
                if( data.result == 1 ){
                    alert( "정상적으로 삭제되었습니다" );
                    location.href="/admin/sawon_list";
                    return;
                }
                alert( "삭제가 정상적으로 이루어지지 않았습니다. 다시 시도하세요" );
            });
        }

        //부서별 사원 리스트 출력
        function deptFilter(deptno, dname){

            fetch("/admin/dept_sawon_list?deptno="+deptno, {method:'POST' })
            .then(res=>res.json())
            .then(data=>{
                let resStr = "";
                if( data.deptSawonList !== null || data.deptSawonList !== ""){
                    data.deptSawonList.forEach( function(vo) {
                        resStr += '<tr>';
                        resStr += '<td>'+vo.sabun+'</td>';
                        resStr += '<td>';

                        if( vo.sabun !== '1' ){
                            resStr += '<a href="javascript:void(0);" onclick="openSawonViewModal('+vo.sabun+')" >'+vo.saname+'</a>';
                        }else{
                            resStr += vo.saname;
                        }

                        resStr += '</td>';
                        resStr += '<td>'+vo.deptno+'</td>';
                        resStr += '<td>'+vo.sajob+'</td>';
                        resStr += '<td>'+vo.sahire+'</td>';
                        resStr += '<td>';

                        if( vo.sabun !== '1' ){
                            resStr += '<input type="button" value="수정" onclick="location.href='+"'"+'/admin/sawon_modify?sabun='+vo.sabun+"'"+'"/>';
                            resStr += '<input type="button" value="퇴사" onclick="del('+vo.sabun+', '+vo.saname+')"/>';
                        }
                        resStr += '</td>'
                    })
                            
                }

                document.getElementById("list-box").style.display="none";
                document.getElementById("deptSawonList-box").innerHTML = resStr;
                document.getElementById("deptSawonList-box").style.display="";
            })
        }

        // fetch로 사원 상세보기 모달 열기
        function openSawonViewModal(sabun){
            fetch("/admin/sawon_view?sabun="+sabun)
            .then(res => res.json())
            .then(data => {
                console.log("컨트롤러에서 넘어온 Map 데이터:", data);

                // 안전하게 변수 처리 (Null 방어)
                const sawon = data.sawon ? data.sawon : {};
                const vo = data.vo ? data.vo : {};

                // 비동기로 받아온 정보들을 모달 창에 입력
                document.getElementById("modalSabun").innerHTML = sawon.sabun !== undefined ? sawon.sabun : "-";
                document.getElementById("modalSaname").innerHTML = sawon.saname !== undefined ? sawon.saname : "-";
                document.getElementById("modalSahire").innerHTML = sawon.sahire !== undefined ? sawon.sahire : "-";
                document.getElementById("modalAnnual").innerHTML = vo.annual !== undefined ? vo.annual + " 일" : "0 일";
                document.getElementById("modalEtc").innerHTML = vo.etc !== undefined ? vo.etc + " 일" : "0 일";
                document.getElementById("modalMc").innerHTML = vo.mc !== undefined ? vo.mc + " 일" : "0 일";
                document.getElementById("modalHealth").innerHTML = vo.health !== undefined ? vo.health + " 일" : "0 일";

                // 모든 데이터가 바인딩된 후 확실하게 모달 표시
                document.getElementById("sawonDetailModal").style.display = "flex";
            })
            .catch(err => {
                console.error("모달 데이터 매핑 에러:", err);
            });
        }
        
        // 모달 닫기
        function closeSawonViewModal(){
            // ✅ 기존 "0" 오타를 "none"으로 확실하게 수정했습니다.
            document.getElementById("sawonDetailModal").style.display = "none";
            
            // 모달창 내용 초기화
            document.getElementById("modalSabun").innerHTML = "-";
            document.getElementById("modalSaname").innerHTML = "-";
            document.getElementById("modalSahire").innerHTML = "-";
            document.getElementById("modalAnnual").innerHTML = "-";
            document.getElementById("modalEtc").innerHTML = "-";
            document.getElementById("modalMc").innerHTML = "-";
            document.getElementById("modalHealth").innerHTML = "-";
        }
    </script>
</head>

<body>
    <div class="manager-container">
        <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/>
        <div class="container">
            <h2>직원 관리 페이지</h2>

            <div class="btn-group">
                <div class="dept-button">
                    <c:forEach var="dept" items="${deptList}">
                        <input type="button" value="${dept.dname}" onclick="deptFilter('${dept.deptno}', '${dept.dname}')"/>
                    </c:forEach>
                </div>
                <input type="button" value="PDF다운로드" onclick="location.href='/admin/sawon_download_pdf'"/>
                <input type="button" value="+사원 추가하기" onclick="location.href='/admin/sawon_add'"/>
            </div>

            <table border="1">
                <colgroup>
                        <col style="width: 10%;">
                        <col style="width: 20%;">
                        <col style="width: 15%;">
                        <col style="width: 15%;">
                        <col style="width: 20%;">
                        <col style="width: 20%;">
                    </colgroup>
                <thead>
                    <tr>
                        <th>사원번호</th>
                        <th>사원명</th>
                        <th>부서번호</th>
                        <th>직급</th>
                        <th>입사일</th>
                        <th>비고</th>
                    </tr>
                </thead>

                <tbody id="list-box" style="display: '';">
                    <c:forEach var="vo" items="${list}">
                        <tr>
                            <td>${vo.sabun}</td>
                            <td>
                                <c:if test="${ vo.sabun ne '1' }">
                                    <a href="javascript:void(0);" onclick="openSawonViewModal('${vo.sabun}')" >
                                        ${vo.saname}
                                    </a>
                                </c:if>
                                <c:if test="${ vo.sabun eq '1'}">
                                    <span class="admin-text">${vo.saname}</span>
                                </c:if>
                            </td>
                            <td>${vo.deptno}</td>
                            <td>${vo.sajob}</td>
                            <td>${vo.sahire}</td>
                            <td>
                                <c:if test="${vo.sabun ne 1}">
                                    <input type="button" value="수정" onclick="location.href='/admin/sawon_modify?sabun=${vo.sabun}'"/>
                                    <input type="button" value="퇴사" onclick="del('${vo.sabun}', '${vo.saname}')"/>
                                </c:if>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
                <tbody id="deptSawonList-box" style="display: none;">

                </tbody>
            </table>
        </div>
    </div>

    <div id="sawonDetailModal" class="modal-overlay" onclick="if(event.target == this) closeSawonViewModal();">
        <div class="modal-content">
            <div class="modal-header">
                <h3>사원 정보 상세보기</h3>
                <button type="button" class="modal-close-btn" onclick="closeSawonViewModal()">&times;</button>
            </div>
            
            <table class="modal-table">
                <tr>
                    <th>사번</th>
                    <td id="modalSabun">-</td>
                </tr>    
                <tr>   
                    <th>사원명</th>
                    <td id="modalSaname">-</td>
                </tr> 
                <tr>
                    <th>입사일</th>
                    <td id="modalSahire">-</td>
                </tr>
                <tr>
                    <th>잔여연차</th>
                    <td><span id="modalAnnual" class="leave-badge badge-annual">-</span></td>
                </tr>
                <tr>
                    <th>기타휴가</th>
                    <td><span id="modalEtc" class="leave-badge badge-unpaid">-</span></td>
                </tr>
                <tr>
                    <th>병가</th>
                    <td><span id="modalMc" class="leave-badge badge-mc">-</span></td>
                </tr>
                <tr>
                    <th>Health</th>
                    <td><span id="modalHealth" class="leave-badge badge-health">-</span></td>
                </tr>
            </table>
            
            <div class="modal-footer">
                <button type="button" class="btn-close-confirm" onclick="closeSawonViewModal()">확인</button>
            </div>
        </div>
    </div>
</body>
</html>