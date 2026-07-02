<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>[Linked : 근로계약서 서명]</title>
<style>
    .contract-box {
        width: 600px;
        margin: 30px auto;
        padding: 20px;
        border: 2px solid #333;
        background-color: #fff;
        font-family: 'Malgun Gothic', sans-serif;
    }
    .contract-title { text-align: center; font-size: 24px; font-weight: bold; margin-bottom: 30px; }
    .contract-row { margin: 15px 0; font-size: 16px; }
    .contract-bold { font-weight: bold; }
    
    /* 사인 패드 스타일 */
    .signature-container {
        text-align: center;
        margin-top: 40px;
        padding-top: 20px;
        border-top: 1px dashed #ccc;
    }
    #signaturePad {
        border: 1px solid #000;
        background-color: #fcfcfc;
        cursor: crosshair;
    }
    .btn-group { margin-top: 15px; }
    .btn { padding: 10px 20px; font-size: 14px; cursor: pointer; margin: 0 5px; }
    .btn-submit { background-color: #4CAF50; color: white; border: none; }
    .btn-clear { background-color: #f44336; color: white; border: none; }

    .certified-container {
        position: relative;
        background-color: #fcfcfc;
        border: 1px solid #e9e9e9;
        padding: 30px;
        border-radius: 8px;
        margin-top: 100px;
        text-align: left;
    }

    /* 디지털 인증 도장 (CSS로 구현) */
    .stamp-mark {
        position: absolute;
        right: 50px;       /* 오른쪽 배치 */
        top: 50%;
        transform: translateY(-50%) rotate(-15deg); /* 도장 찍힌 것처럼 살짝 회전 */
        
        border: 3px double #d32f2f; /* 도장 느낌의 이중선 테두리 */
        color: #d32f2f;            /* 인감 도장 특유의 붉은색 */
        font-size: 16px;
        font-weight: bold;
        padding: 8px 15px;
        border-radius: 5px;
        text-align: center;
        line-height: 1.4;
        letter-spacing: 2px;
        opacity: 0.85;             /* 약간 투명하게 해서 도장 질감 유도 */
        user-select: none;
    }
    
    .stamp-text {
        font-size: 11px;
        border-top: 1px solid #d32f2f;
        margin-top: 3px;
        padding-top: 3px;
        letter-spacing: 0px;
    }
</style>
</head>
<body>

<div class="contract-box">
    <div class="contract-title">근 로 계 약 서 (연봉 계약)</div>
    
    <p>사용자(회사)와 근로자(사원)는 상호 합의 하에 다음과 같이 근로 계약을 체결하고 이를 성실히 이행할 것을 서약한다.</p>
    
    <div class="contract-row">
        <span class="contract-bold">1. 계약 사원번호 :</span> <span>${contract.sabun}</span>
    </div>
    <div class="contract-row">
        <span class="contract-bold">2. 계약 임금 (월 기본급) :</span> <span>${contract.base_salary} 원</span>
    </div>
    <div class="contract-row">
        <span class="contract-bold">3. 비과세 식대 :</span> <span>${contract.meal_allowance} 원</span>
    </div>
    <div class="contract-row">
        <span class="contract-bold">4. 계약 임기 시작일 :</span> <span>${contract.start_date}</span>
    </div>
    <div class="contract-row">
        <span class="contract-bold">5. 계약 임기 종료일 :</span> 
        <span>${contract.end_date != null ? contract.end_date : '기한의 정함이 없음 (정직원)'}</span>
    </div>

    <c:if test="${contract.signed_at eq null}">
    
        <div class="signature-container">
            <h3>서 명 란</h3>
            <canvas id="signaturePad" width="400" height="150"></canvas>
            <div class="btn-group">
                <button type="button" class="btn btn-clear" onclick="clearCanvas()">지우기</button>
                <button type="button" class="btn btn-submit" onclick="submitSignature('${contract.contract_id}', '${contract.sabun}')">계약서 서명제출</button>
            </div>
        </div>
    </c:if>
    <c:if test="${contract.signed_at ne null}">
        <div class="certified-container">
            <!-- 왼쪽: 공식 인증 기록 텍스트 -->
            <div class="certified-info">
                <h4 style="color: #2b579a; margin: 0 0 10px 0; font-size: 16px;">
                    전자문서 체결 정보
                </h4>
                <p style="font-size: 13px; color: #555; margin: 0 0 15px 0; line-height: 1.5;">
                    본 근로계약서는 전자서명법에 의거하여 사원 본인의 인증 및 서명을 통해 <br>
                    적법하게 체결 완료되었음을 시스템이 보증합니다.
                </p>
                <div style="font-size: 12px; color: #888; line-height: 1.6;">
                    • <strong>서명 사원:</strong> ${info.saname} (${contract.sabun}) <br>
                    • <strong>서명 일시:</strong> ${contract.signed_at} <br>
                    • <strong>문서 번호:</strong> NO-${contract.contract_id}
                </div>
            </div>
            <!-- 오른쪽: CSS로 만든 디지털 승인 도장 -->
            <div class="stamp-mark">
                서명완료
                <div class="stamp-text">HR SYSTEM</div>
            </div>
        </div>
    </c:if>   
</div>

<script>
// Canvas 그리기 로직 제어
const canvas = document.getElementById('signaturePad');
const ctx = canvas.getContext('2d');
let isDrawing = false;

// 선 스타일 정의
ctx.strokeStyle = '#000000';
ctx.lineWidth = 3;
ctx.lineCap = 'round';

// 마우스 및 터치 이벤트 리스너 등록
canvas.addEventListener('mousedown', (e) => { isDrawing = true; draw(e); });
canvas.addEventListener('mousemove', draw);
canvas.addEventListener('mouseup', () => { isDrawing = false; ctx.beginPath(); });
canvas.addEventListener('mouseout', () => { isDrawing = false; ctx.beginPath(); });

function draw(e) {
    if (!isDrawing) return;
    
    // 캔버스 내에서의 정확한 마우스 좌표 계산
    const rect = canvas.getBoundingClientRect();
    const x = e.clientX - rect.left;
    const y = e.clientY - rect.top;
    
    ctx.lineTo(x, y);
    ctx.stroke();
    ctx.beginPath();
    ctx.moveTo(x, y);
}

// 캔버스 초기화 (지우기)
function clearCanvas() {
    ctx.clearRect(0, 0, canvas.width, canvas.height);
    ctx.beginPath();
}

// 서명 데이터를 추출하여 서버로 전송
function submitSignature(contractId, sabun) {
    // 1. Canvas에 서명이 비어있는지 기본 검증 (모두 하얗다면 전송 차단 가능)
    // 2. Canvas 내용을 Base64 이미지 문자열로 변환
    const dataURL = canvas.toDataURL('image/png'); 
    // 결과값 형식: "data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAA..."
    
    if(!confirm("이 서명으로 계약을 최종 확정하시겠습니까?")) return;

    // 비동기 전송
    fetch('/user_sign_contract_fin', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: new URLSearchParams({
            'contract_id': contractId,
            'signature_data': dataURL // 문자열로 가공된 사인 이미지 데이터 전달
        })
    })
    .then(response => response.json())
    .then(data => {
        if(data) {
            alert("전자 계약 서명이 성공적으로 완료되었습니다!");
            location.href="/mypage";
        } else {
            alert("서명 처리 중 실패했습니다.");
        }
    })
    .catch(err => console.error("서명 전송 에러:", err));
}
</script>
</body>
</html>