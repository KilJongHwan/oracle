-- DML(Data Manupulation Language) : 데이터를 조회(SELECT),삭제(DELETE),입력(INSERT),변경(UPDATE)
-- 테이블이 아니고 데이터를 조작하는 것

-- DML을 하기 위해서 임시 테이블 생성
-- 기존의 DEPT TABLE을 복사해서 DEPT_TEMP TABLE 생성
CREATE TABLE DEPT_TEMP
AS SELECT * FROM DEPT;

SELECT * FROM DEPT_TEMP;

DROP TABLE DEPT_TEMP;  -- TABLE 삭제

-- TABLE에 데이터 추가하기
INSERT INTO DEPT_TEMP(DEPTNO, DNAME, LOC) VALUES(50, 'DATABASE', 'SEOUL');
INSERT INTO DEPT_TEMP(DEPTNO, LOC, DNAME) VALUES(50, 'BUSAN', 'DEVELOPEMENT');
INSERT INTO DEPT_TEMP(DEPTNO, DNAME, LOC) VALUES(70, NULL, 'INCHEON');

-- 2번째 방법
INSERT INTO DEPT_TEMP VALUES(80, 'FRONTEND', NULL);
INSERT INTO DEPT_TEMP(DEPTNO, DNAME) VALUES(90, 'BACKEND');

CREATE TABLE EMP_TEMP
AS SELECT * FROM EMP
WHERE 1 != 1; -- TABLE을 복사해서 새로운 테이블을 만들 때 데이터는 복사하지 않고 싶을 때 사용

SELECT * FROM EMP_TEMP;
-- TABLE에 날짜 데이터 입력하기
INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
    VALUES(9002,'JESSY', 'MANAGER', 9000, TO_DATE('2023/09/23', 'YYYY/MM/DD'), 1500, 1000, 10);
INSERT INTO EMP_TEMP(EMPNO, ENAME, JOB, MGR, HIREDATE, SAL, COMM, DEPTNO)
    VALUES(9003,'LUCY', 'MANAGER', 9000, SYSDATE, 1500, 1000, 10);

-- 서브쿼리를 이용한 INSERT
INSERT INTO EMP_TEMP(EMPNO, ENAME,JOB,MGR,HIREDATE,SAL,COMM,DEPTNO)
    SELECT E.EMPNO, E.ENAME, E.JOB, E.MGR, E.HIREDATE, E.SAL, E.COMM, E.DEPTNO
    FROM EMP E JOIN SALGRADE S
    ON E.SAL BETWEEN S.LOSAL AND S.HISAL
    WHERE S.GRADE = 1;

-- UPDATE : 행의 정보를 변경할 때 사용
-- UPDATE '테이블이름' SET '변경할 열의 이름과 데이터' WHERE '조건식'
SELECT * FROM DEPT_TEMP2;
CREATE TABLE DEPT_TEMP2
AS SELECT * FROM DEPT_TEMP;
UPDATE DEPT_TEMP2 
    SET DNAME = 'BACKEND',
        LOC = 'KENTUCKY'
    WHERE DEPTNO = 30;

-- TABLE에 있는 데이터 삭제 하기
CREATE TABLE EMP_TEMP2
AS SELECT * FROM EMP;

SELECT * FROM EMP_TEMP2;

-- 조건절 없이 사용하면 모든 데이터가 삭제
DELETE FROM EMP_TEMP2
WHERE JOB = 'SALESMAN';

CREATE TABLE DEPT_TCL
AS SELECT *
FROM DEPT;

SELECT * FROM DEPT_TCL;

INSERT INTO DEPT_TCL VALUES(50, 'DATABASE', 'SEOUL');

COMMIT;

UPDATE DEPT_TCL
SET LOC = 'SEOUL'
WHERE DEPTNO = 30;

ROLLBACK;