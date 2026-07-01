package kr.ac.kopo.wishlist.service;

import java.util.List;
import kr.ac.kopo.wishlist.vo.WishlistVO;

public interface WishlistService {
    /** 찜 토글: 찜 상태면 해제, 아니면 추가. 결과(현재 찜 상태) 반환 */
    boolean toggle(int memberNo, int bookNo);

    boolean isWishlisted(int memberNo, int bookNo);

    List<WishlistVO> getByMember(int memberNo);
}
