# -*- coding: utf-8 -*-
"""BookReview ERD 이미지 생성 — 레퍼런스(테이블+PK/FK뱃지+직각 관계선) 스타일"""
import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt
from matplotlib.patches import FancyBboxPatch
from matplotlib.font_manager import FontProperties
from matplotlib.lines import Line2D

# ── 한글 폰트 ──
KF = FontProperties(fname=r'C:\Windows\Fonts\malgun.ttf')
def kf(size, weight='normal'):
    f = KF.copy(); f.set_size(size); f.set_weight(weight); return f

# ── 팔레트 (레퍼런스 톤) ──
BORDER   = '#C6C8EE'
HEAD_BG  = '#EEF0FB'
HEAD_TX  = '#3D3B7A'
TYPE_TX  = '#8A8FC0'
NAME_TX  = '#2E2E3C'
DESC_TX  = '#6C6C78'
ROWLINE  = '#ECECF3'
PK_BG, PK_TX = '#FBEBCB', '#C8901F'
FK_BG, FK_TX = '#D8EFDB', '#4E9C60'
LINE_C   = '#9C9CB8'
LBL_BG, LBL_BORDER, LBL_TX = '#FFFFFF', '#D3D3E6', '#55556A'

fig, ax = plt.subplots(figsize=(17.2, 10.4), dpi=200)
ax.set_xlim(0, 1720); ax.set_ylim(0, 1030); ax.axis('off')
ax.invert_yaxis()  # y 아래로(위쪽이 작은 값) → top 좌표 직관적

HH = 46   # 헤더 높이
RH = 34   # 행 높이

def table(x, top, w, title, rows):
    """rows: (type, name, key, desc). key in {'','PK','FK'}. returns dict of anchor points."""
    h = HH + RH * len(rows)
    # 본체
    ax.add_patch(FancyBboxPatch((x, top), w, h, boxstyle="round,pad=0,rounding_size=9",
                                ec=BORDER, fc='white', lw=1.4, zorder=3))
    # 헤더
    ax.add_patch(FancyBboxPatch((x, top), w, HH, boxstyle="round,pad=0,rounding_size=9",
                                ec=BORDER, fc=HEAD_BG, lw=1.2, zorder=4))
    ax.add_patch(plt.Rectangle((x, top+HH-10), w, 10, fc=HEAD_BG, ec='none', zorder=4))
    ax.plot([x, x+w], [top+HH, top+HH], color=BORDER, lw=1.1, zorder=4)
    ax.text(x+w/2, top+HH/2, title, ha='center', va='center', fontproperties=kf(14.5, 'bold'),
            color=HEAD_TX, zorder=5)
    # 컬럼
    cx_type = x + 16
    cx_name = x + 66
    cx_badge= x + w*0.47
    cx_desc = x + w*0.58
    for i, (typ, name, key, desc) in enumerate(rows):
        ry = top + HH + RH*i
        if i > 0:
            ax.plot([x, x+w], [ry, ry], color=ROWLINE, lw=0.9, zorder=4)
        cy = ry + RH/2
        ax.text(cx_type, cy, typ, ha='left', va='center', fontproperties=kf(10.5), color=TYPE_TX, zorder=5)
        nm_w = 'bold' if key else 'normal'
        ax.text(cx_name, cy, name, ha='left', va='center', fontproperties=kf(10.5, nm_w), color=NAME_TX, zorder=5)
        if key in ('PK', 'FK'):
            bg, tx = (PK_BG, PK_TX) if key == 'PK' else (FK_BG, FK_TX)
            bw, bh = 30, 19
            ax.add_patch(FancyBboxPatch((cx_badge-bw/2, cy-bh/2), bw, bh,
                        boxstyle="round,pad=0,rounding_size=5", ec='none', fc=bg, zorder=5))
            ax.text(cx_badge, cy, key, ha='center', va='center', fontproperties=kf(8.5, 'bold'), color=tx, zorder=6)
        ax.text(cx_desc, cy, desc, ha='left', va='center', fontproperties=kf(10), color=DESC_TX, zorder=5)
    return {'x': x, 'top': top, 'w': w, 'h': h,
            'cx': x+w/2, 'left': x, 'right': x+w, 'bottom': top+h}

