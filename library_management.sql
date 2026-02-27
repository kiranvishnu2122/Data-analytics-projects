-- Library Management System SQL Project

-- CREATE DATABASE library_management_system;

-- USE library_management_system;
/*
SELECT * FROM books;
SELECT * FROM branch;
SELECT * FROM employees;
SELECT * FROM issued_status;
SELECT * FROM return_status;
SELECT * FROM members;
*/

-- Task 1. Create a New Book Record -- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"

/*INSERT INTO books(isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');*/
-- SELECT * FROM books;

-- Task 2: Update an Existing Member's Address

-- SET SQL_SAFE_UPDATES = 0
/*
UPDATE members
SET member_address = '125 Main St'
WHERE member_id = 'C101';
SELECT * FROM members;
*/

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

/*
SELECT * FROM issued_status
WHERE issued_id = 'IS121';

DELETE FROM issued_status
WHERE issued_id = 'IS121'
*/

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

/*
SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';
*/

-- Task 5: List Employees Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find Employees who have issued more than one book.

/*
SELECT ist.issued_emp_id, e.emp_name,count(*)
FROM issued_status as ist
JOIN
employees as e
ON e.emp_id = ist.issued_emp_id
GROUP BY ist.issued_emp_id, e.emp_name
HAVING COUNT(ist.issued_id) > 1
*/

-- Task 6: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

/*
SELECT issued_member_id, COUNT(*)
FROM issued_status
GROUP BY 1
HAVING COUNT(*) > 1
*/

-- CTAS
-- Task 7 : Create Summary Tables: Used CTAS to generate new tables based on query results - each book and total book_issued_cnt**
-- includes books that have been issued at least once 
-- (since it performs an INNER JOIN).
/*
CREATE TABLE book_cnts
AS    
SELECT b.isbn, b.book_title,COUNT(ist.issued_id) as no_issued
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;

SELECT * FROM book_cnts;
*/
/* --include books that have never been issued (showing no_issued = 0)
CREATE TABLE book_cnt AS    
SELECT b.isbn, b.book_title, COUNT(ist.issued_id) AS no_issued
FROM books AS b
LEFT JOIN issued_status AS ist
ON ist.issued_book_isbn = b.isbn
GROUP BY b.isbn, b.book_title;
SELECT * FROM book_cnt;
*/
-- Task 8. Retrieve All Books in a Specific Category:
/*
SELECT * FROM books
WHERE category = 'Classic'
*/
    
-- Task 9 : Find Total Rental Income by Category:

/*
SELECT b.category, SUM(b.rental_price),COUNT(*)
FROM books as b
JOIN
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY category
*/

-- Task 10 : List Employees with Their Branch Manager's Name and their branch details:

/*
SELECT e1.*, b.manager_id, e2.emp_name as manager
FROM employees as e1
JOIN  
branch as b
ON b.branch_id = e1.branch_id
JOIN
employees as e2
ON b.manager_id = e2.emp_id
*/

-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold 7USD:
/*
CREATE TABLE books_price_greater_than_seven
AS    
SELECT * FROM Books
WHERE rental_price > 7

SELECT * FROM 
books_price_greater_than_seven ;
*/

-- Task 12: Retrieve the List of Books Not Yet Returned
/*
SELECT DISTINCT ist.issued_book_name as not_returned_books
FROM issued_status as ist
LEFT JOIN
return_status as rs
ON ist.issued_id = rs.issued_id
WHERE rs.return_id IS NULL
*/

-- Task 13: List Members Who Registered in the Last 300 Days:
/*
SELECT * FROM members
WHERE reg_date >= CURDATE() - INTERVAL 300 DAY
ORDER BY reg_date DESC;
*/

/* 
Task 14: 
Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.

SELECT m.member_id, m.member_name, 
b.book_title, ist.issued_date, 
DATEDIFF(CURDATE(), ist.issued_date) - 30 AS days_overdue
FROM issued_status AS ist
JOIN members AS m ON m.member_id = ist.issued_member_id
JOIN books AS b ON b.isbn = ist.issued_book_isbn
WHERE DATEDIFF(CURDATE(), ist.issued_date) > 30;
*/
    
/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, 
showing the number of books issued, the number of books returned, 
and the total revenue generated from book rentals.

SELECT * FROM branch;

SELECT * FROM issued_status;

