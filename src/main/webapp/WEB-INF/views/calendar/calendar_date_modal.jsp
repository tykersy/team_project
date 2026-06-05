<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<!-- 날짜 선택 팝업 -->
<div id="dateModal" class="datemodal">

    <div class="datemodal-content">

        <div class="datemodal-title">
            날짜 선택
        </div>

        <div class="select-wrap">

            <select id="year">
                <c:forEach begin="2020" end="2035" var="y">
                    <option value="${y}"
                            <c:if test="${y == year}">
                                selected
                            </c:if>>
                        ${y}년
                    </option>
                </c:forEach>
            </select>

            <select id="month">
                <c:forEach begin="1" end="12" var="m">
                    <option value="${m}"
                            <c:if test="${m == month}">
                                selected
                            </c:if>>
                        ${m}월
                    </option>
                </c:forEach>
            </select>

        </div>

        <div class="cal-btn-area">

            <button type="button"
                    onclick="closeModal()">
                취소
            </button>

            <button type="button"
                    onclick="moveDate()">
                확인
            </button>

        </div>

    </div>

</div>