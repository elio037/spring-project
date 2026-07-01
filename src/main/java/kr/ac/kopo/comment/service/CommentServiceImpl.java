package kr.ac.kopo.comment.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.ac.kopo.comment.dao.CommentDAO;
import kr.ac.kopo.comment.vo.CommentVO;

@Service
public class CommentServiceImpl implements CommentService {

    @Autowired
    private CommentDAO commentDAO;

    @Override
    public void addComment(CommentVO comment) {
        commentDAO.insertComment(comment);
    }

    @Override
    public List<CommentVO> getCommentsByBook(int bookNo, Integer viewerNo) {
        Map<String, Object> params = new HashMap<>();
        params.put("bookNo", bookNo);
        params.put("viewerNo", viewerNo);
        return commentDAO.selectByBook(params);
    }

    @Override
    public List<CommentVO> getCommentsByMember(int memberNo) {
        return commentDAO.selectByMember(memberNo);
    }

    @Override
    public boolean deleteOwnComment(int commentNo, int memberNo) {
        CommentVO c = commentDAO.selectByNo(commentNo);
        if (c == null || c.getMemberNo() != memberNo) {
            return false; // 없거나 남의 댓글이면 삭제 거부
        }
        commentDAO.deleteComment(commentNo);
        return true;
    }

    @Override
    public boolean toggleLike(int commentNo, int memberNo) {
        Map<String, Object> key = new HashMap<>();
        key.put("memberNo", memberNo);
        key.put("commentNo", commentNo);
        if (commentDAO.existsLike(key) > 0) {
            commentDAO.deleteLike(key);
            return false; // 좋아요 취소됨
        }
        commentDAO.insertLike(key);
        return true; // 좋아요 됨
    }

    @Override
    public List<CommentVO> getLikedComments(int memberNo) {
        return commentDAO.selectLikedByMember(memberNo);
    }
}
