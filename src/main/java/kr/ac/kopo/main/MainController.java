package kr.ac.kopo.main;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

import kr.ac.kopo.book.service.BookService;
import kr.ac.kopo.book.vo.BookVO;

@Controller
public class MainController {

    @Autowired
    private BookService bookService;

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("loaded", bookService.isLoaded());
        if (bookService.isLoaded()) {
            List<BookVO> topRating  = bookService.getTopByRating(8, 50);
            List<BookVO> topReviews = bookService.getTopByReviewCount(8);
            model.addAttribute("topRating",  topRating);
            model.addAttribute("topReviews", topReviews);
            model.addAttribute("totalCount", bookService.getTotalBookCount());
        }
        return "index";
    }
}
