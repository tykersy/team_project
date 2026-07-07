package com.kh.project.common;

import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@Component
public class AlreadyLoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        HttpSession session = request.getSession(false);

        if ("GET".equalsIgnoreCase(request.getMethod())
                && session != null && session.getAttribute("user") != null) {
            response.sendRedirect("/dashboard");
            return false;
        }
        return true;
    }
}
