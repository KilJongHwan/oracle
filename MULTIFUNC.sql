-- 다중형 함수 : 여러 형에 대해 함수가 적용되어 하나의 결과를 나타내는 함수(집계 함수)
-- 여러 행이 입력되어 결과가 하나의 행으로 출력
SELECT SUM(SAL)
    FROM EMP;

SELECT ENAME, SUM(SAL)
    FROM EMP;

SELECT DEPTNO, SUM(SAL), COUNT(*), ROUND(AVG(SAL),2), max(SAL), min(SAL)
    FROM EMP
GROUP BY DEPTNO;