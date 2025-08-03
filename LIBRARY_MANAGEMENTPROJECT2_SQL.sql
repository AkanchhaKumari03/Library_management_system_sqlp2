CREATE DATABASE LIBRARY_PROJECT_2;
USE LIBRARY_PROJECT_2;
-- LIBRARY MANAGEMENT SYSTEM PROJECT 2
-- CREATING A BRANCH TABLE
DROP TABLE IF EXISTS BRANCH;
CREATE TABLE BRANCH(
branch_id VARCHAR(10) PRIMARY KEY,
manager_id VARCHAR(10),
branch_address VARCHAR(55),	
contact_no VARCHAR(10)
);
DROP TABLE IF EXISTS EMPLOYEES;
CREATE TABLE EMPLOYEES(
emp_id VARCHAR(10) PRIMARY KEY,
emp_name VARCHAR(25),	
position VARCHAR(15),	
salary INT,	
branch_id VARCHAR(25)
);
DROP TABLE IF EXISTS BOOKS;
CREATE TABLE BOOKS(
isbn VARCHAR(25) PRIMARY KEY,	
book_title VARCHAR(75),	
category VARCHAR(25),	
rental_price FLOAT,	
status	VARCHAR(15),
author	VARCHAR(30),
publisher VARCHAR(50));

DROP TABLE IF EXISTS MEMBERS;
CREATE TABLE MEMBERS(
member_id	VARCHAR(20) PRIMARY KEY,
member_name	VARCHAR(30),
member_address	VARCHAR(75),
reg_date DATE
);

DROP TABLE IF EXISTS ISSUED_STATUS;
CREATE TABLE ISSUED_STATUS(
issued_id	VARCHAR(10) PRIMARY KEY,
issued_member_id	VARCHAR(10),
issued_book_name VARCHAR(75),	
issued_date	DATE,
issued_book_isbn	VARCHAR(25),
issued_emp_id VARCHAR(10)
);

DROP TABLE IF EXISTS RETURN_STATUS;
CREATE TABLE RETURN_STATUS(
return_id	VARCHAR(10) PRIMARY KEY,
issued_id	VARCHAR(10),
return_book_name  VARCHAR(75),	
return_date	DATE,
return_book_isbn VARCHAR(20)
);

-- FOREIGN KEY
ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT FK_MEMBERS
foreign key (ISSUED_MEMBER_ID)
references MEMBERS(MEMBER_ID)
;

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT FK_BOOKS
foreign key (ISSUED_BOOK_ISBN)
references BOOKS(ISBN)
;

ALTER TABLE ISSUED_STATUS
ADD CONSTRAINT FK_EMPLOYEES
foreign key (ISSUED_EMP_ID)
references EMPLOYEES(EMP_ID)
;
ALTER TABLE employees
ADD CONSTRAINT FK_branch
foreign key (branch_id)
references branch(branch_id)
;
ALTER TABLE RETURN_STATUS
ADD CONSTRAINT FK_ISSUED_STATUS
foreign key (ISSUED_ID)
references ISSUED_STATUS(ISSUED_ID)
;

INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');
SELECT * FROM books;

UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';


DELETE FROM issued_status
WHERE   issued_id =   'IS121';

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';


SELECT
    issued_emp_id,
    COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1;




CREATE TABLE book_issued_cnt AS
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS issue_count
FROM issued_status as ist
JOIN books as b
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;


SELECT * FROM books
WHERE category = 'Classic';

SELECT 
    b.category,
    SUM(b.rental_price),
    COUNT(*)
FROM 
issued_status as ist
JOIN
books as b
ON b.isbn = ist.issued_book_isbn
GROUP BY 1;


-- SELECT * FROM members
-- WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';





SELECT * FROM BOOKS;
SELECT * FROM ISSUED_STATUS;
SELECT * FROM EMPLOYEES;
SELECT * FROM BRANCH;
CREATE TABLE BRANCH_REPORTS AS
SELECT E.EMP_NAME,E.EMP_ID,E.POSITION,B.BRANCH_ID,B.BRANCH_ADDRESS,B.MANAGER_ID
FROM EMPLOYEES AS E
JOIN
BRANCH AS B
ON E.BRANCH_ID=B.BRANCH_ID
JOIN
EMPLOYEES AS E1
ON B.MANAGER_ID=E1.EMP_ID;

CREATE TABLE BOOKS_PRICE_GREATER_7 AS
SELECT BOOK_TITLE,RENTAL_PRICE
FROM BOOKS
WHERE RENTAL_PRICE>7;

SELECT * FROM BOOKS_PRICE_GREATER_7;

SELECT * FROM issued_status as ist
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE rs.return_id IS NULL;

SELECT 
    ist.issued_member_id,
    m.member_name,
    bk.book_title,
    ist.issued_date,
    -- rs.return_date,
    CURRENT_DATE - ist.issued_date as over_dues_days
FROM issued_status as ist
JOIN 
members as m
    ON m.member_id = ist.issued_member_id
JOIN 
books as bk
ON bk.isbn = ist.issued_book_isbn
LEFT JOIN 
return_status as rs
ON rs.issued_id = ist.issued_id
WHERE 
    rs.return_date IS NULL
    AND
    (CURRENT_DATE - ist.issued_date) > 30
ORDER BY 1;

SELECT * FROM BOOKS;

SELECT B.BRANCH_ID,B.MANAGER_ID,SUM(BK.RENTAL_PRICE) AS TOTAL_REVENUE,
COUNT(IST.ISSUED_ID) FROM ISSUED_STATUS AS IST
JOIN 
EMPLOYEES AS E
ON
E.EMP_ID=IST.ISSUED_EMP_ID
JOIN
BRANCH AS B
ON E.BRANCH_ID=B.BRANCH_ID
LEFT JOIN
RETURN_STATUS AS RS
ON
RS.ISSUED_ID=IST.ISSUED_ID
JOIN
BOOKS AS BK
ON IST.ISSUED_BOOK_ISBN=BK.ISBN;



-- CREATE TABLE active_members
-- AS
-- SELECT * FROM members
-- WHERE member_id IN (SELECT 
--                         DISTINCT issued_member_id   
--                     FROM issued_status
--                     WHERE 
--                         issued_date >= CURRENT_DATE - INTERVAL '2 month'
--                     )
-- ;

SELECT * FROM active_members;
SELECT 
    e.emp_name,
    b.*,
    COUNT(ist.issued_id) as no_book_issued
FROM issued_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
GROUP BY 1, 2;





