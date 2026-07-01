-- =========================================================
--  book-review  Oracle / SQL Developer 스크립트
--  접속 계정 : hr / hr
--
--  실행 순서:
--    1) 이 파일(book_review.sql) 전체 실행  → 테이블 생성
--    2) book_data.sql 실행                  → 도서/리뷰 데이터 입력
-- =========================================================

-- 재실행 초기화 (없으면 오류 무시)
DROP TABLE BR_REVIEW CASCADE CONSTRAINTS;
DROP TABLE BR_BOOK   CASCADE CONSTRAINTS;
DROP TABLE BR_MEMBER CASCADE CONSTRAINTS;
DROP SEQUENCE SEQ_BR_MEMBER_NO;

-- =========================================================
-- 1) 회원 테이블
-- =========================================================
CREATE TABLE BR_MEMBER (
    NO              NUMBER          PRIMARY KEY,
    ID              VARCHAR2(50)    NOT NULL UNIQUE,
    PASSWORD        VARCHAR2(100),                      -- 소셜 로그인 회원은 NULL
    NICKNAME        VARCHAR2(50)    NOT NULL,
    REG_DATE        DATE            DEFAULT SYSDATE NOT NULL,
    FACE_DESCRIPTOR VARCHAR2(4000),
    PROVIDER        VARCHAR2(20)    DEFAULT 'LOCAL',    -- LOCAL / KAKAO
    PROVIDER_ID     VARCHAR2(100)                       -- 카카오 회원번호 등
);

CREATE SEQUENCE SEQ_BR_MEMBER_NO START WITH 1 INCREMENT BY 1 NOCACHE;

-- 같은 소셜 계정 중복 가입 방지 (일반 회원은 PROVIDER_ID가 NULL이라 인덱스에서 제외됨)
CREATE UNIQUE INDEX UX_BR_MEMBER_PROVIDER
    ON BR_MEMBER (CASE WHEN PROVIDER_ID IS NULL THEN NULL ELSE PROVIDER END, PROVIDER_ID);

-- 테스트 계정
INSERT INTO BR_MEMBER (NO, ID, PASSWORD, NICKNAME)
VALUES (SEQ_BR_MEMBER_NO.NEXTVAL, 'admin', '1234', '관리자');

-- =========================================================
-- 2) 도서 통계 테이블 (책별 집계본)
-- =========================================================
CREATE TABLE BR_BOOK (
    NO            NUMBER          PRIMARY KEY,
    TITLE         VARCHAR2(1500)  NOT NULL,   -- 도서 제목
    REVIEW_COUNT  NUMBER          DEFAULT 0,  -- 리뷰 수
    AVG_RATING    NUMBER(4,2)     DEFAULT 0,  -- 평점 평균
    DIST1         NUMBER          DEFAULT 0,  -- 1점 개수
    DIST2         NUMBER          DEFAULT 0,  -- 2점 개수
    DIST3         NUMBER          DEFAULT 0,  -- 3점 개수
    DIST4         NUMBER          DEFAULT 0,  -- 4점 개수
    DIST5         NUMBER          DEFAULT 0,  -- 5점 개수
    POS_COUNT     NUMBER          DEFAULT 0,  -- 긍정(4~5점)
    NEU_COUNT     NUMBER          DEFAULT 0,  -- 중립(3점)
    NEG_COUNT     NUMBER          DEFAULT 0   -- 부정(1~2점)
);

CREATE INDEX IDX_BR_BOOK_TITLE   ON BR_BOOK (TITLE);
CREATE INDEX IDX_BR_BOOK_RCOUNT  ON BR_BOOK (REVIEW_COUNT);
CREATE INDEX IDX_BR_BOOK_RATING  ON BR_BOOK (AVG_RATING);

-- =========================================================
-- 3) 샘플 리뷰 테이블 (책당 일부 리뷰 원문)
-- =========================================================
CREATE TABLE BR_REVIEW (
    NO        NUMBER          PRIMARY KEY,
    BOOK_NO   NUMBER          NOT NULL,
    CONTENT   VARCHAR2(2000),
    RATING    NUMBER(1),
    CONSTRAINT FK_BR_REVIEW_BOOK FOREIGN KEY (BOOK_NO) REFERENCES BR_BOOK (NO)
);

CREATE INDEX IDX_BR_REVIEW_BOOK ON BR_REVIEW (BOOK_NO);

COMMIT;

-- 확인
-- SELECT * FROM BR_MEMBER;
-- SELECT * FROM BR_BOOK ORDER BY REVIEW_COUNT DESC;
-- SELECT * FROM BR_REVIEW WHERE BOOK_NO = 1;
