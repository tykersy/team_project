package com.kh.project.controller;

import java.io.IOException;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kh.project.common.PwdSecurity;
import com.kh.project.dao.DeptDAO;
import com.kh.project.dao.JobPositionDAO;
import com.kh.project.dao.SawonDAO;
import com.kh.project.dao.SleaveDAO;
import com.kh.project.vo.DeptVO;
import com.kh.project.vo.JobPositionVO;
import com.kh.project.vo.SawonVO;
import com.kh.project.vo.SleaveVO;
import com.lowagie.text.Document;
import com.lowagie.text.Element;
import com.lowagie.text.Font;
import com.lowagie.text.PageSize;
import com.lowagie.text.Paragraph;
import com.lowagie.text.Phrase;
import com.lowagie.text.pdf.BaseFont;
import com.lowagie.text.pdf.PdfPCell;
import com.lowagie.text.pdf.PdfPTable;
import com.lowagie.text.pdf.PdfWriter;

import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;



@Controller
@RequiredArgsConstructor
public class SawonController {

    @Autowired
    HttpSession session;
    
    //사원DAO
    private final SawonDAO sawonDao;
    //부서DAO
    private final DeptDAO deptDao;
    //암호화 컴포넌트
    private final PwdSecurity pwdSecurity;
    //연차DAO
    private final SleaveDAO sleaveDao;
    //직급DAO
    private final JobPositionDAO jobDao;

    //전체 사원 목록
    @GetMapping("/admin/sawon_list")
    public String sawonList( Model model ) {
        
        List<SawonVO> list = sawonDao.sawonList();
        model.addAttribute("list", list);
        return "/sawon/sawon_list";
    }


    //사원 추가 폼
    @GetMapping("/admin/sawon_add")
    public String sawonAddForm(Model model){
        
        //부서 번호조회를 위해 부서 전체
        List<DeptVO> dept = deptDao.selectAll();
        model.addAttribute("dept", dept);

        return "sawon/sawon_add";
    }

    //사원 추가
    @PostMapping("/admin/sawon_add")
    @ResponseBody
    public Map<String, Integer> sawonAdd(SawonVO vo){

        //사용자가 입력한 비밀번호 암호화
        String currPwd = pwdSecurity.pwdEncoding(vo.getPwd());

        //암호화 된 비밀번호 VO에 삽입
        vo.setPwd(currPwd);

        //db에 추가 됐으면 1 아니라면 0
        int result = sawonDao.sawonInsert(vo);
        //사원 추가시 기본 연차 데이터 추가
        int resultSleave = sleaveDao.sleaveInsert(vo.getSabun());

        Map<String, Integer> map = new HashMap<>();
        map.put("result", result);
        map.put("resultSleave", resultSleave);

        return map;
    }


    @GetMapping("/dcal_insert.do")
    public String dcalendarForm( Model model){

        int sabun = (int)session.getAttribute("user");

        SawonVO vo = sawonDao.sawonView(sabun); 
        LocalDate today = LocalDate.now();

        model.addAttribute("today", today);
        model.addAttribute("vo", vo);

        return"calendar/calendar_dcal_insert_form";
    }

    @GetMapping("/scal_insert.do")
    public String scalendarForm( Model model){

        int sabun = (int)session.getAttribute("user");
        
        SawonVO vo = sawonDao.sawonView(sabun);
        LocalDate today = LocalDate.now();

        model.addAttribute("today", today);
        model.addAttribute("vo", vo);

        return"calendar/calendar_scal_insert_form";
    }
    
    
    //사원별 정보 열람 페이지
    @GetMapping("/admin/sawon_view")
    public String sawonLeave( Model model , int sabun ){

        SleaveVO vo = sleaveDao.sawonLeave(sabun);
        SawonVO sawon = sawonDao.sawonView(sabun);
        model.addAttribute("vo", vo);
        model.addAttribute("sawon", sawon);
        return "/sawon/sawon_view";
    }

    //사원 삭제
    @GetMapping("/admin/sawon_delete")
    @ResponseBody
    public Map<String, Integer> sawonDelete( int sabun ){

        int res = sawonDao.sawonDelete(sabun);

        Map<String, Integer> map = new HashMap<>(); 
        map.put("result", res);

        return map;
    }

    @GetMapping("/admin/sawon_modify")
    public String sawonModify( Model model , int sabun){

        //수정할 사원 정보 불러오기 (사원 상세보기를 위한 sawonView함수 재활용)
        SawonVO sawon = sawonDao.sawonView(sabun);
        //부서 선택을 위한 부서목록
        List<DeptVO> deptList = deptDao.selectAll();

        //직급 변경 선택을 위한 직급목록
        List<JobPositionVO> jobList = jobDao.allJob();

        System.out.println(jobList);

        
        //바인딩 및 포워딩
        model.addAttribute("sawon", sawon);
        model.addAttribute("deptList", deptList);

        model.addAttribute("jobList", jobList);
        return "/sawon/sawon_modify_form";

    }

