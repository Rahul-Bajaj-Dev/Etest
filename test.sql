-- Creating tables
CREATE TABLE Patrons (
    PatronID SERIAL PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Address TEXT,
    UniqueID VARCHAR(50) UNIQUE NOT NULL
);

CREATE TABLE Books (
    ISBN VARCHAR(20) PRIMARY KEY,
    Title VARCHAR(255) NOT NULL,
    Author VARCHAR(255) NOT NULL,
    PublicationYear INT,
    Genre VARCHAR(100),
    Availability BOOLEAN DEFAULT TRUE
);

CREATE TABLE BorrowedBooks (
    BorrowID SERIAL PRIMARY KEY,
    PatronID INT REFERENCES Patrons(PatronID),
    ISBN VARCHAR(20) REFERENCES Books(ISBN),
    BorrowDate DATE NOT NULL,
    ReturnDate DATE
);

-- Register a new patron
CREATE OR REPLACE PROCEDURE RegisterPatron(
    IN p_name VARCHAR(255), 
    IN p_address TEXT, 
    IN p_uniqueid VARCHAR(50)
)
LANGUAGE SQL AS $$
INSERT INTO Patrons (Name, Address, UniqueID) VALUES (p_name, p_address, p_uniqueid);
$$;

-- Add a new book entry
CREATE OR REPLACE PROCEDURE AddBook(
    IN p_isbn VARCHAR(20), 
    IN p_title VARCHAR(255), 
    IN p_author VARCHAR(255), 
    IN p_pubyear INT, 
    IN p_genre VARCHAR(100)
)
LANGUAGE SQL AS $$
INSERT INTO Books (ISBN, Title, Author, PublicationYear, Genre) VALUES (p_isbn, p_title, p_author, p_pubyear, p_genre);
$$;

-- Record a book being borrowed
CREATE OR REPLACE PROCEDURE BorrowBook(
    IN p_patronid INT, 
    IN p_isbn VARCHAR(20), 
    IN p_borrowdate DATE
)
LANGUAGE SQL AS $$
INSERT INTO BorrowedBooks (PatronID, ISBN, BorrowDate) VALUES (p_patronid, p_isbn, p_borrowdate);
UPDATE Books SET Availability = FALSE WHERE ISBN = p_isbn;
$$;

-- Update book availability when returned
CREATE OR REPLACE PROCEDURE ReturnBook(
    IN p_isbn VARCHAR(20), 
    IN p_returndate DATE
)
LANGUAGE SQL AS $$
UPDATE BorrowedBooks SET ReturnDate = p_returndate WHERE ISBN = p_isbn AND ReturnDate IS NULL;
UPDATE Books SET Availability = TRUE WHERE ISBN = p_isbn;
$$;

-- Retrieve names of patrons who borrowed a specific book
SELECT DISTINCT p.Name FROM Patrons p
JOIN BorrowedBooks bb ON p.PatronID = bb.PatronID
JOIN Books b ON bb.ISBN = b.ISBN
WHERE b.Title = 'Specific Book Title';

-- Total books borrowed by each patron
SELECT p.Name, COUNT(bb.BorrowID) AS TotalBorrowed
FROM Patrons p
LEFT JOIN
