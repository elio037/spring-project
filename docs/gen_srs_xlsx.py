# -*- coding: utf-8 -*-
"""BookReview SRS — I-Study 요구사항명세서 양식 복제 (xlsxwriter, 한셀 호환)"""
import xlsxwriter

OUT = r'D:\Lecture\spring-workspace\book-review\docs\BookReview_SRS.xlsx'
wb = xlsxwriter.Workbook(OUT)

# ── 팔레트 ──
DARK='#2E4057'; HEADER='#D9E1F2'; FUNC='#EBF2FF'; NONFUNC='#EBF5EB'
SECTION='#3A5A7A'; CREAM='#FFF8E7'; WHITE='#FFFFFF'; ALT='#F5F5F5'
POST_F='#D9E8F5'; POST_C='#0C3C6E'; GET_F='#D9F0D9'; GET_C='#1E6E1E'
PUT_F='#FFF3CC'; PUT_C='#6E5500'; DEL_F='#FAD9D9'; DEL_C='#6E1E1E'
PK_F='#FAEEDA'; PK_C='#633806'; FK_F='#E1F5EE'; FK_C='#085041'
BC='#BFC7D2'; FONT='맑은 고딕'

def fmt(**kw):
    base=dict(font_name=FONT, font_size=10, border=1, border_color=BC,
              valign='vcenter', text_wrap=True)
    base.update(kw)
    return wb.add_format(base)

# 공용 포맷
f_title_l = fmt(bold=True, font_color='white', bg_color=DARK, align='center')
f_title_v = fmt(bold=True, font_color='white', bg_color=DARK, align='left')
f_title_s = fmt(font_color='white', bg_color=DARK, align='left')
f_hdr     = fmt(bold=True, bg_color=HEADER, align='center')
f_section = fmt(bold=True, font_color='white', bg_color=SECTION, align='center')

def cell_fmt(bg=WHITE, bold=False, color='#000000', align='left', valign='vcenter'):
    return fmt(bold=bold, font_color=color, bg_color=bg, align=align, valign=valign)

def title_bar(ws, ncol, sub):
    ws.set_row(0, 22); ws.set_row(1, 20)
    ws.write(0,0,'프로젝트명', f_title_l)
    ws.merge_range(0,1,0,ncol-1,'BookReview — 독자 리뷰 기반 도서 탐색 플랫폼', f_title_v)
    ws.write(1,0,'문서 정보', f_title_l)
    ws.merge_range(1,1,1,ncol-1, sub, f_title_s)

# ════════ 시트1: 요구사항정의 ════════
ws=wb.add_worksheet('요구사항정의')
ws.hide_gridlines(2)
for col,w in {0:22,1:16,2:18,3:46,4:22}.items(): ws.set_column(col,col,w)
title_bar(ws,5,'v1.1  |  최종 수정: 2026-06-30  |  작성: kr.ac.kopo')
for i,h in enumerate(['구분','분류','요구사항 ID','요구사항명','비고']):
    ws.write(3,i,h,f_hdr)
