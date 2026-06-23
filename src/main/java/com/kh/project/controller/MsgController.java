package com.kh.project.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
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

    //채팅방 리스트
    @GetMapping("/msg_chatRoomList")
    public String msgChatRoom(Model model){
        
        int sabun = (int)session.getAttribute("user");
        
        List<ChatRoomVO> list = chatdao.selectListChatRoom(sabun);

        model.addAttribute("chatRooms", list);

        return "msg/chatRoomList";
    }

    //즐겨찾기 채팅방 리스트
    @GetMapping("/msg_LikedChatRoomList")
    public String msgLikedChatRoomList(Model model){
        int sabun = (int)session.getAttribute("user");

        List<ChatRoomVO> list = chatdao.selectListLikedChatRoom(sabun);

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

    @PostMapping("/make_group_room")
    @ResponseBody
    public Map<String, Integer> makeGroupRoom(@RequestBody Map<String, Object> request){
        List<Integer> sabuns = (List<Integer>) request.get("sabuns");

        int mySabun = (Integer)session.getAttribute("user");

        sabuns.add(mySabun);

        String room_name = (String) request.get("room_name");
        Integer roomId = chatservice.makeGroupRoom(sabuns, room_name);

        Map<String, Integer> map = new HashMap<>();
        map.put("roomId", roomId);

        return map;
    }

}
