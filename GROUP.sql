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