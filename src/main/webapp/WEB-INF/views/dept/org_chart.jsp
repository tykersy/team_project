<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>조직도</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/orgChart.css">
    
    <script src="https://balkan.app/js/OrgChart.js"></script>
</head>
<body>

    <div class="main-container">
        <%@ include file="../common/sidebar.jsp" %>
        <div class="content-area">
            <%@ include file="../common/header.jsp" %>
            <div id="tree-wrapper">
                <div id="tree"></div>
            </div>
        </div>
    </div>

    <div id="dawnOfficeModal" class="custom-modal-overlay" onclick="closeCustomModal()">
        <div class="custom-modal-box" onclick="event.stopPropagation();">
            <span class="custom-modal-close" onclick="closeCustomModal()">&times;</span>
            
            <div class="modal-profile-header">
                <div class="modal-profile-img">👤</div>
                <div class="modal-name" id="modalViewName">이름</div>
                <div class="modal-title" id="modalViewTitle">직함</div>
            </div>
            
            <div class="modal-profile-body">
                <div class="attendance-card">
                    <div class="attendance-date" id="modalViewDate">2026-06-10</div>
                    <div class="attendance-status">
                        <span class="status-dot"></span> 출근 &nbsp;<span style="color: #22c55e;">08:42</span>
                    </div>
                </div>
            </div>

            <div class="modal-footer-btns">
                <button class="modal-btn" onclick="sendMail()">✉️ 메일 쓰기</button>
                <button class="modal-btn" onclick="viewSchedule()">📅 일정 보기</button>
            </div>
        </div>
    </div>

    <script>
        var chartData = [{ id: "COMPANY", name: "우리 회사", title: "본부" }];
        var addedDepts = [];

        <c:forEach var="item" items="${orgList}">
            var dNo = "${item.deptNo}".trim();
            var dName = "${item.deptName}".trim();
            var sNo = "${item.sabun}".trim();
            var sName = "${item.saname}".trim();
            var sJob = "${item.sajob}".trim();

            if (dNo) {
                var deptId = "DEPT_" + dNo;
                if (!addedDepts.includes(deptId)) {
                    chartData.push({ id: deptId, pid: "COMPANY", name: dName, title: "부서" });
                    addedDepts.push(deptId);
                }
                if (sNo && sJob.toLowerCase() !== "ceo") {
                    chartData.push({ id: "SAWON_" + sNo, pid: deptId, name: sName, title: sJob });
                } else if (sJob.toLowerCase() === "ceo") {
                    var ceoNode = chartData.find(function(n) { return n.id === "COMPANY"; });
                    if (ceoNode) { ceoNode.name = sName; ceoNode.title = "CEO (대표이사)"; }
                }
            }
        </c:forEach>

        var chart = new OrgChart(document.getElementById("tree"), {
            template: "isla",
            showSearch: true,
            menu: { pdf: { text: "PDF 저장" }, png: { text: "PNG 저장" } },
            nodes: chartData,
            nodeBinding: { 
                field_0: "name", 
                field_1: "title" 
            },
            editUI: null, // 기본 팝업 차단 유지
            
            onRenderNode: function(sender, args) {
                if (args.element.querySelector('.node-inline-edit-btn')) return;

                var editBtn = document.createElement('div');
                editBtn.className = 'node-inline-edit-btn';
                editBtn.innerHTML = '✏️';
                editBtn.title = '수정';
                
                editBtn.addEventListener('click', function(e) {
                    openEditModal(args.node.id, e);
                });

                args.element.appendChild(editBtn);
            }
        });

        // 차트 생성 후 안전하게 클릭 이벤트 리스너 등록
        chart.on('nodeClick', function(sender, args) {
            console.log("노드가 클릭됨(안전모드), ID:", args.node.id);
            openCustomModal(args.node.id);
            return false; // 기본 동작 방지
        });

        function openCustomModal(nodeId) {
            console.log("모달창 오픈 시도, ID:", nodeId);
            var node = chart.getNode(nodeId);
            if (!node || node.id === "COMPANY") return;

            document.getElementById('modalViewName').innerText = node.data.name || '이름 없음';
            document.getElementById('modalViewTitle').innerText = node.data.title || '직함 없음';
            
            var today = new Date().toISOString().substring(0, 10);
            document.getElementById('modalViewDate').innerText = today;

            document.getElementById('dawnOfficeModal').style.display = 'flex';
        }

        function closeCustomModal() {
            document.getElementById('dawnOfficeModal').style.display = 'none';
        }

        function openEditModal(nodeId, event) {
            if (event) event.stopPropagation();
            alert(nodeId + " 정보 수정을 위한 모달창을 오픈합니다.");
        }

        function sendMail() { 
            alert("메일 쓰기 기능 연결"); 
        }
        function viewSchedule() { 
            alert("일정 보기 기능 연결"); 
        }
    </script>
</body>
</html>