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
<title>도서 검색 — BookReview</title>
<%@ include file="/WEB-INF/jsp/layout/style.jsp" %>
</head>
<body>

<%@ include file="/WEB-INF/jsp/layout/nav.jsp" %>

<!-- ── SEARCH HERO ─────────────────────────────────── -->
<section class="hero-section" style="padding-top:44px">
  <div class="hero-split">
    <div class="hero-text-side">
      <p class="hero-breadcrumb"><a href="${ctx}/">홈</a> / 도서 검색</p>
      <h1 class="hero-big-text" style="font-size:80px;letter-spacing:-3px;margin-bottom:16px">도서 검색</h1>
      <p class="hero-tagline" style="font-size:20px;margin-bottom:28px">제목 일부만 입력해도 됩니다</p>
      <form method="get" action="${ctx}/books">
        <div class="search-wrap" style="max-width:520px;margin:0">
          <input type="text" name="q" value="${q}" class="search-input"
                 placeholder="책 제목 검색…" autofocus>
          <button type="submit" class="search-btn">검색</button>
        </div>
      </form>
      <c:if test="${!loaded}">
        <div style="margin-top:20px">
          <div class="loading-badge"><div class="spin"></div> 데이터 로딩 중 — 잠시 후 검색해주세요 (자동 갱신)</div>
        </div>
      </c:if>
    </div>
    <div class="hero-spine-shelf">
      <div class="spine spine-1">소설</div>
      <div class="spine spine-2">자기계발</div>
      <div class="spine spine-3">에세이</div>
      <div class="spine spine-4">경제경영</div>
      <div class="spine spine-5">인문</div>
    </div>
  </div>
</section>

<!-- ── FILTER BAR ──────────────────────────────────── -->
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
    <a href="${ctx}/books/rank/rating" class="filter-chip">평점 순위 ↓</a>
    <a href="${ctx}/books/rank/reviews" class="filter-chip">리뷰 순위 ↓</a>
    <span class="filter-spacer"></span>
    <c:if test="${loaded}">
      <span class="filter-count"><fmt:formatNumber value="${totalCount}" pattern="#,###"/>종 수록</span>
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

<!-- ── RESULTS ─────────────────────────────────────── -->
<c:if test="${not empty books}">
<section class="tile tile-parchment" style="padding-top:40px;padding-bottom:60px">
  <div class="tile-inner-wide">
    <p class="tagline" style="margin-bottom:32px;color:var(--ink-48)">${resultMsg}</p>
    <div class="book-grid">
      <c:forEach var="book" items="${books}" varStatus="st">
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
          <div style="display:flex;align-items:center;gap:4px;margin-top:4px">
            <span class="stars" style="font-size:13px">
              <c:set var="r" value="${book.avgRating}"/>
              <c:forEach begin="1" end="5" varStatus="s">
                <c:choose>
                  <c:when test="${s.index <= r}">★</c:when>
                  <c:otherwise><span style="opacity:.3">★</span></c:otherwise>
                </c:choose>
              </c:forEach>
            </span>
            <span style="font-size:13px;font-weight:600"><fmt:formatNumber value="${book.avgRating}" pattern="0.0"/></span>
          </div>
          <div class="book-card-meta"><fmt:formatNumber value="${book.reviewCount}" pattern="#,###"/>개의 리뷰</div>
        </a>
      </c:forEach>
    </div>
  </div>
</section>
</c:if>

<c:if test="${not empty q and empty books}">
<section class="tile tile-parchment" style="padding:60px 22px;text-align:center">
  <p class="display-md" style="color:var(--ink-48)">"${q}" 검색 결과가 없습니다.</p>
  <p class="caption" style="color:var(--ink-48);margin-top:8px">다른 키워드로 다시 검색해보세요.</p>
</section>
</c:if>

<footer class="site-footer">
  <div class="footer-inner">
    <p class="fine-print footer-copy">Copyright &copy; 2026 BookReview. 수업 과제용 프로젝트입니다.</p>
  </div>
</footer>

<script>
function toggleMobileNav(){document.getElementById('mobileMenu').classList.toggle('open');}
<c:if test="${!loaded}">
setTimeout(function(){ location.reload(); }, 2000);
</c:if>
</script>
</body>
</html>
