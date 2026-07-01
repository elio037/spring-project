package kr.ac.kopo.member.vo;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Pattern;

public class MemberVO {

    private int no;

    @Pattern(regexp = "^[A-Za-z][A-Za-z0-9]*$", message = "아이디는 영문자로 시작해야 합니다")
    @NotEmpty(message = "필수 항목입니다")
    private String id;

    @NotEmpty(message = "필수 항목입니다")
    private String password;

    @NotEmpty(message = "필수 항목입니다")
    private String nickname;

    private String regDate;
    private String faceDescriptor;
    private String role;

    // 소셜 로그인(카카오 등)
    private String provider;     // LOCAL / KAKAO
    private String providerId;   // 소셜 서비스의 사용자 고유 ID

    public int getNo() { return no; }
    public void setNo(int no) { this.no = no; }

    public String getId() { return id; }
    public void setId(String id) { this.id = id; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    public String getFaceDescriptor() { return faceDescriptor; }
    public void setFaceDescriptor(String faceDescriptor) { this.faceDescriptor = faceDescriptor; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public String getProvider() { return provider; }
    public void setProvider(String provider) { this.provider = provider; }

    public String getProviderId() { return providerId; }
    public void setProviderId(String providerId) { this.providerId = providerId; }

    public boolean isAdmin() { return "ADMIN".equals(role); }
    public boolean isFaceRegistered() { return faceDescriptor != null && !faceDescriptor.isBlank(); }

    @Override
    public String toString() {
        return "MemberVO [no=" + no + ", id=" + id + ", nickname=" + nickname + "]";
    }
}
