package kr.ac.kopo.member.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import kr.ac.kopo.member.dao.MemberDAO;
import kr.ac.kopo.member.vo.MemberVO;

@Service
public class MemberServiceImpl implements MemberService {

    @Autowired
    private MemberDAO memberDAO;

    @Override
    public MemberVO login(MemberVO loginVO) {
        return memberDAO.login(loginVO);
    }

    @Override
    public void register(MemberVO memberVO) {
        memberDAO.insertMember(memberVO);
    }

    @Override
    public boolean isDuplicateId(String id) {
        return memberDAO.countById(id) > 0;
    }

    @Override
    public void saveFaceDescriptor(MemberVO memberVO) {
        memberDAO.saveFaceDescriptor(memberVO);
    }

    @Override
    public List<MemberVO> getMembersWithFace() {
        return memberDAO.selectAllWithFace();
    }

    @Override
    public MemberVO getMemberByNo(int no) {
        return memberDAO.selectMemberByNo(no);
    }

    @Override
    public List<MemberVO> getAllMembers() {
        return memberDAO.selectAllMembers();
    }

    @Override
    public MemberVO socialLogin(String provider, String providerId, String nickname) {
        MemberVO key = new MemberVO();
        key.setProvider(provider);
        key.setProviderId(providerId);

        MemberVO found = memberDAO.selectByProviderId(key);
        if (found != null) {
            return found; // 이미 가입된 소셜 회원
        }

        // 최초 로그인 → 자동 회원가입
        MemberVO vo = new MemberVO();
        vo.setId(provider.toLowerCase() + "_" + providerId);
        vo.setNickname((nickname != null && !nickname.isBlank()) ? nickname : provider + "회원");
        vo.setProvider(provider);
        vo.setProviderId(providerId);
        memberDAO.insertSocialMember(vo); // selectKey로 no가 채워짐

        return memberDAO.selectMemberByNo(vo.getNo());
    }

    @Override
    public void withdraw(int no) {
        memberDAO.deleteMember(no);
    }
}
