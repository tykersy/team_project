package com.kh.project.common;

import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import lombok.RequiredArgsConstructor;

@Configuration
@RequiredArgsConstructor
public class WebMvcConfig implements WebMvcConfigurer {

    private final LoginInterceptor loginInterceptor;
    private final AdminInterceptor adminInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor)
            .addPathPatterns("/**")
            .excludePathPatterns(
                "/login",
                "/logout",
                "/", "/home", "/dashboard",
                "/board/**",
                "/chat",
                "/css/**",
                "/js/**",
                "/img/**",
                "/images/**",
                "/fonts/**",
                "/favicon.ico",
                "/error"
            );

        registry.addInterceptor(adminInterceptor)
            .addPathPatterns("/admin/**");
    }
}
