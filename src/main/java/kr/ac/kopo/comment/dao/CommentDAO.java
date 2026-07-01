package kr.ac.kopo.comment.dao;

import java.util.List;
import java.util.Map;
import kr.ac.kopo.comment.vo.CommentVO;

public interface CommentDAO {
    void insertComment(CommentVO comment);
    List<CommentVO> selectByBook(Map<String, Object> params);   // {bookNo, viewerNo}
    List<CommentVO> selectByMember(int memberNo);
    CommentVO selectByNo(int no);
    void deleteComment(int no);

    // 좋아요
    int existsLike(Map<String, Object> key);                    // {memberNo, commentNo}
    void insertLike(Map<String, Object> key);
    void deleteLike(Map<String, Object> key);
    List<CommentVO> selectLikedByMember(int memberNo);
}
