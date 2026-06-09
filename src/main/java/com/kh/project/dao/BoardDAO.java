package com.kh.project.dao;

import com.kh.project.vo.BoardVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository // 스프링에게 이 클래스가 DB 소통을 담당하는 DAO라고 알려주는 어노테이션
public class BoardDAO {

    // MyBatis를 이용해 DB에 쿼리를 날려주는 핵심 객체
    private final SqlSession sqlSession;

    public BoardDAO(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }

    // 네임스페이스를 지정해 XML 파일의 쿼리 아이디와 연결
    private static final String NAMESPACE = "com.kh.project.dao.BoardDAO.";

    // 전체 게시글 목록
    public List<BoardVO> getBoardList() {
        // XML에 있는 id="getBoardList" 쿼리를 실행해서 리스트를 받아옴
        return sqlSession.selectList(NAMESPACE + "getBoardList");
    }

    // 게시글 작성
    public void insertBoard(BoardVO board) {
        // XML에 있는 id="insertBoard" 쿼리에 board를 실어서 보냄
        sqlSession.insert(NAMESPACE + "insertBoard", board);
    }

    // 게시글 상세 보기
    public BoardVO getBoard(int idx) {
        // XML에 있는 id="getBoard" 쿼리를 실행하여 결과값 1개를 받아옴
        return sqlSession.selectOne(NAMESPACE + "getBoard", idx);
    }

    // 조회수 증가
    public void incrementViews(int idx) {
        sqlSession.update(NAMESPACE + "incrementViews", idx);
    }

    // 게시글 수정
    public void updateBoard(BoardVO board) {
        sqlSession.update(NAMESPACE + "updateBoard", board);
    }

    // 게시글 삭제
    public void deleteBoard(int idx) {
        sqlSession.delete(NAMESPACE + "deleteBoard", idx);
    }

}
