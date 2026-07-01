-- =========================================================
--  카카오(소셜) 로그인용 BR_MEMBER 컬럼 추가
--  접속 계정 : hr / hr
--  기존 데이터를 유지한 채 한 번만 실행하세요.
-- =========================================================

-- 소셜 회원은 비밀번호가 없으므로 NULL 허용으로 변경
ALTER TABLE BR_MEMBER MODIFY (PASSWORD VARCHAR2(100) NULL);

-- 로그인 제공자 / 제공자별 사용자 고유 ID
ALTER TABLE BR_MEMBER ADD (
    PROVIDER     VARCHAR2(20)  DEFAULT 'LOCAL',   -- LOCAL / KAKAO
    PROVIDER_ID  VARCHAR2(100)                    -- 카카오 회원번호 등
);

-- 같은 소셜 계정 중복 가입 방지 (PROVIDER_ID가 있을 때만 유일하게 검사)
-- 일반 회원(PROVIDER_ID = NULL)은 인덱스에서 제외되어 중복 충돌이 없음
CREATE UNIQUE INDEX UX_BR_MEMBER_PROVIDER
    ON BR_MEMBER (CASE WHEN PROVIDER_ID IS NULL THEN NULL ELSE PROVIDER END, PROVIDER_ID);

COMMIT;

-- 확인
-- SELECT NO, ID, NICKNAME, PROVIDER, PROVIDER_ID FROM BR_MEMBER ORDER BY NO;
