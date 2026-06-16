package com.kh.project.common;

import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Configuration;
import org.springframework.http.server.ServerHttpRequest;
import org.springframework.http.server.ServerHttpResponse;
import org.springframework.http.server.ServletServerHttpRequest;
import org.springframework.web.socket.WebSocketHandler;
import org.springframework.web.socket.config.annotation.EnableWebSocket;
import org.springframework.web.socket.config.annotation.WebSocketConfigurer;
import org.springframework.web.socket.config.annotation.WebSocketHandlerRegistry;
import org.springframework.web.socket.server.support.HttpSessionHandshakeInterceptor;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@RequiredArgsConstructor
@Configuration
@EnableWebSocket
public class WebSocketConfig implements WebSocketConfigurer{

    private final ChatWebSocketHandler chatWebSocketHandler;

    @Override
    public void registerWebSocketHandlers(WebSocketHandlerRegistry registry) {
        
        registry.addHandler(chatWebSocketHandler, "/chat/{roomId}")
            .addInterceptors(new ChatHandshakeInterceptor())
            .setAllowedOrigins("*");
        
    }

    static class ChatHandshakeInterceptor extends HttpSessionHandshakeInterceptor {
        
       @Override
       public boolean beforeHandshake(ServerHttpRequest request, ServerHttpResponse response,
               WebSocketHandler wsHandler, Map<String, Object> attributes) throws Exception {
           
            super.beforeHandshake(request, response, wsHandler, attributes);

            String path = request.getURI().getPath();
            String[] parts = path.split("/");
            Long roomId = Long.parseLong(parts[parts.length - 1]);
            attributes.put("roomId", roomId);

            if(request instanceof ServerHttpRequest){
                 HttpSession httpSession = ((ServletServerHttpRequest) request)
                    .getServletRequest().getSession(false);

                if(httpSession == null || httpSession.getAttribute("user") == null){
                    return false;
                }

                attributes.put("userId", httpSession.getAttribute("userId"));
                attributes.put("userName", httpSession.getAttribute("userName"));

            }

            return true;

       } 
    }



}