SELECT * FROM employees;

SELECT * FROM books;

SELECT * FROM return_status;

CREATE TABLE branch_reports
AS
SELECT 
    b.branch_id,
    b.manager_id,
    COUNT(ist.issued_id) as number_book_issued,
    COUNT(rs.return_id) as number_of_book_return,
    SUM(bk.rental_price) as total_revenue
FROM issued_status as ist
JOIN 
employees as e
ON e.emp_id = ist.issued_emp_id
JOIN
branch as b
ON e.branch_id = b.branch_id
LEFT JOIN
return_status as rs
ON rs.issued_id = ist.issued_id
JOIN 
books as bk
ON ist.issued_book_isbn = bk.isbn
GROUP BY branch_id,manager_id;

SELECT * FROM branch_reports;
*/

/*
Task 16: Create a View of Active Members
Use the CREATE VIEW statement to create a view of active_members
 containing members who have issued at least one book in the last 12 months.

CREATE VIEW active_members AS
SELECT * FROM members 
WHERE member_id IN (
    SELECT DISTINCT issued_member_id FROM issued_status 
    WHERE issued_date >= CURDATE() - INTERVAL 12 MONTH
);
SELECT * FROM active_members;
*/

-- Task 17: Find Employees with the Most Book Issues Processed
-- Write a query to find the top 3 employees who have processed the most book issues. 
-- Display the employee name, number of books processed, and their branch.
/*
SELECT 
    e.emp_name, 
    b.branch_id, 
    b.branch_address, 
    COUNT(ist.issued_id) AS no_book_issued
FROM issued_status AS ist
JOIN employees AS e ON e.emp_id = ist.issued_emp_id
JOIN branch AS b ON e.branch_id = b.branch_id
GROUP BY e.emp_name, b.branch_id, b.branch_address
ORDER BY no_book_issued DESC;
*/

/*
Task 18: Stored Procedure Objective: 
Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
The procedure should function as follows: 
The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). 
If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 
If the book is not available (status = 'no'), the procedure should return an error message indicating that the book is currently not available.


DELIMITER //

CREATE PROCEDURE IssueBook(IN book_id INT)
BEGIN
    DECLARE book_status VARCHAR(10);

    -- Check if the book is available
    SELECT status INTO book_status FROM books WHERE book_id = book_id;

    IF book_status = 'yes' THEN
        -- Update book status to 'no' (issued)
        UPDATE books SET status = 'no' WHERE book_id = book_id;
        SELECT 'Book issued successfully!' AS message;
    ELSE
        -- Return error message if book is not available
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Error: The book is currently not available.';
    END IF;
END //

DELIMITER ;
*/

-- Task 19 : Window function objective
-- Write a query to find the most frequently issued book using rank function.
/*
SELECT isbn, book_title, total_issues, RANK() OVER (ORDER BY total_issues DESC) AS rank_position
FROM (
    SELECT b.isbn, b.book_title, COUNT(i.issued_id) AS total_issues
    FROM issued_status i
    JOIN books b ON i.issued_book_isbn = b.isbn
    GROUP BY b.isbn, b.book_title
) AS book_issue_counts;
*/

-- Task 20 : Find Only the Most Frequently Issued Book
/*
WITH ranked_books AS (
    SELECT isbn, book_title, total_issues, RANK() OVER (ORDER BY total_issues DESC) AS rank_position
    FROM (
        SELECT b.isbn, b.book_title, COUNT(i.issued_id) AS total_issues
        FROM issued_status i
        JOIN books b ON i.issued_book_isbn = b.isbn
        GROUP BY b.isbn, b.book_title
    ) AS book_issue_counts
)
SELECT * FROM ranked_books WHERE rank_position = 1;
*/

-- Task 21 : Write SQL Query to Get the Branch with the Most Issued Books
/*
SELECT branch_id, branch_address, total_issues
FROM (
    SELECT b.branch_id, b.branch_address, COUNT(i.issued_id) AS total_issues,
           RANK() OVER (ORDER BY COUNT(i.issued_id) DESC) AS rank_position
    FROM issued_status i
    JOIN employees e ON i.issued_emp_id = e.emp_id
    JOIN branch b ON e.branch_id = b.branch_id
    GROUP BY b.branch_id, b.branch_address
) AS branch_ranking
--WHERE rank_position = 1;
*/

