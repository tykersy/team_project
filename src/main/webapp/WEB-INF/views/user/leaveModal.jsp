<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!-- ─────────────────────────────── 연차 신청 모달 ─── -->
                    <div id="leaveModal" class="modal-overlay" style="display:none;">
                        <form>
                            <input type="hidden" name="use_days" id="use_days" value="0" />
                            <div class="modal-box">
                                <div class="modal-title">연차 신청</div>

                                <div class="modal-field">
                                    <label>휴가 종류</label>
                                    <select name="leave_type" id="leave_type">
                                        <option value="annual">연차</option>
                                        <option value="mc">병가</option>
                                        <option value="health">보건휴가</option>
                                        <option value="etc">기타</option>
                                    </select>
                                </div>

                                <div class="modal-field">
                                    <label>시작일</label>
                                    <input type="date" name="use_date" id="leaveStart" onchange="calcDays()">
                                </div>

                                <div class="modal-field">
                                    <label>종료일</label>
                                    <input type="date" name="leaveEnd" id="leaveEnd" onchange="calcDays()">
                                </div>

                                <div class="modal-field">
                                    <label>반차 여부</label>
                                    <select id="leaveHalf" name="leaveHalf" onchange="calcDays()">
                                        <option value="full">하루 종일</option>
                                        <option value="half">반차 (0.5일)</option>
                                    </select>
                                </div>

                                <div class="modal-field">
                                    <label>사용 일수</label>
                                    <div id="calcResult" style="font-weight:700; color:var(--accent); font-size:1.1rem;">— 일</div>
                                </div>

                                <div class="modal-field">
                                    <label>사유</label>
                                    <textarea id="reason" name="reason" style="resize:none" rows="3" placeholder="사유를 입력하세요 (선택)" ></textarea>
                                </div>

                                <div class="modal-actions">
                                    <input type="button" value="취소" class="btn-cancel" onclick="closeLeaveModal()" />
                                    <input type="button" value="신청" class="btn-submit" onclick="submitLeave(this.form)" />
                                </div>
                            </div>
                        </form>
                    </div>

<script>
    let feasibility = false; //전송 가능한 상태인지 판별
            let totalDay = 0; // 휴가일 수

            function submitLeave(f){
                let use_days = f.use_days.value;

                if(use_days == 0 || !feasibility){
                    alert("내용을 확인해주세요.");
                    return;
                }  

                let formdata = new FormData(f);

                fetch("/mypage/leaveApply", { method:"post" , body : formdata })
                    .then(res => res.json() )
                    .then(data => {
                        if(data.result == "login"){
                            alert("로그인 후 재시도 해주세요.");
                            location.href="/login";
                            return;
                        }else if(data.result == "success"){
                            alert("신청이 완료되었습니다.");
                            location.href="/mypage";
                            return;
                        }else if(data.result == "fail"){
                            alert("신청한 연차의 일수가 부족합니다.");
                            return;
                        }else if(data.result == "overlap"){
                            alert("이미 신청한 휴가가 존재합니다.");
                            return;
                        }else{
                            alert("오류가 발생했습니다.");
                            return;
                        }
                    });


            }

            // ── 연차 모달 ──
            function openLeaveModal() {
                document.getElementById('leaveModal').style.display = 'flex';
                document.getElementById("leaveStart").value = "";
                document.getElementById("leaveEnd").value = "";
                document.getElementById("use_days").value = 0;
                document.getElementById("calcResult").textContent = "— 일";
                document.getElementById("leave_type").options[0].selected = true;
                document.getElementById("leaveHalf").options[0].selected = true;
                document.getElementById("reason").value= "";
            }
            function closeLeaveModal() {
                document.getElementById('leaveModal').style.display = 'none';
                
            }

            // 사용 일수 자동 계산
            function calcDays() {
                let today = new Date(); //당일 날짜
                let start  = new Date(document.getElementById('leaveStart').value);
                let end    = new Date(document.getElementById('leaveEnd').value);
                let isHalf = document.getElementById('leaveHalf').value === 'half';
                let result = document.getElementById('calcResult');
                let use_days = document.getElementById('use_days');
                use_days.value = 0;
                

                if (!document.getElementById('leaveStart').value ||
                    !document.getElementById('leaveEnd').value) {
                    result.textContent = '— 일';
                    feasibility = false;
                    return;
                }
                if (end < start) {
                    result.textContent = '⚠ 종료일이 시작일보다 빠릅니다';
                    result.style.color = '#ef4444';
                    feasibility = false;
                    return;
                }

                // 평일만 계산
                let days = 0;
                let cur  = new Date(start);
                while (cur <= end) {
                    const dow = cur.getDay();
                    if (dow !== 0 && dow !== 6) days++;
                    cur.setDate(cur.getDate() + 1);
                }

                if(isHalf && days > 1){
                    result.textContent = '⚠ 반차는 하루만 선택할 수 있습니다.';
                    result.style.color = '#ef4444';
                    feasibility = false;
                    return;
                }if(!isHalf && start.getDate() == today.getDate()){
                    result.textContent = '⚠ 당일 연차는 사용 불가능합니다.';
                    result.style.color = '#ef4444';
                    feasibility = false;
                    return;
                }

                totalDay = (isHalf ? 0.5 : days);
                use_days.value = totalDay;
                result.textContent  =  totalDay + ' 일';
                result.style.color  = 'var(--accent)';
                feasibility = true;
                
            }
            
</script>