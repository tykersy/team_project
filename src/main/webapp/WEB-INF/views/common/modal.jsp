<!-- 오버레이 (어두운 배경) -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    /* ── modal.css ── */
    :root {
        --bg: #f0f4f9;
        --surface: #ffffff;
        --surface2: #f7f9fc;
        --border: #dde3ee;
        --accent: #2563eb;
        --accent2: #7c3aed;
        --green: #16a34a;
        --red: #dc2626;
        --yellow: #d97706;
        --text: #1a202c;
        --text-muted: #64748b;
        --text-dim: #a0aec0;
        --radius: 14px;
        --radius-sm: 8px;
    }
    /* 오버레이 */
    .modal-overlay {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(15, 23, 42, 0.45);
    backdrop-filter: blur(2px);
    z-index: 500;
    align-items: center;
    justify-content: center;
    }
    .modal-overlay.open {
    display: flex;
    animation: overlayIn 0.2s ease;
    }
    @keyframes overlayIn {
    from { opacity: 0; }
    to   { opacity: 1; }
    }

    /* 모달 박스 */
    .modal {
    background: var(--surface);
    border: 1px solid var(--border);
    border-radius: var(--radius);
    width: 100%;
    max-width: 460px;
    box-shadow: 0 20px 60px rgba(15, 23, 42, 0.18);
    animation: modalIn 0.25s cubic-bezier(0.34, 1.56, 0.64, 1);
    overflow: hidden;
    }
    @keyframes modalIn {
    from { opacity: 0; transform: scale(0.94) translateY(12px); }
    to   { opacity: 1; transform: scale(1)    translateY(0); }
    }

    /* 헤더 */
    .modal-header {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 22px 28px 0;
    }
    .modal-title {
    font-size: 16px;
    font-weight: 700;
    color: var(--text);
    display: flex;
    align-items: center;
    gap: 8px;
    }
    .modal-title .dot {
    width: 6px;
    height: 6px;
    border-radius: 50%;
    background: var(--accent);
    flex-shrink: 0;
    }
    .modal-close {
    background: none;
    border: none;
    font-size: 18px;
    color: var(--text-muted);
    cursor: pointer;
    padding: 4px 6px;
    border-radius: 6px;
    line-height: 1;
    transition: color 0.15s, background 0.15s;
    }
    .modal-close:hover { color: var(--text); background: var(--surface2); }

    /* 바디 */
    .modal-body {
    padding: 24px 28px;
    font-size: 14px;
    color: var(--text-muted);
    line-height: 1.7;
    }

    /* 푸터 */
    .modal-footer {
    display: flex;
    justify-content: flex-end;
    gap: 10px;
    padding: 0 28px 24px;
    }

    /* 버튼 */
    .btn-ghost {
    padding: 9px 18px;
    border: 1px solid var(--border);
    background: transparent;
    color: var(--text-muted);
    font-family: 'Noto Sans KR', sans-serif;
    font-size: 13px;
    font-weight: 500;
    border-radius: var(--radius-sm);
    cursor: pointer;
    transition: all 0.2s;
    }
    .btn-ghost:hover { border-color: var(--text-muted); color: var(--text); }

    .btn-primary {
    padding: 9px 18px;
    border: none;
    background: var(--accent);
    color: #fff;
    font-family: 'Noto Sans KR', sans-serif;
    font-size: 13px;
    font-weight: 600;
    border-radius: var(--radius-sm);
    cursor: pointer;
    transition: all 0.2s;
    box-shadow: 0 4px 12px rgba(37, 99, 235, 0.25);
    }
    .btn-primary:hover { background: #1d4ed8; box-shadow: 0 4px 16px rgba(37,99,235,0.35); }
    .btn-primary:active { transform: scale(0.98); }
    .btn-primary:disabled { background: var(--text-dim); box-shadow: none; cursor: not-allowed; }
</style>
<div class="modal-overlay" id="modalOverlay">
  <div class="modal">

    <div class="modal-header">
      <div class="modal-title">
        <span class="dot"></span>
        <span id="modalTitle">제목</span>
      </div>
      <button class="modal-close" onclick="closeModal()">&#x2715;</button>
    </div>

    <div class="modal-body">
      <span id="modalContent">내용</span>
    </div>

    <div class="modal-footer">
      <button class="btn-ghost" onclick="closeModal()">취소</button>
      <button class="btn-primary" id="modalConfirmBtn" >확인</button>
    </div>

  </div>
</div>

<script>
    function openModal(title, content, onConfirm) {
        document.getElementById('modalTitle').textContent      = title       || '알림';
        document.getElementById('modalContent').textContent   = content     || '';

        document.getElementById('modalOverlay').classList.add('open');
        document.body.style.overflow = 'hidden';

        document.getElementById('modalConfirmBtn').onclick = function() {
            if (onConfirm) onConfirm();
            closeModal();
        };
    }
    
    function closeModal() {
        document.getElementById('modalOverlay').classList.remove('open');
        document.body.style.overflow = '';
    }
    
    document.addEventListener('keydown', function(e) {
        if (e.key === 'Escape') closeModal();
    });
</script>