    //변경할 비밀번호와 현재 비밀번호의 중복 여부 체크
    @PostMapping("/admin/check_pwd")
    @ResponseBody
    public Map<String, String> checkPwd(SawonVO vo, String new_pwd, String ori_pwd ) {
        
        boolean res = pwdSecurity.pwdDecoding(new_pwd, ori_pwd);

        String resStr;
        if( !res ){
            //기존 비밀번호와 새 비밀번호가 일치하지 않아 변경 가능
            resStr = "possible";
        }else{
            //기존 비밀번호와 새로 입력받은 비밀번호가 일치해서 변경 불가능
            resStr = "impossible";
        }
        
        Map<String, String> map = new HashMap<>();
        map.put("result", resStr);
        return map;
    }
    
    //관리자용 사원 정보 변경
    @PostMapping("/admin/sawon_modify")
    @ResponseBody
    public Map<String, Integer> modifySawonInfo( SawonVO vo, String new_pwd ){

        //새로 입력받은 비밀번호 암호화
        String securedPwd = pwdSecurity.pwdEncoding(new_pwd);
        vo.setPwd(securedPwd);

        int res = sawonDao.sawonUpdate(vo);

        Map<String, Integer> map = new HashMap<>();
        map.put("result", res);

        return map;

    }

    //관리자 - 사원 리스트 pdf파일 다운로드 (무료 오픈소스 라이브러리 사용)
    @GetMapping("/admin/sawon_download_pdf")
    public void download_sawonPdf( HttpServletResponse response ) throws IOException{

        // 1. 응답 헤더 설정 (PDF 파일 다운로드 형식 지정)
        response.setContentType("application/pdf;charset=UTF-8");
        String headerKey = "Content-Disposition";
        String headerValue = "attachment; filename=employee_list.pdf";
        response.setHeader(headerKey, headerValue);

        // 2. 가상의 사원 데이터 생성 (실제 구현 시에는 DB에서 조회한 리스트를 넣으세요)
        // List<EmpVO> empList = empdao.selectEmpList(); 
        
        // 3. PDF 문서 객체 생성 (A4 용지, 여백 설정)
        Document document = new Document(PageSize.A4, 36, 36, 36, 36);
        PdfWriter.getInstance(document, response.getOutputStream());

        document.open();

        // PDF 한글 깨짐 방지 폰트 설정
        // Windows 시스템의 맑은 고딕(malgun.ttf)이나 Pretendard 등 프로젝트 내 사용 중인 ttf 파일 경로를 지정해야 한글이 깨지지 않습니다.
        BaseFont bf = BaseFont.createFont("C:\\Windows\\Fonts\\malgun.ttf", BaseFont.IDENTITY_H, BaseFont.EMBEDDED);
        Font titleFont = new Font(bf, 18, Font.BOLD, java.awt.Color.BLACK);
        Font headerFont = new Font(bf, 11, Font.BOLD, java.awt.Color.WHITE);
        Font bodyFont = new Font(bf, 10, Font.NORMAL, java.awt.Color.BLACK);

        // 4. 문서 제목 추가
        Paragraph title = new Paragraph("사원 정보 리스트", titleFont);
        title.setAlignment(Element.ALIGN_CENTER);
        title.setSpacingAfter(20);
        document.add(title);

        // 5. 테이블 생성 (열 개수 지정: 사번, 이름, 부서, 직급, 입사일 등 5개 기준)
        PdfPTable table = new PdfPTable(5);
        table.setWidthPercentage(100); // 가로 꽉 차게
        table.setSpacingBefore(10);
        table.setWidths(new float[] {1.5f, 2f, 2.5f, 2f, 3f}); // 컬럼 너비 비율

        // 6. 테이블 헤더 스타일 및 데이터 정의
        String[] headers = {"사원번호", "이름", "소속부서", "직급", "입사일"};
        for (String header : headers) {
            PdfPCell cell = new PdfPCell(new Phrase(header, headerFont));
            cell.setBackgroundColor(new java.awt.Color(17, 24, 39)); // 기존 테마 컬러인 다크 그레이 (#111827) 느낌 적용
            cell.setPadding(8);
            cell.setHorizontalAlignment(Element.ALIGN_CENTER);
            table.addCell(cell);
        }

        // 7. 테이블 본문 데이터 입력 (예시 반복문)
        // 실제로는 for(EmpVO emp : empList) 형태로 돌리시면 됩니다.

        List<SawonVO> sawonList = sawonDao.sawonList();
        for (SawonVO vo : sawonList) {
            table.addCell(createCell(String.valueOf(vo.getSabun()), bodyFont, Element.ALIGN_CENTER));
            table.addCell(createCell(vo.getSaname(), bodyFont, Element.ALIGN_CENTER));
            table.addCell(createCell(vo.getSaemail(), bodyFont, Element.ALIGN_CENTER));
            table.addCell(createCell(vo.getSajob(), bodyFont, Element.ALIGN_CENTER));
            table.addCell(createCell(vo.getSahire(), bodyFont, Element.ALIGN_CENTER));
            table.addCell(createCell(vo.getSatel(), bodyFont, Element.ALIGN_CENTER));
        }

        // 8. 문서에 테이블 추가 및 닫기
        document.add(table);
        document.close();
    }

    // 셀 생성을 간편하게 해주는 헬퍼 메서드
    private PdfPCell createCell(String text, Font font, int alignment) {
        PdfPCell cell = new PdfPCell(new Phrase(text, font));
        cell.setPadding(6);
        cell.setHorizontalAlignment(alignment);
        cell.setVerticalAlignment(Element.ALIGN_MIDDLE);
        return cell;
    }

}
