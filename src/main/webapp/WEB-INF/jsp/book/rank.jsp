<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<c:set var="pageTitle" value="${rankType == 'rating' ? '평점 순위' : '리뷰 수 순위'}"/>
<title>${pageTitle} — BookReview</title>
<%@ include file="/WEB-INF/jsp/layout/style.jsp" %>
</head>
<body>

<%@ include file="/WEB-INF/jsp/layout/nav.jsp" %>

<div class="sub-nav">
  <div class="sub-nav-inner">
    <span class="sub-nav-title">${pageTitle}</span>
    <span style="flex:1"></span>
    <a href="${ctx}/books/rank/rating" class="caption ${rankType=='rating' ? 'text-primary' : ''}" style="margin-right:16px">평점순</a>
    <a href="${ctx}/books/rank/reviews" class="caption ${rankType=='reviews' ? 'text-primary' : ''}">리뷰순</a>
  </div>
</div>

<section class="tile tile-dark" style="padding-top:calc(60px + 44px);padding-bottom:40px">
  <div class="tile-inner">
    <h1 class="display-lg" style="color:#fff;margin-bottom:8px">${pageTitle}</h1>
    <c:choose>
      <c:when test="${rankType=='rating'}">
        <p class="lead-sm text-muted-dark">리뷰 ${minReviews}개 이상 기준 · 평점 평균 상위 100권</p>
        <div style="margin-top:14px;display:flex;gap:8px">
          <c:url var="descUrl" value="/books/rank/rating"><c:param name="min" value="${minReviews}"/><c:param name="order" value="desc"/></c:url>
          <c:url var="ascUrl"  value="/books/rank/rating"><c:param name="min" value="${minReviews}"/><c:param name="order" value="asc"/></c:url>
          <a href="${descUrl}" class="btn-ghost ${order != 'asc' ? 'btn-primary' : ''}" style="padding:8px 16px;font-size:14px">평점 높은순</a>
          <a href="${ascUrl}"  class="btn-ghost ${order == 'asc' ? 'btn-primary' : ''}" style="padding:8px 16px;font-size:14px">평점 낮은순</a>
        </div>
      </c:when>
      <c:otherwise>
        <p class="lead-sm text-muted-dark">가장 많은 독자가 읽고 리뷰를 남긴 책 100권</p>
      </c:otherwise>
    </c:choose>
  </div>
</section>

<section class="tile tile-parchment" style="padding-top:32px;padding-bottom:60px">
  <div class="tile-inner-wide" style="text-align:left">

    <c:if test="${!loaded}">
      <div style="text-align:center;padding:40px 0">
        <div class="loading-badge"><div class="spin"></div> 데이터 로딩 중…</div>
      </div>
      <script>setTimeout(function(){ location.reload(); }, 2000);</script>
    </c:if>

    <c:if test="${loaded}">
    <table class="rank-table">
      <thead>
        <tr>
          <th style="width:48px">순위</th>
          <th>책 제목</th>
          <c:if test="${rankType=='rating'}">
            <th style="width:140px">평점</th>
          </c:if>
          <th style="width:120px">리뷰 수</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="book" items="${books}" varStatus="st">
        <tr>
          <td class="rank-num ${st.index < 3 ? 'top3' : ''}">${st.index + 1}</td>
          <td>
            <c:url var="detailUrl" value="/books/detail"><c:param name="title" value="${book.title}"/></c:url>
            <a href="${detailUrl}" class="rank-title-link">${book.title}</a>
          </td>
          <c:if test="${rankType=='rating'}">
          <td>
            <div style="display:flex;align-items:center;gap:6px">
              <span class="stars" style="font-size:14px">
                <c:forEach begin="1" end="5" varStatus="s">
                  <c:choose>
                    <c:when test="${s.index <= book.avgRating}">★</c:when>
                    <c:otherwise><span style="opacity:.25">★</span></c:otherwise>
                  </c:choose>
                </c:forEach>
              </span>
              <span class="body-strong"><fmt:formatNumber value="${book.avgRating}" pattern="0.0"/></span>
            </div>
          </td>
          </c:if>
          <td class="caption" style="color:var(--ink-48)"><fmt:formatNumber value="${book.reviewCount}" pattern="#,###"/>개</td>
        </tr>
        </c:forEach>
      </tbody>
    </table>
    </c:if>

  </div>
</section>

<footer class="site-footer">
  <div class="footer-inner">
    <p class="fine-print footer-copy">Copyright &copy; 2026 BookReview. 수업 과제용 프로젝트입니다.</p>
  </div>
</footer>

<script>function toggleMobileNav(){document.getElementById('mobileMenu').classList.toggle('open');}</script>
</body>
</html>
