package kr.ac.kopo.book.vo;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class BookVO {

    private int no;
    private String title;
    private String author;
    private String cover;
    private int reviewCount;
    private double avgRating;
    private Map<Integer, Integer> ratingDist = new HashMap<>(); // rating(1~5) -> count
    private List<ReviewVO> sampleReviews;

    // 감성 비율
    private int posCount;  // 4~5점
    private int neuCount;  // 3점
    private int negCount;  // 1~2점

    public int getNo() { return no; }
    public void setNo(int no) { this.no = no; }

    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }

    public String getCover() { return cover; }
    public void setCover(String cover) { this.cover = cover; }
    public boolean hasCover() { return cover != null && !cover.isBlank(); }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public int getReviewCount() { return reviewCount; }
    public void setReviewCount(int reviewCount) { this.reviewCount = reviewCount; }

    public double getAvgRating() { return avgRating; }
    public void setAvgRating(double avgRating) { this.avgRating = avgRating; }

    public Map<Integer, Integer> getRatingDist() { return ratingDist; }
    public void setRatingDist(Map<Integer, Integer> ratingDist) { this.ratingDist = ratingDist; }

    // MyBatis: DIST1~5 컬럼 → ratingDist 맵 채우기
    public void setDist1(int v) { ratingDist.put(1, v); }
    public void setDist2(int v) { ratingDist.put(2, v); }
    public void setDist3(int v) { ratingDist.put(3, v); }
    public void setDist4(int v) { ratingDist.put(4, v); }
    public void setDist5(int v) { ratingDist.put(5, v); }
    public int getDist1() { return ratingDist.getOrDefault(1, 0); }
    public int getDist2() { return ratingDist.getOrDefault(2, 0); }
    public int getDist3() { return ratingDist.getOrDefault(3, 0); }
    public int getDist4() { return ratingDist.getOrDefault(4, 0); }
    public int getDist5() { return ratingDist.getOrDefault(5, 0); }

    public List<ReviewVO> getSampleReviews() { return sampleReviews; }
    public void setSampleReviews(List<ReviewVO> sampleReviews) { this.sampleReviews = sampleReviews; }

    public int getPosCount() { return posCount; }
    public void setPosCount(int posCount) { this.posCount = posCount; }

    public int getNeuCount() { return neuCount; }
    public void setNeuCount(int neuCount) { this.neuCount = neuCount; }

    public int getNegCount() { return negCount; }
    public void setNegCount(int negCount) { this.negCount = negCount; }

    public double getPosPercent() {
        return reviewCount > 0 ? posCount * 100.0 / reviewCount : 0;
    }
    public double getNeuPercent() {
        return reviewCount > 0 ? neuCount * 100.0 / reviewCount : 0;
    }
    public double getNegPercent() {
        return reviewCount > 0 ? negCount * 100.0 / reviewCount : 0;
    }

    public int getRatingPct(int star) {
        if (ratingDist == null || reviewCount == 0) return 0;
        return (int) Math.round(ratingDist.getOrDefault(star, 0) * 100.0 / reviewCount);
    }
}
