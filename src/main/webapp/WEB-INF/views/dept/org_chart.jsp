<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>[Linked : 조직도]</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/Sidebar.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/user/org_chart.css">
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

    <script>
        window.onload = function() {
            fetch('${pageContext.request.contextPath}/api/orgList')
                .then(response => response.json())
                .then(data => {
                    var chart = new OrgChart(document.getElementById("tree"), {
                        nodes: data,
                        nodeBinding: {
                            field_0: "name",
                            field_1: "title"
                        },
                        template: "isla", 
                        
                        enableZoom : true, 
                        
                        // 스크롤과 확대/축소 동작 제어
                        mouseScrool: OrgChart.action.zoom 
                    });

                    // 화면에 강제로 핏팅
                    chart.fit();
                })
                .catch(error => console.error("데이터 로드 에러:", error));
        };
    </script>
</body>
</html>