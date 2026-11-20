CREATE DATABASE IF NOT EXISTS cineman
    CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci;
USE cineman;

CREATE TABLE IF NOT EXISTS tblMember5 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(120) NOT NULL,
    birthday DATE,
    address VARCHAR(255),
    email VARCHAR(255),
    phone VARCHAR(30),
    note VARCHAR(255),
    username VARCHAR(255) NOT NULL UNIQUE,
    authenticationInfo VARCHAR(255) NOT NULL,
    role VARCHAR(20) NOT NULL,
    CHECK (role IN ('CUSTOMER', 'MANAGER', 'SALE_STAFF'))
);

CREATE TABLE IF NOT EXISTS tblCustomer5 (
    memberId INT PRIMARY KEY,
    FOREIGN KEY (memberId) REFERENCES tblMember5(id)
);

CREATE TABLE IF NOT EXISTS tblStaff5 (
    memberId INT PRIMARY KEY,
    position VARCHAR(255) NOT NULL,
    FOREIGN KEY (memberId) REFERENCES tblMember5(id)
);

CREATE TABLE IF NOT EXISTS tblMembershipCard5 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    cardCode VARCHAR(255) NOT NULL UNIQUE,
    issueDate DATE NOT NULL,
    tblCustomer5Id INT NOT NULL UNIQUE,
    issuedByStaffId INT NOT NULL,
    FOREIGN KEY (tblCustomer5Id) REFERENCES tblCustomer5(memberId),
    FOREIGN KEY (issuedByStaffId) REFERENCES tblStaff5(memberId)
);

CREATE TABLE IF NOT EXISTS tblMovie5 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(255) NOT NULL,
    duration INT NOT NULL,
    description VARCHAR(255) NOT NULL,
    CHECK (duration > 0)
);

CREATE TABLE IF NOT EXISTS tblScreeningRoom5 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    capacity INT NOT NULL,
    CHECK (capacity > 0)
);

CREATE TABLE IF NOT EXISTS tblScreening5 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    startDateTime DATETIME NOT NULL,
    ticketPrice DECIMAL(15,2) NOT NULL,
    tblScreeningRoom5Id INT NOT NULL,
    tblMovie5Id INT NOT NULL,
    FOREIGN KEY (tblScreeningRoom5Id) REFERENCES tblScreeningRoom5(id),
    FOREIGN KEY (tblMovie5Id) REFERENCES tblMovie5(id),
    CHECK (ticketPrice >= 0)
);

-- Each record represents a completed purchase. Tickets inherit the screening from this record.
CREATE TABLE IF NOT EXISTS tblTicketPurchaseTransaction5 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    transactionCode VARCHAR(255) NOT NULL UNIQUE,
    transactionDateTime DATETIME NOT NULL,
    purchaseChannel VARCHAR(20) NOT NULL,
    tblCustomer5Id INT,
    tblScreening5Id INT NOT NULL,
    tblStaff5Id INT,
    FOREIGN KEY (tblCustomer5Id) REFERENCES tblCustomer5(memberId),
    FOREIGN KEY (tblScreening5Id) REFERENCES tblScreening5(id),
    FOREIGN KEY (tblStaff5Id) REFERENCES tblStaff5(memberId),
    INDEX ix_transactions_date (transactionDateTime, tblCustomer5Id),
    INDEX ix_transactions_customer_date (tblCustomer5Id, transactionDateTime),
    CHECK (
        (purchaseChannel = 'ONLINE' AND tblCustomer5Id IS NOT NULL AND tblStaff5Id IS NULL)
        OR (purchaseChannel = 'COUNTER' AND tblStaff5Id IS NOT NULL)
    )
);

CREATE TABLE IF NOT EXISTS tblMovieTicket5 (
    id INT AUTO_INCREMENT PRIMARY KEY,
    ticketCode VARCHAR(255) NOT NULL UNIQUE,
    salePrice DECIMAL(15,2) NOT NULL,
    tblTicketPurchaseTransaction5Id INT NOT NULL,
    FOREIGN KEY (tblTicketPurchaseTransaction5Id) REFERENCES tblTicketPurchaseTransaction5(id),
    CHECK (salePrice >= 0)
);

DELIMITER $$

CREATE PROCEDURE IF NOT EXISTS findMoviesByTitle(IN p_title VARCHAR(255))
SQL SECURITY INVOKER
READS SQL DATA
BEGIN
    SELECT id, title, genre, duration, description
    FROM tblMovie5
    WHERE CHAR_LENGTH(TRIM(p_title)) > 0 AND LOCATE(TRIM(p_title), title) > 0
    ORDER BY id;
END$$

CREATE PROCEDURE IF NOT EXISTS getMovieDetails(IN p_movieId INT)
SQL SECURITY INVOKER
READS SQL DATA
BEGIN
    SELECT id, title, genre, duration, description
    FROM tblMovie5
    WHERE id = p_movieId;
END$$

CREATE PROCEDURE IF NOT EXISTS getCustomerRevenue(IN p_startDate DATE, IN p_endDate DATE)
SQL SECURITY INVOKER
READS SQL DATA
BEGIN
    SELECT m.id AS customerId, m.name AS customerName,
           SUM(t.salePrice) AS totalAmount,
           COUNT(DISTINCT p.id) AS totalTransaction, COUNT(t.id) AS totalTicket
    FROM tblTicketPurchaseTransaction5 p
    JOIN tblCustomer5 c ON c.memberId = p.tblCustomer5Id
    JOIN tblMember5 m ON m.id = c.memberId
    JOIN tblMovieTicket5 t ON t.tblTicketPurchaseTransaction5Id = p.id
    WHERE p.transactionDateTime >= p_startDate
      AND p.transactionDateTime <= TIMESTAMP(p_endDate, '23:59:59.999999')
    GROUP BY m.id, m.name
    ORDER BY totalAmount DESC, m.id;
END$$

CREATE PROCEDURE IF NOT EXISTS getCustomerTransactions(
    IN p_customerId INT, IN p_startDate DATE, IN p_endDate DATE
)
SQL SECURITY INVOKER
READS SQL DATA
BEGIN
    SELECT p.id, p.transactionCode, p.transactionDateTime, p.purchaseChannel,
           m.id AS customerId, m.name AS customerName,
           COUNT(t.id) AS ticketCount, SUM(t.salePrice) AS totalAmount
    FROM tblTicketPurchaseTransaction5 p
    JOIN tblCustomer5 c ON c.memberId = p.tblCustomer5Id
    JOIN tblMember5 m ON m.id = c.memberId
    JOIN tblMovieTicket5 t ON t.tblTicketPurchaseTransaction5Id = p.id
    WHERE p.tblCustomer5Id = p_customerId
      AND p.transactionDateTime >= p_startDate
      AND p.transactionDateTime <= TIMESTAMP(p_endDate, '23:59:59.999999')
    GROUP BY p.id, p.transactionCode, p.transactionDateTime, p.purchaseChannel, m.id, m.name
    ORDER BY p.transactionDateTime, p.id;
END$$

DELIMITER ;
