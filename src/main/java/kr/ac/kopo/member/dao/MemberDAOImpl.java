package kr.ac.kopo.member.dao;

import java.util.List;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import kr.ac.kopo.member.vo.MemberVO;

@Repository
public class MemberDAOImpl implements MemberDAO {

    @Autowired
    private SqlSessionTemplate sqlSession;

    private static final String NS = "member.dao.MemberDAO.";

    @Override
    public MemberVO login(MemberVO loginVO) {
        return sqlSession.selectOne(NS + "login", loginVO);
    }

    @Override
    public void insertMember(MemberVO memberVO) {
        sqlSession.insert(NS + "insertMember", memberVO);
    }

    @Override
    public int countById(String id) {
        return sqlSession.selectOne(NS + "countById", id);
    }

    @Override
    public void saveFaceDescriptor(MemberVO memberVO) {
        sqlSession.update(NS + "saveFaceDescriptor", memberVO);
    }

    @Override
    public List<MemberVO> selectAllWithFace() {
        return sqlSession.selectList(NS + "selectAllWithFace");
    }

    @Override
    public MemberVO selectMemberByNo(int no) {
        return sqlSession.selectOne(NS + "selectMemberByNo", no);
    }

    @Override
    public List<MemberVO> selectAllMembers() {
        return sqlSession.selectList(NS + "selectAllMembers");
    }

    @Override
    public MemberVO selectByProviderId(MemberVO key) {
        return sqlSession.selectOne(NS + "selectByProviderId", key);
    }

    @Override
    public void insertSocialMember(MemberVO memberVO) {
        sqlSession.insert(NS + "insertSocialMember", memberVO);
    }

    @Override
    public void deleteMember(int no) {
        sqlSession.delete(NS + "deleteMember", no);
    }
}
