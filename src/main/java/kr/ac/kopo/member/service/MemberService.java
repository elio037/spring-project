package kr.ac.kopo.member.service;

import java.util.List;
import kr.ac.kopo.member.vo.MemberVO;

public interface MemberService {
    MemberVO login(MemberVO loginVO);
    void register(MemberVO memberVO);
    boolean isDuplicateId(String id);
    void saveFaceDescriptor(MemberVO memberVO);
    List<MemberVO> getMembersWithFace();
    MemberVO getMemberByNo(int no);
    List<MemberVO> getAllMembers();

    /** 소셜 로그인: provider+providerId로 회원을 찾고, 없으면 새로 가입시킨 뒤 회원 정보를 반환 */
    MemberVO socialLogin(String provider, String providerId, String nickname);

    /** 회원 탈퇴: 해당 회원을 삭제 */
    void withdraw(int no);
}