rows=[
 # (구분, 분류, ID, 요구사항명, 비고)
 ('기능 요구사항','도서','BOOK-001','도서 검색','제목 부분일치'),
 ('기능 요구사항','도서','BOOK-002','평점 순위 조회','리뷰 N개 이상'),
 ('기능 요구사항','도서','BOOK-003','리뷰 순위 조회',''),
 ('기능 요구사항','도서','BOOK-004','도서 상세 조회','분포·감성·리뷰'),
 ('기능 요구사항','도서','BOOK-005','메인 큐레이션','평점·리뷰 TOP'),
 ('기능 요구사항','회원','USER-001','회원가입',''),
 ('기능 요구사항','회원','USER-002','로그인',''),
 ('기능 요구사항','회원','USER-003','로그아웃',''),
 ('기능 요구사항','회원','USER-004','아이디 중복 검사',''),
 ('기능 요구사항','회원','USER-005','카카오 로그인','OAuth2 인가코드'),
 ('기능 요구사항','회원','USER-006','마이페이지','내 정보·리뷰·찜'),
 ('기능 요구사항','회원','USER-007','회원 탈퇴','연관 데이터 CASCADE'),
 ('기능 요구사항','얼굴 인증','FACE-001','얼굴 등록','descriptor 저장'),
 ('기능 요구사항','얼굴 인증','FACE-002','얼굴 로그인','거리 매칭'),
 ('기능 요구사항','얼굴 인증','FACE-003','등록 얼굴 조회','JSON'),
 ('기능 요구사항','리뷰','REV-001','리뷰 작성(별점)','별점 1~5 + 본문'),
 ('기능 요구사항','리뷰','REV-002','리뷰 삭제','본인 작성분'),
 ('기능 요구사항','리뷰','REV-003','리뷰 좋아요','토글'),
 ('기능 요구사항','리뷰','REV-004','좋아요한 리뷰 조회','마이페이지'),
 ('기능 요구사항','찜','WISH-001','찜하기/해제','토글'),
 ('기능 요구사항','찜','WISH-002','찜 목록 조회','마이페이지'),
 ('기능 요구사항','분석','ANAL-001','평점 분포 집계','DIST1~5'),
 ('기능 요구사항','분석','ANAL-002','감성 비율 분석','긍정/중립/부정'),
 ('비기능 요구사항','데이터','DATA-001','도서 집계 데이터','BR_BOOK'),
 ('비기능 요구사항','데이터','DATA-002','샘플 리뷰 데이터','BR_REVIEW'),
 ('비기능 요구사항','데이터','DATA-003','회원 계정 데이터','BR_MEMBER'),
 ('비기능 요구사항','데이터','DATA-004','얼굴 특징 벡터 저장','face_descriptor'),
 ('비기능 요구사항','데이터','DATA-005','회원 리뷰 데이터','BR_COMMENT'),
 ('비기능 요구사항','데이터','DATA-006','리뷰 좋아요 데이터','BR_COMMENT_LIKE'),
 ('비기능 요구사항','데이터','DATA-007','찜 데이터','BR_WISHLIST'),
 ('비기능 요구사항','소프트웨어','SYS-001','Java','17'),
 ('비기능 요구사항','소프트웨어','SYS-002','Spring Web MVC','6.2'),
 ('비기능 요구사항','소프트웨어','SYS-003','MyBatis','3.5 + spring'),
 ('비기능 요구사항','소프트웨어','SYS-004','Oracle XE','21c'),
 ('비기능 요구사항','소프트웨어','SYS-005','face-api.js','얼굴 인식'),
 ('비기능 요구사항','소프트웨어','SYS-006','JSP / JSTL','Jakarta'),
 ('비기능 요구사항','운영환경','SYS-007','Apache Tomcat','11.0'),
 ('비기능 요구사항','운영환경','SYS-008','웹캠 장치','얼굴 인증용'),
 ('비기능 요구사항','운영환경','SYS-009','카카오 OAuth 앱','developers.kakao.com'),
 ('비기능 요구사항','보안','SEC-001','세션 기반 인증',''),
 ('비기능 요구사항','보안','SEC-002','UTF-8 인코딩 필터',''),
 ('비기능 요구사항','보안','SEC-003','카카오 OAuth2 인가코드 방식',''),
 ('비기능 요구사항','성능','PERF-001','검색·순위 1초 이내 응답',''),
 ('비기능 요구사항','가용성','AVAIL-001','데이터 미적재 시 안내 처리',''),
]
start=4
# 데이터 본문 (ID/요구사항명/비고)
for i,(grp,cls,idv,name,bigo) in enumerate(rows):
    r=start+i
    ws.write(r,2,idv,cell_fmt(WHITE,align='left'))
    ws.write(r,3,name,cell_fmt(WHITE,align='left'))
    ws.write(r,4,bigo,cell_fmt(WHITE,align='center'))

