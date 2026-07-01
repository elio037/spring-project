import java.io.*;
import java.nio.charset.StandardCharsets;
import java.util.*;
import java.util.stream.Collectors;

/**
 * 알라딘 리뷰 CSV를 집계해 "리뷰 많은 순 상위 N권"만 골라
 * Oracle SQL Developer에서 실행 가능한 INSERT 스크립트(book_data.sql)를 생성한다.
 *
 * 사용법:
 *   javac GenBookSql.java
 *   java GenBookSql
 */
public class GenBookSql {

    static final String[] CSV_CANDIDATES = {
        "D:/Lecture/_AIService26/data/aladin_reviews_filtered.csv",
        "C:/Users/user/Desktop/크롤링 내용/aladin_reviews_clean_3col.csv"
    };
    static final String OUT = "D:/Lecture/spring-workspace/book-review/src/main/resources/sql/book_data.sql";

    static final int TOP_N             = 200;  // 상위 몇 권
    static final int MAX_SAMPLE        = 20;   // 책당 샘플 리뷰 수
    static final int MAX_TITLE_LEN     = 400;  // 제목 최대 길이
    static final int MAX_CONTENT_LEN   = 500;  // 리뷰 본문 최대 길이

    static class Book {
        String title;
        int count;
        long ratingSum;
        int[] dist = new int[6];
        int pos, neu, neg;
        List<String[]> samples = new ArrayList<>(); // {content, rating}
        void add(String content, int rating) {
            count++; ratingSum += rating; dist[rating]++;
            if (rating >= 4) pos++; else if (rating == 3) neu++; else neg++;
            if (samples.size() < MAX_SAMPLE) samples.add(new String[]{content, String.valueOf(rating)});
        }
    }

    public static void main(String[] args) throws Exception {
        File csv = null;
        for (String p : CSV_CANDIDATES) { File f = new File(p); if (f.exists()) { csv = f; break; } }
        if (csv == null) { System.err.println("CSV 파일을 찾을 수 없습니다."); return; }
        System.out.println("CSV 읽는 중: " + csv.getAbsolutePath());

        Map<String, Book> map = new HashMap<>();
        long rows = 0;
        try (BufferedReader br = new BufferedReader(
                new InputStreamReader(new FileInputStream(csv), StandardCharsets.UTF_8))) {
            String line = br.readLine();             // 헤더
            if (line != null && line.startsWith("\uFEFF")) { /* BOM */ }
            while ((line = br.readLine()) != null) {
                String[] parts = parseCsv(line);
                if (parts.length < 3) continue;
                String title = parts[0].trim();
                String content = parts[1].trim();
                int rating;
                try { rating = Integer.parseInt(parts[2].trim()); } catch (Exception e) { continue; }
                if (rating < 1 || rating > 5 || title.isEmpty()) continue;
                map.computeIfAbsent(title, k -> { Book b = new Book(); b.title = k; return b; })
                   .add(content, rating);
                if (++rows % 200000 == 0) System.out.println("  " + rows + "행 처리...");
            }
        }
        System.out.println("총 " + rows + "행, 고유 도서 " + map.size() + "종");

        List<Book> top = map.values().stream()
                .sorted(Comparator.comparingInt((Book b) -> b.count).reversed())
                .limit(TOP_N)
                .collect(Collectors.toList());
        System.out.println("상위 " + top.size() + "권 선정 완료");

        new File(OUT).getParentFile().mkdirs();
        int reviewNo = 0;
        try (Writer w = new OutputStreamWriter(new FileOutputStream(OUT), StandardCharsets.UTF_8)) {
            w.write("-- =========================================================\n");
            w.write("-- book-review 데이터 (리뷰 많은 순 상위 " + top.size() + "권)\n");
            w.write("-- 먼저 book_review.sql 로 테이블을 생성한 뒤 실행하세요.\n");
            w.write("-- SQL Developer: 파일 열 때 인코딩 UTF-8 확인\n");
            w.write("-- =========================================================\n\n");

            int bookNo = 0;
            for (Book b : top) {
                bookNo++;
                double avg = b.count > 0 ? Math.round(b.ratingSum * 100.0 / b.count) / 100.0 : 0;
                String title = esc(trunc(b.title, MAX_TITLE_LEN));
                w.write("INSERT INTO BR_BOOK (NO, TITLE, REVIEW_COUNT, AVG_RATING, DIST1, DIST2, DIST3, DIST4, DIST5, POS_COUNT, NEU_COUNT, NEG_COUNT) VALUES (");
                w.write(bookNo + ", '" + title + "', " + b.count + ", " + avg + ", "
                        + b.dist[1] + ", " + b.dist[2] + ", " + b.dist[3] + ", " + b.dist[4] + ", " + b.dist[5] + ", "
                        + b.pos + ", " + b.neu + ", " + b.neg + ");\n");
                for (String[] s : b.samples) {
                    reviewNo++;
                    String content = esc(trunc(s[0], MAX_CONTENT_LEN));
                    w.write("INSERT INTO BR_REVIEW (NO, BOOK_NO, CONTENT, RATING) VALUES (");
                    w.write(reviewNo + ", " + bookNo + ", '" + content + "', " + s[1] + ");\n");
                }
            }
            w.write("\nCOMMIT;\n");
        }
        System.out.println("생성 완료: " + OUT);
        System.out.println("책 " + top.size() + "권, 리뷰 " + reviewNo + "건");
    }

    static String trunc(String s, int n) { return s.length() > n ? s.substring(0, n) : s; }
    static String esc(String s) { return s.replace("'", "''"); }

    /** 큰따옴표 처리 CSV 파서 */
    static String[] parseCsv(String line) {
        List<String> fields = new ArrayList<>();
        boolean inQuote = false;
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < line.length(); i++) {
            char c = line.charAt(i);
            if (c == '"') {
                if (inQuote && i + 1 < line.length() && line.charAt(i + 1) == '"') { sb.append('"'); i++; }
                else inQuote = !inQuote;
            } else if (c == ',' && !inQuote) {
                fields.add(sb.toString()); sb.setLength(0);
            } else sb.append(c);
        }
        fields.add(sb.toString());
        return fields.toArray(new String[0]);
    }
}
