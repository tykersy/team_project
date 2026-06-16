package com.kh.project.controller;

import org.springframework.stereotype.Controller;

import com.kh.project.dao.ChatDAO;
import com.kh.project.service.ChatService;

import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class ChattingController {

    private final ChatService chatService;
    private final ChatDAO chatDAO;

    

}
