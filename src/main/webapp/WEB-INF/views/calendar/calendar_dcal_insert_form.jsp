<%@ page contentType="text/html;charset=UTF-8" language="java"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<!DOCTYPE html>
<html>

    <head></head>
    <body>
        <form>
            <div align="center">
                <button type = "button" onclick ="history.back()">x</button>
                <span>부서 일정</span>
                <button type="button" onclick = "send(this.form)">저장</button>
            </div>
            <div>
                <input type = "hidden" name="dcal_idx" value="${param.dcal_idx}" />
                <table border="1" align="center">
                    <tr>
                        <td colspan="4">
                            <input name = "title" placeholder="일정을 입력하세요" />
                        </td>
                    </tr>
                    <tr>
                        <th>
                            <span>부서번호</span>
                        </th>
                        <td>
                            <input name = "deptno" value="${vo.deptno}" readonly />
                        </td>
                        <th>
                            <span>사번</span>
                        </th>
                        <td>
                            <input name= "sabun" value="${vo.sabun}" readonly />
                        </td>
                    </tr>
                    <tr>
                        <th>시작</th>
                        <td>
                            <input type="date" name= "startdate" value="${today}"/>
                        </td>
                        <th>종료</th>
                        <td>
                            <input type="date" name= "enddate" value = "${today}"/>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <input name = "loc" placeholder="장소" />
                        </td>
                    </tr>
                    <tr>
                        <td colspan="4">
                            <input name = "content" placeholder="설명" />
                        </td>
                    </tr>
                </table>
            </div>
        </form>
    </body>
    
</html>
