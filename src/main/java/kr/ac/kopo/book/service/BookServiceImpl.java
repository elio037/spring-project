package kr.ac.kopo.book.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import kr.ac.kopo.book.dao.BookDAO;
import kr.ac.kopo.book.vo.BookVO;
import kr.ac.kopo.book.vo.ReviewVO;

@Service
public class BookServiceImpl implements BookService {

    @Autowired
    private BookDAO bookDAO;

    @Override
    public List<BookVO> searchBooks(String keyword) {
        if (keyword == null || keyword.isBlank()) return List.of();
        return bookDAO.searchBooks(keyword.trim());
    }

    @Override
    public List<BookVO> getTopByRating(int topN, int minReviews) {
        return getTopByRating(topN, minReviews, "desc");
    }

    @Override
    public List<BookVO> getTopByRating(int topN, int minReviews, String order) {
        // SQL 주입 방지: asc/desc 만 허용
        String dir = "asc".equalsIgnoreCase(order) ? "ASC" : "DESC";
        return bookDAO.topByRating(topN, minReviews, dir);
    }

    @Override
    public List<BookVO> getTopByReviewCount(int topN) {
        return bookDAO.topByReviewCount(topN);
    }

    @Override
    public BookVO getBook(String title) {
        BookVO book = bookDAO.selectByTitle(title);
        if (book != null) {
            book.setSampleReviews(bookDAO.selectReviews(book.getNo()));
        }
        return book;
    }

    @Override
    public List<ReviewVO> getReviews(String title, int page, int size) {
        BookVO book = bookDAO.selectByTitle(title);
        if (book == null) return List.of();
        List<ReviewVO> all = bookDAO.selectReviews(book.getNo());
        int from = Math.min(page * size, all.size());
        int to   = Math.min(from + size, all.size());
        return all.subList(from, to);
    }

    @Override
    public boolean isLoaded() {
        // 데이터가 DB에 있으므로 항상 사용 가능
        return true;
    }

    @Override
    public int getTotalBookCount() {
        return bookDAO.countBooks();
    }

    @Override
    public List<BookVO> getAllBooks() {
        return bookDAO.selectAllBooks();
    }

    @Override
    public void updateCover(int no, String cover) {
        bookDAO.updateCover(no, cover);
    }
}
