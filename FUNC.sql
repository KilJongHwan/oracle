-- 함수 --
-- 오라클에서 함수는 내장 함수 사용자 정의 함수로 나누어 진다
-- 내장 함수는 단일형 함수와 다중형(집계)함수로 나누어 진다.
-- DUAL 테이블 : ORACLE의 SYS 계정에사 제공하는 테이블로 
-- 함수나 계산식에서 테이블 참조 없이 실행해 보기 위해 제공 된다.(DUMMY 테이블)

-- ABS : 절대값을 구하는 함수
SELECT -10, ABS(-10) FROM DUAL;

-- ROUND : 반올림한 결과를 반환하는 함수 => ROUND(숫자, 반올림할 위치), 위치는 음수값도 줄 수 있디.
SELECT ROUND(1234.5678) AS ROUND,
    ROUND(1234.5678, 0) AS ROUND_0,
    ROUND(1234.5678, 1) AS ROUND_1,
    ROUND(1234.5678, 2) AS ROUND_2,
    ROUND(1234.5678, -1) AS ROUND_MINUS1,
    ROUND(1234.5678, -2) AS ROUND_MINUS2
FROM DUAL;

-- TRUNC : 버림한 결과를 반환하는 함수
SELECT TRUNC(1234.5678) AS TRUNC,
    TRUNC(1234.5678, 0) AS TRUNC_0,
    TRUNC(1234.5678, 1) AS TRUNC_1,
    TRUNC(1234.5678, 2) AS TRUNC_2,
    TRUNC(1234.5678, -1) AS TRUNC_MINUS1,
    TRUNC(1234.5678, -2) AS TRUNC_MINUS2
FROM DUAL;

-- MOD : 나누기한 나머지를 출력하는 함수
SELECT MOD(21, 5) FROM DUAL;

-- CEIL : 소수점 이하를 무조건 올림
SELECT CEIL(12.0000001) FROM DUAL;

-- FLOOR : 소수점 이하를 무조건 내림
SELECT FLOOR(12.9999999) FROM DUAL;

-- POWER : 정수 A를 정수 B만큼 제곱하는 함수 (3,4)
SELECT POWER(3,4) FROM DUAL;

-- 문자함수 : 문자 데이터를 가공하는 것
SELECT ENAME, UPPER(ENAME),LOWER(ENAME),INITCAP(ENAME)
FROM EMP;

SELECT * FROM EMP
WHERE UPPER(ENAME) = UPPER('james');

-- LENGTH : 문자열 길이를 반환
-- LENGTHB : 문자열의 바이트 수 반환
SELECT LENGTH('한글'), LENGTHB('한글')
FROM DUAL;

-- SUBSTR / SUBSTRB
-- 데이터베이스 시작위치가 0이 아님, 3번째 매개변수는 생략하면 끝까지
SELECT JOB, SUBSTR(JOB,1,2), SUBSTR(JOB,3 ,2), SUBSTR(JOB ,5)
FROM EMP;

SELECT JOB,
    SUBSTR(JOB , -LENGTH(JOB)), -- 음수는 뒤에서 계산, 길이에 대한 음수값으로 역순 접근
    SUBSTR(JOB , -LENGTH(JOB),2),   -- SALESMAN, -8 이면 S 위치에서 길이가 2만큼 출력 
    SUBSTR(JOB ,-3)
FROM EMP;

-- INSTR : 문자열 데이터 안에 특정 문자나 문자열이 어디에 포함되어 있는지 알고자 할 때 사용
SELECT INSTR('HELLO, ORACLE!' ,'L') AS INSTR_1,
    INSTR('HELLO, ORACLE', 'L',5) AS INSTR_2,   -- 3번째 인자로 찾을 시작 위치 지점
    INSTR('HELLO, ORACLE', 'L',2,2) AS INSTR_3-- 3번째 인자는 시작위치, 4번째 인자는 몇번째 인지
FROM DUAL;

-- 특정 문자가 포함된 형 찾기
SELECT *
FROM EMP
WHERE INSTR(ENAME, 'S') > 0;

SELECT *
FROM EMP
WHERE ENAME LIKE '%S%';

-- REPLACE : 특정 문자열 데이터에 포함된 문자를 다른 문자로 대체 할 경우 사용
-- 대체할 문자를 넣지 않으면 해당 문자 삭제 
SELECT '010-1234-5678' AS REPLACE_BEFORE,
    REPLACE('010-1234-5678', '-','')AS REPLACE_1, -- 공백으로 대체
    REPLACE('010-1234-5678', '-')AS REPLACE_2 -- 해당 문자 삭제
FROM DUAL;

-- LPAD / RPAD : 기준 공건의 칸 수를 특정 문자로 채우는 함수  
SELECT LPAD('ORACLE',10, '+')
FROM DUAL;
SELECT RPAD('ORACLE',10, '+')
FROM DUAL;

SELECT 'ORACLE',
    LPAD('ORACLE', 10, '#') AS LPAD_1,
    RPAD('ORACLE', 10, '*') AS RPAD_1,
    LPAD('ORACLE', 10) AS LPAD_2,
    RPAD('ORACLE', 10) AS RPAD_2
FROM DUAL;

-- 개인정보 뒤자리 *표시로 출력하기
SELECT
    RPAD('971225-',14, '*') AS RPAD_JMNO,
    RPAD('010-1234-', 13 ,'*') AS RPAD_PHONE
FROM DUAL;

-- 두 문자열을 합치는 CONCAT 함수
SELECT CONCAT(EMPNO, ENAME),
    CONCAT(EMPNO, CONCAT(' : ', ENAME))
FROM EMP
WHERE ENAME = 'JAMES';

-- TRIM / LTRIM / RTRIM : 문자열 내에서 특정 문자열을 지우기 위해 사용
-- 삭제할 문자를 지정하지 않으면 공백 제거 (공백 제거 용도로 쓸만하다)
SELECT '[' || TRIM(' _Oracle_ ') || ']' AS TRIM,
 '[' || LTRIM('   _Oracle_   ') || ']' AS LTRIM,
 '[' || LTRIM('<_Oracle_>', '<_') || ']' AS LTRIM_2,
 '[' || RTRIM('   _Oracle_   ') || ']' AS RTRIM,
 '[' || RTRIM('<_Oracle_>', '_>') || ']' AS RTRIM_2
FROM DUAL;

SELECT LTRIM('ssssasdasdfsdafasdfasdkfsdasdfdsaf    ', 's')
FROM DUAL;