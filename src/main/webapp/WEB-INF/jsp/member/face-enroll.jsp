<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>얼굴 등록 — BookReview</title>
<%@ include file="/WEB-INF/jsp/layout/style.jsp" %>
<style>
.enroll-card {
  background: var(--canvas); border-radius: 20px;
  padding: 48px 40px 40px; width: 100%; max-width: 440px;
  box-shadow: 0 4px 30px rgba(0,0,0,0.08); text-align: center;
}
.enroll-video { width:100%; border-radius:14px; background:#000; display:block; }
.enroll-btn {
  width:100%; border:none; border-radius:9999px; padding:14px;
  font-size:17px; font-weight:400; cursor:pointer; margin-top:14px;
  background:var(--primary); color:#fff; transition:transform .1s;
}
.enroll-btn:hover { background:#0077ed; }
.enroll-btn:active { transform:scale(0.95); }
.enroll-btn:disabled { background:#aeaeb2; cursor:not-allowed; }
.enroll-back {
  width:100%; background:var(--parchment); color:var(--ink);
  border:none; border-radius:9999px; padding:13px;
  font-size:17px; cursor:pointer; margin-top:10px; transition:transform .1s;
}
.enroll-back:active { transform:scale(0.95); }
.enroll-status { margin-top:14px; font-size:14px; color:var(--ink-48); min-height:20px; }
.enroll-status.ok    { color:#30a46c; font-weight:700; }
.enroll-status.error { color:#e5484d; }
.enroll-status.info  { color:#0066cc; }
</style>
</head>
<body>

<%@ include file="/WEB-INF/jsp/layout/nav.jsp" %>

<div class="form-page">
  <div class="enroll-card">

    <div class="form-logo" style="margin-bottom:4px">
      <svg width="22" height="22" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="12" cy="8" r="4"/>
        <path d="M8 14c-2.2.5-4 2.2-4 4"/>
        <path d="M16 14c2.2.5 4 2.2 4 4"/>
        <path d="M9 19c1 .5 2 .8 3 .8s2-.3 3-.8"/>
      </svg>
      얼굴 등록
    </div>
    <p class="form-sub"><strong>${userVO.nickname}</strong>님, 카메라를 정면으로 보고 버튼을 눌러주세요</p>

    <c:if test="${param.fromJoin == 'true'}">
      <div style="background:#e8f5e9;border-radius:12px;padding:12px 16px;margin-bottom:16px">
        <p class="caption" style="color:#2e7d32">🎉 회원가입이 완료됐어요! 얼굴을 등록하면 다음부터 카메라로 바로 로그인할 수 있어요.</p>
      </div>
    </c:if>

    <video id="video" class="enroll-video" autoplay muted playsinline></video>

    <div class="enroll-status info" id="status">딥러닝 얼굴인식 모델 로딩 중… (10~20초 소요)</div>

    <button class="enroll-btn" id="captureBtn" onclick="capture()" disabled>얼굴 촬영 &amp; 등록</button>

    <c:choose>
      <c:when test="${param.fromJoin == 'true'}">
        <button class="enroll-back" onclick="location.href='${ctx}/'">나중에 등록하기</button>
      </c:when>
      <c:otherwise>
        <button class="enroll-back" onclick="location.href='${ctx}/'">← 홈으로</button>
      </c:otherwise>
    </c:choose>

  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/@vladmandic/face-api/dist/face-api.js"></script>
<script>
const MODEL_URL = 'https://cdn.jsdelivr.net/npm/@vladmandic/face-api/model';
const CTX = '${ctx}';

function setStatus(msg, cls) {
  const el = document.getElementById('status');
  el.textContent = msg;
  el.className = 'enroll-status ' + (cls || '');
}

async function init() {
  try {
    await Promise.all([
      faceapi.nets.ssdMobilenetv1.loadFromUri(MODEL_URL),
      faceapi.nets.faceLandmark68Net.loadFromUri(MODEL_URL),
      faceapi.nets.faceRecognitionNet.loadFromUri(MODEL_URL)
    ]);
  } catch(e) {
    setStatus('모델 로딩 실패. 인터넷 연결을 확인하세요.', 'error');
    return;
  }

  try {
    const stream = await navigator.mediaDevices.getUserMedia({ video: true });
    document.getElementById('video').srcObject = stream;
  } catch(e) {
    setStatus('카메라 접근이 거부되었습니다.', 'error');
    return;
  }

  setStatus('준비됐습니다. 정면을 보고 버튼을 눌러주세요 📷', 'info');
  document.getElementById('captureBtn').disabled = false;
}

async function capture() {
  const video = document.getElementById('video');
  const btn = document.getElementById('captureBtn');
  btn.disabled = true;
  setStatus('얼굴 감지 중…', 'info');

  const result = await faceapi
    .detectSingleFace(video)
    .withFaceLandmarks()
    .withFaceDescriptor();

  if (!result) {
    setStatus('얼굴을 찾을 수 없습니다. 조명과 각도를 조정해보세요.', 'error');
    btn.disabled = false;
    return;
  }

  // 128개 실수값 (5자리 반올림)
  const descriptor = Array.from(result.descriptor).map(v => Math.round(v * 100000) / 100000);

  setStatus('서버에 저장 중…', 'info');
  let text;
  try {
    const res = await fetch(CTX + '/face-enroll', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'descriptor=' + encodeURIComponent(JSON.stringify(descriptor))
    });
    text = (await res.text()).trim();
  } catch(err) {
    setStatus('서버 통신 오류: ' + err.message, 'error');
    btn.disabled = false;
    return;
  }

  if (text === 'OK') {
    setStatus('✅ 얼굴이 등록되었습니다! 이제 얼굴로 로그인할 수 있어요.', 'ok');
    btn.textContent = '다시 등록하기';
    btn.disabled = false;
  } else if (text === 'UNAUTHORIZED') {
    setStatus('로그인이 풀렸습니다. 다시 로그인 후 시도하세요.', 'error');
    btn.disabled = false;
  } else {
    setStatus('저장 실패 (응답=' + text.substring(0, 60) + ')', 'error');
    btn.disabled = false;
  }
}

function toggleMobileNav(){document.getElementById('mobileMenu').classList.toggle('open');}
init();
</script>
</body>
</html>
