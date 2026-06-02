<%-- passwordModal.jsp --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<div class="pw-overlay" id="pwOverlay" role="dialog" aria-modal="true" aria-labelledby="pwModalTitle">
  <div class="pw-modal">

    <div class="pw-modal-header">
      <div class="card-title" id="pwModalTitle">
        <span class="dot"></span>비밀번호 변경
      </div>
      <button class="pw-close" onclick="closePwModal()" aria-label="닫기">&#x2715;</button>
    </div>

    <form name="pwForm">

      <div class="pw-modal-body">

        <div class="pw-alert" id="pwAlert" style="display:none;"></div>

        <div class="pw-field">
          <label for="pwCurrent">현재 비밀번호</label>
          <div class="pw-input-wrap">
            <input type="password" id="pwCurrent" name="currentPw" placeholder="현재 비밀번호를 입력하세요" autocomplete="current-password">
            <button class="pw-toggle" type="button" onclick="togglePw('pwCurrent', this)" aria-label="비밀번호 보기">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
            </button>
          </div>
        </div>

        <div class="pw-field">
          <label for="pwNew">새 비밀번호</label>
          <div class="pw-input-wrap">
            <input type="password" id="pwNew" name="newPw" placeholder="새 비밀번호를 입력하세요" autocomplete="new-password" oninput="checkStrength(this.value)">
            <button class="pw-toggle" type="button" onclick="togglePw('pwNew', this)" aria-label="비밀번호 보기">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
            </button>
          </div>
          <div class="pw-strength">
            <div class="pw-strength-bars">
              <div class="pw-bar" id="bar1"></div>
              <div class="pw-bar" id="bar2"></div>
              <div class="pw-bar" id="bar3"></div>
              <div class="pw-bar" id="bar4"></div>
            </div>
            <span class="pw-strength-label" id="strengthLabel"></span>
          </div>
        </div>

        <div class="pw-field">
          <label for="pwConfirm">새 비밀번호 확인</label>
          <div class="pw-input-wrap">
            <input type="password" id="pwConfirm" name="confirmPw" placeholder="새 비밀번호를 다시 입력하세요" autocomplete="new-password">
            <button class="pw-toggle" type="button" onclick="togglePw('pwConfirm', this)" aria-label="비밀번호 보기">
              <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M1 12s4-8 11-8 11 8 11 8-4 8-11 8-11-8-11-8z"/><circle cx="12" cy="12" r="3"/></svg>
            </button>
          </div>
        </div>

        <div class="pw-notice">
          <svg width="14" height="14" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round" style="flex-shrink:0;margin-top:1px;color:var(--accent)"><circle cx="12" cy="12" r="10"/><line x1="12" y1="8" x2="12" y2="12"/><line x1="12" y1="16" x2="12.01" y2="16"/></svg>
          <span>영문 대·소문자, 숫자, 특수문자를 포함하여 8자 이상으로 설정해 주세요.</span>
        </div>

      </div>

      <div class="pw-modal-footer">
        <button class="btn-ghost" type="button" onclick="closePwModal()">취소</button>
        <button class="btn-primary" type="button" id="pwSubmitBtn" onclick="submitPwChange(this.form)">변경하기</button>
      </div>

    </form>

  </div>
</div>

