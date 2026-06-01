<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>조직도</title>
    <script src="https://balkan.app/js/OrgChart.js"></script>
    <style>
        html, body {
            margin: 0;
            padding: 0;
            width: 100%;
            height: 100%;
            background-color: #f8fafc; /* 대시보드 배경색과 통일 */
            overflow: hidden;
        }
        #tree {
            width: 100%;
            height: 100%;
            padding: 20px;
            box-sizing: border-box;
        }
        
        /* 내보내기 툴바 버튼 스타일 깔끔하게 정돈 */
        .boc-img-button {
            background-color: #ffffff !important;
            border: 1px solid #e2e8f0 !important;
            border-radius: 6px !important;
        }
    </style>
</head>
<body>

    <div id="tree"></div>

    <script>
        try {
            var chartData = [];
            
            // 최상위 회사 노드 배치 (기본값)
            chartData.push({ id: "COMPANY", name: "우리 회사", title: "본부" });

            // 부서 중복 생성 방지용 바구니
            var addedDepts = [];

            // DB에서 넘어온 데이터를 안전하게 순회
            <c:forEach var="item" items="${orgList}">
                (function() {
                    var dNo = "${item.deptNo}";
                    var dName = "${item.deptName}";
                    var sNo = "${item.sabun}";
                    var sName = "${item.saname}";
                    var sJob = "${item.sajob}";

                    if (dNo && dNo.trim() !== "") {
                        var deptId = "DEPT_" + dNo.trim();
                        
                        // 부서 노드 추가
                        if (!addedDepts.includes(deptId)) {
                            chartData.push({
                                id: deptId,
                                pid: "COMPANY",
                                name: dName ? dName.trim() : "미지정 부서",
                                title: "부서"
                            });
                            addedDepts.push(deptId);
                        }

                        // 사원 노드 추가 (사장 제외한 임직원)
                        if (sNo && sNo.trim() !== "" && sJob && sJob.trim().toLowerCase() !== "ceo") {
                            chartData.push({
                                id: "SAWON_" + sNo.trim(),
                                pid: deptId,
                                name: sName ? sName.trim() : "이름 없음",
                                title: sJob.trim()
                            });
                        }

                        // 사장(CEO)인 경우 최상위 노드 교체
                        if (sJob && sJob.trim().toLowerCase() === "ceo" && sName) {
                            var companyNode = chartData.find(function(node) { return node.id === "COMPANY"; });
                            if (companyNode) {
                                companyNode.name = sName.trim();
                                companyNode.title = "CEO (대표이사)";
                            }
                        }
                    }
                })();
            </c:forEach>

            // 확실하게 검증된 테마와 안정적인 옵션으로 렌더링
            if (chartData.length > 0) {
                var chart = new OrgChart(document.getElementById("tree"), {
                    template: "isla",
                    menu: {
                        pdf: { text: "PDF로 내보내기" },
                        png: { text: "PNG 이미지로 저장" }
                    },
                    mouseScroll: OrgChart.action.zoom, // 마우스 휠 줌 기능
                    nodes: chartData,
                    nodeBinding: {
                        field_0: "name",
                        field_1: "title"
                    }
                });
            } else {
                document.getElementById("tree").innerHTML = "<div style='padding:20px; color:#64748b;'>조직도에 표시할 데이터가 없습니다.</div>";
            }

        } catch (error) {
            console.error("조직도 구동 실패:", error);
        }
    </script>
</body>
</html>