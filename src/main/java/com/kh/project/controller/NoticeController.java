package com.kh.project.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

// 공지사항 TEST용
@Controller
public class NoticeController {

    @GetMapping("/notice")
    public String noticeTest(Model model) {
        
        // 1. 실제 DB 연결 대신 테스트용 가짜 데이터(Map 형식) 생성
        List<Map<String, Object>> testList = new ArrayList<>();
        
        Map<String, Object> notice1 = new HashMap<>();
        notice1.put("noticeId", 1);
        notice1.put("title", "[필독] 인력관리시스템 오픈 안내 🚀");
        notice1.put("writeDate", "2026-05-27");
        testList.add(notice1);
        
        Map<String, Object> notice2 = new HashMap<>();
        notice2.put("noticeId", 2);
        notice2.put("title", "6월 전사 워크숍 일정 공지 🏖️");
        notice2.put("writeDate", "2026-05-26");
        testList.add(notice2);

        // 2. 만약 실제 Service와 DB 연결이 끝났다면 아래 한 줄로 대체 가능합니다!
        // List<NoticeVO> testList = noticeService.getNoticeList();

        model.addAttribute("noticeList", testList);        
        return "notice"; 
    }
}
