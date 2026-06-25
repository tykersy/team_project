package com.kh.project.common;

import org.springframework.stereotype.Component;
import org.springframework.web.method.HandlerMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class AdminInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);
        Object user = session.getAttribute("user");

        if (!Integer.valueOf(1).equals(user)) {
            if (handler instanceof HandlerMethod handlerMethod) {
                if (handlerMethod.hasMethodAnnotation(ResponseBody.class)) {
                    response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                    response.setContentType("application/json;charset=UTF-8");
                    response.getWriter().write("{\"result\":\"forbidden\"}");
                    return false;
                }
            }
            response.sendRedirect("/dashboard");
            return false;
        }
        return true;
    }
}
