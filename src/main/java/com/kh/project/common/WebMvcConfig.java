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
    private final PreventBackCacheInterceptor backCacheInterceptor;
    private final AlreadyLoginInterceptor alreadyLoginInterceptor;

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(loginInterceptor)
            .addPathPatterns("/**")
            .excludePathPatterns(
                "/login",
                "/", "/home", "/dashboard",
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

        registry.addInterceptor(alreadyLoginInterceptor)
            .addPathPatterns("/login");

        registry.addInterceptor(backCacheInterceptor)
            .addPathPatterns("/**")
            .excludePathPatterns(
                "/css/**",
                "/js/**",
                "/img/**",
                "/images/**",
                "/fonts/**",
                "/favicon.ico",
                "/error"
            );
    }
}
