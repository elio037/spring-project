# -*- coding: utf-8 -*-
"""BookReview 발표 내용 → 보고서 형식 PDF"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
import matplotlib.image as mpimg
from matplotlib.patches import FancyBboxPatch
from matplotlib.backends.backend_pdf import PdfPages
from matplotlib.font_manager import FontProperties

KF = FontProperties(fname=r'C:\Windows\Fonts\malgun.ttf')
def kf(size, weight='normal'):
    f = KF.copy(); f.set_size(size); f.set_weight(weight); return f

INK='#1D1D2E'; NAVY='#20263F'; BLUE='#2E7CE6'; GOLD='#C8901F'
GREEN='#2EA06A'; RED='#E0574F'; GREY='#5C6270'; LIGHT='#F1F3F8'; WHITE='#FFFFFF'

DOC = r'D:\Lecture\spring-workspace\book-review\docs\BookReview_보고서.pdf'
ERD = r'D:\Lecture\spring-workspace\book-review\docs\erd_bookreview.png'
pdf = PdfPages(DOC)
pages_png = []

def new_page(kicker, title):
    fig = plt.figure(figsize=(8.27, 11.69), dpi=150)
    ax = fig.add_axes([0, 0, 1, 1]); ax.set_xlim(0, 210); ax.set_ylim(0, 297)
    ax.invert_yaxis(); ax.axis('off')
    # 상단 네이비 밴드
    ax.add_patch(plt.Rectangle((0, 0), 210, 32, fc=NAVY, ec='none'))
    ax.text(20, 13, kicker, ha='left', va='center', fontproperties=kf(10, 'bold'), color=GOLD)
    ax.text(20, 23, title, ha='left', va='center', fontproperties=kf(17, 'bold'), color=WHITE)
    ax.text(190, 20, 'BookReview', ha='right', va='center', fontproperties=kf(11, 'bold'), color='#8B93A7')
    # 하단 푸터
    ax.plot([20, 190], [285, 285], color='#D8DCE6', lw=0.8)
    ax.text(20, 290, 'BookReview · 스프링 발표자료 보고서 · kr.ac.kopo', ha='left', va='center',
            fontproperties=kf(8), color=GREY)
    return fig, ax

def h2(ax, y, text, color=BLUE):
    ax.add_patch(plt.Rectangle((20, y-3.4), 3, 6.8, fc=color, ec='none'))
    ax.text(26, y, text, ha='left', va='center', fontproperties=kf(13, 'bold'), color=INK)

def bullet(ax, y, text, x=27, color=GREY, size=10.5, strong=False):
    ax.text(x, y, '•', ha='left', va='center', fontproperties=kf(size, 'bold'), color=BLUE)
    ax.text(x+5, y, text, ha='left', va='center',
            fontproperties=kf(size, 'bold' if strong else 'normal'), color=INK if strong else '#33384A')

def para(ax, y, text, x=26, size=10.5, color='#33384A'):
    ax.text(x, y, text, ha='left', va='center', fontproperties=kf(size), color=color)

def card(ax, x, y, w, h, fc=LIGHT, ec='#E1E4EE'):
    ax.add_patch(FancyBboxPatch((x, y), w, h, boxstyle="round,pad=0,rounding_size=2.5",
                                fc=fc, ec=ec, lw=1))

def savefig(fig):
    pdf.savefig(fig, facecolor='white')
    p = DOC.replace('.pdf', f'_p{len(pages_png)+1}.png')
    fig.savefig(p, dpi=110, facecolor='white'); pages_png.append(p); plt.close(fig)

# ═══════════════ PAGE 1 — 개요 ═══════════════
fig, ax = new_page('01  OVERVIEW', '프로젝트 개요')
# 한 줄 정의 배너
card(ax, 20, 44, 170, 18, fc=BLUE, ec=BLUE)
ax.text(105, 53, '“독자가 남긴 실제 리뷰”로 책을 고르는 도서 리뷰·탐색 플랫폼', ha='center', va='center',
        fontproperties=kf(13, 'bold'), color=WHITE)
para(ax, 72, '알라딘 도서 리뷰 크롤링 데이터(도서 200종 · 리뷰 4,000건)를 정제해 Oracle에 적재하고,')
para(ax, 79, '도서 검색 · 평점/리뷰 순위 · 상세 통계(평점 분포 · 감성 분석)를 제공하는 Spring MVC 웹앱이다.')

h2(ax, 96, '무엇을 하는 사이트인가')
bullet(ax, 106, '독자 리뷰를 모아 책의 평점·별점 분포·감성(긍정/중립/부정)을 한눈에 보여준다')
bullet(ax, 114, '제목 검색 · 평점 순위 · 리뷰 순위로 원하는 책을 빠르게 탐색한다')
bullet(ax, 122, '로그인 후 별점 리뷰 작성 · 좋아요 · 찜(내 서재) 등 회원 활동을 지원한다')
bullet(ax, 130, '각 도서를 예스24·알라딘·교보문고 검색으로 연결해 실시간 가격을 확인한다')

h2(ax, 148, '기술 스택')
bullet(ax, 158, 'Backend : Java 17 · Spring Web MVC 6.2 · MyBatis')
bullet(ax, 166, 'Database : Oracle XE 21c (테이블 6개)')
bullet(ax, 174, 'Frontend : JSP / JSTL · 자체 CSS 디자인')
bullet(ax, 182, 'AI/인증 : 딥러닝 얼굴 인식(face-api.js) · 카카오 OAuth')

# 스탯 카드 4개
stats = [('200', '도서'), ('4,000', '리뷰'), ('6', '테이블'), ('3', '로그인 방식')]
sx = 20
for val, lab in stats:
    card(ax, sx, 198, 40, 30)
    ax.text(sx+20, 210, val, ha='center', va='center', fontproperties=kf(22, 'bold'), color=BLUE)
    ax.text(sx+20, 221, lab, ha='center', va='center', fontproperties=kf(10), color=GREY)
    sx += 43
savefig(fig)

# ═══════════════ PAGE 2 — ERD ═══════════════
fig, ax = new_page('02  DATABASE', '데이터베이스 구조 (ERD)')
para(ax, 45, '테이블 6개 · 외래키(FK) 7개 · 모든 관계는 1 : N (부모 → 자식).')
para(ax, 52, '회원 탈퇴 시 관련 데이터는 ON DELETE CASCADE로 함께 삭제된다.')
# ERD 이미지 (하단 설명 패널 포함)
img = mpimg.imread(ERD)
ih, iw = img.shape[0], img.shape[1]
disp_w_mm = 188.0
disp_h_mm = disp_w_mm * ih / iw
imax = fig.add_axes([ (210-disp_w_mm)/2/210, 1 - (62+disp_h_mm)/297, disp_w_mm/210, disp_h_mm/297 ])
imax.imshow(img); imax.axis('off')
savefig(fig)

# ═══════════════ PAGE 3 — 기능 ═══════════════
fig, ax = new_page('03  FEATURES', '기능 — 권한 · 로그인')
h2(ax, 46, '사용자 권한별 기능')
roles = [
    ('비회원 (Guest)', RED, ['도서 검색 · 평점/리뷰 순위 · 도서 상세 열람만 (읽기 전용)']),
    ('회원 (User)', BLUE, ['가입 · 로그인 / 얼굴 · 카카오 로그인',
                          '별점 리뷰 작성·삭제 · 좋아요 · 찜 · 마이페이지']),
    ('관리자 (Admin)', GREEN, ['대시보드(회원 수·도서 수) · 전체 회원 목록',
                             '도서 표지 이미지 관리 (책 추가·삭제는 없음)']),
]
y = 56
for name, col, items in roles:
    ax.text(27, y, name, ha='left', va='center', fontproperties=kf(11.5, 'bold'), color=col)
    y += 8
    for it in items:
        bullet(ax, y, it); y += 7.5
    y += 4

h2(ax, y+4, '로그인 — 3가지 방식'); y += 16
logins = [
    ('아이디 · 비밀번호', '입력값 검증 · 세션(HttpSession) 인증 · 로그아웃/탈퇴'),
    ('카카오 로그인', 'OAuth 2.0 인가코드 · 최초 로그인 시 자동 회원가입'),
    ('얼굴 인식 로그인', 'face-api.js · 128차원 얼굴 특징 추출 · 유클리드 거리(임계값 0.5)'),
]
for name, desc in logins:
    ax.text(27, y, name, ha='left', va='center', fontproperties=kf(11, 'bold'), color=INK)
    para(ax, y+7, desc, x=29, size=10)
    y += 18
savefig(fig)

# ═══════════════ PAGE 4 — 구현/미구현 ═══════════════
fig, ax = new_page('04  SCOPE', '구현한 기능 · 아쉬운 점')
h2(ax, 46, '구현 완료 (한 것)', color=GREEN)
done = [
    '도서 검색 · 평점/리뷰 순위 · 도서 상세',
    '평점 분포 + 감성(긍정/중립/부정) 시각화',
    '회원가입 · 세션 로그인 · 카카오 OAuth',
    '딥러닝 얼굴 등록 · 얼굴 로그인 (face-api.js)',
    '별점 리뷰 · 좋아요 · 찜 · 마이페이지',
    '관리자 대시보드 · 회원관리 · 표지관리',
    '예스24·알라딘·교보문고 구매처 바로가기',
]
y = 56
for d in done:
    bullet(ax, y, d); y += 8

h2(ax, y+4, '미구현 · 아쉬운 점 (못한 것 / 향후)', color=RED); y += 16
todo = [
    '관리자 도서 CRUD (추가·삭제) — 표지 관리만 가능',
    '실시간 크롤링 파이프라인 미연동 (정적 데이터)',
    '감성 분석이 별점 규칙 기반 (NLP 모델 아님)',
    '검색 페이징 · 자동완성 미구현',
    '도서 표지 일부 누락 · 이미지 업로드 미지원',
    '모바일 반응형 최적화 부족',
]
for t in todo:
    bullet(ax, y, t); y += 8

# 향후 핵심
card(ax, 20, y+4, 170, 20, fc='#EEF3FE', ec='#CFE0FA')
ax.text(27, y+10, '★ 향후 1순위', ha='left', va='center', fontproperties=kf(10.5, 'bold'), color=BLUE)
ax.text(27, y+17, '브라우저에서 하던 얼굴 인식을 독립 Python 서버(FastAPI)로 분리 → 보안·확장성 개선',
        ha='left', va='center', fontproperties=kf(10), color='#33384A')
savefig(fig)

pdf.close()
print('PDF 저장 완료:', DOC, '| 페이지', len(pages_png))
