<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회원 관리 — BookReview</title>
<%@ include file="/WEB-INF/jsp/layout/style.jsp" %>
</head>
<body>

<%@ include file="/WEB-INF/jsp/layout/nav.jsp" %>

<div class="sub-nav">
  <div class="sub-nav-inner">
    <a href="${ctx}/admin" style="color:var(--primary);font-size:14px">← 대시보드</a>
    <span class="sub-nav-title" style="margin-left:16px">회원 관리</span>
  </div>
</div>

<section class="tile tile-parchment" style="padding-top:calc(60px + 44px);padding-bottom:60px">
  <div class="tile-inner-wide" style="text-align:left">
    <table class="rank-table">
      <thead>
        <tr>
          <th style="width:60px">번호</th>
          <th>아이디</th>
          <th>닉네임</th>
          <th style="width:100px">권한</th>
          <th style="width:120px">가입일</th>
          <th style="width:110px">얼굴 등록</th>
        </tr>
      </thead>
      <tbody>
        <c:forEach var="m" items="${members}">
        <tr>
          <td class="caption" style="color:var(--ink-48)">${m.no}</td>
          <td class="body-strong">${m.id}</td>
          <td>${m.nickname}</td>
          <td>
            <c:choose>
              <c:when test="${m.admin}"><span class="caption-strong" style="color:var(--primary)">관리자</span></c:when>
              <c:otherwise><span class="caption" style="color:var(--ink-48)">일반</span></c:otherwise>
            </c:choose>
          </td>
          <td class="caption" style="color:var(--ink-48)">${m.regDate}</td>
          <td>
            <c:choose>
              <c:when test="${m.faceRegistered}"><span class="caption-strong" style="color:var(--pos)">✔ 등록</span></c:when>
              <c:otherwise><span class="caption" style="color:var(--ink-48)">미등록</span></c:otherwise>
            </c:choose>
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
