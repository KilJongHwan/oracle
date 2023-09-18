-- 다중행 함수 : 여러 행에 대해 함수가 적용되어 하나의 결과를 나타내는 함수(집계 함수)
-- 여러 행이 입력되어 결과가 하나의 행으로 출력
SELECT SUM(SAL)
    FROM EMP;

SELECT ENAME, SUM(SAL)
    FROM EMP;

SELECT DEPTNO, SUM(SAL), COUNT(*), ROUND(AVG(SAL),2), max(SAL), min(SAL)
    FROM EMP
GROUP BY DEPTNO;

-- GROUP BY : 여러 데이터에서 의미 있는 하나의 결과를 특정 열 값별로 묵어서 출력할 때 사용
SELECT ROUND(AVG(SAL),2) as 사원전체평균
FROM EMP;

-- 부서별 사원 평균
SELECT DEPTNO, ROUND(AVG(SAL), 2) as 부서별평균
FROM EMP
GROUP BY DEPTNO
ORDER BY DEPTNO

-- GROUP BY 없이 구현한다면?
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 10;
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 20;
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 30;

-- 집합연산자를 사용하여 구현 하기
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 10
UNION ALL
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 20
UNION ALL
SELECT AVG(SAL) FROM EMP WHERE DEPTNO = 30;

-- 부서코드, 급여 합계, 부서 평균, 부서 코드 순 정렬
SELECT DEPTNO 부서코드, 
    SUM(SAL) 합계,
    ROUND(AVG(SAL), 2) 평균,
    COUNT(*) 인원수 -- 각 그룹에 해당하는 인원이 몇명인지 확인
FROM EMP
GROUP BY DEPTNO 
ORDER BY DEPTNO;

-- HAVING 절 : GROUP BY 절이 존재하는 경우에만 사용 가능
-- GROUP BY를 통해 그룹화된 결과 값의 범위를 제한할 때 사용
-- 먼저 부서별, 직책별로 그룹화하여 평균을 구함
-- 그 다음 각 그룹별 급여 평균이 2000 넘는 그룹을 출력
SELECT DEPTNO, JOB, ROUND(AVG(SAL), 2) 평균
FROM EMP
GROUP BY DEPTNO, JOB
    HAVING AVG(SAL) >= 2000
ORDER BY DEPTNO, JOB;

-- WHERE를 사용하는 경우 
-- 먼저 급여가 2000 이상인 사원들을 골라내기
-- 조건에 맞는 사원 중에서 부서별, 직책별 급여의 평균을 구해서 출력
SELECT DEPTNO, JOB, ROUND(AVG(SAL), 2) 평균
FROM EMP
WHERE SAL >= 2000
GROUP BY DEPTNO, JOB
ORDER BY DEPTNO, JOB;

-- 1. 부서별 직책의 평균급여가 500 이상인 사원들의 부서 번호, 직책, 부서별 직책의 평균 급여 출력
SELECT DEPTNO, JOB, ROUND(AVG(SAL), 2) 부서별평균
FROM EMP
GROUP BY DEPTNO,JOB
    HAVING AVG(SAL) > 500
ORDER BY DEPTNO, JOB;

-- 2. 부서번호, 평균급여, 최고급여, 최저급여, 사원수를 출력 
-- (단 평균급여를 출력할 떄는 소수점 제외하고 부서번호별로 출력)
SELECT DEPTNO 부서번호, 
    TRUNC(AVG(SAL)) 평균급여, 
    MAX(SAL) 최고급여, 
    MIN(SAL) 최저급여, 
    COUNT(*) 사원수
FROM EMP
GROUP BY DEPTNO;

-- 3. 같은 직책에 종사하는 사원이 3명 이상인 직책과 인원을 출력
SELECT JOB 직책, COUNT(*) 사원수
FROM EMP
GROUP BY JOB
    HAVING COUNT(*) >= 3;

-- 4. 사원들의 입사연도를 기준으로 부서별로 몇 명이 입사 했는지 출력
-- SELECT EXTRACT(YEAR FROM HIREDATE) 입사일, COUNT(*),
SELECT TO_CHAR(HIREDATE, 'YYYY') 입사일,
    DEPTNO,
    COUNT(*) 사원수
FROM EMP
GROUP BY TO_CHAR(HIREDATE, 'YYYY'), DEPTNO
ORDER BY TO_CHAR(HIREDATE, 'YYYY');

-- 5. 추가 수당을 받는 사원 수와 받지 않는 사원수를 출력(O,X)로 출력
SELECT NVL2(COMM, 'O', 'X') "추가 수당",
    COUNT(*) 사원수
FROM EMP
GROUP BY NVL2(COMM, 'O', 'X');

-- 6. 각 부서의 입사 연도별 사원수, 최고 급여, 급여 합, 평균급여를 출력
SELECT DEPTNO,
    TO_CHAR(HIREDATE, 'YYYY') 입사년도,
    COUNT(*) 사원수,
    MAX(SAL) 최고급여,
    SUM(SAL) 합계,
    TRUNC(AVG(SAL)) 평균급여
FROM EMP
GROUP BY DEPTNO, TO_CHAR(HIREDATE, 'YYYY')
ORDER BY DEPTNO, TO_CHAR(HIREDATE, 'YYYY');

-- 그룹화 관련된 여러함수 : ROLLIP, CUBE...
SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL)
FROM EMP
GROUP BY DEPTNO, JOB
ORDER BY DEPTNO, JOB;

