<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>조직도</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <script src="https://balkan.app/js/OrgChart.js"></script>
    
    <style>
        html, body { margin: 0; padding: 0; width: 100%; height: 100%; background-color: #f8fafc; overflow: hidden; }
        .main-container { display: flex; width: 100%; height: 100%; }
        .content-area { flex: 1; display: flex; flex-direction: column; height: 100%; overflow: hidden; position: relative; }
        
        /* 헤더 스타일 정리 */
        .content-area > .header { display: flex !important; justify-content: space-between !important; align-items: center !important; height: 70px !important; padding: 0 40px !important; z-index: 10 !important; background-color: #ffffff !important; }
        .content-area > .header .header-right { display: flex !important; align-items: center !important; gap: 16px !important; margin-left: auto !important; }
        
        /* 조직도 영역 */
        #tree-wrapper { flex: 1; width: 100%; height: 100%; position: relative !important; overflow: visible !important; }
        #tree { width: 100% !important; height: 100% !important; position: relative !important; }

        /* 검색창과 메뉴 버튼 위치 (상단 중앙/우측 배치) */
        #tree .boc-search { top: 24px !important; left: 50% !important; transform: translateX(-50%) !important; z-index: 99 !important; }
        #tree .boc-menu { top: 24px !important; right: 24px !important; left: auto !important; z-index: 99 !important; }
        
        /* 버튼 스타일 */
        .boc-img-button { background-color: #ffffff !important; border: 1px solid #e2e8f0 !important; border-radius: 6px !important; }
    </style>
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
                    var ceoNode = chartData.find(n => n.id === "COMPANY");
                    if (ceoNode) { ceoNode.name = sName; ceoNode.title = "CEO (대표이사)"; }
                }
            }
        </c:forEach>

        var chart = new OrgChart(document.getElementById("tree"), {
            template: "isla",
            showSearch: true,
            menu: { pdf: { text: "PDF 저장" }, png: { text: "PNG 저장" } },
            nodes: chartData,
            nodeBinding: { field_0: "name", field_1: "title" }
        });
    </script>
</body>
</html>