# 연속된 동일 값끼리 병합 (구분 col0 / 분류 col1)
def merge_runs(col, values, fmt_for):
    i,n=0,len(values)
    while i<n:
        j=i
        while j+1<n and values[j+1]==values[i]: j+=1
        if i==j: ws.write(start+i,col,values[i],fmt_for(values[i]))
        else:    ws.merge_range(start+i,col,start+j,col,values[i],fmt_for(values[i]))
        i=j+1

merge_runs(0,[r[0] for r in rows],
           lambda v: cell_fmt(FUNC if v=='기능 요구사항' else NONFUNC, bold=True, align='center'))
merge_runs(1,[r[1] for r in rows], lambda v: cell_fmt(WHITE, align='center'))
ws.freeze_panes(3,0)

# ════════ 시트2: 요구사항명세 ════════
ws2=wb.add_worksheet('요구사항명세')
ws2.hide_gridlines(2)
for col,w in {0:16,1:80,2:14,3:20}.items(): ws2.set_column(col,col,w)
title_bar(ws2,4,'소프트웨어 요구사항 명세서  v1.1  |  2026-06-30')
specs=[
 ('1. 기능 요구사항 — 도서 (BOOK)',[
   ('BOOK-001','도서 검색','도서','높음','전체','사용자가 제목 일부를 입력하면 일치하는 도서를 리뷰 많은 순으로 최대 50건 반환한다. 검색어가 비어 있으면 빈 결과를 반환한다.'),
   ('BOOK-002','평점 순위 조회','도서','높음','전체','리뷰 N개(기본 30) 이상인 도서를 평점 평균 내림차순으로 정렬해 상위 100권을 제공한다. 동점 시 리뷰 수로 2차 정렬한다.'),
   ('BOOK-003','리뷰 순위 조회','도서','중간','전체','리뷰 수 기준 내림차순으로 상위 100권을 제공한다.'),
   ('BOOK-004','도서 상세 조회','도서','높음','전체','선택한 도서의 평균 별점, 1~5점 분포, 감성 비율(긍정/중립/부정), 샘플 리뷰를 함께 제공한다.'),
   ('BOOK-005','메인 큐레이션','도서','중간','전체','메인 화면에 평점 TOP 8과 리뷰 수 TOP 8 도서를 노출한다.'),
 ]),
 ('2. 기능 요구사항 — 회원 (USER)',[
   ('USER-001','회원가입','회원','높음','비로그인','아이디/비밀번호/닉네임을 입력받아 검증 후 저장한다. 아이디는 영문으로 시작해야 하며 중복 시 거부한다.'),
   ('USER-002','로그인','회원','높음','비로그인','아이디·비밀번호로 인증하고 세션에 사용자 정보를 저장한다. 실패 시 안내 메시지를 표시한다.'),
   ('USER-003','로그아웃','회원','높음','로그인','세션을 종료하고 메인으로 이동한다.'),
   ('USER-004','아이디 중복 검사','회원','중간','비로그인','회원가입 시 입력한 아이디의 사용 여부를 조회한다.'),
   ('USER-005','카카오 로그인','회원','높음','비로그인','카카오 OAuth2 인가코드 방식으로 로그인한다. 인가코드를 액세스 토큰으로 교환하고 사용자 정보를 조회해, 최초 로그인 시 자동 회원가입(provider=KAKAO) 후 세션에 로그인 상태를 저장한다.'),
   ('USER-006','마이페이지','회원','높음','로그인','내 정보, 내가 쓴 리뷰, 좋아요한 리뷰, 찜한 책을 한 화면에서 조회하고 각 항목을 관리(삭제·해제)한다.'),
   ('USER-007','회원 탈퇴','회원','중간','로그인','회원 계정을 삭제한다. 작성한 리뷰·좋아요·찜 등 연관 데이터는 FK ON DELETE CASCADE로 함께 삭제되고 세션을 종료한다.'),
 ]),
 ('3. 기능 요구사항 — 리뷰 (REVIEW)',[
   ('REV-001','리뷰 작성','리뷰','높음','로그인','로그인 회원이 도서 상세에서 별점(1~5)과 본문으로 리뷰를 작성한다. 작성한 리뷰는 독자 리뷰 영역 상단에 노출된다.'),
   ('REV-002','리뷰 삭제','리뷰','중간','로그인','본인이 작성한 리뷰만 삭제할 수 있다. 세션 회원 번호와 작성자 번호가 일치할 때만 허용한다.'),
   ('REV-003','리뷰 좋아요','리뷰','중간','로그인','리뷰에 좋아요를 누르거나 취소한다(토글). 한 리뷰에 회원당 1회로 제한하며 좋아요 수를 함께 표시한다.'),
   ('REV-004','좋아요한 리뷰 조회','리뷰','중간','로그인','내가 좋아요한 리뷰 목록을 마이페이지에서 조회한다.'),
 ]),
 ('4. 기능 요구사항 — 찜 (WISHLIST)',[
   ('WISH-001','찜하기/해제','찜','중간','로그인','도서를 찜하거나 해제한다(토글). 같은 책 중복 찜은 UNIQUE 제약으로 방지한다.'),
   ('WISH-002','찜 목록 조회','찜','중간','로그인','내가 찜한 책 목록을 표지·평점과 함께 마이페이지에서 조회한다.'),
 ]),
 ('5. 기능 요구사항 — 얼굴 인증 (FACE)',[
   ('FACE-001','얼굴 등록','얼굴 인증','높음','로그인','브라우저(face-api.js)에서 추출한 128차원 얼굴 특징 벡터를 회원 레코드(face_descriptor)에 저장한다.'),
   ('FACE-002','얼굴 로그인','얼굴 인증','높음','비로그인','카메라 프레임의 특징 벡터와 등록된 회원들의 벡터 간 유클리드 거리를 계산해, 최소 거리가 임계값(0.5) 이하인 회원으로 자동 로그인한다.'),
   ('FACE-003','등록 얼굴 조회','얼굴 인증','중간','전체','얼굴이 등록된 회원의 번호와 특징 벡터 목록을 JSON으로 제공한다.'),
 ]),
 ('6. 기능 요구사항 — 분석 (ANALYSIS)',[
   ('ANAL-001','평점 분포 집계','분석','중간','전체','도서별 1~5점 리뷰 개수(DIST1~5)를 집계해 분포 막대로 시각화한다.'),
   ('ANAL-002','감성 비율 분석','분석','중간','전체','리뷰 평점을 4~5점 긍정, 3점 중립, 1~2점 부정으로 분류해 비율을 제공한다.'),
 ]),
]
r=3
blk=0
for title,blocks in specs:
    ws2.merge_range(r,0,r,3,title,f_section); r+=1
    for i,h in enumerate(['항목','내용','우선순위','접근 권한']):
        ws2.write(r,i,h,f_hdr)
    r+=1
    for (idv,name,cat,prio,acc,desc) in blocks:
        tint = FUNC if blk%2==0 else WHITE
        # ID row
        ws2.write(r,0,'요구사항 ID',cell_fmt(CREAM,bold=True,align='right'))
        ws2.merge_range(r,1,r,3,idv,cell_fmt(CREAM,bold=True,align='left')); r+=1
        # name row
        ws2.write(r,0,'요구사항명',cell_fmt(tint,bold=True,align='right'))
        ws2.merge_range(r,1,r,3,name,cell_fmt(tint,bold=True,align='left')); r+=1
        # 분류/우선순위/접근권한
        ws2.write(r,0,'분류',cell_fmt(tint,bold=True,align='right'))
        ws2.write(r,1,cat,cell_fmt(tint,align='left'))
        ws2.write(r,2,prio,cell_fmt(tint,align='center'))
        ws2.write(r,3,acc,cell_fmt(tint,align='center')); r+=1
        # 상세 설명
        ws2.set_row(r,42)
        ws2.write(r,0,'상세 설명',cell_fmt(tint,bold=True,align='right',valign='top'))
        ws2.merge_range(r,1,r,3,desc,cell_fmt(tint,align='left',valign='top')); r+=1
        blk+=1
    r+=1