-- ROLLIP : 명시한 열을 소그룹부터 대그룹의 순서로 각 그룹별 결과를 출력하고 
-- 마지막에 총 데이터 결과를 출력
-- 각 부서별 중간 결과를 부여
SELECT DEPTNO, JOB, COUNT(*), MAX(SAL), SUM(SAL), AVG(SAL)
FROM EMP
GROUP BY ROLLUP(DEPTNO, JOB);

-- JOIN : 두 개 이상의 테이블에서 데이터를 가져와서 연결하는 데 사용하는 SQL 기능
-- RDMS에서는 테이블 설계 시 무결성 원칙으로 인해 동일한 정보가 여러 군데 존재하면 안되기 때문에
-- 필연적으로 테이블을 관리 목적에 맞게 설계
SELECT * FROM DEPT;

-- 열 이름을 비교하는 조건식으로 조인하기
SELECT *
FROM EMP , DEPT
WHERE EMP.DEPTNO = DEPT.DEPTNO
ORDER BY EMPNO;

-- 테이블 별칭 사용하기
SELECT *
FROM EMP E, DEPT D
    WHERE E.DEPTNO = D.DEPTNO
ORDER BY EMPNO;

-- 조인 종류 : 두 개 이상의 테이블을 하나의 테이블처럼 가로로 늘려서 출력하기 위해 사용
-- 조인은 대상 데이터를 어떻게 연결하느냐에 따라 등가, 비등가, 자체, 외부 조인으로 구분
-- 등가 조인 : 테이블을 연결한 후 출력 행을 각 테이블 특정 열에 일치한 데이터를 기준으로 선정하는 방법
-- 등가 조인에는 ANSI(안시) 조인과 오라클 조인이 있음
SELECT EMPNO, ENAME, D.DEPTNO, DNAME, LOC
    FROM EMP E, DEPT D
    WHERE E.DEPTNO = D.DEPTNO
    AND E.DEPTNO = 10
    ORDER BY D.DEPTNO;

SELECT EMPNO, ENAME, SAL, D.DEPTNO, DNAME, LOC
    FROM EMP E, DEPT D
    WHERE E.DEPTNO = D.DEPTNO
    AND SAL >= 3000
    ORDER BY D.DEPTNO;

SELECT EMPNO, ENAME, SAL, D.DEPTNO, DNAME ,LOC 
    FROM EMP E JOIN DEPT D
    ON E.DEPTNO = D.DEPTNO
    WHERE SAL >= 3000
    ORDER BY D.DEPTNO;

-- EMP 테이블 별칭을 E , DEPT 테이블 별칭을 D로 하여 다음과 같이 등가 조인을 했을 때
-- 급여가 2500 이하이고 사원번호가 9999 이하인 사원의 정보가 출력 되도록 작성(ANSI, Oracle 조인)
-- ANSI 조인
SELECT *
    FROM EMP E JOIN DEPT D
    ON E.DEPTNO = D.DEPTNO  -- 동등 조인, 이너 조인(두 테이블이 일치하는 데이터만 선택)
    WHERE SAL <= 2500 AND EMPNO <= 9999
    ORDER BY EMPNO;
-- Oracle 조인
SELECT *
    FROm EMP E, DEPT D
    WHERE E.DEPTNO = D.DEPTNO
    AND SAL <= 2500 AND EMPNO <= 9999
    ORDER BY EMPNO;

-- 비등가 조인 : 동일 Column(열, field)없이 다른 조건을 사용하여 조인 할 때 사용 (일반적인 경우는 아님)
SELECT * FROM EMP;
SELECT * FROM SALGRADE;

SELECT E.ENAME, E.SAL, S.GRADE
FROM EMP E, SALGRADE S  -- 두 개의 테이블을 연결
WHERE E.SAL BETWEEN S.LOSAL AND S.HISAL;    -- 비등가 조인

--ANSI 조인으로 변경
SELECT ENAME, SAL, GRADE
FROM EMP E JOIN SALGRADE S
ON SAL BETWEEN S.LOSAL AND S.HISAL;

-- 자체 조인 : SELF 조인, 같은 테이블을 두 번 사용하여 자체 조인
-- EMP 테이블에서 직속 상관의 사원번호는 MGR에 있음
-- MGR을 이용해서 상관의 이름을 알아내기 위해서 사용할 수 있음
SELECT E1.EMPNO, E1.ENAME, E1.MGR,
    E2.EMPNO AS MGR_EMPNO, E2.ENAME AS MGR_ENAME
    FROM EMP E1 , EMP E2
WHERE E1.MGR = E2.EMPNO;

-- 외부 조인 : 동등 조인의 경우 한쪽의 Column이 없으면 해당 행으로 표시되지 않음
-- 외부 조인은 내부조인과 다르게 다른 한쪽에 값이 없어도 출력
-- 외부 조인은 동등 조인 조건을 만족하지 못해 누락되는 행을 출력하기 위해 사용

INSERT INTO EMP(EMPNO ,ENAME ,JOB ,MGR ,HIREDATE ,SAL ,COMM ,DEPTNO)
    VALUES(9000,'ALIICE','SALESMAN',7698,SYSDATE,2000,1000,NULL);

-- 왼쪽 외부 조인 사용하기
SELECT ENAME, E.DEPTNO, DNAME
FROM EMP E, DEPT D
WHERE E.DEPTNO = D.DEPTNO(+)
ORDER BY E.DEPTNO;

-- 오른쪽 외부 조인 사용하기
SELECT E.ENAME, D.DEPTNO, D.DNAME
FROM EMP E , DEPT D
WHERE E.DEPTNO(+) = D.DEPTNO
ORDER BY E.DEPTNO;

-- SQL-99 표준뮨법으로 배우는 ANSI 조인