<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>관리자 — BookReview</title>
<%@ include file="/WEB-INF/jsp/layout/style.jsp" %>
</head>
<body>

<%@ include file="/WEB-INF/jsp/layout/nav.jsp" %>

<div class="sub-nav">
  <div class="sub-nav-inner">
    <span class="sub-nav-title">관리자 대시보드</span>
    <span style="flex:1"></span>
    <a href="${ctx}/admin/members" class="caption" style="margin-right:16px">회원 관리</a>
    <a href="${ctx}/admin/books" class="caption text-primary">도서 표지 관리</a>
  </div>
</div>

<section class="tile tile-parchment" style="padding-top:calc(60px + 44px);padding-bottom:60px">
  <div class="tile-inner-wide" style="text-align:left">
    <h1 class="display-lg" style="margin-bottom:8px">안녕하세요, ${userVO.nickname}님</h1>
    <p class="lead-sm" style="color:var(--ink-48);margin-bottom:40px">사이트 운영 현황을 확인하고 관리합니다.</p>

    <div class="book-grid" style="grid-template-columns:repeat(2,1fr);max-width:720px">
      <a href="${ctx}/admin/members" class="book-card" style="gap:4px">
        <div class="book-card-icon" style="background:linear-gradient(135deg,#2e7ce6,#5aa0f0)">👤</div>
        <div class="book-card-title" style="font-size:17px">회원 관리</div>
        <div class="book-card-meta">총 <fmt:formatNumber value="${memberCount}" pattern="#,###"/>명</div>
      </a>
      <a href="${ctx}/admin/books" class="book-card" style="gap:4px">
        <div class="book-card-icon" style="background:linear-gradient(135deg,#f5a623,#f7c061)">📚</div>
        <div class="book-card-title" style="font-size:17px">도서 표지 관리</div>
        <div class="book-card-meta">총 <fmt:formatNumber value="${bookCount}" pattern="#,###"/>권</div>
      </a>
    </div>
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
