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
<title>${book.title} — BookReview</title>
<%@ include file="/WEB-INF/jsp/layout/style.jsp" %>
</head>
<body>

<%@ include file="/WEB-INF/jsp/layout/nav.jsp" %>

<div class="sub-nav">
  <div class="sub-nav-inner">
    <a href="${ctx}/books" style="color:var(--primary);font-size:14px">← 검색으로</a>
    <span style="flex:1"></span>
    <span class="sub-nav-title" style="font-size:16px;max-width:400px;overflow:hidden;text-overflow:ellipsis;white-space:nowrap">${book.title}</span>
  </div>
</div>

<!-- ── BOOK HEADER (light) ─────────────────────────── -->
<section class="tile tile-light" style="padding-top:calc(var(--section-pad) + 44px);text-align:left">
  <div class="detail-header-inner">

    <div style="display:flex;gap:32px;align-items:flex-start;flex-wrap:wrap">

      <!-- 책 표지 -->
      <c:choose>
        <c:when test="${not empty book.cover}">
          <img src="${fn:startsWith(book.cover,'http') ? '' : ctx}${book.cover}" alt="${book.title}"
               style="width:120px;height:170px;border-radius:12px;object-fit:cover;flex-shrink:0;
                      box-shadow:rgba(0,0,0,0.22) 3px 5px 30px 0">
        </c:when>
        <c:otherwise>
          <div style="width:120px;height:120px;border-radius:16px;background:linear-gradient(135deg,#1c1c1e,#48484a);
                      display:flex;align-items:center;justify-content:center;font-size:54px;flex-shrink:0;
                      box-shadow:rgba(0,0,0,0.22) 3px 5px 30px 0">📚</div>
        </c:otherwise>
      </c:choose>

      <div style="flex:1;min-width:240px">
        <h1 class="display-md" style="margin-bottom:6px">${book.title}</h1>

        <!-- 찜하기 -->
        <c:if test="${not empty userVO}">
          <form method="post" action="${ctx}/wishlist/toggle" style="margin:10px 0 0">
            <input type="hidden" name="bookNo" value="${book.no}">
            <input type="hidden" name="title" value="<c:out value='${book.title}'/>">
            <input type="hidden" name="from" value="detail">
            <button type="submit"
              style="display:inline-flex;align-items:center;gap:6px;padding:9px 18px;border-radius:9999px;
                     border:1px solid ${wishlisted ? '#e5484d' : 'var(--hairline)'};background:#fff;
                     font-size:14px;font-weight:600;cursor:pointer;color:${wishlisted ? '#e5484d' : 'var(--ink-80)'}">
              <c:choose><c:when test="${wishlisted}">♥ 찜한 책</c:when><c:otherwise>♡ 찜하기</c:otherwise></c:choose>
            </button>
          </form>
        </c:if>

        <!-- 별점 대형 표시 (알라딘 스타일) -->
        <div style="display:flex;align-items:center;gap:12px;margin-top:12px;margin-bottom:20px;flex-wrap:wrap">
          <div class="detail-big-rating"><fmt:formatNumber value="${book.avgRating}" pattern="0.0"/></div>
          <div>
            <div class="detail-stars">
              <c:forEach begin="1" end="5" varStatus="s">
                <c:choose>
                  <c:when test="${s.index <= book.avgRating}">★</c:when>
                  <c:when test="${s.index - 0.5 <= book.avgRating}">★</c:when>
                  <c:otherwise><span style="opacity:.2">★</span></c:otherwise>
                </c:choose>
              </c:forEach>
            </div>
            <div class="caption" style="color:var(--ink-48);margin-top:4px">
              <fmt:formatNumber value="${book.reviewCount}" pattern="#,###"/>개의 리뷰 기준
            </div>
          </div>
        </div>

        <!-- 별점 분포 바 (알라딘/예스24 스타일) -->
        <div class="rating-bars" style="max-width:320px">
          <c:set var="p5" value="${book.getRatingPct(5)}"/>
          <c:set var="p4" value="${book.getRatingPct(4)}"/>
          <c:set var="p3" value="${book.getRatingPct(3)}"/>
          <c:set var="p2" value="${book.getRatingPct(2)}"/>
          <c:set var="p1" value="${book.getRatingPct(1)}"/>
          <div class="rating-row"><span class="rating-label">5★</span><div class="rating-bar-track"><div class="rating-bar-fill" style="width:${p5}%"></div></div><span class="rating-pct">${p5}%</span></div>
          <div class="rating-row"><span class="rating-label">4★</span><div class="rating-bar-track"><div class="rating-bar-fill" style="width:${p4}%"></div></div><span class="rating-pct">${p4}%</span></div>
          <div class="rating-row"><span class="rating-label">3★</span><div class="rating-bar-track"><div class="rating-bar-fill" style="width:${p3}%"></div></div><span class="rating-pct">${p3}%</span></div>
          <div class="rating-row"><span class="rating-label">2★</span><div class="rating-bar-track"><div class="rating-bar-fill" style="width:${p2}%"></div></div><span class="rating-pct">${p2}%</span></div>
          <div class="rating-row"><span class="rating-label">1★</span><div class="rating-bar-track"><div class="rating-bar-fill" style="width:${p1}%"></div></div><span class="rating-pct">${p1}%</span></div>
        </div>
      </div>
    </div>

    <!-- 감성 요약 바 -->
    <div style="margin-top:40px;max-width:600px">
      <p class="caption-strong" style="margin-bottom:10px;color:var(--ink-48)">감성 분포</p>
      <div class="senti-bar">
        <div class="senti-pos" style="flex:${book.posPercent}"></div>
        <div class="senti-neu" style="flex:${book.neuPercent}"></div>
        <div class="senti-neg" style="flex:${book.negPercent}"></div>
      </div>
      <div class="senti-legend">
        <div style="display:flex;align-items:center;gap:6px">
          <div class="senti-dot" style="background:var(--pos)"></div>
          <span class="caption">긍정 (4~5점) <strong><fmt:formatNumber value="${book.posPercent}" pattern="0"/></strong>%</span>
        </div>
        <div style="display:flex;align-items:center;gap:6px">
          <div class="senti-dot" style="background:var(--neu)"></div>
          <span class="caption">중립 (3점) <strong><fmt:formatNumber value="${book.neuPercent}" pattern="0"/></strong>%</span>
        </div>
        <div style="display:flex;align-items:center;gap:6px">
          <div class="senti-dot" style="background:var(--neg)"></div>
          <span class="caption">부정 (1~2점) <strong><fmt:formatNumber value="${book.negPercent}" pattern="0"/></strong>%</span>
        </div>
      </div>
    </div>

    <!-- 한 줄 총평 -->
    <div style="margin-top:32px;background:var(--parchment);border-radius:14px;padding:20px 24px;max-width:600px">
      <p class="body-strong" style="margin-bottom:6px">리뷰 총평</p>
      <p style="font-size:15px;color:var(--ink-80);line-height:1.6">
        총 <strong><fmt:formatNumber value="${book.reviewCount}" pattern="#,###"/>개</strong>의 리뷰를 분석한 결과,
        <c:choose>
          <c:when test="${book.posPercent >= 70}">
            대체로 <strong style="color:var(--pos)">호평</strong>을 받는 책입니다. 평균 평점 <strong><fmt:formatNumber value="${book.avgRating}" pattern="0.0"/>점</strong>으로 독자 만족도가 높습니다.
          </c:when>
          <c:when test="${book.posPercent >= 50}">
            <strong style="color:var(--pos)">긍정적</strong> 평가가 우세합니다. 평균 <strong><fmt:formatNumber value="${book.avgRating}" pattern="0.0"/>점</strong>.
          </c:when>
          <c:when test="${book.negPercent >= 40}">
            <strong style="color:var(--neg)">혹평</strong>이 적지 않은 책입니다. 평균 <strong><fmt:formatNumber value="${book.avgRating}" pattern="0.0"/>점</strong>.
          </c:when>
          <c:otherwise>
            평가가 다소 <strong>엇갈리는</strong> 책입니다. 평균 <strong><fmt:formatNumber value="${book.avgRating}" pattern="0.0"/>점</strong>.
          </c:otherwise>
        </c:choose>
      </p>
    </div>

    <!-- 구매처 바로가기 (제목으로 각 서점 검색 → 실시간 가격 확인) -->
    <div style="margin-top:28px;max-width:600px">
      <p class="caption-strong" style="margin-bottom:10px;color:var(--ink-48)">구매처 · 가격 보기</p>
      <c:url var="yes24Url" value="https://www.yes24.com/Product/Search"><c:param name="domain" value="BOOK"/><c:param name="query" value="${book.title}"/></c:url>
      <c:url var="aladinUrl" value="https://www.aladin.co.kr/search/wsearchresult.aspx"><c:param name="SearchWord" value="${book.title}"/></c:url>
      <c:url var="kyoboUrl" value="https://search.kyobobook.co.kr/search"><c:param name="keyword" value="${book.title}"/></c:url>
      <c:set var="storeBtn" value="display:inline-flex;align-items:center;gap:7px;padding:10px 18px;border-radius:9999px;border:1px solid var(--hairline);background:#fff;font-size:14px;font-weight:600;text-decoration:none"/>
      <div style="display:flex;gap:10px;flex-wrap:wrap">
        <a href="${yes24Url}"  target="_blank" rel="noopener" style="${storeBtn};color:#0b6cb7">예스24 <span style="opacity:.5">↗</span></a>
        <a href="${aladinUrl}" target="_blank" rel="noopener" style="${storeBtn};color:#1f8a70">알라딘 <span style="opacity:.5">↗</span></a>
        <a href="${kyoboUrl}"  target="_blank" rel="noopener" style="${storeBtn};color:#7a3e9d">교보문고 <span style="opacity:.5">↗</span></a>
      </div>
      <p class="fine-print" style="margin-top:8px;color:var(--ink-48)">각 서점에서 '<c:out value="${book.title}"/>' 검색 결과(실시간 가격)로 이동합니다.</p>
    </div>

  </div>
