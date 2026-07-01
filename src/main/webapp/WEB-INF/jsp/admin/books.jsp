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
<title>도서 표지 관리 — BookReview</title>
<%@ include file="/WEB-INF/jsp/layout/style.jsp" %>
<style>
.cover-thumb { width:44px; height:62px; border-radius:6px; object-fit:cover; background:var(--parchment); display:block; }
.cover-none { width:44px; height:62px; border-radius:6px; background:var(--hairline);
  display:flex; align-items:center; justify-content:center; font-size:18px; }
.cover-form { display:flex; gap:6px; align-items:center; }
.cover-input { flex:1; min-width:220px; border:1px solid var(--hairline); border-radius:8px;
  padding:7px 10px; font-size:13px; outline:none; }
.cover-input:focus { border-color:var(--primary); }
.cover-save { background:var(--primary); color:#fff; border:none; border-radius:8px;
  padding:7px 14px; font-size:13px; cursor:pointer; white-space:nowrap; }
.cover-save:active { transform:scale(0.96); }
</style>
</head>
<body>

<%@ include file="/WEB-INF/jsp/layout/nav.jsp" %>

<div class="sub-nav">
  <div class="sub-nav-inner">
    <a href="${ctx}/admin" style="color:var(--primary);font-size:14px">← 대시보드</a>
    <span class="sub-nav-title" style="margin-left:16px">도서 표지 관리</span>
    <span style="flex:1"></span>
    <span class="caption" style="color:var(--ink-48)">총 ${fn:length(books)}권</span>
  </div>
</div>

<section class="tile tile-parchment" style="padding-top:calc(60px + 44px);padding-bottom:60px">
  <div class="tile-inner-wide" style="text-align:left">
    <p class="caption" style="color:var(--ink-48);margin-bottom:16px">
      표지 경로(예: <code>/img/covers/1.jpg</code>) 또는 이미지 URL을 입력하고 저장하세요.
    </p>
    <table class="rank-table">
      <thead>
        <tr>
          <th style="width:50px">No</th>
          <th style="width:60px">표지</th>
          <th>제목</th>
          <th style="width:90px">리뷰</th>
          <th style="width:380px">표지 경로 / URL</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="book" items="${books}">
        <tr>
          <td class="caption" style="color:var(--ink-48)">${book.no}</td>
          <td>
            <c:choose>
              <c:when test="${not empty book.cover}">
                <img src="<c:choose><c:when test='${fn:startsWith(book.cover, "http")}'>${book.cover}</c:when><c:otherwise>${ctx}${book.cover}</c:otherwise></c:choose>" class="cover-thumb" alt="">
              </c:when>
              <c:otherwise><div class="cover-none">📚</div></c:otherwise>
            </c:choose>
          </td>
          <td class="body-strong">${book.title}</td>
          <td class="caption" style="color:var(--ink-48)"><fmt:formatNumber value="${book.reviewCount}" pattern="#,###"/></td>
          <td>
            <form method="post" action="${ctx}/admin/books/cover" class="cover-form">
              <input type="hidden" name="no" value="${book.no}">
              <input type="text" name="cover" value="${book.cover}" class="cover-input" placeholder="/img/covers/${book.no}.jpg">
              <button type="submit" class="cover-save">저장</button>
            </form>
          </td>
        </tr>
        </c:forEach>
      </tbody>
    </table>
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