ws2.freeze_panes(3,0)

# ════════ 시트3: API 명세 ════════
ws3=wb.add_worksheet('API 명세')
ws3.hide_gridlines(2)
for col,w in {0:10,1:12,2:40,3:40,4:18}.items(): ws3.set_column(col,col,w)
title_bar(ws3,5,'Spring MVC 엔드포인트 명세  v1.1')
for i,h in enumerate(['ID','메서드','엔드포인트','기능 설명','접근 권한']):
    ws3.write(3,i,h,f_hdr)
apis=[
 ('BR-01','GET','/','메인 (평점·리뷰 TOP)','전체'),
 ('BR-02','GET','/books?q={keyword}','도서 검색','전체'),
 ('BR-03','GET','/books/rank/rating?min={n}','평점 순위','전체'),
 ('BR-04','GET','/books/rank/reviews','리뷰 순위','전체'),
 ('BR-05','GET','/books/detail?title={title}','도서 상세','전체'),
 ('BR-06','GET','/join','회원가입 폼','비로그인'),
 ('BR-07','POST','/join','회원가입 처리','비로그인'),
 ('BR-08','GET','/login','로그인 폼','비로그인'),
 ('BR-09','POST','/login','로그인 처리','비로그인'),
 ('BR-10','GET','/logout','로그아웃','로그인'),
 ('BR-11','GET','/face-enroll','얼굴 등록 폼','로그인'),
 ('BR-12','POST','/face-enroll','얼굴 특징 저장','로그인'),
 ('BR-13','GET','/face-descriptors','등록 얼굴 목록(JSON)','전체'),
 ('BR-14','POST','/face-login','얼굴 로그인','비로그인'),
 ('BR-15','GET','/oauth/kakao','카카오 인가 페이지로 이동','비로그인'),
 ('BR-16','GET','/oauth/kakao/callback','카카오 로그인 콜백(자동 가입·로그인)','비로그인'),
 ('BR-17','GET','/mypage','마이페이지(정보·리뷰·좋아요·찜)','로그인'),
 ('BR-18','POST','/withdraw','회원 탈퇴','로그인'),
 ('BR-19','POST','/comments','리뷰 작성','로그인'),
 ('BR-20','POST','/comments/delete','리뷰 삭제(본인)','로그인'),
 ('BR-21','POST','/comments/like','리뷰 좋아요 토글','로그인'),
 ('BR-22','POST','/wishlist/toggle','찜하기/해제 토글','로그인'),
]
mcol={'GET':(GET_F,GET_C),'POST':(POST_F,POST_C),'PUT':(PUT_F,PUT_C),'DELETE':(DEL_F,DEL_C)}
for i,(idv,m,ep,desc,acc) in enumerate(apis):
    r=4+i; base=ALT if i%2==0 else WHITE
    mf,mc=mcol[m]
    ws3.write(r,0,idv,cell_fmt(base,align='center'))
    ws3.write(r,1,m,cell_fmt(mf,bold=True,color=mc,align='center'))
    ws3.write(r,2,ep,cell_fmt(base,align='left'))
    ws3.write(r,3,desc,cell_fmt(base,align='left'))
    ws3.write(r,4,acc,cell_fmt(base,align='center'))
