# -*- coding: utf-8 -*-
"""알라딘 검색으로 200권 표지 수집 → webapp/img/covers/{no}.jpg + 배포본"""
import sys, io, re, os, time, urllib.request, urllib.parse
sys.stdout = io.TextIOWrapper(sys.stdout.buffer, encoding='utf-8')

SRC_DIR = r'D:\Lecture\spring-workspace\book-review\src\main\webapp\img\covers'
DEP_DIR = r'D:\Lecture\eclipse-server\wtpwebapps\book-review\img\covers'
LIST    = r'D:\Lecture\spring-workspace\book-review\docs\_booklist.txt'
RESULT  = r'D:\Lecture\spring-workspace\book-review\docs\_cover_results.tsv'
os.makedirs(SRC_DIR, exist_ok=True)
os.makedirs(DEP_DIR, exist_ok=True)

UA = {'User-Agent':'Mozilla/5.0 (Windows NT 10.0; Win64; x64)'}

def fetch(url, t=12):
    req = urllib.request.Request(url, headers=UA)
    with urllib.request.urlopen(req, timeout=t) as r:
        return r.read()

def search_aladin(title):
    """반환: (cover_url, matched_title) 또는 (None, None)"""
    url = "https://www.aladin.co.kr/search/wsearchresult.aspx?SearchTarget=Book&SearchWord=" + urllib.parse.quote(title)
    html = fetch(url).decode('euc-kr', 'ignore')
    cover = None
    m = re.search(r'(https?://image\.aladin\.co\.kr/product/\d+/\d+/cover\w*/\w+_\d+\.(?:jpg|gif))', html)
    if m:
        cover = m.group(1)
    tm = re.search(r'<a[^>]*class="bo3"[^>]*>(.*?)</a>', html, re.S)
    matched = re.sub(r'<[^>]+>', '', tm.group(1)).strip() if tm else ''
    return cover, matched

def download_cover(cover_url, dest_paths):
    """cover500 우선, 실패 시 원본. 성공 시 저장하고 True"""
    candidates = []
    for size in ('cover500', 'cover200'):
        candidates.append(re.sub(r'/cover\w*/', f'/{size}/', cover_url))
    candidates.append(cover_url)
    seen = set()
    for u in candidates:
        if u in seen: continue
        seen.add(u)
        try:
            img = fetch(u)
        except Exception:
            continue
        # 유효 이미지 + 너무 작은 'noimg' 제외 (보통 1KB 미만)
        if len(img) < 1500: continue
        if img[:2] != b'\xff\xd8' and img[:3] != b'GIF':  # jpg or gif
            continue
        for p in dest_paths:
            with open(p, 'wb') as f:
                f.write(img)
        return True, len(img)
    return False, 0

rows = []
with open(LIST, encoding='utf-8') as f:
    for line in f:
        line = line.rstrip('\n')
        if not line.strip(): continue
        parts = line.split('\t', 1)
        if len(parts) < 2: continue
        no = parts[0].strip()
        title = parts[1].strip()
        if no.isdigit():
            rows.append((int(no), title))

ok = 0; fail = []
with open(RESULT, 'w', encoding='utf-8') as out:
    out.write("no\tstatus\tmatched\tsize\ttitle\n")
    for i, (no, title) in enumerate(rows, 1):
        status='FAIL'; matched=''; size=0
        try:
            cover, matched = search_aladin(title)
            if cover:
                fname = f'{no}.jpg'
                ok_dl, size = download_cover(cover, [os.path.join(SRC_DIR, fname), os.path.join(DEP_DIR, fname)])
                if ok_dl:
                    status='OK'; ok += 1
                else:
                    fail.append((no, title, '다운로드 실패'))
            else:
                fail.append((no, title, '검색결과 없음'))
        except Exception as e:
            fail.append((no, title, f'오류:{type(e).__name__}'))
        out.write(f"{no}\t{status}\t{matched}\t{size}\t{title}\n")
        out.flush()
        if i % 20 == 0:
            print(f"  진행 {i}/{len(rows)} (성공 {ok})", flush=True)
        time.sleep(0.25)

print(f"\n=== 수집 완료: 성공 {ok} / 전체 {len(rows)} ===")
if fail:
    print(f"실패 {len(fail)}건:")
    for no, title, reason in fail:
        print(f"  [{no}] {title} — {reason}")