</section>

<!-- ── REVIEWS (dark) ──────────────────────────────── -->
<section class="tile tile-dark" style="text-align:left">
  <div style="max-width:860px;margin:0 auto">
    <h2 class="display-md" style="color:#fff;margin-bottom:28px">독자 리뷰</h2>

    <!-- 회원 리뷰 작성 -->
    <c:choose>
      <c:when test="${not empty userVO}">
        <div style="background:rgba(255,255,255,0.06);border-radius:14px;padding:18px 20px;margin-bottom:32px">
          <div style="display:flex;align-items:center;gap:12px;margin-bottom:12px">
            <span style="color:rgba(255,255,255,0.7);font-size:14px">별점</span>
            <div id="starInput" style="font-size:26px;cursor:pointer;user-select:none;letter-spacing:2px">
              <span data-v="1">★</span><span data-v="2">★</span><span data-v="3">★</span><span data-v="4">★</span><span data-v="5">★</span>
            </div>
            <span id="ratingLabel" style="color:rgba(255,255,255,0.5);font-size:13px">5점</span>
          </div>
          <form method="post" action="${ctx}/comments" style="display:flex;gap:10px;flex-wrap:wrap">
            <input type="hidden" name="bookNo" value="${book.no}">
            <input type="hidden" name="title" value="<c:out value='${book.title}'/>">
            <input type="hidden" name="rating" id="ratingValue" value="5">
            <input type="text" name="content" maxlength="1000" required
                   placeholder="이 책에 대한 리뷰를 남겨보세요"
                   style="flex:1;min-width:220px;padding:12px 14px;border:none;border-radius:10px;font-size:15px">
            <button type="submit" class="btn-primary-nav">리뷰 등록</button>
          </form>
        </div>
      </c:when>
      <c:otherwise>
        <p style="margin-bottom:28px;color:rgba(255,255,255,0.6)">
          리뷰를 작성하려면 <a href="${ctx}/login" style="color:#93c5fd">로그인</a>하세요.
        </p>
      </c:otherwise>
    </c:choose>

    <div class="review-list">

      <!-- 회원이 작성한 리뷰 (최신순, 맨 위) -->
      <c:forEach var="cmt" items="${comments}">
        <div class="review-item-dark">
          <div style="display:flex;align-items:center;gap:8px;margin-bottom:8px;flex-wrap:wrap">
            <span class="stars" style="font-size:14px">
              <c:forEach begin="1" end="5" varStatus="s">
                <c:choose>
                  <c:when test="${s.index <= cmt.rating}">★</c:when>
                  <c:otherwise><span style="opacity:.25">★</span></c:otherwise>
                </c:choose>
              </c:forEach>
            </span>
            <span style="font-size:13px;color:rgba(255,255,255,0.5)">${cmt.rating}점</span>
            <span style="font-size:11px;padding:2px 8px;border-radius:9999px;
                  background:${cmt.sentiment == '긍정' ? 'rgba(48,164,108,0.2)' : (cmt.sentiment == '중립' ? 'rgba(200,144,47,0.2)' : 'rgba(229,72,77,0.2)')};
                  color:${cmt.sentiment == '긍정' ? '#4ade80' : (cmt.sentiment == '중립' ? '#fbbf24' : '#f87171')}">${cmt.sentiment}</span>
            <strong style="font-size:13px;color:#fff;margin-left:4px"><c:out value="${cmt.nickname}"/></strong>
            <span style="font-size:12px;color:rgba(255,255,255,0.4)">${cmt.regDate}</span>
            <span style="font-size:11px;padding:2px 8px;border-radius:9999px;background:rgba(96,165,250,0.2);color:#93c5fd">회원</span>
            <c:if test="${not empty userVO and userVO.no == cmt.memberNo}">
              <form method="post" action="${ctx}/comments/delete" style="margin:0 0 0 auto"
                    onsubmit="return confirm('리뷰를 삭제할까요?');">
                <input type="hidden" name="commentNo" value="${cmt.no}">
                <input type="hidden" name="from" value="detail">
                <input type="hidden" name="title" value="<c:out value='${book.title}'/>">
                <button type="submit" style="background:none;border:none;color:#f87171;cursor:pointer;font-size:13px;padding:0">삭제</button>
              </form>
            </c:if>
          </div>
          <p class="review-content"><c:out value="${cmt.content}"/></p>
          <div style="margin-top:8px">
            <c:choose>
              <c:when test="${not empty userVO}">
                <form method="post" action="${ctx}/comments/like" style="display:inline">
                  <input type="hidden" name="commentNo" value="${cmt.no}">
                  <input type="hidden" name="from" value="detail">
                  <input type="hidden" name="title" value="<c:out value='${book.title}'/>">
                  <button type="submit"
                    style="background:none;border:none;cursor:pointer;font-size:13px;padding:0;
                           color:${cmt.liked ? '#f87171' : 'rgba(255,255,255,0.6)'}">
                    ${cmt.liked ? '♥' : '♡'} 좋아요 ${cmt.likeCount}
                  </button>
                </form>
              </c:when>
              <c:otherwise>
                <span style="font-size:13px;color:rgba(255,255,255,0.5)">♥ ${cmt.likeCount}</span>
              </c:otherwise>
            </c:choose>
          </div>
        </div>
      </c:forEach>

      <!-- 크롤링 샘플 리뷰 -->
      <c:forEach var="review" items="${book.sampleReviews}" end="29">
        <div class="review-item-dark">
          <div style="display:flex;align-items:center;gap:8px;margin-bottom:8px">
            <span class="stars" style="font-size:14px">
              <c:forEach begin="1" end="5" varStatus="s">
                <c:choose>
                  <c:when test="${s.index <= review.rating}">★</c:when>
                  <c:otherwise><span style="opacity:.25">★</span></c:otherwise>
                </c:choose>
              </c:forEach>
            </span>
            <span style="font-size:13px;color:rgba(255,255,255,0.5)">${review.rating}점</span>
            <span style="font-size:12px;margin-left:auto;padding:2px 8px;border-radius:9999px;
                  background:${review.sentiment == '긍정' ? 'rgba(48,164,108,0.2)' : (review.sentiment == '중립' ? 'rgba(200,144,47,0.2)' : 'rgba(229,72,77,0.2)')};
                  color:${review.sentiment == '긍정' ? '#4ade80' : (review.sentiment == '중립' ? '#fbbf24' : '#f87171')}">${review.sentiment}</span>
          </div>
          <p class="review-content">${review.content}</p>
        </div>
      </c:forEach>

      <c:if test="${empty comments and empty book.sampleReviews}">
        <p style="color:var(--muted-on-dark)">아직 리뷰가 없습니다. 첫 리뷰를 남겨보세요!</p>
      </c:if>
    </div>
  </div>
