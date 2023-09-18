-- 서브쿼리 : 어떤 상황이나 조건에 따라 변할 수 있는 데이터 값을 비교하기 위해 
-- SQL문 안에 작성하는 작은 작은 SELECT 문을 의미
-- KING이라는 이름을 가진 사원의 부서 이름을 찾기 위한 쿼리
SELECT DNAME FROM DEPT
WHERE DEPTNO = (SELECT DEPTNO FROM EMP
                WHERE ENAME = 'KING');

-- 사원 'JONES'의 급여보다 높은 급여를 받는 사원 정보 출력하기
SELECT * FROM EMP
WHERE SAL > (SELECT SAL FROM EMP
             WHERE ENAME = 'JONES');

-- EMP 테이블의 사원 정보 중에서 사원이름이 'ALLEN'인 사원의 추가 수당보다 많은 추가 수당을 받는 사원 출력
SELECT ENAME FROM EMP
WHERE COMM > (SELECT COMM FROM EMP
             WHERE ENAME = 'ALLEN');

-- 'JAMES'보다 이전에 입사한 사원 출력
SELECT *
FROM EMP
WHERE HIREDATE < (SELECT HIREDATE FROM EMP
                 WHERE ENAME = 'JAMES');

-- 20번 부서에 속한 사원 중 전체 사원의 평균 급여보다 높은 급여를 받는
-- 사원 정보와 소속 부서 정보를 조회하는 경우에 대한 쿼리 작성
SELECT EMPNO, ENAME, JOB, SAL, D.DEPTNO, DNAME, LOC
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.DEPTNO = 20 
AND SAL > (SELECT AVG(SAL) FROM EMP);

-- 다중행 서브쿼리 : 서브쿼리의 실행 결과 행이 여러개로 반환되는 서브쿼리
-- IN : 메인쿼리의 데이터가 서브쿼리의 결과 중 하나라도 일치하면 true
-- 각 부서별 최대 급여와 동일한 급여를 받는 사원 정보를 출력
SELECT *
FROM EMP
WHERE SAL IN (SELECT MAX(SAL) FROM EMP
              GROUP BY DEPTNO)
ORDER BY DEPTNO;

-- ANY : 메인쿼리의 비교조건이 서브 쿼리의 여러 검색 결과 중 하나 이상 만족되면 반환
SELECT EMPNO, ENAME, SAL
FROM EMP
WHERE SAL > ANY (SELECT SAL FROM EMP
                 WHERE JOB = 'SALESMAN')
ORDER BY SAL;

-- 30번 부서 사원들의 급여보다 적은 급여를 받는 사원의 정보 출력
-- ALL : 모든 조건을 만족하는 경우에 성립
SELECT *
FROM EMP
WHERE SAL < ALL(SELECT SAL FROM EMP
            WHERE DEPTNO = 30);

SELECT EMPNO, ENAME, SAL
FROM EMP
WHERE SAL > ALL(SELECT SAL FROM EMP
                WHERE JOB = 'MANAGER');

-- EXISTS 연산자 : 서브쿼리의 결과 값이 하나 이상 존재하면 조건식이 모두 true, 존재하지 않으면 모두 false
SELECT *
FROM EMP
WHERE EXISTS(SELECT DNAME FROM DEPT
            WHERE DEPTNO = 40);

-- 다중 열 서브쿼리 : 서브쿼리의 결과가 두 개 이상의 컬럼으로 반환되어 메인쿼리에 전달하는 쿼리
SELECT EMPNO, ENAME, SAL, DEPTNO
FROM EMP
WHERE (DEPTNO, SAL) IN (SELECT DEPTNO, SAL FROM EMP
                        WHERE DEPTNO = 30);

-- GROUP BY 포함된 다중열 서브쿼리
SELECT * FROM EMP
WHERE (DEPTNO,SAL) IN (SELECT DEPTNO, MAX(SAL)
                       FROM EMP
                       GROUP BY DEPTNO);