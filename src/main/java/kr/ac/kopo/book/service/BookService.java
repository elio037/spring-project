package kr.ac.kopo.book.service;

import java.util.List;
import kr.ac.kopo.book.vo.BookVO;
import kr.ac.kopo.book.vo.ReviewVO;

public interface BookService {
    /** 제목 검색 (최대 50건) */
    List<BookVO> searchBooks(String keyword);

    /** 평점 높은 순 (최소 리뷰 n건 이상) */
    List<BookVO> getTopByRating(int topN, int minReviews);

    /** 평점 순 (order=asc|desc, 최소 리뷰 n건 이상) */
    List<BookVO> getTopByRating(int topN, int minReviews, String order);

    /** 리뷰 많은 순 */
    List<BookVO> getTopByReviewCount(int topN);

    /** 단일 책 상세 */
    BookVO getBook(String title);

    /** 책 리뷰 목록 (페이징) */
    List<ReviewVO> getReviews(String title, int page, int size);

    /** 전체 데이터 로딩 완료 여부 */
    boolean isLoaded();

    /** 전체 책 수 */
    int getTotalBookCount();

    /** [관리자] 전체 도서 목록 */
    List<BookVO> getAllBooks();

    /** [관리자] 표지 경로 수정 */
    void updateCover(int no, String cover);
}
