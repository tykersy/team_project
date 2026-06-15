package com.kh.project.dao;

import com.kh.project.vo.BoardVO;
import org.apache.ibatis.session.SqlSession;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Map;

@Repository
public class BoardDAO {

    private final SqlSession sqlSession;

    public BoardDAO(SqlSession sqlSession) {
        this.sqlSession = sqlSession;
    }

    private static final String NAMESPACE = "com.kh.project.dao.BoardDAO.";

    // 기존 페이징용 메서드와 별개로 대시보드용 메서드 추가
    public List<BoardVO> getBoardListAll() {
    return sqlSession.selectList(NAMESPACE + "getBoardListAll");
    }

    // 페이징 처리를 위해 Map을 인자로 받도록 변경
    public List<BoardVO> getBoardList(Map<String, Object> map) {
    return sqlSession.selectList(NAMESPACE + "getBoardList", map);
    }
    
    // 전체 게시글 수 조회 (페이징 계산용)
    public int getTotalCount(Map<String, Object> map) {
    return sqlSession.selectOne(NAMESPACE + "getTotalCount", map);
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