</section>

<!-- ── FOOTER ─────────────────────────────────────── -->
<footer class="site-footer">
  <div class="footer-inner">
    <p class="fine-print footer-copy">Copyright &copy; 2026 BookReview. 수업 과제용 프로젝트입니다.</p>
  </div>
</footer>

<script>function toggleMobileNav(){document.getElementById('mobileMenu').classList.toggle('open');}</script>

<script>
// 별점 바 애니메이션
document.querySelectorAll('.rating-bar-fill').forEach(bar => {
  const w = bar.style.width;
  bar.style.width = '0';
  requestAnimationFrame(() => { bar.style.width = w; });
});

// 별점 입력 위젯 (클릭으로만 선택, hover 미리보기 없음)
(function(){
  const input = document.getElementById('starInput');
  if (!input) return;
  const stars  = input.querySelectorAll('span');
  const hidden = document.getElementById('ratingValue');
  const label  = document.getElementById('ratingLabel');
  function paint(v){
    stars.forEach(s => { s.style.color = (Number(s.dataset.v) <= v) ? '#ffd43b' : '#555'; });
    if (label) label.textContent = v + '점';
  }
  stars.forEach(s => {
    s.addEventListener('click', () => { hidden.value = s.dataset.v; paint(Number(s.dataset.v)); });
  });
  paint(Number(hidden.value)); // 기본 5점 표시
})();
</script>
</body>
</html>
