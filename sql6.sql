CREATE TABLE Stud_Marks (
    Roll_No      NUMBER(5) PRIMARY KEY,
    Name         VARCHAR2(50),
    Total_Marks  NUMBER(5)
);
CREATE TABLE Result (
    Roll_No   NUMBER(5),
    Name      VARCHAR2(50),
    Class     VARCHAR2(30)
);
INSERT INTO Stud_Marks VALUES (101, 'Amit Sharma', 1450);
INSERT INTO Stud_Marks VALUES (102, 'Priya Singh', 980);
INSERT INTO Stud_Marks VALUES (103, 'Rahul Mehta', 870);
INSERT INTO Stud_Marks VALUES (104, 'Sneha Patel', 820);
INSERT INTO Stud_Marks VALUES (105, 'Vikas Yadav', 1550);  -- invalid marks (for testing)
CREATE OR REPLACE PROCEDURE proc_Grade(
    p_rollno IN Stud_Marks.Roll_No%TYPE
)
IS
    v_name        Stud_Marks.Name%TYPE;
    v_totalmarks  Stud_Marks.Total_Marks%TYPE;
    v_class       VARCHAR2(30);
BEGIN
    -- Retrieve student details
    SELECT Name, Total_Marks INTO v_name, v_totalmarks
    FROM Stud_Marks
    WHERE Roll_No = p_rollno;

    -- Determine class based on marks
    IF v_totalmarks BETWEEN 990 AND 1500 THEN
        v_class := 'Distinction';
    ELSIF v_totalmarks BETWEEN 900 AND 989 THEN
        v_class := 'First Class';
    ELSIF v_totalmarks BETWEEN 825 AND 899 THEN
        v_class := 'Higher Second Class';
    ELSE
        v_class := 'Fail / Below Criteria';
    END IF;

    -- Insert into Result table
    INSERT INTO Result (Roll_No, Name, Class)
    VALUES (p_rollno, v_name, v_class);

    DBMS_OUTPUT.PUT_LINE('Result Inserted: ' || v_name || ' - ' || v_class);

EXCEPTION
    WHEN NO_DATA_FOUND THEN
        DBMS_OUTPUT.PUT_LINE('No student found with Roll No: ' || p_rollno);
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END proc_Grade;
/
SET SERVEROUTPUT ON;

DECLARE
    v_rollno Stud_Marks.Roll_No%TYPE;
BEGIN
    -- Process each student
    FOR rec IN (SELECT Roll_No FROM Stud_Marks) LOOP
        proc_Grade(rec.Roll_No);
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('All student results processed successfully.');
END;
/
SELECT * FROM Result;
