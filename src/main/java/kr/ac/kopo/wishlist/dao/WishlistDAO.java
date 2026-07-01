package kr.ac.kopo.wishlist.dao;

import java.util.List;
import java.util.Map;
import kr.ac.kopo.wishlist.vo.WishlistVO;

public interface WishlistDAO {
    int exists(Map<String, Object> key);       // {memberNo, bookNo}
    void insert(Map<String, Object> key);
    void delete(Map<String, Object> key);
    List<WishlistVO> selectByMember(int memberNo);
}
