package kr.ac.kopo.wishlist.vo;

public class WishlistVO {

    private int no;
    private int memberNo;
    private int bookNo;
    private String regDate;

    // 조인으로 채우는 도서 표시용 필드 (BR_BOOK)
    private String bookTitle;
    private String cover;
    private int reviewCount;
    private double avgRating;

    public int getNo() { return no; }
    public void setNo(int no) { this.no = no; }

    public int getMemberNo() { return memberNo; }
    public void setMemberNo(int memberNo) { this.memberNo = memberNo; }

    public int getBookNo() { return bookNo; }
    public void setBookNo(int bookNo) { this.bookNo = bookNo; }

    public String getRegDate() { return regDate; }
    public void setRegDate(String regDate) { this.regDate = regDate; }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getCover() { return cover; }
    public void setCover(String cover) { this.cover = cover; }
    public boolean hasCover() { return cover != null && !cover.isBlank(); }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    public double getAvgRating() { return avgRating; }
    public void setAvgRating(double avgRating) { this.avgRating = avgRating; }
}