# ── 테이블 정의 ──
member = table(130, 60, 470, 'BR_MEMBER  (회원)', [
    ('int',    'NO',              'PK', '회원 고유 번호'),
    ('string', 'ID',              '',   '로그인 아이디'),
    ('string', 'PASSWORD',        '',   '암호화 비밀번호(소셜 NULL)'),
    ('string', 'NICKNAME',        '',   '닉네임'),
    ('string', 'ROLE',            '',   '권한 (USER / ADMIN)'),
    ('string', 'FACE_DESCRIPTOR', '',   '얼굴 특징 벡터(JSON)'),
    ('string', 'PROVIDER',        '',   '가입 경로 (LOCAL/KAKAO)'),
    ('date',   'REG_DATE',        '',   '가입일'),
])
book = table(1120, 60, 480, 'BR_BOOK  (도서 집계)', [
    ('int',    'NO',            'PK', '도서 고유 번호'),
    ('string', 'TITLE',         '',   '도서 제목'),
    ('int',    'REVIEW_COUNT',  '',   '리뷰 수'),
    ('float',  'AVG_RATING',    '',   '평점 평균'),
    ('int',    'DIST1~5',       '',   '1~5점 개수'),
    ('int',    'POS/NEU/NEG',   '',   '긍정/중립/부정 수'),
])
like = table(55, 470, 395, 'BR_COMMENT_LIKE  (좋아요)', [
    ('int', 'NO',         'PK', '좋아요 번호'),
    ('int', 'MEMBER_NO',  'FK', '누른 회원 번호'),
    ('int', 'COMMENT_NO', 'FK', '대상 리뷰 번호'),
    ('-',   'UNIQUE',     '',   '(회원, 리뷰) 중복 방지'),
])
comment = table(480, 470, 420, 'BR_COMMENT  (회원 리뷰)', [
    ('int',    'NO',        'PK', '리뷰 번호'),
    ('int',    'MEMBER_NO', 'FK', '작성 회원 번호'),
    ('int',    'BOOK_NO',   'FK', '대상 도서 번호'),
    ('string', 'CONTENT',   '',   '리뷰 내용'),
    ('int',    'RATING',    '',   '별점 (1~5)'),
    ('date',   'REG_DATE',  '',   '작성일'),
])
wish = table(930, 470, 395, 'BR_WISHLIST  (찜)', [
    ('int', 'NO',        'PK', '찜 번호'),
    ('int', 'MEMBER_NO', 'FK', '회원 번호'),
    ('int', 'BOOK_NO',   'FK', '도서 번호'),
    ('-',   'UNIQUE',    '',   '(회원, 도서) 중복 방지'),
])
review = table(1355, 470, 360, 'BR_REVIEW  (샘플 리뷰)', [
    ('int',    'NO',      'PK', '리뷰 번호'),
    ('int',    'BOOK_NO', 'FK', '대상 도서 번호'),
    ('string', 'CONTENT', '',   '리뷰 원문(크롤링)'),
    ('int',    'RATING',  '',   '별점 (1~5)'),
])

# ── 관계선(직각) + 라벨 + 카디널리티 ──
def one_tick(x, y, horizontal=False):
    """1(one) 표시: 짧은 수직/수평 이중 눈금"""
    if horizontal:
        for dx in (-5, 1):
            ax.plot([x+dx, x+dx], [y-7, y+7], color=LINE_C, lw=1.6, zorder=6)
    else:
        for dy in (-5, 1):
            ax.plot([x-7, x+7], [y+dy, y+dy], color=LINE_C, lw=1.6, zorder=6)

def crowfoot_down(x, y):
    """many 표시: 아래쪽 엔티티로 들어가는 까마귀발"""
    for dx in (-8, 0, 8):
        ax.plot([x, x+dx], [y-12, y], color=LINE_C, lw=1.5, zorder=6)

def label(x, y, txt):
    ax.text(x, y, txt, ha='center', va='center', fontproperties=kf(10.5, 'bold'), color=LBL_TX,
            zorder=7, bbox=dict(boxstyle='round,pad=0.3', fc=LBL_BG, ec=LBL_BORDER, lw=1.1))

