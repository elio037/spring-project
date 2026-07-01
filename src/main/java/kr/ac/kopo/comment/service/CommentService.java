package kr.ac.kopo.comment.service;

import java.util.List;
import kr.ac.kopo.comment.vo.CommentVO;

public interface CommentService {
    void addComment(CommentVO comment);

    /** 특정 책의 리뷰 목록 (viewerNo: 좋아요 여부 판정용, 비로그인 시 null) */
    List<CommentVO> getCommentsByBook(int bookNo, Integer viewerNo);

    List<CommentVO> getCommentsByMember(int memberNo);

    /** 본인 댓글만 삭제 (memberNo 일치 확인). 삭제하면 true */
    boolean deleteOwnComment(int commentNo, int memberNo);

    /** 좋아요 토글: 누른 상태면 취소, 아니면 추가. 결과(현재 좋아요 상태) 반환 */
    boolean toggleLike(int commentNo, int memberNo);

    /** 내가 좋아요한 리뷰 목록 */
    List<CommentVO> getLikedComments(int memberNo);
}
