package com.kh.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.project.dao.ChatDAO;
import com.kh.project.dao.SawonDAO;
import com.kh.project.service.ChatService;
import com.kh.project.vo.ChatRoomVO;
import com.kh.project.vo.SawonVO;

import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class MsgController {
    
    private final SawonDAO sawondao;

    private final ChatDAO chatdao;

    @Autowired
    HttpSession session;

    @Autowired
    ChatService chatservice;

    @GetMapping("/msg_member.do")
    public String msgMember(Model model){

        if(session.getAttribute("user") == null){
            return "redirect:/login";
        }

        int sabun = (int)session.getAttribute("user");

        List<SawonVO> list = sawondao.member_list();

        model.addAttribute("sabun", sabun);
        model.addAttribute("memberlist", list);

        return "msg/member";
    }


    @GetMapping("/msg_profile.do")
    @ResponseBody
    public SawonVO msgProfile(int sabun) {
        return sawondao.memberView(sabun);
    }

    @GetMapping("/msg_chatRoomList")
    public String msgChatRoom(Model model){
        
        int sabun = (int)session.getAttribute("user");
        
        List<ChatRoomVO> list = chatdao.selectListChatRoom(sabun);

        model.addAttribute("chatRooms", list);

        return "msg/chatRoomList";

    }

    @PostMapping("/make_room.do")
    @ResponseBody
    public Map<String, Object> makeRoom(int sabun){

        int mySabun = (Integer)session.getAttribute("user");

        Integer roomId =
            chatservice.makeOneRoom(mySabun, sabun);

        Map<String,Object> map =
            new HashMap<>();

        map.put("roomId", roomId);

        return map;
    }

}
