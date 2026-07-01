package kr.ac.kopo.book.dao;

import java.util.List;

import kr.ac.kopo.book.vo.BookVO;
import kr.ac.kopo.book.vo.ReviewVO;

public interface BookDAO {

    /** 제목 검색 (리뷰 많은 순, 최대 50건) */
    List<BookVO> searchBooks(String keyword);

    /** 평점 순 (최소 리뷰 minReviews 이상, 상위 topN, order=ASC|DESC) */
    List<BookVO> topByRating(int topN, int minReviews, String order);

    /** 리뷰 많은 순 (상위 topN) */
    List<BookVO> topByReviewCount(int topN);

    /** 단일 도서 상세 (제목으로 조회) */
    BookVO selectByTitle(String title);

    /** 도서별 샘플 리뷰 */
    List<ReviewVO> selectReviews(int bookNo);

    /** 전체 도서 수 */
    int countBooks();

    /** [관리자] 전체 도서 목록 */
    List<BookVO> selectAllBooks();

    /** [관리자] 표지 경로 수정 */
    void updateCover(int no, String cover);
}
