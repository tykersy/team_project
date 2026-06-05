<%@ page contentType="text/html;charset=UTF-8" language="java"%>

<!-- 일정 상세보기 -->
<div id="detailModal" class="detail-modal">

    <div class="detail-content">

        <input type="button"
               class="close-btn"
               value="X"
               onclick="closeDetailModal()" />

        <div class="detail-title">
            일정
        </div>

        <input type="hidden" id="scheduleIdx">
        <input type="hidden" id="scheduleType">

        <table class="detail-table">

            <tr>
                <th>일정</th>
                <td id="detailTitle"></td>
            </tr>

            <tr>
                <th>시작일</th>
                <td id="detailStart"></td>
            </tr>

            <tr>
                <th>종료일</th>
                <td id="detailEnd"></td>
            </tr>
            <tr>
                <th>내용</th>
                <td id="detailContent"></td>
            </tr>

        </table>

        <div class="detail-btn-area">

            <button type="button"
                    id="modifyBtn"
                    onclick="modifySchedule()">
                수정
            </button>

            <button type="button"
                    id="deleteBtn"
                    onclick="deleteSchedule()">
                삭제
            </button>

        </div>

    </div>

</div>