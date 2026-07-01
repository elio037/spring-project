<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;600;700&display=swap" rel="stylesheet">
<style>
/* ═══════════════════════════════════════════════════════
   Apple Design System — Book Review
   ─────────────────────────────────────────────────────── */
:root {
  --primary:         #0066cc;
  --primary-focus:   #0071e3;
  --primary-on-dark: #2997ff;
  --canvas:          #ffffff;
  --parchment:       #f5f5f7;
  --pearl:           #fafafc;
  --tile-1:          #272729;
  --tile-2:          #2a2a2c;
  --tile-3:          #252527;
  --black:           #000000;
  --ink:             #1d1d1f;
  --body-on-dark:    #ffffff;
  --muted-on-dark:   #cccccc;
  --ink-80:          #333333;
  --ink-48:          #7a7a7a;
  --divider-soft:    #f0f0f0;
  --hairline:        #e0e0e0;
  --star:            #ff9500;
  --pos:             #30a46c;
  --neu:             #c8902f;
  --neg:             #e5484d;
  --section-pad:     80px;
}
*,*::before,*::after { box-sizing:border-box; margin:0; padding:0; }
html { scroll-behavior:smooth; }
body {
  font-family: 'Inter', system-ui, -apple-system, BlinkMacSystemFont, sans-serif;
  background: var(--canvas);
  color: var(--ink);
  font-size: 17px;
  font-weight: 400;
  line-height: 1.47;
  letter-spacing: -0.374px;
}
a { text-decoration: none; color: inherit; }
img { max-width: 100%; display: block; }

