# 📚 BookReview — 독자 리뷰 기반 도서 탐색 플랫폼

알라딘 도서 리뷰 크롤링 데이터를 기반으로 **도서 검색 · 평점/리뷰 순위 · 상세 통계(평점 분포 · 감성 분석)** 를 제공하고,
**얼굴 인식 로그인(face-api.js)** 을 지원하는 Spring MVC 웹 애플리케이션입니다.

> 수업 기말 프로젝트 (kr.ac.kopo)

---

## ✨ 주요 기능

| 기능 | 설명 |
|------|------|
| **메인 대시보드** | 평점 TOP 8 · 리뷰 수 TOP 8 큐레이션 |
| **도서 검색** | 제목 일부 입력으로 검색 (최대 50건, 리뷰 많은 순) |
| **평점 순위** | 리뷰 N개 이상 기준 평점 평균 상위 100권 |
| **리뷰 순위** | 리뷰 수 기준 상위 100권 |
| **도서 상세** | 평균 별점 · 1~5점 분포 · 감성 비율(긍정/중립/부정) · 샘플 리뷰 |
| **회원가입 / 로그인** | 아이디·비밀번호 가입, 입력값 검증(Bean Validation) |
| **얼굴 등록 / 얼굴 로그인** | face-api.js로 128차원 얼굴 특징 추출, 유클리드 거리 매칭 로그인 |
| **카카오 로그인** | 카카오 OAuth 2.0 인가코드 방식, 최초 로그인 시 자동 회원가입 |
| **마이페이지 / 리뷰** | 내 정보·내가 쓴 리뷰 조회/삭제·회원 탈퇴, 도서 상세에서 별점 리뷰 작성(독자 리뷰에 통합 표시) |
| **리뷰 좋아요** | 리뷰에 좋아요 토글(회원당 1회)·좋아요 수 표시, 마이페이지에서 좋아요한 리뷰 모아보기 |
| **찜하기** | 도서 찜/해제, 마이페이지 "찜한 책"에서 표지·평점과 함께 조회 |

---

## 🛠 기술 스택

