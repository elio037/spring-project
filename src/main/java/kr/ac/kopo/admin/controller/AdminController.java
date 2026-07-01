package kr.ac.kopo.admin.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttribute;

import kr.ac.kopo.book.service.BookService;
import kr.ac.kopo.member.service.MemberService;
import kr.ac.kopo.member.vo.MemberVO;

@Controller
@RequestMapping("/admin")
public class AdminController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private BookService bookService;

    /** 관리자 권한 확인 */
    private boolean isAdmin(MemberVO userVO) {
        return userVO != null && userVO.isAdmin();
    }

    /** 관리자 대시보드 */
    @GetMapping
    public String dashboard(
            @SessionAttribute(name = "userVO", required = false) MemberVO userVO,
            Model model) {
        if (!isAdmin(userVO)) return "redirect:/";
        model.addAttribute("memberCount", memberService.getAllMembers().size());
        model.addAttribute("bookCount", bookService.getTotalBookCount());
        return "admin/dashboard";
    }

    /** 회원 목록 */
    @GetMapping("/members")
    public String members(
            @SessionAttribute(name = "userVO", required = false) MemberVO userVO,
            Model model) {
        if (!isAdmin(userVO)) return "redirect:/";
        model.addAttribute("members", memberService.getAllMembers());
        return "admin/members";
    }

    /** 도서 표지 관리 */
    @GetMapping("/books")
    public String books(
            @SessionAttribute(name = "userVO", required = false) MemberVO userVO,
            Model model) {
        if (!isAdmin(userVO)) return "redirect:/";
        model.addAttribute("books", bookService.getAllBooks());
        return "admin/books";
    }

    /** 도서 표지 경로 수정 */
    @PostMapping("/books/cover")
    public String updateCover(
            @SessionAttribute(name = "userVO", required = false) MemberVO userVO,
            @RequestParam("no") int no,
            @RequestParam(name = "cover", defaultValue = "") String cover) {
        if (!isAdmin(userVO)) return "redirect:/";
        bookService.updateCover(no, cover.isBlank() ? null : cover.trim());
        return "redirect:/admin/books";
    }
}
