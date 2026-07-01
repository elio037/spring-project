<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<nav class="global-nav" id="globalNav">
  <div class="nav-inner">
    <a href="${ctx}/" class="nav-logo">
      <svg width="20" height="20" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M4 19.5A2.5 2.5 0 016.5 17H20"/>
        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z"/>
      </svg>
      BookReview
    </a>
    <ul class="nav-links">
      <li><a href="${ctx}/books">도서 검색</a></li>
      <li><a href="${ctx}/books/rank/rating">평점 순위</a></li>
      <li><a href="${ctx}/books/rank/reviews">리뷰 순위</a></li>
      <c:if test="${userVO.admin}"><li><a href="${ctx}/admin">관리자</a></li></c:if>
    </ul>
    <div class="nav-actions">
      <c:choose>
        <c:when test="${not empty userVO}">
          <span class="nav-user">${userVO.nickname}</span>
          <a href="${ctx}/mypage" class="btn-dark-util">마이페이지</a>
          <a href="${ctx}/face-enroll" class="btn-dark-util">얼굴 등록</a>
          <a href="${ctx}/logout" class="btn-dark-util">로그아웃</a>
        </c:when>
        <c:otherwise>
          <a href="${ctx}/login" class="btn-dark-util">로그인</a>
          <a href="${ctx}/join" class="btn-primary-nav">회원가입</a>
        </c:otherwise>
      </c:choose>
    </div>
    <button class="nav-hamburger" onclick="toggleMobileNav()" aria-label="메뉴">
      <span></span><span></span><span></span>
    </button>
  </div>
</nav>
<div class="mobile-menu" id="mobileMenu">
  <a href="${ctx}/books">도서 검색</a>
  <a href="${ctx}/books/rank/rating">평점 순위</a>
  <a href="${ctx}/books/rank/reviews">리뷰 순위</a>
  <c:if test="${userVO.admin}"><a href="${ctx}/admin">관리자</a></c:if>
  <c:choose>
    <c:when test="${not empty userVO}">
      <a href="${ctx}/mypage">마이페이지</a>
      <a href="${ctx}/face-enroll">얼굴 등록</a>
      <a href="${ctx}/logout">로그아웃</a>
    </c:when>
    <c:otherwise>
      <a href="${ctx}/login">로그인</a>
      <a href="${ctx}/join">회원가입</a>
    </c:otherwise>
  </c:choose>
</div>
