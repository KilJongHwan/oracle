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