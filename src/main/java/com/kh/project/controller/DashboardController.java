package com.kh.project.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model; // 💡 데이터를 jsp로 보내기 위해 필요!
import org.springframework.web.bind.annotation.GetMapping;

import com.kh.project.dao.BoardDAO;
import com.kh.project.dao.DcalendarDAO; // 💡 CalendarDAO 대신 팀원이 만든 DcalendarDAO로 교체!
// 연결할 DAO 부품들을 가져옵니다.
import com.kh.project.dao.SawonDAO;
import com.kh.project.dao.SleaveDAO;
import com.kh.project.vo.BoardVO;

@Controller
public class DashboardController {

    // 다른 DAO 부품들을 담아둘 변수 선언
    private final SawonDAO sawonDao;
    private final SleaveDAO sleaveDao;
    private final DcalendarDAO dcalendarDao; // 💡 dcalendarDao로 변경
    private final BoardDAO boardDao;

    // 생성자 파라미터도 dcalendarDao에 맞춰서 자동으로 조립되도록 변경했습니다.
    public DashboardController(SawonDAO sawonDao, SleaveDAO sleaveDao, DcalendarDAO dcalendarDao, BoardDAO boardDao) {
        this.sawonDao = sawonDao;
        this.sleaveDao = sleaveDao;
        this.dcalendarDao = dcalendarDao;
        this.boardDao = boardDao;
    }

    @GetMapping({"/", "/home", "/dashboard"})
    public String dashboard(Model model) { // 💡 파라미터에 Model을 추가해 줍니다!

        // ========================================================
        // [임시 데이터 영역] 임시로 숫자를 넣어두고, 나중에 DAO 메서드로 바꾸시면 됩니다!
        // ========================================================
        int attendCount = 128; // 나중에 sawonDAO.getLiveSawonCount() 같은 걸로 변경
        int leaveCount = 12; // 나중에 sleaveDAO.getTodayLeaveCount() 같은 걸로 변경
        int approvalCount = 7; // 승인 대기 수
        String totalHours = "1,284h"; // 총 근무시간

        // Model 객체에 파라미터를 담아서 main.jsp 화면으로 보냄
        model.addAttribute("attend", attendCount);
        model.addAttribute("vacation", leaveCount);
        model.addAttribute("approval", approvalCount);
        model.addAttribute("totalHours", totalHours);

        // 1. 공지사항 데이터 가져오기 및 디버깅 로그 출력       
        List<BoardVO> boardList = boardDao.getBoardList();
        System.out.println("========== 대시보드 공지사항 체크 ==========");
        if (boardList != null) {
            System.out.println("가져온 공지사항 개수: " + boardList.size());
            for (BoardVO b : boardList) {
                System.out.println("글 제목: " + b.getTitle());
            }
        } else {
            System.out.println("boardList가 null(비어있음)입니다!");
        }
        System.out.println("=========================================");

        model.addAttribute("boardList", boardList);

        // 2. 💡 [최종 추가] 팀원이 만든 부서별 일정 리스트 가져오기
        // 임시로 10번 부서의 일정을 조회하게 파라미터를 세팅했습니다.
        int testDeptNo = 10; 
        // List<ScheduleDTO> scheduleList = dcalendarDao.selectDept(testDeptNo);
        // model.addAttribute("scheduleList", scheduleList); // 💡 jsp 화면으로 배달!

        // 원래 리턴하던 jsp 경로 그대로 유지
        return "dashboard/main";
    }
}