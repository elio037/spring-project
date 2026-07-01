package kr.ac.kopo.comment.dao;

import java.util.List;
import java.util.Map;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import kr.ac.kopo.comment.vo.CommentVO;

@Repository
public class CommentDAOImpl implements CommentDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;

    private static final String NS = "comment.dao.CommentDAO.";

    @Override
    public void insertComment(CommentVO comment) {
        sqlSession.insert(NS + "insertComment", comment);
    }

    @Override
    public List<CommentVO> selectByBook(Map<String, Object> params) {
        return sqlSession.selectList(NS + "selectByBook", params);
    }

    @Override
    public List<CommentVO> selectByMember(int memberNo) {
        return sqlSession.selectList(NS + "selectByMember", memberNo);
    }

    @Override
    public CommentVO selectByNo(int no) {
        return sqlSession.selectOne(NS + "selectByNo", no);
    }

    @Override
    public void deleteComment(int no) {
        sqlSession.delete(NS + "deleteComment", no);
    }

    // ── 좋아요 ──────────────────────────────────────────
    @Override
    public int existsLike(Map<String, Object> key) {
        return sqlSession.selectOne(NS + "existsLike", key);
    }

    @Override
    public void insertLike(Map<String, Object> key) {
        sqlSession.insert(NS + "insertLike", key);
    }

    @Override
    public void deleteLike(Map<String, Object> key) {
        sqlSession.delete(NS + "deleteLike", key);
    }

    @Override
    public List<CommentVO> selectLikedByMember(int memberNo) {
        return sqlSession.selectList(NS + "selectLikedByMember", memberNo);
    }
}