def rel(hub_x, hub_bottom, child_cx, child_top, bus_y, lbl):
    """hub 아래→bus_y→child 위. 1은 hub쪽, N(까마귀발)은 child쪽."""
    ax.plot([hub_x, hub_x], [hub_bottom, bus_y], color=LINE_C, lw=1.6, zorder=2)
    ax.plot([hub_x, child_cx], [bus_y, bus_y], color=LINE_C, lw=1.6, zorder=2)
    ax.plot([child_cx, child_cx], [bus_y, child_top], color=LINE_C, lw=1.6, zorder=2)
    one_tick(hub_x, hub_bottom+8)
    crowfoot_down(child_cx, child_top)
    label((hub_x + child_cx)/2, bus_y, lbl)

# MEMBER → 자식 3 (버스 y=430 근처)
rel(member['cx']-70, member['bottom'], like['cx'],    like['top'],    418, '좋아요')
rel(member['cx'],    member['bottom'], comment['cx']-40, comment['top'], 400, '작성')
rel(member['cx']+70, member['bottom'], wish['cx']-40,  wish['top'],    382, '찜')
# BOOK → 자식 3 (버스 위쪽, 겹침 방지 stagger)
rel(book['cx']+60,   book['bottom'], review['cx'],    review['top'], 430, '원문')
rel(book['cx'],      book['bottom'], wish['cx']+40,   wish['top'],   412, '대상도서')
rel(book['cx']-60,   book['bottom'], comment['cx']+40, comment['top'],394, '대상도서')

# COMMENT → LIKE (인접, 옆면 연결)
seg_y = 560
ax.plot([like['right'], comment['left']], [seg_y, seg_y], color=LINE_C, lw=1.6, zorder=2)
one_tick(comment['left']-2, seg_y, horizontal=True)
for dy in (-8, 0, 8):
    ax.plot([like['right'], like['right']+12], [seg_y, seg_y+dy], color=LINE_C, lw=1.5, zorder=6)
label((like['right']+comment['left'])/2, seg_y, '대상리뷰')

# ── 관계 범례 ──
ax.text(150, 762, '관계는 모두 1 : N   ·   눈금( || ) = 1(부모)   ·   까마귀발 = N(자식)   ·   외래키(FK) 7개',
        ha='left', va='center', fontproperties=kf(11), color=DESC_TX)

# ── 테이블 설명 패널 (각 테이블이 무엇인지) ──
ax.plot([140, 1600], [808, 808], color='#E1E1EC', lw=1.3)
ax.text(140, 842, '■ 테이블 한눈에 — 각 테이블이 무엇을 저장하는지', ha='left', va='center',
        fontproperties=kf(13.5, 'bold'), color=HEAD_TX)
explains = [
    ('BR_MEMBER',       '#3F6FE0', '회원 계정 · 권한(USER/ADMIN) · 얼굴 특징 벡터'),
    ('BR_BOOK',         '#E0A32B', '도서별 집계 — 평점 · 리뷰 수 · 별점 분포 · 감성 수'),
    ('BR_REVIEW',       '#2FA06A', '크롤링으로 수집한 샘플 리뷰 원문'),
    ('BR_COMMENT',      '#2FA06A', '회원이 직접 작성한 별점 리뷰'),
    ('BR_COMMENT_LIKE', '#E0574F', '리뷰 좋아요 (회원당 1회 · 중복 방지)'),
    ('BR_WISHLIST',     '#E0A32B', '회원이 찜한 책 (마이페이지 내 서재)'),
]
pos = [(170, 375, 892), (170, 375, 936), (170, 375, 980),
       (905, 1115, 892), (905, 1115, 936), (905, 1115, 980)]
for (name, cdot, desc), (nx, dx, y) in zip(explains, pos):
    ax.scatter([nx-22], [y], s=95, color=cdot, zorder=6)
    ax.text(nx, y, name, ha='left', va='center', fontproperties=kf(12, 'bold'), color=NAME_TX)
    ax.text(dx, y, desc, ha='left', va='center', fontproperties=kf(11), color=DESC_TX)

plt.subplots_adjust(left=0, right=1, top=1, bottom=0)
out = r'D:\Lecture\spring-workspace\book-review\docs\erd_bookreview.png'
plt.savefig(out, dpi=200, facecolor='white', bbox_inches='tight', pad_inches=0.25)
print('ERD 이미지 저장:', out)
