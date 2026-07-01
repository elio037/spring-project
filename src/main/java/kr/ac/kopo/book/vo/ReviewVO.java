package kr.ac.kopo.book.vo;

public class ReviewVO {

    private String bookTitle;
    private String content;
    private int rating;

    public ReviewVO() {}

    public ReviewVO(String bookTitle, String content, int rating) {
        this.bookTitle = bookTitle;
        this.content = content;
        this.rating = rating;
    }

    public String getBookTitle() { return bookTitle; }
    public void setBookTitle(String bookTitle) { this.bookTitle = bookTitle; }

    public String getContent() { return content; }
    public void setContent(String content) { this.content = content; }

    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }

    public String getSentiment() {
        if (rating >= 4) return "긍정";
        if (rating == 3) return "중립";
        return "부정";
    }
}
