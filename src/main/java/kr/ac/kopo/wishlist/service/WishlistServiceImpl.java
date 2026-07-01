package kr.ac.kopo.wishlist.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.ac.kopo.wishlist.dao.WishlistDAO;
import kr.ac.kopo.wishlist.vo.WishlistVO;

@Service
public class WishlistServiceImpl implements WishlistService {

    @Autowired
    private WishlistDAO wishlistDAO;

    private Map<String, Object> key(int memberNo, int bookNo) {
        Map<String, Object> m = new HashMap<>();
        m.put("memberNo", memberNo);
        m.put("bookNo", bookNo);
        return m;
    }

    @Override
    public boolean toggle(int memberNo, int bookNo) {
        Map<String, Object> key = key(memberNo, bookNo);
        if (wishlistDAO.exists(key) > 0) {
            wishlistDAO.delete(key);
            return false; // 찜 해제됨
        }
        wishlistDAO.insert(key);
        return true; // 찜 됨
    }

    @Override
    public boolean isWishlisted(int memberNo, int bookNo) {
        return wishlistDAO.exists(key(memberNo, bookNo)) > 0;
    }

    @Override
    public List<WishlistVO> getByMember(int memberNo) {
        return wishlistDAO.selectByMember(memberNo);
    }
}
