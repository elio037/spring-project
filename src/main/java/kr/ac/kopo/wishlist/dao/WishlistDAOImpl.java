package kr.ac.kopo.wishlist.dao;

import java.util.List;
import java.util.Map;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import kr.ac.kopo.wishlist.vo.WishlistVO;

@Repository
public class WishlistDAOImpl implements WishlistDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;

    private static final String NS = "wishlist.dao.WishlistDAO.";

    @Override
    public int exists(Map<String, Object> key) {
        return sqlSession.selectOne(NS + "exists", key);
    }

    @Override
    public void insert(Map<String, Object> key) {
        sqlSession.insert(NS + "insert", key);
    }

    @Override
    public void delete(Map<String, Object> key) {
        sqlSession.delete(NS + "delete", key);
    }

    @Override
    public List<WishlistVO> selectByMember(int memberNo) {
        return sqlSession.selectList(NS + "selectByMember", memberNo);
    }
}
