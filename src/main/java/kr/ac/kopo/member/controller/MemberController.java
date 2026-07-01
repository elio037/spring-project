package kr.ac.kopo.member.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.bind.support.SessionStatus;

import jakarta.validation.Valid;
import kr.ac.kopo.comment.service.CommentService;
import kr.ac.kopo.member.service.MemberService;
import kr.ac.kopo.member.vo.MemberVO;
import kr.ac.kopo.wishlist.service.WishlistService;

@SessionAttributes({ "userVO" })
@Controller
public class MemberController {

    @Autowired
    private MemberService memberService;

    @Autowired
    private CommentService commentService;

    @Autowired
    private WishlistService wishlistService;

    @GetMapping("/logout")
    public String logout(SessionStatus status) {
        status.setComplete();
        return "redirect:/";
    }

    @GetMapping("/login")
    public String loginForm() {
        return "member/login";
    }

    @GetMapping("/mypage")
    public String mypage(
            @SessionAttribute(name = "userVO", required = false) MemberVO userVO,
            Model model) {
        if (userVO == null) {
            return "redirect:/login";
        }
        model.addAttribute("myComments", commentService.getCommentsByMember(userVO.getNo()));
        model.addAttribute("likedReviews", commentService.getLikedComments(userVO.getNo()));
        model.addAttribute("myWishlist", wishlistService.getByMember(userVO.getNo()));
        return "member/mypage";
    }

    @PostMapping("/withdraw")
    public String withdraw(
            @SessionAttribute(name = "userVO", required = false) MemberVO userVO,
            SessionStatus status) {
        if (userVO == null) {
            return "redirect:/login";
        }
        memberService.withdraw(userVO.getNo());
        status.setComplete(); // 세션 종료(자동 로그아웃)
        return "redirect:/";
    }

    @PostMapping("/login")
    public String login(MemberVO loginVO, Model model) {
        MemberVO userVO = memberService.login(loginVO);
        if (userVO == null) {
            model.addAttribute("msg", "아이디 또는 비밀번호를 확인해주세요");
            return "member/login";
        }
        model.addAttribute("userVO", userVO);
        return "redirect:/";
    }

    @GetMapping("/join")
    public String joinForm(Model model) {
        model.addAttribute("memberVO", new MemberVO());
        return "member/join";
    }

    @PostMapping("/join")
    public String join(@Valid MemberVO memberVO, BindingResult result, Model model) {
        if (result.hasErrors()) {
            return "member/join";
        }
        if (memberService.isDuplicateId(memberVO.getId())) {
            model.addAttribute("msg", "이미 사용 중인 아이디입니다");
            return "member/join";
        }
        memberService.register(memberVO);
        // 가입 후 자동 로그인
        MemberVO userVO = memberService.login(memberVO);
        if (userVO != null) {
            model.addAttribute("userVO", userVO);
            return "redirect:/face-enroll?fromJoin=true";
        }
        return "redirect:/login";
    }

    // ── 얼굴 등록 ──────────────────────────────────────────────

    @GetMapping("/face-enroll")
    public String faceEnrollForm(
            @SessionAttribute(name = "userVO", required = false) MemberVO userVO,
            Model model) {
        if (userVO == null) return "redirect:/login";
        return "member/face-enroll";
    }

    @PostMapping("/face-enroll")
    @ResponseBody
    public String faceEnroll(
            @SessionAttribute(name = "userVO", required = false) MemberVO userVO,
            @RequestParam("descriptor") String descriptor) {
        if (userVO == null) return "UNAUTHORIZED";
        try {
            MemberVO vo = new MemberVO();
            vo.setNo(userVO.getNo());
            vo.setFaceDescriptor(descriptor);
            memberService.saveFaceDescriptor(vo);
            return "OK";
        } catch (Exception e) {
            System.out.println("[face-enroll] 저장 실패: " + e.getMessage());
            return "FAIL";
        }
    }

    // ── 얼굴 로그인 ─────────────────────────────────────────────

    @GetMapping("/face-descriptors")
    @ResponseBody
    public List<Map<String, Object>> faceDescriptors() {
        return memberService.getMembersWithFace().stream().map(m -> {
            Map<String, Object> map = new HashMap<>();
            map.put("no", m.getNo());
            map.put("descriptor", m.getFaceDescriptor());
            return map;
        }).collect(Collectors.toList());
    }

    @PostMapping("/face-login")
    public String faceLogin(@RequestParam("memberNo") int memberNo, Model model) {
        MemberVO userVO = memberService.getMemberByNo(memberNo);
        if (userVO == null) {
            model.addAttribute("msg", "얼굴 인증에 실패했습니다");
            return "member/login";
        }
        model.addAttribute("userVO", userVO);
        return "redirect:/";
    }
}
