package kr.ac.kopo.comment.vo;

public class CommentVO {

    private int no;
    private int memberNo;
    private int bookNo;
    private String content;
    private int rating;        // 별점 1~5
    private String regDate;

    // 조인으로 채우는 표시용 필드
    private String nickname;   // 작성자 닉네임 (BR_MEMBER)
    private String bookTitle;  // 책 제목 (BR_BOOK)
    private int likeCount;     // 좋아요 수
    private int likedByMe;     // 현재 사용자가 좋아요 했는지 (1/0)

    public int getNo() { return no; }
    public void setNo(int no) { this.no = no; }

    public int getMemberNo() { return memberNo; }
    public void setMemberNo(int memberNo) { this.memberNo = memberNo; }

    public int getBookNo() { return bookNo; }
    public void setBookNo(int bookNo) { this.bookNo = bookNo; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getSentiment() {
        if (rating >= 4) return "긍정";
        if (rating == 3) return "중립";
        return "부정";
    }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    public String getNickname() { return nickname; }
    public void setNickname(String nickname) { this.nickname = nickname; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public int getLikeCount() { return likeCount; }
    public void setLikeCount(int likeCount) { this.likeCount = likeCount; }

    public int getLikedByMe() { return likedByMe; }
    public void setLikedByMe(int likedByMe) { this.likedByMe = likedByMe; }
    public boolean isLiked() { return likedByMe > 0; }
}
