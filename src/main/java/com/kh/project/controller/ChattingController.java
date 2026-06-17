package com.kh.project.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;

import com.kh.project.dao.ChatDAO;
import com.kh.project.service.ChatService;
import com.kh.project.vo.ChatMessageVO;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ChattingController {

    private final ChatService chatService;
    private final ChatDAO chatDAO;


    @GetMapping("/msg_chatRoom/{roomId}")
    public String chatRoom(Model model, @PathVariable int roomId){

        List<ChatMessageVO> logs = chatService.getRecentLogs(roomId);

        model.addAttribute("roomId", roomId);
        model.addAttribute("logs", logs);

        return "/msg/chatRoom";
    }
    

}
