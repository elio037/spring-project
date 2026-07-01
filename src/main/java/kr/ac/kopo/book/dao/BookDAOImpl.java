package kr.ac.kopo.book.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.ac.kopo.book.vo.BookVO;
import kr.ac.kopo.book.vo.ReviewVO;

@Repository
public class BookDAOImpl implements BookDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;

    private static final String NS = "book.dao.BookDAO.";

    @Override
    public List<BookVO> searchBooks(String keyword) {
        return sqlSession.selectList(NS + "searchBooks", keyword);
    }

    @Override
    public List<BookVO> topByRating(int topN, int minReviews, String order) {
        Map<String, Object> params = new HashMap<>();
        params.put("topN", topN);
        params.put("minReviews", minReviews);
        params.put("order", order);
        return sqlSession.selectList(NS + "topByRating", params);
    }

    @Override
    public List<BookVO> topByReviewCount(int topN) {
        return sqlSession.selectList(NS + "topByReviewCount", topN);
    }

    @Override
    public BookVO selectByTitle(String title) {
        return sqlSession.selectOne(NS + "selectByTitle", title);
    }

    @Override
    public List<ReviewVO> selectReviews(int bookNo) {
        return sqlSession.selectList(NS + "selectReviews", bookNo);
    }

    @Override
    public int countBooks() {
        return sqlSession.selectOne(NS + "countBooks");
    }

    @Override
    public List<BookVO> selectAllBooks() {
        return sqlSession.selectList(NS + "selectAllBooks");
    }

    @Override
    public void updateCover(int no, String cover) {
        Map<String, Object> params = new HashMap<>();
        params.put("no", no);
        params.put("cover", cover);
        sqlSession.update(NS + "updateCover", params);
    }
}
