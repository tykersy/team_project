package com.kh.project.controller;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.project.dao.DeptDAO;
import com.kh.project.dao.SalaryDAO;
import com.kh.project.dao.SawonDAO;
import com.kh.project.dao.SleaveDAO;
import com.kh.project.dao.TADAO;
import com.kh.project.dao.UserDAO;
import com.kh.project.vo.DeptVO;
import com.kh.project.vo.SalaryContractVO;
import com.kh.project.vo.SawonVO;
import com.kh.project.vo.SleaveLogVO;
import com.kh.project.vo.TAVO;

import lombok.RequiredArgsConstructor;


@Controller
@RequiredArgsConstructor
@RequestMapping("/admin")
public class AdminController {

    private final TADAO tadao;
    private final DeptDAO deptdao;
    private final UserDAO userdao;
    private final SawonDAO sawondao;
    private final SleaveDAO sleavedao;
    private final SalaryDAO salarydao;
    
    //관리자 로그인 확인용 session
    @Autowired
    private HttpSession session;

    @GetMapping("/main")
    public String toMain(Model model) {



        //오늘 근태현황
        Map<String, Integer> todayTa = tadao.totalAllTa();
        //부서별 연차 소진율
        List<Map<String, Object>> deptAnnualUseAvg = tadao.selectDeptAnnualUseAvg();
        //오늘 출근율
        Double todayCommuteAvg = tadao.selectTodayCommuteAvg();
        //이번달 퇴사자
        int monthLeaveSawon = tadao.selectMonthLeaveSawon( LocalDate.now() );
        //이번달 입사자
        int monthJoinedSawon = tadao.selectMonthJoinedSawon( LocalDate.now() );
        //미승인 휴가/연차
        int countPendingLeaves = sleavedao.countPendingLeaves();
        //미승인 급여정산
        int countLedgers = salarydao.getCountLedgers(LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM")));

        model.addAttribute("todayTa", todayTa);
        model.addAttribute("deptAnnualUseAvg", deptAnnualUseAvg);
        model.addAttribute("todayCommuteAvg", todayCommuteAvg);
        model.addAttribute("monthLeaveSawon", monthLeaveSawon);
        model.addAttribute("monthJoinedSawon", monthJoinedSawon);
        model.addAttribute("countPendingLeaves", countPendingLeaves);
        model.addAttribute("countLedgers", countLedgers);
        
        return "/admin_main/main";
    }

    //일일 근태 현황 페이지
    @GetMapping("/today_ta")
    public String todayTA(Model model){ //Integer를 사용 하면 null 체크 가능



        List<DeptVO> deptList = deptdao.selectAll(); 
        
        model.addAttribute("deptList", deptList);

        return "admin_ta/admin_today_ta";
    }

    //부서별 근태 현황 페이지
    @GetMapping("/today_ta/data")
    @ResponseBody
    public List<Map<String, Object>> loadTA(Integer deptno){
        return tadao.selectDeptTA(deptno);
    }

    //사원 근태 현황
    @GetMapping("/today_ta/view")
    public String sawonTaView(Model model, int sabun, String ym){



        Map<String, Object> info = new HashMap<>();
        int year;
        int month;

        //년월 정보가 넘어오지 않았다면 (현재 년월로 조회)
        if( ym == null || ym.equals("") || ym.trim().equals("")){

            year = LocalDate.now().getYear();
            month = LocalDate.now().getMonthValue();

            //view.jsp에서 오늘 기준 년월을 뿌려주기 위해 ym에 값 넣어주기
            ym = LocalDate.now().format(DateTimeFormatter.ofPattern("yyyy-MM"));

        }else{ //만약 년월 정보가 넘어왔다면(근태 수정중이라면)

            //해당 년월의 해당직원의 근태 정보만 불러오기
            year = Integer.parseInt(ym.split("-")[0]);
            month = Integer.parseInt(ym.substring(5,7));
        }

        info.put("year", year);
        info.put("month", month);
        info.put("sabun", sabun);
        info.put("orderBy", "desc");
        info.put("ym", ym);

        //해당 사원의 해당 년월 근태가 마감 된 상태인지 확인
        String approved = tadao.alreadyApproved(info);

        //근태가 마감 전일 경우
        if( approved == null || !approved.equals("완료") ){
            approved = "show";
        }else{
            approved = "noshow";
        }

        //해당 사원의 해당 년월 출근기록
        List<TAVO> userTAList = userdao.getMonthlyTA(info);
        //해당 사원의 이름
        SawonVO sawon = sawondao.selectSawon(sabun);

        model.addAttribute("userTaList",userTAList);
        model.addAttribute("ym", ym);
        model.addAttribute("sawon", sawon);
        model.addAttribute("approved", approved);

        return "admin_ta/admin_ta_view";
    }

    @GetMapping("/system_role")
    public String adminSystemControlForRole( Model model ){

        //각팀별 팀장 조회
        List<SawonVO> leaderList = sawondao.getLeaderList();

        //바인딩
        model.addAttribute("leaderList", leaderList);

        return "admin_system/admin_role";
    }

    @PostMapping("/reposition_leader")
    @ResponseBody
    public Map<String, Integer> changeLeader( int deptno, String sabun ){
        
        //파라미터를 담을 map
        Map<String, Integer> map = new HashMap<>();

        //기존 팀장(관리자) 사번 비우기
            int Ares = sawondao.deleteLeader(deptno);

        //사번이 잘 넘어왔다면 로직 실행
        if( sabun != null && !sabun.trim().equals("") ){

            map.put("deptno", deptno);
            map.put("sabun", Integer.parseInt(sabun));

            //새로운 팀장(관리자) 사번 업데이트
            Ares += sawondao.insertLeader(map);

        }

        //반환할 결과 map에 주입 (result : 변경 성공시 2, 비우기 성공시 1, 실패시 0)
        map.put("result", Ares);

        return map;

    }

    //부서별 사원 목록 가져오기
    @GetMapping("/read_dept_sawon")
    @ResponseBody
    public Map<String, Object> getDeptSawonList(int deptno){

        //부서별 사원 목록 조회
        List<SawonVO> deptSawonList = sawondao.getDeptSawonList(deptno);

        Map<String, Object> map = new HashMap<>();
        map.put("deptSawonList", deptSawonList);

        return map;

    }

    //전자 계약 현황 페이지
    @GetMapping("/admin_contract_list")
    public String contractListMain( Model model ){

        //부서리스트 조회 및 바인딩
        List<DeptVO> deptList = deptdao.selectAll();
        model.addAttribute("deptList", deptList);

        //페이지가 로드 될 때 리스트를 사번 순으로 출력하기 위한 바인딩
        Map<String, Object> map = new HashMap<>();
        map.put("sortType", null);

        //대시보드 상단 카운트 박스 정보조회 및 바인딩
        Map<String, Object> counts = salarydao.getCountsContract();
        model.addAttribute("pending_count", counts.get("pendingCount"));
        model.addAttribute("renewal_count", counts.get("renewalCount"));
        System.out.println(counts.get("pendingCount"));
        System.out.println(counts.get("renewalCount"));

        //사원번호 순으로 정렬된 계약서 리스트 조회 및 바인딩
        List<SalaryContractVO> contractList = salarydao.getfilteredList(map);
        model.addAttribute("contractList", contractList);

        return "admin_salary/admin_contract_list";
    }

    //전자 계약 현황 리스트 필터링
    @GetMapping("/admin_contract_status")
    public String filertingContractList( Model model, String saname, String sortType, String deptno){

        //대시보드 상단 카운트 박스 정보조회 및 바인딩
        Map<String, Object> counts = salarydao.getCountsContract();
        model.addAttribute("pending_count", counts.get("pendingCount"));
        model.addAttribute("renewal_count", counts.get("renewalCount"));

        //검색 조건 필터링 조건 map에 담기
        Map<String, Object> filter = new HashMap<>();
        filter.put("deptno", deptno);
        filter.put("sortType", sortType);
        filter.put("saname", saname);

        //조건으로 조회하기+ 결과 바인딩하기
        List<SalaryContractVO> contractList = salarydao.getfilteredList(filter);
        model.addAttribute("contractList", contractList);

        return "admin_salary/admin_contract_list";
    }

    //이름 클릭시 사원(최근) 계약서 상세보기 페이지
    @GetMapping("/admin_contract_detail")
    @ResponseBody
    public Map<String, Object> showDetailOfContract(String sabun){

        int i_sabun = 0;
        SalaryContractVO contract;
        Map<String, Object> map = new HashMap<>();

        //방어 코드
        if( sabun != null && sabun != ""){
            i_sabun = Integer.parseInt(sabun);
            contract = salarydao.getContractBySabun(i_sabun);
            
            map.put("contract", contract);

        }else{
            map.put("contract", null);
        }

        return map;
        
    }
}
