<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회원가입 — BookReview</title>
<%@ include file="/WEB-INF/jsp/layout/style.jsp" %>
</head>
<body>

<%@ include file="/WEB-INF/jsp/layout/nav.jsp" %>

<div class="form-page">
  <div class="form-card" style="max-width:460px">

    <div class="form-logo">
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M4 19.5A2.5 2.5 0 016.5 17H20"/>
        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z"/>
      </svg>
      BookReview 회원가입
    </div>
    <p class="form-sub">계정을 만들고 리뷰를 즐겨보세요</p>

    <c:if test="${not empty msg}">
      <p class="form-msg">${msg}</p>
    </c:if>

    <form:form method="post" action="${ctx}/join" modelAttribute="memberVO">

      <div class="form-field">
        <label class="form-label">아이디 *</label>
        <form:input path="id" cssClass="form-input" placeholder="영문+숫자, 영문으로 시작" />
        <form:errors path="id" cssClass="form-err" />
      </div>

      <div class="form-field">
        <label class="form-label">비밀번호 *</label>
        <form:password path="password" cssClass="form-input" placeholder="비밀번호를 입력하세요" />
        <form:errors path="password" cssClass="form-err" />
      </div>

      <div class="form-field">
        <label class="form-label">닉네임 *</label>
        <form:input path="nickname" cssClass="form-input" placeholder="표시될 이름을 입력하세요" />
        <form:errors path="nickname" cssClass="form-err" />
      </div>

      <button type="submit" class="form-submit">가입하기</button>
    </form:form>

    <!-- 얼굴 등록 안내 -->
    <div style="margin-top:24px;background:var(--parchment);border-radius:14px;padding:16px 20px;text-align:left">
      <p class="caption-strong" style="margin-bottom:6px">💡 얼굴 로그인</p>
      <p class="caption" style="color:var(--ink-48);line-height:1.5">
        가입 후 얼굴을 등록하면 다음부터 카메라로 즉시 로그인할 수 있어요.
        가입 완료 후 자동으로 얼굴 등록 페이지로 이동합니다.
      </p>
    </div>

    <div class="form-foot">
      이미 계정이 있으신가요? <a href="${ctx}/login">로그인</a>
    </div>

  </div>
</div>

<script>function toggleMobileNav(){document.getElementById('mobileMenu').classList.toggle('open');}</script>
</body>
</html>
