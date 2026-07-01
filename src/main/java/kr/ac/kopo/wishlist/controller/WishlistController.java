package kr.ac.kopo.wishlist.controller;

import java.net.URLEncoder;
import java.nio.charset.StandardCharsets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.bind.annotation.SessionAttributes;

import kr.ac.kopo.member.vo.MemberVO;
import kr.ac.kopo.wishlist.service.WishlistService;

@SessionAttributes({ "userVO" })
@Controller
public class WishlistController {

    @Autowired
    private WishlistService wishlistService;

    /** 찜 토글. from=mypage 면 마이페이지로, 기본은 책 상세로 복귀 */
    @PostMapping("/wishlist/toggle")
    public String toggle(
            @SessionAttribute(name = "userVO", required = false) MemberVO userVO,
            @RequestParam("bookNo") int bookNo,
            @RequestParam(name = "from", defaultValue = "detail") String from,
            @RequestParam(name = "title", required = false) String title) {

        if (userVO == null) {
            return "redirect:/login";
        }
        wishlistService.toggle(userVO.getNo(), bookNo);

        if ("mypage".equals(from)) {
            return "redirect:/mypage";
        }
        return "redirect:/books/detail?title=" + URLEncoder.encode(title, StandardCharsets.UTF_8);
    }
}
