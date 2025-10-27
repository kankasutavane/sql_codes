CREATE TABLE O_RollCall (
    Roll_No   NUMBER(5) PRIMARY KEY,
    Name      VARCHAR2(50),
    Class     VARCHAR2(20)
);
CREATE TABLE N_RollCall (
    Roll_No   NUMBER(5),
    Name      VARCHAR2(50),
    Class     VARCHAR2(20)
);
INSERT INTO O_RollCall VALUES (101, 'Amit Sharma', 'FYBScIT');
INSERT INTO O_RollCall VALUES (102, 'Priya Singh', 'SYBScIT');
INSERT INTO O_RollCall VALUES (103, 'Rahul Mehta', 'TYBScIT');
INSERT INTO N_RollCall VALUES (102, 'Priya Singh', 'SYBScIT');  -- duplicate
INSERT INTO N_RollCall VALUES (104, 'Sneha Patel', 'FYBScIT');  -- new
INSERT INTO N_RollCall VALUES (105, 'Vikas Yadav', 'SYBScIT');  -- new
INSERT INTO N_RollCall VALUES (101, 'Amit Sharma', 'FYBScIT');  -- duplicate
SET SERVEROUTPUT ON;

DECLARE
    -- Parameterized Cursor: accepts Roll_No from N_RollCall
    CURSOR cur_merge(p_rollno N_RollCall.Roll_No%TYPE) IS
        SELECT Roll_No, Name, Class
        FROM N_RollCall
        WHERE Roll_No = p_rollno;

    v_rollno   N_RollCall.Roll_No%TYPE;
    v_name     N_RollCall.Name%TYPE;
    v_class    N_RollCall.Class%TYPE;
    v_count    NUMBER;

BEGIN
    -- Outer loop: iterate over all records in N_RollCall
    FOR rec IN (SELECT Roll_No FROM N_RollCall) LOOP
        -- Check if record already exists in O_RollCall
        SELECT COUNT(*) INTO v_count
        FROM O_RollCall
        WHERE Roll_No = rec.Roll_No;

        IF v_count = 0 THEN
            -- Fetch data from N_RollCall using parameterized cursor
            OPEN cur_merge(rec.Roll_No);
            FETCH cur_merge INTO v_rollno, v_name, v_class;
            CLOSE cur_merge;

            -- Insert into old roll call table
            INSERT INTO O_RollCall (Roll_No, Name, Class)
            VALUES (v_rollno, v_name, v_class);

            DBMS_OUTPUT.PUT_LINE('Inserted Roll_No ' || v_rollno || ' - ' || v_name);
        ELSE
            DBMS_OUTPUT.PUT_LINE('Skipped duplicate Roll_No ' || rec.Roll_No);
        END IF;
    END LOOP;

    DBMS_OUTPUT.PUT_LINE('Data merge completed successfully.');

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
END;
/
SELECT * FROM O_RollCall;
