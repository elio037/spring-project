package kr.ac.kopo.member.dao;

import java.util.List;
import kr.ac.kopo.member.vo.MemberVO;

public interface MemberDAO {
    MemberVO login(MemberVO loginVO);
    void insertMember(MemberVO memberVO);
    int countById(String id);
    void saveFaceDescriptor(MemberVO memberVO);
    List<MemberVO> selectAllWithFace();
    MemberVO selectMemberByNo(int no);
    List<MemberVO> selectAllMembers();
    MemberVO selectByProviderId(MemberVO key);
    void insertSocialMember(MemberVO memberVO);
    void deleteMember(int no);
}
