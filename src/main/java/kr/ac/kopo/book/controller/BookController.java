package kr.ac.kopo.book.controller;

import java.io.UnsupportedEncodingException;
import java.net.URLDecoder;
import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;

import kr.ac.kopo.book.service.BookService;
import kr.ac.kopo.book.vo.BookVO;
import kr.ac.kopo.comment.service.CommentService;
import kr.ac.kopo.member.vo.MemberVO;
import kr.ac.kopo.wishlist.service.WishlistService;

@Controller
@RequestMapping("/books")
public class BookController {

    @Autowired
    private BookService bookService;

    @Autowired
    private CommentService commentService;

    @Autowired
    private WishlistService wishlistService;

    /** 책 목록 / 검색 */
    @GetMapping
    public String list(@RequestParam(name = "q", defaultValue = "") String q, Model model) {
        model.addAttribute("q", q);
        if (!q.isBlank()) {
            List<BookVO> results = bookService.searchBooks(q);
            model.addAttribute("books", results);
            model.addAttribute("resultMsg",
                "'" + q + "' 검색 결과: " + results.size() + "권");
        }
        model.addAttribute("loaded", bookService.isLoaded());
        model.addAttribute("totalCount", bookService.getTotalBookCount());
        return "book/list";
    }

    /** 평점 TOP 순위 */
    @GetMapping("/rank/rating")
    public String rankByRating(
            @RequestParam(name = "min", defaultValue = "30") int min,
            @RequestParam(name = "order", defaultValue = "desc") String order,
            Model model) {
        String dir = "asc".equalsIgnoreCase(order) ? "asc" : "desc";
        model.addAttribute("rankType", "rating");
        model.addAttribute("minReviews", min);
        model.addAttribute("order", dir);
        model.addAttribute("books", bookService.getTopByRating(100, min, dir));
        model.addAttribute("loaded", bookService.isLoaded());
        return "book/rank";
    }

    /** 리뷰 수 TOP 순위 */
    @GetMapping("/rank/reviews")
    public String rankByReviews(Model model) {
        model.addAttribute("rankType", "reviews");
        model.addAttribute("books", bookService.getTopByReviewCount(100));
        model.addAttribute("loaded", bookService.isLoaded());
        return "book/rank";
    }

    /** 책 상세 */
    @GetMapping("/detail")
    public String detail(@RequestParam("title") String title,
            @SessionAttribute(name = "userVO", required = false) MemberVO userVO,
            Model model) {
        BookVO book = bookService.getBook(title);
        if (book == null) {
            return "redirect:/books";
        }
        Integer viewerNo = (userVO != null) ? userVO.getNo() : null;
        model.addAttribute("book", book);
        model.addAttribute("titleEncoded",
            URLEncoder.encode(title, StandardCharsets.UTF_8));
        model.addAttribute("comments", commentService.getCommentsByBook(book.getNo(), viewerNo));
        if (userVO != null) {
            model.addAttribute("wishlisted",
                wishlistService.isWishlisted(userVO.getNo(), book.getNo()));
        }
        return "book/detail";
    }
}
