<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>BookReview — 독자 리뷰의 모든 것</title>
<%@ include file="/WEB-INF/jsp/layout/style.jsp" %>
</head>
<body>

<%@ include file="/WEB-INF/jsp/layout/nav.jsp" %>

<!-- ── HERO SECTION ───────────────────────────────────── -->
<section class="hero-section" style="padding-top:44px">
  <div class="hero-split">

    <!-- Left: Text -->
    <div class="hero-text-side">
      <p class="hero-breadcrumb">
        <a href="${ctx}/">홈</a> / 도서
      </p>
      <h1 class="hero-big-text">도서</h1>
      <p class="hero-tagline">독자가 말하는<br>진짜 책 이야기.</p>
      <p class="hero-info">
        <c:choose>
          <c:when test="${loaded}"><fmt:formatNumber value="${totalCount}" pattern="#,###"/>종 도서</c:when>
          <c:otherwise>알라딘 도서 리뷰 플랫폼</c:otherwise>
        </c:choose>
      </p>
      <div class="hero-actions">
        <a href="${ctx}/books" class="btn-primary">도서 검색</a>
        <a href="${ctx}/books/rank/rating" class="btn-ghost">평점 순위 보기</a>
      </div>
      <c:if test="${!loaded}">
        <div style="margin-top:24px">
          <div class="loading-badge">
            <div class="spin"></div> 리뷰 데이터 로딩 중… (최초 1회, 자동 갱신됩니다)
          </div>
        </div>
      </c:if>
    </div>

    <!-- Right: Book spine shelf decoration -->
    <div class="hero-spine-shelf">
      <div class="spine spine-1">소설</div>
      <div class="spine spine-2">자기계발</div>
      <div class="spine spine-3">에세이</div>
      <div class="spine spine-4">경제경영</div>
      <div class="spine spine-5">인문</div>
    </div>

  </div>
</section>

<!-- ── FILTER BAR ─────────────────────────────────────── -->
<div class="filter-bar">
  <div class="filter-bar-inner">
    <button class="filter-chip">
      <svg width="14" height="14" viewBox="0 0 14 14" fill="none" stroke="currentColor" stroke-width="1.5" stroke-linecap="round">
        <line x1="1" y1="3.5" x2="13" y2="3.5"/>
        <line x1="3" y1="7" x2="11" y2="7"/>
        <line x1="5" y1="10.5" x2="9" y2="10.5"/>
      </svg>
      전체 필터
    </button>
    <a href="${ctx}/books" class="filter-chip">도서 검색 ↓</a>
    <a href="${ctx}/books/rank/rating" class="filter-chip">평점 순위 ↓</a>
    <a href="${ctx}/books/rank/reviews" class="filter-chip">리뷰 순위 ↓</a>
    <span class="filter-spacer"></span>
    <c:if test="${loaded}">
      <span class="filter-count"><fmt:formatNumber value="${totalCount}" pattern="#,###"/>종 도서</span>
    </c:if>
    <div class="filter-view-btns">
      <div class="filter-view-btn active" title="그리드 보기">
        <svg width="12" height="12" viewBox="0 0 12 12" fill="currentColor">
          <rect x="0" y="0" width="5" height="5"/><rect x="7" y="0" width="5" height="5"/>
          <rect x="0" y="7" width="5" height="5"/><rect x="7" y="7" width="5" height="5"/>
        </svg>
      </div>
      <div class="filter-view-btn" title="목록 보기">
        <svg width="12" height="12" viewBox="0 0 12 12" fill="currentColor">
          <rect x="0" y="1" width="12" height="2"/><rect x="0" y="5" width="12" height="2"/>
          <rect x="0" y="9" width="12" height="2"/>
        </svg>
      </div>
    </div>
  </div>
</div>

