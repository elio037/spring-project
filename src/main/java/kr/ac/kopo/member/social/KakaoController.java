package kr.ac.kopo.member.social;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;

import kr.ac.kopo.member.social.KakaoService.KakaoUser;
import kr.ac.kopo.member.service.MemberService;
import kr.ac.kopo.member.vo.MemberVO;

/**
 * 카카오 소셜 로그인 진입/콜백 컨트롤러.
 * 기존 일반·얼굴 로그인과 동일하게 세션 속성 "userVO"에 로그인 회원을 저장한다.
 */
@SessionAttributes({ "userVO" })
@Controller
public class KakaoController {

    @Autowired
    private KakaoService kakaoService;

    @Autowired
    private MemberService memberService;

    /** 로그인 버튼 → 카카오 인가 페이지로 리다이렉트 */
    @GetMapping("/oauth/kakao")
    public String kakaoLogin() {
        return "redirect:" + kakaoService.authorizeUrl();
    }

    /** 카카오가 인가 코드를 들고 돌아오는 콜백 */
    @GetMapping("/oauth/kakao/callback")
    public String kakaoCallback(@RequestParam("code") String code, Model model) {
        try {
            String accessToken = kakaoService.getAccessToken(code);
            KakaoUser kakaoUser = kakaoService.getUserInfo(accessToken);

            MemberVO userVO = memberService.socialLogin(
                    "KAKAO", kakaoUser.providerId(), kakaoUser.nickname());

            model.addAttribute("userVO", userVO); // 세션에 로그인 상태 저장
            return "redirect:/";
        } catch (Exception e) {
            System.out.println("[kakao-login] 실패: " + e.getMessage());
            model.addAttribute("msg", "카카오 로그인에 실패했습니다. 다시 시도해주세요.");
            return "member/login";
        }
    }
}