| 구분 | 기술 |
|------|------|
| Language | Java 17 |
| Framework | Spring Web MVC 6.2.17 |
| Persistence | MyBatis 3.5.19 + mybatis-spring 4.0.0 |
| Database | Oracle XE 21c (ojdbc11), commons-dbcp 커넥션 풀 |
| View | JSP / JSTL (Jakarta), 자체 디자인 시스템(CSS) |
| Validation | Hibernate Validator 9.1 (Jakarta Bean Validation) |
| JSON | Jackson 2.21 |
| 얼굴 인식 | [@vladmandic/face-api](https://github.com/vladmandic/face-api) (브라우저) |
| Build | Maven (`war`) |
| WAS | Apache Tomcat 11.0.18 |

---

## 🏗 아키텍처

```
브라우저(JSP + face-api.js)
        │  HTTP
        ▼
DispatcherServlet ─ Controller ─ Service ─ DAO ─ MyBatis Mapper ─ Oracle
   (spring-mvc.xml)   @Controller  @Service  @Repository   (*.xml)
```

레이어드 아키텍처 (Controller → Service → DAO → Mapper → DB)

```
kr.ac.kopo
├── main
│   └── MainController            // 메인 페이지
├── book
│   ├── controller/BookController // 검색·순위·상세
│   ├── service/BookService(Impl)
│   ├── dao/BookDAO(Impl)
│   └── vo/BookVO, ReviewVO
└── member
    ├── controller/MemberController // 가입·로그인·얼굴
    ├── service/MemberService(Impl)
    ├── dao/MemberDAO(Impl)
    └── vo/MemberVO
```

---

## 🗄 데이터베이스 스키마

| 테이블 | 설명 | 주요 컬럼 |
|--------|------|-----------|
| `BR_MEMBER` | 회원 | NO(PK), ID, PASSWORD, NICKNAME, REG_DATE, **FACE_DESCRIPTOR**(VARCHAR2 4000) |
| `BR_BOOK` | 도서 집계 | NO(PK), TITLE, REVIEW_COUNT, AVG_RATING, DIST1~5, POS/NEU/NEG_COUNT |
| `BR_REVIEW` | 샘플 리뷰(크롤링) | NO(PK), BOOK_NO(FK), CONTENT, RATING |
| `BR_COMMENT` | 회원 리뷰 | NO(PK), MEMBER_NO(FK→회원, ON DELETE CASCADE), BOOK_NO(FK→도서), CONTENT, RATING(별점 1~5), REG_DATE |
| `BR_COMMENT_LIKE` | 리뷰 좋아요 | NO(PK), MEMBER_NO(FK), COMMENT_NO(FK), UNIQUE(회원,리뷰), 모두 ON DELETE CASCADE |
| `BR_WISHLIST` | 찜 | NO(PK), MEMBER_NO(FK→회원, ON DELETE CASCADE), BOOK_NO(FK→도서), UNIQUE(회원,도서) |

- 도서 200종 · 리뷰 4,000건 (알라딘 리뷰 상위 200권)
- `FACE_DESCRIPTOR` : face-api.js의 128차원 실수 배열을 JSON 문자열로 저장

---

## 🚀 실행 방법

### 1. 사전 준비
- JDK 17, Apache Tomcat 11, Oracle XE 21c
- Oracle 계정: `hr / hr` (`jdbc:oracle:thin:@localhost:1521:xe`)

### 2. DB 구축 (SQL Developer 또는 SQL*Plus)
```sql
-- ① 테이블 생성
@src/main/resources/sql/book_review.sql

-- ② 데이터 입력 (파일 상단 SET DEFINE OFF 필수 — 리뷰 내 '&' 처리)
@src/main/resources/sql/book_data.sql

-- 확인
SELECT COUNT(*) FROM BR_BOOK;    -- 200
SELECT COUNT(*) FROM BR_REVIEW;  -- 4000
```

### 3. 빌드 & 배포
```bash
mvn clean package          # book-review.war 생성
```
Eclipse(WTP)에서 Tomcat 서버에 프로젝트를 add 후 Start.

### 4. 접속
```
http://localhost:8088/book-review/
```

> 얼굴 로그인은 카메라 권한이 필요합니다. `localhost` 또는 HTTPS 환경에서만 동작합니다.

---

## 🌐 주요 엔드포인트

| Method | URL | 설명 |
|--------|-----|------|
| GET | `/` | 메인 (평점·리뷰 TOP) |
| GET | `/books?q={keyword}` | 도서 검색 |
| GET | `/books/rank/rating?min={n}` | 평점 순위 |
| GET | `/books/rank/reviews` | 리뷰 순위 |
| GET | `/books/detail?title={title}` | 도서 상세 |
| GET·POST | `/join` | 회원가입 |
| GET·POST | `/login` | 로그인 |
| GET | `/logout` | 로그아웃 |
| POST | `/withdraw` | 회원 탈퇴(계정 삭제 후 세션 종료) |
| GET·POST | `/face-enroll` | 얼굴 등록 |
| GET | `/face-descriptors` | 등록된 얼굴 목록(JSON) |
| POST | `/face-login` | 얼굴 로그인 |
| GET | `/oauth/kakao` | 카카오 인가 페이지로 이동 |
| GET | `/oauth/kakao/callback` | 카카오 로그인 콜백(자동 가입·로그인) |
| GET | `/mypage` | 마이페이지(내 정보·내 댓글·탈퇴) |
| POST | `/comments` | 리뷰 작성 |
| POST | `/comments/delete` | 리뷰 삭제(본인 것만) |
| POST | `/comments/like` | 리뷰 좋아요 토글 |
| POST | `/wishlist/toggle` | 찜하기/해제 토글 |

---

## 🤖 얼굴 인식 로그인 동작 원리

1. **등록** — 브라우저에서 face-api.js가 얼굴을 감지 → 128차원 descriptor 추출 → 서버 저장(`FACE_DESCRIPTOR`)
2. **로그인** — 카메라 프레임마다 descriptor 추출 → 등록된 모든 회원과 **유클리드 거리** 비교
3. 최소 거리가 **임계값 0.5 이하**면 해당 회원으로 자동 로그인

사용 모델: `ssdMobilenetv1` + `faceLandmark68Net` + `faceRecognitionNet`

---

## 📁 프로젝트 구조

```
book-review/
├── pom.xml
├── README.md
├── docs/                     # SRS, 기술 리포트
└── src/main/
    ├── java/kr/ac/kopo/...    # Controller·Service·DAO·VO
    ├── resources/
    │   ├── config/spring/spring-mvc.xml
    │   ├── config/mybatis/sqlMapConfig.xml
    │   ├── config/sqlMap/oracle/*.xml
    │   └── sql/book_review.sql, book_data.sql
    └── webapp/WEB-INF/
        ├── web.xml
        └── jsp/...            # index, book/*, member/*, layout/*
```

---

## 📝 라이선스 / 출처

- 리뷰 데이터: 알라딘 도서 리뷰 크롤링 데이터 (학습용)
- 본 프로젝트는 수업 과제 목적으로 제작되었습니다.