/* ── Global Nav ──────────────────────────────────────── */
.global-nav {
  position: fixed; top: 0; left: 0; right: 0; z-index: 1000;
  height: 44px;
  background: #fff;
  border-bottom: 1px solid rgba(0,0,0,0.08);
}
.nav-inner {
  max-width: 1440px; margin: 0 auto;
  height: 100%;
  display: flex; align-items: center; gap: 20px;
  padding: 0 22px;
}
.nav-logo {
  display: flex; align-items: center; gap: 6px;
  color: var(--ink); font-size: 13px; font-weight: 600;
  letter-spacing: -0.12px; white-space: nowrap;
}
.nav-logo svg { opacity: 0.65; }
.nav-links {
  display: flex; list-style: none; gap: 0;
  margin-left: 8px; flex: 1;
}
.nav-links a {
  color: rgba(0,0,0,0.62); font-size: 12px;
  letter-spacing: -0.12px; line-height: 1;
  padding: 0 12px; transition: color .15s;
}
.nav-links a:hover { color: #000; }
.nav-actions {
  display: flex; align-items: center; gap: 8px; margin-left: auto;
}
.nav-user {
  color: rgba(0,0,0,0.48); font-size: 12px; margin-right: 4px;
}
.btn-dark-util {
  background: var(--ink); color: #fff;
  font-size: 12px; letter-spacing: -0.224px;
  border-radius: 8px; padding: 5px 12px;
  transition: transform .1s;
}
.btn-dark-util:hover { background: #3a3a3c; }
.btn-dark-util:active { transform: scale(0.95); }
.btn-primary-nav {
  background: var(--primary); color: #fff;
  font-size: 12px; border-radius: 9999px;
  padding: 6px 14px; transition: transform .1s;
}
.btn-primary-nav:hover { background: #0077ed; }
.btn-primary-nav:active { transform: scale(0.95); }
.nav-hamburger {
  display: none; flex-direction: column; gap: 5px;
  background: none; border: none; cursor: pointer; padding: 4px;
}
.nav-hamburger span { display:block; width:22px; height:2px; background:var(--ink); border-radius:2px; }
.mobile-menu {
  display: none; position: fixed; top: 44px; left: 0; right: 0; z-index: 999;
  background: rgba(255,255,255,0.98); padding: 16px 22px;
  flex-direction: column; gap: 2px;
  box-shadow: 0 8px 24px rgba(0,0,0,0.1);
  border-top: 1px solid rgba(0,0,0,0.06);
}
.mobile-menu a {
  color: var(--ink); font-size: 15px; padding: 12px 0;
  border-bottom: 1px solid rgba(0,0,0,0.06);
}
.mobile-menu.open { display: flex; }

/* ── Hero Section (light, book-style) ───────────── */
.hero-section {
  background: #fff;
  overflow: hidden;
  border-bottom: 1px solid var(--hairline);
}
.hero-split {
  max-width: 1440px; margin: 0 auto;
  display: grid;
  grid-template-columns: 55% 45%;
  align-items: flex-end;
  min-height: 340px;
}
.hero-text-side {
  padding: 60px 40px 52px 22px;
}
.hero-breadcrumb {
  font-size: 12px; color: var(--ink-48);
  margin-bottom: 14px; letter-spacing: 0;
}
.hero-breadcrumb a { color: var(--ink-48); }
.hero-breadcrumb a:hover { color: var(--ink); }
.hero-big-text {
  font-size: 128px; font-weight: 800;
  line-height: 0.88; letter-spacing: -5px;
  color: #000; margin-bottom: 20px;
  font-family: 'Inter', system-ui, sans-serif;
}
.hero-tagline {
  font-size: 26px; font-weight: 400;
  letter-spacing: -0.4px; color: var(--ink);
  margin-bottom: 10px; line-height: 1.25;
}
.hero-info { font-size: 15px; color: var(--ink-48); margin-bottom: 28px; }
.hero-actions { display: flex; gap: 12px; flex-wrap: wrap; }

/* ── Book Spine Shelf ────────────────────────────── */
.hero-spine-shelf {
  display: flex;
  align-items: flex-end;
  gap: 10px;
  padding: 0;
  height: 340px;
  overflow: visible;
}
.spine {
  width: 54px;
  border-radius: 5px 2px 2px 5px;
  writing-mode: vertical-rl;
  text-orientation: mixed;
  display: flex;
  align-items: center;
  justify-content: center;
  font-size: 13px; font-weight: 700;
  color: #fff;
  letter-spacing: 4px;
  box-shadow: 4px 4px 18px rgba(0,0,0,0.18);
  flex-shrink: 0;
  transition: transform .25s ease;
  position: relative;
  user-select: none;
  cursor: default;
}
.spine::after {
  content: '';
  position: absolute;
  left: 0; top: 0; bottom: 0; width: 8px;
  background: rgba(0,0,0,0.16);
  border-radius: 5px 0 0 5px;
}
.spine:hover { transform: translateY(-16px); }
.spine-1 { height: 268px; background: #7b5ea7; }
.spine-2 { height: 240px; background: #e07b28; }
.spine-3 { height: 288px; background: #2a9d5c; }
.spine-4 { height: 216px; background: #17826a; }
.spine-5 { height: 310px; background: #4a9fd4; }

/* ── Filter Bar ──────────────────────────────────── */
.filter-bar {
  background: #fff;
  border-bottom: 1px solid var(--hairline);
  padding: 10px 22px;
}
.filter-bar-inner {
  max-width: 1440px; margin: 0 auto;
  display: flex; align-items: center; gap: 8px;
}
.filter-chip {
  display: inline-flex; align-items: center; gap: 5px;
  background: #fff; border: 1px solid #c0c0c0;
  border-radius: 9999px; padding: 5px 14px;
  font-size: 13px; color: var(--ink); cursor: pointer;
  text-decoration: none; white-space: nowrap;
  transition: border-color .15s; font-family: inherit;
}
.filter-chip:hover { border-color: var(--ink); }
.filter-count { font-size: 13px; color: var(--ink-48); white-space: nowrap; }
.filter-spacer { flex: 1; }
.filter-view-btns { display: flex; gap: 4px; }
.filter-view-btn {
  width: 30px; height: 30px;
  display: flex; align-items: center; justify-content: center;
  border: 1px solid var(--hairline); border-radius: 5px;
  cursor: pointer; color: var(--ink-48); transition: all .15s;
}
.filter-view-btn.active { border-color: #999; color: var(--ink); }

/* ── Book cover image ────────────────────────────── */
.book-card-cover { width: 100%; height: 100%; object-fit: cover; border-radius: 10px; display: block; }

/* ── Book cover color helpers ────────────────────── */
.book-card-icon.bg-c0 { background: linear-gradient(150deg,#7b5ea7,#5c4299); }
.book-card-icon.bg-c1 { background: linear-gradient(150deg,#e07b28,#c05a18); }
.book-card-icon.bg-c2 { background: linear-gradient(150deg,#2a9d5c,#1e7a44); }
.book-card-icon.bg-c3 { background: linear-gradient(150deg,#17826a,#0f6251); }
.book-card-icon.bg-c4 { background: linear-gradient(150deg,#4a9fd4,#2e7fb5); }
.book-card-icon.bg-c5 { background: linear-gradient(150deg,#c0392b,#922b21); }
.book-card-icon.bg-c6 { background: linear-gradient(150deg,#8e44ad,#6c3483); }
.book-card-icon.bg-c7 { background: linear-gradient(150deg,#2471a3,#1a5276); }

/* ── Buttons ─────────────────────────────────────────── */
.btn-primary {
  display: inline-block;
  background: var(--primary); color: #fff;
  font-size: 17px; font-weight: 400;
  border-radius: 9999px; padding: 11px 22px;
  border: none; cursor: pointer;
  transition: transform .1s;
}
.btn-primary:hover { background: #0077ed; }
.btn-primary:active { transform: scale(0.95); }
.btn-ghost {
  display: inline-block;
  background: transparent; color: var(--primary);
  font-size: 17px; border-radius: 9999px;
  padding: 10px 22px; border: 1px solid var(--primary);
  cursor: pointer; transition: transform .1s;
}
.btn-ghost:hover { background: rgba(0,102,204,.06); }
.btn-ghost:active { transform: scale(0.95); }

/* ── Hero Tile (dark) ───────────────────────────────── */
.tile { width: 100%; }
.tile-dark {
  background: var(--tile-1); color: var(--body-on-dark);
  padding: var(--section-pad) 22px;
  text-align: center;
}
.tile-dark-2 { background: var(--tile-2); color: var(--body-on-dark); padding: var(--section-pad) 22px; text-align: center; }
.tile-light { background: var(--canvas); color: var(--ink); padding: var(--section-pad) 22px; text-align: center; }
.tile-parchment { background: var(--parchment); color: var(--ink); padding: var(--section-pad) 22px; text-align: center; }

.tile-inner { max-width: 980px; margin: 0 auto; }
.tile-inner-wide { max-width: 1200px; margin: 0 auto; }

/* ── Typography ──────────────────────────────────────── */
.hero-display {
  font-size: 56px; font-weight: 600;
  line-height: 1.07; letter-spacing: -0.28px;
  margin-bottom: 16px;
}
.display-lg {
  font-size: 40px; font-weight: 600;
  line-height: 1.10; letter-spacing: -0.374px;
  margin-bottom: 12px;
}
.display-md {
  font-size: 34px; font-weight: 600;
  line-height: 1.47; letter-spacing: -0.374px;
}
.lead {
  font-size: 28px; font-weight: 400;
  line-height: 1.14; letter-spacing: 0.196px;
  margin-bottom: 28px;
}
.lead-sm {
  font-size: 21px; font-weight: 400;
  line-height: 1.47; letter-spacing: -0.374px;
  margin-bottom: 20px;
}
.tagline {
  font-size: 21px; font-weight: 600;
  line-height: 1.19; letter-spacing: 0.231px;
}
.body-strong { font-size: 17px; font-weight: 600; letter-spacing: -0.374px; }
.caption { font-size: 14px; font-weight: 400; letter-spacing: -0.224px; }
.caption-strong { font-size: 14px; font-weight: 600; letter-spacing: -0.224px; }
.fine-print { font-size: 12px; font-weight: 400; letter-spacing: -0.12px; }

.text-muted-dark { color: var(--muted-on-dark); }
.text-primary { color: var(--primary); }
.text-primary-dark { color: var(--primary-on-dark); }

/* ── Book Grid Cards ─────────────────────────────────── */
.book-grid {
  display: grid;
  grid-template-columns: repeat(4, 1fr);
  gap: 20px;
  text-align: left;
}
.book-card {
  background: var(--canvas);
  border: 1px solid var(--hairline);
  border-radius: 18px;
  padding: 24px;
  cursor: pointer;
  transition: transform .15s;
  display: flex; flex-direction: column; gap: 8px;
}
.book-card:hover { transform: translateY(-2px); }
.tile-dark .book-card,
.tile-dark-2 .book-card { background: rgba(255,255,255,0.06); border-color: rgba(255,255,255,0.1); }
.book-card-icon {
  width: 56px; height: 56px; border-radius: 10px;
  background: linear-gradient(135deg,#1c1c1e,#3a3a3c);
  display: flex; align-items: center; justify-content: center;
  font-size: 24px; margin-bottom: 4px;
  flex-shrink: 0;
}
.tile-light .book-card-icon:not([class*="bg-c"]),
.tile-parchment .book-card-icon:not([class*="bg-c"]) { background: linear-gradient(135deg,#f0f0f2,#e5e5ea); }
.book-card-title {
  font-size: 15px; font-weight: 600;
  line-height: 1.3; letter-spacing: -0.374px;
  display: -webkit-box; -webkit-line-clamp: 2; line-clamp: 2;
  -webkit-box-orient: vertical; overflow: hidden;
}
.tile-dark .book-card-title,
.tile-dark-2 .book-card-title { color: #fff; }
.book-card-meta { font-size: 13px; color: var(--ink-48); letter-spacing: -0.12px; }
.tile-dark .book-card-meta,
.tile-dark-2 .book-card-meta { color: var(--muted-on-dark); }

/* ── Stars ───────────────────────────────────────────── */
.stars { display: inline-flex; gap: 2px; color: var(--star); font-size: 15px; }
.stars-lg { font-size: 22px; }
.rating-num { font-size: 14px; font-weight: 600; margin-left: 4px; color: var(--ink); }
.tile-dark .rating-num { color: #fff; }

/* ── Rating Bars (알라딘 스타일) ─────────────────────── */
.rating-bars { width: 100%; }
.rating-row {
  display: flex; align-items: center; gap: 8px;
  margin-bottom: 6px;
}
.rating-label { width: 24px; font-size: 13px; text-align: right; color: var(--ink-48); }
.rating-bar-track {
  flex: 1; height: 6px; border-radius: 3px;
  background: var(--hairline); overflow: hidden;
}
.rating-bar-fill { height: 100%; border-radius: 3px; background: var(--star); transition: width .4s; }
.rating-pct { width: 32px; font-size: 12px; color: var(--ink-48); text-align: right; }

/* ── Sentiment Bar ───────────────────────────────────── */
.senti-bar {
  display: flex; height: 8px; border-radius: 4px; overflow: hidden; gap: 1px;
}
.senti-pos { background: var(--pos); }
.senti-neu { background: var(--neu); }
.senti-neg { background: var(--neg); }
.senti-legend { display: flex; gap: 16px; margin-top: 8px; }
.senti-dot { width: 10px; height: 10px; border-radius: 50%; flex-shrink: 0; margin-top: 3px; }

/* ── Review Cards ────────────────────────────────────── */
.review-list { display: flex; flex-direction: column; gap: 16px; }
.review-item {
  background: var(--parchment); border-radius: 14px;
  padding: 20px 24px; text-align: left;
}
.review-item-dark { background: rgba(255,255,255,0.07); border-radius: 14px; padding: 20px 24px; }
.review-content { font-size: 15px; line-height: 1.6; color: var(--ink-80); }
.review-item-dark .review-content { color: var(--muted-on-dark); }
.review-meta { font-size: 13px; color: var(--ink-48); margin-top: 8px; }
.review-item-dark .review-meta { color: rgba(255,255,255,0.4); }

/* ── Search ──────────────────────────────────────────── */
.search-wrap { position: relative; max-width: 600px; margin: 0 auto; }
.search-input {
  width: 100%;
  background: var(--canvas); color: var(--ink);
  font-size: 17px; letter-spacing: -0.374px;
  border: 1px solid rgba(0,0,0,0.08);
  border-radius: 9999px;
  padding: 12px 48px 12px 20px;
  height: 44px; outline: none;
  transition: border-color .15s;
}
.search-input:focus { border-color: var(--primary); }
.search-icon {
  position: absolute; right: 16px; top: 50%;
  transform: translateY(-50%); color: var(--ink-48);
  pointer-events: none;
}
.search-btn {
  position: absolute; right: 4px; top: 50%;
  transform: translateY(-50%);
  background: var(--primary); color: #fff;
  border: none; border-radius: 9999px;
  padding: 6px 16px; font-size: 14px; cursor: pointer;
  transition: transform .1s;
}
.search-btn:active { transform: translateY(-50%) scale(0.95); }

/* ── Sub-nav ─────────────────────────────────────────── */
.sub-nav {
  position: sticky; top: 44px; z-index: 900;
  background: rgba(245,245,247,0.8);
  backdrop-filter: saturate(180%) blur(20px);
  border-bottom: 1px solid rgba(0,0,0,0.08);
  height: 52px;
}
.sub-nav-inner {
  max-width: 1200px; margin: 0 auto;
  height: 100%; display: flex; align-items: center;
  padding: 0 22px; gap: 20px;
}
.sub-nav-title { font-size: 21px; font-weight: 600; letter-spacing: 0.231px; }

/* ── Forms ───────────────────────────────────────────── */
.form-page {
  min-height: 100vh; display: flex; align-items: center;
  justify-content: center; background: var(--parchment);
  padding: 80px 22px 40px;
}
.form-card {
  background: var(--canvas); border-radius: 20px;
  padding: 48px 44px 40px; width: 100%; max-width: 420px;
  box-shadow: 0 4px 30px rgba(0,0,0,0.08);
  text-align: center;
}
.form-logo {
  display: flex; align-items: center; justify-content: center; gap: 8px;
  font-size: 22px; font-weight: 700; color: var(--ink); margin-bottom: 8px;
}
.form-sub { font-size: 14px; color: var(--ink-48); margin-bottom: 32px; }
.form-field { text-align: left; margin-bottom: 16px; }
.form-label { font-size: 13px; font-weight: 600; color: var(--ink-48); margin-bottom: 6px; display: block; }
.form-input {
  width: 100%; background: var(--parchment); color: var(--ink);
  font-size: 15px; border: 1px solid transparent;
  border-radius: 12px; padding: 13px 16px; outline: none;
  transition: border-color .15s;
}
.form-input:focus { border-color: var(--primary); background: var(--canvas); }
.form-submit {
  width: 100%; background: var(--primary); color: #fff;
  font-size: 17px; font-weight: 400; border: none;
  border-radius: 9999px; padding: 14px; cursor: pointer;
  margin-top: 8px; transition: transform .1s;
}
.form-submit:hover { background: #0077ed; }
.form-submit:active { transform: scale(0.95); }
.form-divider {
  display: flex; align-items: center; gap: 12px;
  margin: 22px 0; color: var(--ink-48); font-size: 13px;
}
.form-divider::before, .form-divider::after {
  content: ''; flex: 1; height: 1px; background: var(--hairline);
}
.form-face-btn {
  width: 100%; background: var(--ink); color: #fff;
  border: none; border-radius: 14px; padding: 14px;
  font-size: 15px; font-weight: 600; cursor: pointer;
  display: flex; align-items: center; justify-content: center; gap: 8px;
  transition: background .15s;
}
.form-face-btn:hover { background: #3a3a3c; }
.kakao-login-btn {
  width: 100%; box-sizing: border-box; margin-top: 12px;
  background: #FEE500; color: rgba(0,0,0,0.85);
  border: none; border-radius: 14px; padding: 14px;
  font-size: 15px; font-weight: 600; cursor: pointer; text-decoration: none;
  display: flex; align-items: center; justify-content: center; gap: 8px;
  transition: filter .15s;
}
.kakao-login-btn:hover { filter: brightness(0.96); }
.face-area { display: none; margin-top: 18px; }
.face-area video { width: 100%; border-radius: 14px; background: #000; display: block; }
.face-status { margin-top: 10px; font-size: 14px; color: var(--ink-48); min-height: 20px; }
.face-status.scanning { color: #228be6; }
.face-status.success  { color: #30a46c; font-weight: 700; }
.face-status.error    { color: #e5484d; }
.form-foot { margin-top: 20px; font-size: 14px; color: var(--ink-48); }
.form-foot a { color: var(--primary); font-weight: 600; }
.form-msg { color: #e5484d; font-size: 13px; margin-bottom: 14px; }
.form-err { color: #e5484d; font-size: 12px; margin-top: 4px; }

/* ── Rank Table ──────────────────────────────────────── */
.rank-table { width: 100%; border-collapse: collapse; }
.rank-table th, .rank-table td {
  text-align: left; padding: 14px 16px;
  border-bottom: 1px solid var(--hairline); font-size: 15px;
}
.rank-table th { font-size: 13px; font-weight: 600; color: var(--ink-48); }
.rank-table tr:hover td { background: var(--parchment); }
.rank-num { font-size: 20px; font-weight: 700; color: var(--ink-48); width: 40px; text-align: center; }
.rank-num.top3 { color: var(--star); }
.rank-title-link { color: var(--primary); font-weight: 600; }

/* ── Book Detail Header ──────────────────────────────── */
.detail-header {
  background: var(--canvas); padding: var(--section-pad) 22px;
}
.detail-header-inner {
  max-width: 860px; margin: 0 auto;
}
.detail-big-rating {
  font-size: 72px; font-weight: 700; color: var(--ink);
  line-height: 1; letter-spacing: -2px;
}
.detail-stars { font-size: 28px; color: var(--star); }

/* ── Pagination ──────────────────────────────────────── */
.pagination { display: flex; justify-content: center; gap: 4px; margin-top: 32px; }
.page-btn {
  width: 36px; height: 36px; border-radius: 50%;
  display: flex; align-items: center; justify-content: center;
  font-size: 14px; color: var(--ink); cursor: pointer;
  border: 1px solid var(--hairline); background: var(--canvas);
  transition: all .15s;
}
.page-btn.active { background: var(--primary); color: #fff; border-color: var(--primary); }
.page-btn:hover:not(.active) { background: var(--parchment); }

/* ── Footer ──────────────────────────────────────────── */
.site-footer {
  background: var(--parchment); padding: 48px 22px;
}
.footer-inner { max-width: 980px; margin: 0 auto; }
.footer-copy { font-size: 12px; color: var(--ink-48); }

/* ── Loading overlay ─────────────────────────────────── */
.loading-badge {
  display: inline-flex; align-items: center; gap: 8px;
  background: rgba(0,0,0,0.06); border-radius: 9999px;
  padding: 6px 16px; font-size: 13px; color: var(--ink-48);
}
.spin {
  width: 14px; height: 14px; border: 2px solid var(--hairline);
  border-top-color: var(--primary); border-radius: 50%;
  animation: spin .8s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }

/* ── Responsive ──────────────────────────────────────── */
@media (max-width: 1068px) {
  .hero-display { font-size: 40px; }
  .book-grid { grid-template-columns: repeat(3, 1fr); }
  .hero-big-text { font-size: 96px; }
}
@media (max-width: 833px) {
  .nav-links, .nav-actions { display: none; }
  .nav-hamburger { display: flex; margin-left: auto; }
  .hero-display { font-size: 34px; }
  .display-lg { font-size: 30px; }
  .lead { font-size: 22px; }
  .book-grid { grid-template-columns: repeat(2, 1fr); }
  .form-card { padding: 36px 24px 28px; }
  .hero-split { grid-template-columns: 1fr; }
  .hero-spine-shelf { display: none; }
  .hero-big-text { font-size: 72px; letter-spacing: -3px; }
  .hero-text-side { padding: 48px 22px 40px; }
}
@media (max-width: 640px) {
  .hero-display { font-size: 28px; }
  .book-grid { grid-template-columns: 1fr 1fr; gap: 12px; }
  .tile-dark, .tile-dark-2, .tile-light, .tile-parchment { padding: 48px 16px; }
  .hero-big-text { font-size: 56px; letter-spacing: -2px; }
  .filter-bar-inner { gap: 6px; }
}
@media (max-width: 419px) {
  .book-grid { grid-template-columns: 1fr; }
}
</style>