ws3.freeze_panes(4,0)

# ════════ 시트4: DB 구조 ════════
ws4=wb.add_worksheet('DB 구조')
ws4.hide_gridlines(2)
for col,w in {0:24,1:20,2:12,3:48}.items(): ws4.set_column(col,col,w)
title_bar(ws4,4,'데이터베이스 구조 (Oracle)')
r=3
def db_table(name,cols):
    global r
    ws4.merge_range(r,0,r,3,f'테이블: {name}',f_section); r+=1
    for i,h in enumerate(['컬럼명','타입','키','설명']): ws4.write(r,i,h,f_hdr)
    r+=1
    for i,(cn,tp,key,d) in enumerate(cols):
        base=FUNC if i%2==0 else WHITE
        is_key = key in ('PK','FK')
        ws4.write(r,0,cn,cell_fmt(base,bold=is_key,align='left'))
        ws4.write(r,1,tp,cell_fmt(base,align='center'))
        if key=='PK': ws4.write(r,2,'PK',cell_fmt(PK_F,bold=True,color=PK_C,align='center'))
        elif key=='FK': ws4.write(r,2,'FK',cell_fmt(FK_F,bold=True,color=FK_C,align='center'))
        else: ws4.write(r,2,'',cell_fmt(base,align='center'))
        ws4.write(r,3,d,cell_fmt(base,align='left'))
        r+=1
    r+=1
