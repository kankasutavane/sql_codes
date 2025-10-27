CREATE TABLE Borrower (
    Roll_no       INT PRIMARY KEY,
    Name          VARCHAR(50),
    Date_of_Issue DATE,
    Name_of_Book  VARCHAR(100),
    Status        CHAR(1) CHECK (Status IN ('I', 'R'))
);
CREATE TABLE Fine (
    Fine_id   INT AUTO_INCREMENT PRIMARY KEY,  -- Optional for MySQL, use SEQUENCE in Oracle
    Roll_no   INT,
    Date      DATE,
    Amt       DECIMAL(10,2),
    FOREIGN KEY (Roll_no) REFERENCES Borrower(Roll_no)
);
INSERT INTO Borrower (Roll_no, Name, Date_of_Issue, Name_of_Book, Status)
VALUES 
(101, 'Amit Sharma', DATE '2025-09-20', 'Database Systems', 'I'),
(102, 'Priya Singh', DATE '2025-10-05', 'Operating Systems', 'I'),
(103, 'Rahul Mehta', DATE '2025-10-25', 'Computer Networks', 'I');
DECLARE
    v_rollno       Borrower.Roll_no%TYPE;
    v_bookname     Borrower.Name_of_Book%TYPE;
    v_issue_date   Borrower.Date_of_Issue%TYPE;
    v_days         NUMBER;
    v_fine         NUMBER := 0;
    v_status       Borrower.Status%TYPE;
    e_not_found    EXCEPTION;
BEGIN
    -- Accept input
    v_rollno := &Roll_no;
    v_bookname := '&Name_of_Book';

    -- Get issue date
    SELECT Date_of_Issue, Status 
    INTO v_issue_date, v_status
    FROM Borrower
    WHERE Roll_no = v_rollno AND Name_of_Book = v_bookname;

    IF v_status = 'R' THEN
        DBMS_OUTPUT.PUT_LINE('Book already returned.');
    ELSE
        -- Calculate number of days
        v_days := TRUNC(SYSDATE - v_issue_date);

        IF v_days > 30 THEN
            v_fine := (15 * 5) + ((v_days - 30) * 50);
        ELSIF v_days > 15 THEN
            v_fine := (v_days - 15) * 5;
        ELSE
            v_fine := 0;
        END IF;

        -- Update status to Returned
        UPDATE Borrower
        SET Status = 'R'
        WHERE Roll_no = v_rollno AND Name_of_Book = v_bookname;

        -- Insert fine details if applicable
        IF v_fine > 0 THEN
            INSERT INTO Fine(Roll_no, Date, Amt)
            VALUES(v_rollno, SYSDATE, v_fine);
        END IF;

        DBMS_OUTPUT.PUT_LINE('Book returned successfully.');
        DBMS_OUTPUT.PUT_LINE('Total Fine: Rs ' || v_fine);
    END IF;

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        RAISE e_not_found;
    WHEN e_not_found THEN
        DBMS_OUTPUT.PUT_LINE('Record not found for given Roll_no and Book.');
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Unexpected error: ' || SQLERRM);
END;
/

