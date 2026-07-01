<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="ctx" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>로그인 — BookReview</title>
<%@ include file="/WEB-INF/jsp/layout/style.jsp" %>
</head>
<body>

<%@ include file="/WEB-INF/jsp/layout/nav.jsp" %>

<div class="form-page">
  <div class="form-card">

    <div class="form-logo">
      <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <path d="M4 19.5A2.5 2.5 0 016.5 17H20"/>
        <path d="M6.5 2H20v20H6.5A2.5 2.5 0 014 19.5v-15A2.5 2.5 0 016.5 2z"/>
      </svg>
      BookReview
    </div>
    <p class="form-sub">독자 리뷰 플랫폼에 오신 것을 환영합니다</p>

    <c:if test="${not empty msg}">
      <p class="form-msg">${msg}</p>
    </c:if>

    <!-- 일반 로그인 -->
    <form method="post" action="${ctx}/login">
      <div class="form-field">
        <label class="form-label">아이디</label>
        <input type="text" name="id" class="form-input" placeholder="아이디를 입력하세요" autocomplete="username">
      </div>
      <div class="form-field">
        <label class="form-label">비밀번호</label>
        <input type="password" name="password" class="form-input" placeholder="비밀번호를 입력하세요" autocomplete="current-password">
      </div>
      <button type="submit" class="form-submit">로그인</button>
    </form>

    <div class="form-divider">또는</div>

    <!-- 얼굴 로그인 -->
    <button class="form-face-btn" onclick="toggleFaceLogin()">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
        <circle cx="12" cy="8" r="4"/>
        <path d="M8 14c-2.2.5-4 2.2-4 4"/>
        <path d="M16 14c2.2.5 4 2.2 4 4"/>
        <path d="M9 19c1 .5 2 .8 3 .8s2-.3 3-.8"/>
      </svg>
      얼굴로 로그인
    </button>

    <div class="face-area" id="faceArea">
      <video id="video" autoplay muted playsinline style="border-radius:14px;width:100%;background:#000"></video>
      <div class="face-status" id="faceStatus">딥러닝 얼굴인식 모델 로딩 중…</div>
    </div>

    <!-- 카카오 로그인 -->
    <a href="${ctx}/oauth/kakao" class="kakao-login-btn">
      <svg width="18" height="18" viewBox="0 0 24 24" fill="#000000" aria-hidden="true">
        <path d="M12 3C6.48 3 2 6.48 2 10.8c0 2.74 1.86 5.15 4.66 6.52-.15.53-.97 3.34-1 3.56 0 0-.02.17.09.24.11.07.24.02.24.02.31-.04 3.6-2.36 4.17-2.76.6.08 1.21.13 1.84.13 5.52 0 10-3.48 10-7.78S17.52 3 12 3z"/>
      </svg>
      카카오로 로그인
    </a>

    <!-- 얼굴 인증 성공 시 JS가 자동 submit -->
    <form id="faceLoginForm" method="post" action="${ctx}/face-login" style="display:none">
      <input type="hidden" name="memberNo" id="memberNoInput">
    </form>

    <div class="form-foot">
      아직 계정이 없으신가요? <a href="${ctx}/join">회원가입</a>
    </div>
  </div>
</div>

<script src="https://cdn.jsdelivr.net/npm/@vladmandic/face-api/dist/face-api.js"></script>
<script>
const MODEL_URL = 'https://cdn.jsdelivr.net/npm/@vladmandic/face-api/model';
const CTX = '${ctx}';
const THRESHOLD = 0.5;
let videoStream = null;
let detecting = false;
let faceOpen = false;

function setStatus(msg, cls) {
  const el = document.getElementById('faceStatus');
  el.textContent = msg;
  el.className = 'face-status' + (cls ? ' ' + cls : '');
}

async function toggleFaceLogin() {
  if (!faceOpen) {
    faceOpen = true;
    document.getElementById('faceArea').style.display = 'block';
    await startFaceLogin();
  } else {
    stopCamera();
    faceOpen = false;
    document.getElementById('faceArea').style.display = 'none';
  }
}

async function startFaceLogin() {
  setStatus('딥러닝 얼굴인식 모델 로딩 중… (10~20초 소요)', 'scanning');
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

  setStatus('카메라 켜는 중…', 'scanning');
  try {
    videoStream = await navigator.mediaDevices.getUserMedia({ video: true });
    const video = document.getElementById('video');
    video.srcObject = videoStream;
    await new Promise(r => video.onloadedmetadata = r);
  } catch(e) {
    setStatus('카메라 접근이 거부되었습니다.', 'error');
    return;
  }

  setStatus('서버에서 회원 얼굴 데이터 불러오는 중…', 'scanning');
  let members;
  try {
    const res = await fetch(CTX + '/face-descriptors');
    members = await res.json();
  } catch(e) {
    setStatus('서버 통신 오류가 발생했습니다.', 'error');
    return;
  }

  if (!members || members.length === 0) {
    setStatus('등록된 얼굴이 없습니다. 먼저 얼굴을 등록하세요.', 'error');
    return;
  }

  const stored = members.map(m => ({
    no: m.no,
    descriptor: new Float32Array(JSON.parse(m.descriptor))
  }));

  setStatus('얼굴을 카메라 정면에 보여주세요 📷', 'scanning');
  detecting = true;
  detectLoop(stored);
}

async function detectLoop(stored) {
  const video = document.getElementById('video');
  while (detecting) {
    const result = await faceapi
      .detectSingleFace(video)
      .withFaceLandmarks()
      .withFaceDescriptor();

    if (result) {
      let best = null, bestDist = Infinity;
      for (const m of stored) {
        const dist = faceapi.euclideanDistance(result.descriptor, m.descriptor);
        if (dist < bestDist) { bestDist = dist; best = m; }
      }
      if (bestDist <= THRESHOLD) {
        detecting = false;
        stopCamera();
        setStatus('✅ 얼굴 인식 성공! 로그인 중… (거리=' + bestDist.toFixed(2) + ')', 'success');
        document.getElementById('memberNoInput').value = best.no;
        document.getElementById('faceLoginForm').submit();
        return;
      } else {
        setStatus('일치하는 회원이 없습니다. (거리=' + bestDist.toFixed(2) + ') 계속 시도 중…', 'error');
      }
    }
    await new Promise(r => setTimeout(r, 400));
  }
}

function stopCamera() {
  detecting = false;
  if (videoStream) {
    videoStream.getTracks().forEach(t => t.stop());
    videoStream = null;
  }
}

function toggleMobileNav(){document.getElementById('mobileMenu').classList.toggle('open');}
</script>
</body>
</html>