db_table('BR_MEMBER',[
 ('no','number','PK','회원 고유 ID'),
 ('id','varchar2(50)','','로그인 아이디 (UNIQUE)'),
 ('password','varchar2(100)','','비밀번호 (소셜 회원은 NULL)'),
 ('nickname','varchar2(50)','','닉네임'),
 ('reg_date','date','','가입일 (기본 SYSDATE)'),
 ('face_descriptor','varchar2(4000)','','얼굴 특징 벡터 (128차원 JSON)'),
 ('provider','varchar2(20)','','로그인 제공자 (LOCAL / KAKAO)'),
 ('provider_id','varchar2(100)','','소셜 사용자 고유 ID'),
])
db_table('BR_BOOK',[
 ('no','number','PK','도서 고유 ID'),
 ('title','varchar2(1500)','','도서 제목'),
 ('review_count','number','','리뷰 수'),
 ('avg_rating','number(4,2)','','평점 평균'),
 ('dist1 ~ dist5','number','','1~5점 리뷰 개수'),
 ('pos_count','number','','긍정(4~5점) 수'),
 ('neu_count','number','','중립(3점) 수'),
 ('neg_count','number','','부정(1~2점) 수'),
])
db_table('BR_REVIEW',[
 ('no','number','PK','리뷰 고유 ID'),
 ('book_no','number','FK','도서 ID → BR_BOOK.no'),
 ('content','varchar2(2000)','','리뷰 내용 (크롤링 샘플)'),
 ('rating','number(1)','','평점 (1~5)'),
])
db_table('BR_COMMENT',[
 ('no','number','PK','회원 리뷰 고유 ID'),
 ('member_no','number','FK','작성 회원 → BR_MEMBER.no (ON DELETE CASCADE)'),
 ('book_no','number','FK','대상 도서 → BR_BOOK.no'),
 ('content','varchar2(1000)','','리뷰 본문'),
 ('rating','number(1)','','별점 (1~5)'),
 ('reg_date','date','','작성일 (기본 SYSDATE)'),
])
db_table('BR_COMMENT_LIKE',[
 ('no','number','PK','좋아요 고유 ID'),
 ('member_no','number','FK','회원 → BR_MEMBER.no (ON DELETE CASCADE)'),
 ('comment_no','number','FK','리뷰 → BR_COMMENT.no (ON DELETE CASCADE)'),
 ('reg_date','date','','일시 · UNIQUE(member_no, comment_no)'),
])
db_table('BR_WISHLIST',[
 ('no','number','PK','찜 고유 ID'),
 ('member_no','number','FK','회원 → BR_MEMBER.no (ON DELETE CASCADE)'),
 ('book_no','number','FK','도서 → BR_BOOK.no'),
 ('reg_date','date','','찜한 일시 · UNIQUE(member_no, book_no)'),
])

wb.close()
print('SRS xlsx (xlsxwriter) 생성 완료')