<!-- ── TOP RATING ─────────────────────────────────────── -->
<c:if test="${loaded}">
<section class="tile tile-light">
  <div class="tile-inner-wide">
    <p class="tagline text-primary" style="margin-bottom:6px">평점 최고</p>
    <h2 class="display-lg" style="margin-bottom:8px">이 책들이 가장 높게 평가받았습니다.</h2>
    <p class="lead-sm" style="color:var(--ink-48);margin-bottom:40px">리뷰 50개 이상 기준 · 별점 평균 순</p>

    <div class="book-grid">
      <c:forEach var="book" items="${topRating}" varStatus="st">
        <c:url var="detailUrl" value="/books/detail"><c:param name="title" value="${book.title}"/></c:url>
        <a href="${detailUrl}" class="book-card">
          <c:choose>
            <c:when test="${not empty book.cover}">
              <div class="book-card-icon" style="padding:0;overflow:hidden"><img src="${fn:startsWith(book.cover,'http') ? '' : ctx}${book.cover}" class="book-card-cover" alt=""></div>
            </c:when>
            <c:otherwise>
              <div class="book-card-icon bg-c${st.index % 8}" style="color:#fff;font-size:12px;font-weight:700;padding:8px;line-height:1.3;overflow:hidden;text-align:center">${book.title}</div>
            </c:otherwise>
          </c:choose>
          <div class="book-card-title">${book.title}</div>
          <div class="book-card-meta">
            <span class="stars">
              <c:set var="fullStars" value="${book.avgRating >= 4.5 ? 5 : (book.avgRating >= 3.5 ? 4 : (book.avgRating >= 2.5 ? 3 : (book.avgRating >= 1.5 ? 2 : 1)))}"/>
              <c:forEach begin="1" end="${fullStars}">★</c:forEach>
            </span>
            <fmt:formatNumber value="${book.avgRating}" pattern="0.0"/>
            &nbsp;·&nbsp;<fmt:formatNumber value="${book.reviewCount}" pattern="#,###"/>개
          </div>
        </a>
      </c:forEach>
    </div>

    <div style="margin-top:32px">
      <a href="${ctx}/books/rank/rating" class="text-primary" style="font-size:17px">전체 순위 보기 →</a>
    </div>
  </div>
</section>

<!-- ── TOP REVIEWS ────────────────────────────────────── -->
<section class="tile tile-dark-2">
  <div class="tile-inner-wide">
    <p class="tagline" style="color:var(--primary-on-dark);margin-bottom:6px">리뷰 가장 많은</p>
    <h2 class="display-lg" style="margin-bottom:8px;color:#fff">독자가 가장 많이 읽고 남긴 책.</h2>
    <p class="lead-sm text-muted-dark" style="margin-bottom:40px">리뷰 수 기준 상위 도서</p>

    <div class="book-grid">
      <c:forEach var="book" items="${topReviews}" varStatus="st">
        <c:url var="detailUrl" value="/books/detail"><c:param name="title" value="${book.title}"/></c:url>
        <a href="${detailUrl}" class="book-card">
          <c:choose>
            <c:when test="${not empty book.cover}">
              <div class="book-card-icon" style="padding:0;overflow:hidden"><img src="${fn:startsWith(book.cover,'http') ? '' : ctx}${book.cover}" class="book-card-cover" alt=""></div>
            </c:when>
            <c:otherwise>
              <div class="book-card-icon">📖</div>
            </c:otherwise>
          </c:choose>
          <div class="book-card-title">${book.title}</div>
          <div class="book-card-meta">
            <fmt:formatNumber value="${book.reviewCount}" pattern="#,###"/>개의 리뷰
            &nbsp;·&nbsp;<fmt:formatNumber value="${book.avgRating}" pattern="0.0"/>점
          </div>
        </a>
      </c:forEach>
    </div>

    <div style="margin-top:32px">
      <a href="${ctx}/books/rank/reviews" class="text-primary-dark" style="font-size:17px">전체 순위 보기 →</a>
    </div>
  </div>
</section>
</c:if>

<!-- ── FOOTER ─────────────────────────────────────────── -->
<footer class="site-footer">
  <div class="footer-inner">
    <p class="fine-print footer-copy">
      Copyright &copy; 2026 BookReview. 수업 과제용 프로젝트입니다.<br>
      리뷰 데이터 출처: 알라딘 도서 리뷰 크롤링 데이터
    </p>
  </div>
</footer>

<script>
function toggleMobileNav() {
  document.getElementById('mobileMenu').classList.toggle('open');
}
<c:if test="${!loaded}">
// 데이터 로딩 완료 시 즉시 반영되도록 2초마다 자동 갱신
setTimeout(function(){ location.reload(); }, 2000);
</c:if>
</script>
</body>
</html>
