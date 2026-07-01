package kr.ac.kopo.comment.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.bind.annotation.SessionAttributes;

import kr.ac.kopo.comment.service.CommentService;
import kr.ac.kopo.comment.vo.CommentVO;
import kr.ac.kopo.member.vo.MemberVO;

@SessionAttributes({ "userVO" })
@Controller
public class CommentController {

    @Autowired
    private CommentService commentService;

    /** 책 상세에서 댓글 작성 */
    @PostMapping("/comments")
    public String add(
            @SessionAttribute(name = "userVO", required = false) MemberVO userVO,
            @RequestParam("bookNo") int bookNo,
            @RequestParam("title") String title,
            @RequestParam("content") String content,
            @RequestParam(name = "rating", defaultValue = "5") int rating) {

        if (userVO == null) {
            return "redirect:/login";
        }
        if (content != null && !content.isBlank()) {
            if (rating < 1 || rating > 5) rating = 5;
            CommentVO c = new CommentVO();
            c.setMemberNo(userVO.getNo());
            c.setBookNo(bookNo);
            c.setContent(content.trim());
            c.setRating(rating);
            commentService.addComment(c);
        }
        return "redirect:/books/detail?title=" + enc(title);
    }

    /** 리뷰 좋아요 토글. from=detail 이면 책 상세로, 기본은 마이페이지로 복귀 */
    @PostMapping("/comments/like")
    public String like(
            @SessionAttribute(name = "userVO", required = false) MemberVO userVO,
            @RequestParam("commentNo") int commentNo,
            @RequestParam(name = "from", defaultValue = "detail") String from,
            @RequestParam(name = "title", required = false) String title) {

        if (userVO == null) {
            return "redirect:/login";
        }
        commentService.toggleLike(commentNo, userVO.getNo());

        if ("mypage".equals(from)) {
            return "redirect:/mypage";
        }
        return "redirect:/books/detail?title=" + enc(title);
    }

    /** 댓글 삭제 (본인 것만). from=detail 이면 책 상세로, 기본은 마이페이지로 복귀 */
    @PostMapping("/comments/delete")
    public String delete(
            @SessionAttribute(name = "userVO", required = false) MemberVO userVO,
            @RequestParam("commentNo") int commentNo,
            @RequestParam(name = "from", defaultValue = "mypage") String from,
            @RequestParam(name = "title", required = false) String title) {

        if (userVO == null) {
            return "redirect:/login";
        }
        commentService.deleteOwnComment(commentNo, userVO.getNo());

        if ("detail".equals(from) && title != null) {
            return "redirect:/books/detail?title=" + enc(title);
        }
        return "redirect:/mypage";
    }

    private String enc(String s) {
        return URLEncoder.encode(s, StandardCharsets.UTF_8);
    }
}
