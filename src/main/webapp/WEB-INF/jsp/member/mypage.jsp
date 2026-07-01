<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>마이페이지 — BookReview</title>
<%@ include file="/WEB-INF/jsp/layout/style.jsp" %>
</head>
<body>

<%@ include file="/WEB-INF/jsp/layout/nav.jsp" %>

<section class="tile tile-light" style="text-align:left;padding-top:calc(var(--section-pad) + 44px)">
  <div style="max-width:860px;margin:0 auto">

    <h1 class="display-md" style="margin-bottom:28px">마이페이지</h1>

    <!-- ── 내 정보 ───────────────────────────────── -->
    <div style="background:var(--parchment);border-radius:14px;padding:24px 28px;margin-bottom:40px">
      <div style="display:flex;align-items:center;gap:16px;flex-wrap:wrap">
        <div style="width:56px;height:56px;border-radius:50%;background:var(--ink);color:#fff;
                    display:flex;align-items:center;justify-content:center;font-size:24px">
          ${fn:substring(userVO.nickname,0,1)}
        </div>
        <div>
          <p class="body-strong" style="font-size:20px"><c:out value="${userVO.nickname}"/></p>
          <p class="caption" style="color:var(--ink-48);margin-top:2px">
            아이디 <c:out value="${userVO.id}"/>
            · 가입 방식
            <c:choose>
              <c:when test="${userVO.provider == 'KAKAO'}">카카오</c:when>
              <c:otherwise>일반</c:otherwise>
            </c:choose>
          </p>
        </div>
      </div>
    </div>

    <!-- ── 내가 쓴 리뷰 ──────────────────────────── -->
    <h2 style="font-size:24px;font-weight:600;margin-bottom:18px">내가 쓴 리뷰
      <span style="font-size:15px;color:var(--ink-48)">(${fn:length(myComments)})</span>
    </h2>

    <c:choose>
      <c:when test="${not empty myComments}">
        <c:forEach var="cmt" items="${myComments}">
          <div style="padding:16px 0;border-bottom:1px solid var(--hairline)">
            <div style="display:flex;align-items:center;gap:10px;margin-bottom:6px;flex-wrap:wrap">
              <c:url var="detailUrl" value="/books/detail">
                <c:param name="title" value="${cmt.bookTitle}"/>
              </c:url>
              <a href="${detailUrl}" style="color:var(--primary);font-weight:600;font-size:15px">
                📖 <c:out value="${cmt.bookTitle}"/>
              </a>
              <span style="color:#f5a623;font-size:14px;letter-spacing:1px">
                <c:forEach begin="1" end="5" varStatus="s"><c:choose><c:when test="${s.index <= cmt.rating}">★</c:when><c:otherwise><span style="color:#ddd">★</span></c:otherwise></c:choose></c:forEach>
              </span>
              <span style="font-size:11px;padding:2px 8px;border-radius:9999px;
                    background:${cmt.sentiment == '긍정' ? 'rgba(48,164,108,0.12)' : (cmt.sentiment == '중립' ? 'rgba(200,144,47,0.12)' : 'rgba(229,72,77,0.12)')};
                    color:${cmt.sentiment == '긍정' ? '#2f9e44' : (cmt.sentiment == '중립' ? '#c8902f' : '#e5484d')}">${cmt.sentiment}</span>
              <span style="font-size:12px;color:var(--ink-48)">${cmt.regDate}</span>
              <form method="post" action="${ctx}/comments/delete" style="margin:0 0 0 auto"
                    onsubmit="return confirm('리뷰를 삭제할까요?');">
                <input type="hidden" name="commentNo" value="${cmt.no}">
                <input type="hidden" name="from" value="mypage">
                <button type="submit" style="background:none;border:none;color:var(--neg);cursor:pointer;font-size:13px;padding:0">삭제</button>
              </form>
            </div>
            <p style="font-size:15px;color:var(--ink-80);line-height:1.6"><c:out value="${cmt.content}"/></p>
          </div>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <p style="color:var(--ink-48)">아직 작성한 리뷰가 없습니다. 도서 상세 페이지에서 리뷰를 남겨보세요.</p>
      </c:otherwise>
    </c:choose>

    <!-- ── 좋아요한 리뷰 ─────────────────────────── -->
    <h2 style="font-size:24px;font-weight:600;margin:48px 0 18px">좋아요한 리뷰
      <span style="font-size:15px;color:var(--ink-48)">(${fn:length(likedReviews)})</span>
    </h2>

    <c:choose>
      <c:when test="${not empty likedReviews}">
        <c:forEach var="cmt" items="${likedReviews}">
          <div style="padding:16px 0;border-bottom:1px solid var(--hairline)">
            <div style="display:flex;align-items:center;gap:10px;margin-bottom:6px;flex-wrap:wrap">
              <c:url var="lUrl" value="/books/detail"><c:param name="title" value="${cmt.bookTitle}"/></c:url>
              <a href="${lUrl}" style="color:var(--primary);font-weight:600;font-size:15px">📖 <c:out value="${cmt.bookTitle}"/></a>
              <span style="color:#f5a623;font-size:14px;letter-spacing:1px">
                <c:forEach begin="1" end="5" varStatus="s"><c:choose><c:when test="${s.index <= cmt.rating}">★</c:when><c:otherwise><span style="color:#ddd">★</span></c:otherwise></c:choose></c:forEach>
              </span>
              <span style="font-size:13px;color:var(--ink-48)">by <c:out value="${cmt.nickname}"/></span>
              <form method="post" action="${ctx}/comments/like" style="margin:0 0 0 auto">
                <input type="hidden" name="commentNo" value="${cmt.no}">
                <input type="hidden" name="from" value="mypage">
                <button type="submit" style="background:none;border:none;color:#e5484d;cursor:pointer;font-size:13px;padding:0">♥ 좋아요 취소 (${cmt.likeCount})</button>
              </form>
            </div>
            <p style="font-size:15px;color:var(--ink-80);line-height:1.6"><c:out value="${cmt.content}"/></p>
          </div>
        </c:forEach>
      </c:when>
      <c:otherwise>
        <p style="color:var(--ink-48)">좋아요한 리뷰가 없습니다.</p>
      </c:otherwise>
    </c:choose>

    <!-- ── 찜한 책 ───────────────────────────────── -->
    <h2 style="font-size:24px;font-weight:600;margin:48px 0 18px">찜한 책
      <span style="font-size:15px;color:var(--ink-48)">(${fn:length(myWishlist)})</span>
    </h2>

    <c:choose>
      <c:when test="${not empty myWishlist}">
        <div style="display:flex;flex-wrap:wrap;gap:18px">
          <c:forEach var="w" items="${myWishlist}">
            <div style="width:150px">
              <c:url var="wUrl" value="/books/detail"><c:param name="title" value="${w.bookTitle}"/></c:url>
              <a href="${wUrl}" style="text-decoration:none;color:inherit">
                <c:choose>
                  <c:when test="${w.hasCover()}">
                    <img src="${fn:startsWith(w.cover,'http') ? '' : ctx}${w.cover}" alt="<c:out value='${w.bookTitle}'/>"
                         style="width:150px;height:210px;object-fit:cover;border-radius:10px;box-shadow:rgba(0,0,0,0.18) 2px 4px 16px 0">
                  </c:when>
                  <c:otherwise>
                    <div style="width:150px;height:210px;border-radius:10px;background:linear-gradient(135deg,#1c1c1e,#48484a);display:flex;align-items:center;justify-content:center;font-size:40px">📚</div>
                  </c:otherwise>
                </c:choose>
                <p style="font-size:14px;font-weight:600;margin-top:8px;line-height:1.35;display:-webkit-box;-webkit-line-clamp:2;-webkit-box-orient:vertical;overflow:hidden"><c:out value="${w.bookTitle}"/></p>
              </a>
              <p style="font-size:13px;color:var(--ink-48);margin-top:2px">
                ★ <fmt:formatNumber value="${w.avgRating}" pattern="0.0"/>
                · 리뷰 <fmt:formatNumber value="${w.reviewCount}" pattern="#,###"/>
              </p>
              <form method="post" action="${ctx}/wishlist/toggle" style="margin-top:4px">
                <input type="hidden" name="bookNo" value="${w.bookNo}">
                <input type="hidden" name="from" value="mypage">
                <button type="submit" style="background:none;border:none;color:#e5484d;cursor:pointer;font-size:13px;padding:0">♥ 찜 해제</button>
              </form>
            </div>
          </c:forEach>
        </div>
      </c:when>
      <c:otherwise>
        <p style="color:var(--ink-48)">찜한 책이 없습니다. 도서 상세 페이지에서 ♡ 찜하기를 눌러보세요.</p>
      </c:otherwise>
    </c:choose>

    <!-- ── 회원 탈퇴 ─────────────────────────────── -->
    <div style="margin-top:56px;padding-top:28px;border-top:1px solid var(--hairline)">
      <h2 style="font-size:24px;font-weight:600;margin-bottom:10px;color:var(--neg)">회원 탈퇴</h2>
      <p class="caption" style="color:var(--ink-48);margin-bottom:16px">
        탈퇴하면 계정과 작성한 모든 댓글이 삭제되며 복구할 수 없습니다.
      </p>
      <form method="post" action="${ctx}/withdraw"
            onsubmit="return confirm('정말 탈퇴하시겠습니까?\n계정과 작성한 댓글이 모두 삭제되며 복구할 수 없습니다.');">
        <button type="submit"
                style="background:var(--neg);color:#fff;border:none;border-radius:9999px;
                       padding:12px 28px;font-size:15px;font-weight:600;cursor:pointer">
          회원 탈퇴
        </button>
      </form>
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
