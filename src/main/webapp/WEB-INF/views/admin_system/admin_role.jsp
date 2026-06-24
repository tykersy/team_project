<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <link rel="stylesheet" href="/css/admin/sidebar.css">
    <link rel="stylesheet" href="/css/admin/main.css">
    <link rel="stylesheet" href="/css/admin/admin_role.css">

    <title>권한 관리</title>
    <style>
        /* 모달 스타일 기본 배치 */
        .role-modal {
            display: none;
            position: fixed; z-index: 9999; left: 0; top: 0; width: 100%; height: 100%;
            background-color: rgba(15, 23, 42, 0.6); align-items: center; justify-content: center;
        }
        .role-modal-content {
            background-color: #ffffff; border-radius: 12px; width: 100%; max-width: 400px;
            padding: 24px; box-shadow: 0 10px 15px -3px rgba(0, 0, 0, 0.1); position: relative;
        }
        .select-leader-box {
            width: 100%; padding: 10px; border-radius: 6px; border: 1px solid #CBD5E1;
            margin-top: 12px; font-size: 14px; color: #334155;
        }
    </style>
</head>
<body>

    <div class="manager-container">
        <jsp:include page="/WEB-INF/views/admin_common/admin_sidebar.jsp"/> 
        
        <div class="main-content">
            <div class="page-title-section">
                <h2>시스템 권한 관리</h2>
                <p>부서별 팀장(관리자)을 임명하고 시스템 마스터 권한을 제어합니다.</p>
                <hr class="title-divider"/>
            </div>

            <div class="status-card-wrapper">
                <div class="status-card">
                    <span class="card-label">운영 부서 수</span>
                    <span class="card-value">5개 부서</span>
                </div>
                <div class="status-card">
                    <span class="card-label">마스터 최고 관리자</span>
                    <span class="card-value" style="color: #DC2626;">인사팀장</span>
                </div>
                <div class="status-card">
                    <span class="card-label">부서 책임 관리자</span>
                    <span class="card-value" style="color: #2563EB;">각 팀별 팀장</span>
                </div>
            </div>

            <div class="table-container">
                <table class="erp-table">
                    <thead>
                        <tr>
                            <th>부서 번호</th>
                            <th>부서명</th>
                            <th>현재 관리자(사번)</th>
                            <th>이름</th>
                            <th>부여 권한</th>
                            <th style="text-align: center;">액션</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="leader" items="${leaderList}">
                            <tr>
                                <td><strong>${leader.deptno}</strong></td>
                                <td style="font-weight: 600; color: #0F172A;">${leader.dname}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${leader.sabun != 0}">
                                            <span>${leader.sabun}</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="text-muted">미지정</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>${leader.saname != null ? leader.saname : '-'}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${leader.deptno eq 10}">
                                            <span class="badge badge-admin">👑 마스터 관리자</span>
                                        </c:when>
                                        <c:otherwise>
                                            <c:choose>
                                                <c:when test="${leader.sabun != 0}">
                                                    <span class="badge badge-manager">👤 부서 관리자</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span class="badge badge-none">일반 사원</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td style="text-align: center;">
                                    <button type="button" class="btn-salary-secondary" 
                                            onclick="openRoleModal('${leader.deptno}', '${leader.dname}', '${leader.sabun}')">
                                        관리자 변경
                                    </button>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </div>

    <div id="roleModal" class="role-modal">
        <div class="role-modal-content">
            <h3 id="modalDeptName">부서 관리자 임명</h3>
            <p>새로운 팀장을 지정하면 기존 권한은 자동으로 회수됩니다.</p>
            
            <input type="hidden" id="modalDeptNo">
            
            <select id="selectSabun" class="select-leader-box">
                <option value="">-- 관리자 미지정(권한 회수) --</option>
                <option value="2026001">홍길동 (2026001)</option>
                
            </select>
            
            <div class="modal-btn-group" style="margin-top: 24px; display: flex; justify-content: flex-end; gap: 8px;">
                <button type="button" class="modal-btn btn-close" onclick="closeRoleModal()">취소</button>
                <button type="button" class="modal-btn btn-save" onclick="submitRoleChange()">변경 저장</button>
            </div>
        </div>
    </div>
    <script>
    function openRoleModal(deptno, dname, currentSabun) {
        document.getElementById('modalDeptNo').value = deptno;
        document.getElementById('modalDeptName').innerText = dname + " 관리자 임명";
        document.getElementById('selectSabun').value = currentSabun || "";
        document.getElementById('roleModal').style.display = 'flex';

        //선택된 부서 사원 목록 가져오기
        // fetch( "/admin_read_dept_sawon?deptno="+deptno )
        // .then( res => res.json() )
        // .then( data => {

        // } )
    }

    function closeRoleModal() {
        document.getElementById('roleModal').style.display = 'none';
    }

    function submitRoleChange() {
        const deptno = document.getElementById('modalDeptNo').value;
        const sabun = document.getElementById('selectSabun').value;
        
        fetch('/admin_reposition_leader', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ deptno: deptno, sabun: sabun })
        })
        .then(res => res.json())
        .then(data => {
            if(data.result == 2) {
                alert("관리자 권한 변경이 완료되었습니다.");
                location.reload();
            } else {
                alert("실패: 변경 중 오류가 발생했습니다");
            }
        })
    }
    </script>
</body>
</html>