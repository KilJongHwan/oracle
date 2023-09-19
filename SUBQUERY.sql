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

-- FROM 절에 사용하는 서브쿼리 : 인라인뷰
-- FROM 절에 직접 테이블을 명시하여 사용하기에는 테이블 내 데이터 규모가 너무 큰 경우 사용
-- 보안이나 특정 목적으로 정보를 제공하는 경우
-- 10 부서에 해당하는 테이블만 가지고 옴
SELECT E10.EMPNO, E10.ENAME, E10.DEPTNO, D.DNAME, D.LOC
FROM (SELECT * FROM EMP
      WHERE DEPTNO = 10) E10 JOIN (SELECT * FROM DEPT) D
ON E10.DEPTNO = D.DEPTNO;

-- 먼저 정렬하고 해당 갯수만 가져오기
-- ROWNUM : Oracle에서 제공하는 문법으로 행번호를 자동으로 매겨 준다. 
-- 정렬된 결과에서 상위 3개를 뽑아내기위해 테이블을 가져올 때 정렬된 상태로 가져와야 한다.
-- 일반적인 SELECT문에서는 ORDER BY 절이 맨 나중에 수행되기 때문
SELECT ROWNUM ,ENAME, SAL
FROM (SELECT * FROM EMP
        ORDER BY SAL DESC)
WHERE ROWNUM <= 3;

-- SELECT절에 사용하는 서브쿼리 : 단일행 스칼라 서브쿼리라고도 부른다(반드시 하나의 결과만 도출해야한다.)
SELECT EMPNO, ENAME, JOB, SAL, (SELECT GRADE
                                FROM SALGRADE
                                WHERE E.SAL BETWEEN LOSAL AND HISAL) AS 급여등급,
       DEPTNO,
       (SELECT DNAME
        FROM DEPT
        WHERE E.DEPTNO = DEPT.DEPTNO) AS DNAME
FROM EMP E;

-- 매 행마다 부서번호가 각 행의 부서번호와 동일한 사원들의 SAL 평균을 구해서 반환
SELECT ENAME, DEPTNO, SAL,
       (SELECT TRUNC(AVG(SAL))
        FROM EMP
        WHERE DEPTNO = E.DEPTNO) AS 부서별평균급여
FROM EMP E;

-- 부서 위치가 NEW YORK 인 경우에 본사로, 그 외 부서는 분점으로 반환
SELECT EMPNO, ENAME,
        CASE WHEN DEPTNO = (SELECT DEPTNO
                            FROM DEPT
                            WHERE LOC = 'NEW YORK')
            THEN '본사'
            else '분점'
        END AS 소속
FROM EMP
ORDER BY 소속;

-- 1번 전체 사원 중 ALLEN과 같은 직책(JOB)인 사원들의
-- 사원 정보, 부서 정보를 다음과 같이 출력하는 SQL문을 작성하세요.
-- 조인과 서브쿼리
SELECT E.JOB, E.EMPNO, E.ENAME, E.SAL, D.DEPTNO, D.DNAME
FROM EMP E JOIN DEPT D
ON E.DEPTNO = D.DEPTNO
WHERE E.JOB = (SELECT JOB FROM EMP
               WHERE ENAME = 'ALLEN')
ORDER BY EMPNO DESC;

-- 2번 전체 사원의 평균 급여(SAL)보다 높은 급여를 받는 사원들의
-- 사원 정보, 부서 정보, 급여 등급 정보를 출력하는 SQL문을 작성하세요
-- (단 출력할 때 급여가 많은 순으로 정렬하되 급여가 같을 경우에는 사원 번호를 기준으로 오름차순으로 정렬하세요).
SELECT E.EMPNO, E.ENAME, (SELECT DNAME
                          FROM DEPT
                          WHERE E.DEPTNO = DEPT.DEPTNO) AS DNAME,
                          HIREDATE, 
                          (SELECT LOC
                          FROM DEPT
                          WHERE E.DEPTNO = DEPT.DEPTNO) AS LOC,
                          SAL, 
                         (SELECT GRADE
                         FROM SALGRADE
                         WHERE E.SAL BETWEEN LOSAL AND HISAL) AS GRADE
FROM EMP E
WHERE E.SAL > (SELECT TRUNC(AVG(SAL))
            FROM EMP
            WHERE DEPTNO = E.DEPTNO)
ORDER BY E.SAL DESC, E.EMPNO;
-------------------------------------------------------------------
SELECT E.EMPNO, E.ENAME, D.DEPTNO, D.DNAME, D.LOC, E.SAL, S.GRADE
FROM EMP E 
JOIN DEPT D ON E.DEPTNO = D.DEPTNO
JOIN SALGRADE S ON E.SAL BETWEEN S.LOSAL AND S.HISAL
WHERE E.SAL > (SELECT AVG(E.SAL)
               FROM EMP)
ORDER BY E.SAL DESC, E.EMPNO;

-- 3번 10번 부서에 근무하는 사원 중 30번 부서에는 존재하지 않는 직책을 가진 사원들의 사원 정보, 
-- 부서 정보를 다음과 같이 출력하는 SQL문을 작성하세요.
SELECT E10.EMPNO, E10.ENAME, E10.JOB, D.DEPTNO, D.DNAME, D.LOC
FROM EMP E10 JOIN DEPT D ON E10.DEPTNO = D.DEPTNO
WHERE E10.DEPTNO = 10
AND E10.JOB NOT IN (SELECT DISTINCT JOB FROM EMP WHERE DEPTNO = 30);

-- 4번 직책이 SALESMAN인 사람들의 최고 급여보다 높은 급여를 받는 사원들의 사원 정보,
-- 급여 등급 정보를 다음과 같이 출력하는 SQL문을 작성하세요
-- (단 서브쿼리를 활용할 때 다중행 함수를 사용하는 방법과 사용하지 않는 방법을 통해 사원 번호를 기준으로 오름차순으로 정렬하세요).