<script>
  function openPwModal() {
    resetPwModal();
    document.getElementById('pwOverlay').classList.add('open');
    document.body.style.overflow = 'hidden';
    setTimeout(() => document.getElementById('pwCurrent').focus(), 100);
  }
  function closePwModal() {
    document.getElementById('pwOverlay').classList.remove('open');
    document.body.style.overflow = '';
  }
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Escape') closePwModal();
  });
  function resetPwModal() {
    ['pwCurrent','pwNew','pwConfirm'].forEach(id => {
      const el = document.getElementById(id);
      el.value = '';
      el.type = 'password';
      el.classList.remove('error');
    });
    document.querySelectorAll('.pw-toggle').forEach(btn => btn.style.color = '');
    checkStrength('');
    showAlert('', '');
  }
  function togglePw(id, btn) {
    const input = document.getElementById(id);
    input.type = input.type === 'password' ? 'text' : 'password';
    btn.style.color = input.type === 'text' ? 'var(--accent)' : '';
  }
  function checkStrength(val) {
    const bars  = [1,2,3,4].map(i => document.getElementById('bar' + i));
    const label = document.getElementById('strengthLabel');
    bars.forEach(b => b.className = 'pw-bar');
    if (!val) { label.textContent = ''; label.className = 'pw-strength-label'; return; }
    let score = 0;
    if (val.length >= 8)           score++;
    if (/[A-Z]/.test(val))         score++;
    if (/[0-9]/.test(val))         score++;
    if (/[^A-Za-z0-9]/.test(val))  score++;
    const levels = [
      { cls: 'weak',   txt: '취약' },
      { cls: 'weak',   txt: '취약' },
      { cls: 'medium', txt: '보통' },
      { cls: 'strong', txt: '강함' },
    ];
    const lvl = levels[Math.min(score, 4) - 1] || levels[0];
    for (let i = 0; i < score; i++) bars[i].classList.add(lvl.cls);
    label.textContent = lvl.txt;
    label.className   = 'pw-strength-label ' + lvl.cls;
  }
  function showAlert(msg, type) {
    const el = document.getElementById('pwAlert');
    el.textContent = msg;
    el.className = 'pw-alert ' + type;
    el.style.display = msg ? 'block' : 'none';
  }
  function validatePw() {
    const cur = document.getElementById('pwCurrent').value.trim();
    const nw  = document.getElementById('pwNew').value;
    const cf  = document.getElementById('pwConfirm').value;
    ['pwCurrent','pwNew','pwConfirm'].forEach(id => document.getElementById(id).classList.remove('error'));
    if (!cur) {
      document.getElementById('pwCurrent').classList.add('error');
      showAlert('현재 비밀번호를 입력해 주세요.', 'error'); return false;
    }
    if (!nw) {
      document.getElementById('pwNew').classList.add('error');
      showAlert('새 비밀번호를 입력해 주세요.', 'error'); return false;
    }
    if (!/^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^A-Za-z0-9]).{8,}$/.test(nw)) {
      document.getElementById('pwNew').classList.add('error');
      showAlert('비밀번호는 영문 대·소문자, 숫자, 특수문자를 포함하여 8자 이상이어야 합니다.', 'error'); return false;
    }
    if (nw !== cf) {
      document.getElementById('pwConfirm').classList.add('error');
      showAlert('새 비밀번호가 일치하지 않습니다.', 'error'); return false;
    }
    return true;
  }
  function submitPwChange(f) {
    if (!validatePw()) return;

    const btn = document.getElementById('pwSubmitBtn');

    btn.disabled = true;
    btn.textContent = '처리 중...';

    const params = new URLSearchParams({
      currentPw : f.pwCurrent.value,
      newPw     : f.pwNew.value,
    });

    fetch('/mypage/changePw', {
      method  : 'POST',
      headers : { 'Content-Type': 'application/x-www-form-urlencoded' },
      body    : params.toString()
    })
    .then(res => res.json())
    .then(data => {
      if (data.result == "success") {
        showAlert('비밀번호가 성공적으로 변경되었습니다.', 'success');
        setTimeout(closePwModal, 1800);
      } else if(data.result == "failure") {
        showAlert(data.message || '비밀번호 변경에 실패했습니다.', 'error');
      } else {
        showAlert('다시 로그인후 시도바랍니다.' , 'session');
        setTimeout(closePwModal, 1800);
        location.href="/login";
      }
    })
    .catch(() => showAlert('서버 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.', 'error'))
    .finally(() => { btn.disabled = false; btn.textContent = '변경하기'; });
  }
</script>
