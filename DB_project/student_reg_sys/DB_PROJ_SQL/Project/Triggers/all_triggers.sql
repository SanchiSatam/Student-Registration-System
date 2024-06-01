CREATE OR REPLACE TRIGGER del_grad_enrollment_trigger
BEFORE DELETE ON students
FOR EACH ROW
BEGIN
    -- Delete tuples from G_Enrollments table involving the student being deleted
    DELETE FROM g_enrollments
    WHERE g_B# = :old.B#;
    DBMS_OUTPUT.PUT_LINE('Associated tuples deleted successfully from the G_Enrollments table.');
END;
/

-- TRIGGER To Update Class by 1 post insert in G_Enrollments
CREATE OR REPLACE TRIGGER enroll_student_trigger
AFTER INSERT ON g_enrollments
FOR EACH ROW
BEGIN
    -- Update the class size after a new enrollment
    UPDATE classes
    SET class_size = class_size + 1
    WHERE classid = :new.classid;
        
    DBMS_OUTPUT.PUT_LINE('Class size updated successfully after enrollment.');
END;
/

-- Log generation for G_Enrollment Table
CREATE OR REPLACE TRIGGER g_enrollment_logs_trigger
AFTER INSERT OR DELETE ON g_enrollments
FOR EACH ROW
DECLARE
    v_op varchar2(6);
    v_log_id NUMBER;
BEGIN
    IF INSERTING THEN
        v_op := 'INSERT';
    ELSE
        v_op := 'DELETE';
    END IF;

    -- Get the next value from the sequence
    SELECT log_sequence.NEXTVAL INTO v_log_id FROM DUAL;

    -- Insert the log record
    IF INSERTING THEN
        INSERT INTO logs (log#, user_name, op_time, table_name, operation, tuple_keyvalue)
        VALUES (v_log_id, USER, SYSDATE, 'G_Enrollments', v_op, :NEW.g_B# || ',' || :NEW.classid);
    ELSE
        INSERT INTO logs (log#, user_name, op_time, table_name, operation, tuple_keyvalue)
        VALUES (v_log_id, USER, SYSDATE, 'G_Enrollments', v_op, :OLD.g_B# || ',' || :OLD.classid);
    END IF;
END g_enrollment_logs_trigger;
/
show errors

-- Log generation for Students Table
CREATE OR REPLACE TRIGGER student_delete_logs_trigger
AFTER DELETE ON students
FOR EACH ROW
DECLARE
    v_log_id NUMBER;
BEGIN
	-- Get the next value from the sequence
    SELECT log_sequence.NEXTVAL INTO v_log_id FROM DUAL;
	
    INSERT INTO logs (log#, user_name, op_time, table_name, operation, tuple_keyvalue)
    VALUES (v_log_id, USER, SYSDATE, 'Students', 'DELETE', :OLD.B#);
END student_delete_logs_trigger;
/

-- TRIGGER To reduce Class by 1 post delete in G_Enrollments
CREATE OR REPLACE TRIGGER update_class_size_trigger
AFTER DELETE ON g_enrollments
FOR EACH ROW
BEGIN
    UPDATE classes
    SET class_size = class_size - 1
    WHERE classid = :old.classid;
    DBMS_OUTPUT.PUT_LINE('Class size updated successfully after dropping the student.');
END;
/

--Trigger for Adding Student

CREATE OR REPLACE TRIGGER student_insert_logs_trigger
AFTER INSERT ON students
FOR EACH ROW
DECLARE
    v_log_id NUMBER;
BEGIN
    -- Get the next value from the sequence
    SELECT log_sequence.NEXTVAL INTO v_log_id FROM DUAL;
    
    -- Insert into logs table
    INSERT INTO logs (log#, user_name, op_time, table_name, operation, tuple_keyvalue)
    VALUES (v_log_id, USER, SYSDATE, 'Students', 'INSERT', :NEW.B#);
END student_insert_logs_trigger;
/
show errors

-- Trigger to add classes
CREATE OR REPLACE TRIGGER class_insert_logs_trigger
BEFORE INSERT ON classes
FOR EACH ROW
DECLARE
    v_log_id NUMBER;
    v_course_count INTEGER;
BEGIN
    -- Check if the dept_code and course# exist in the courses table
    SELECT COUNT(*)
    INTO v_course_count
    FROM courses
    WHERE dept_code = :NEW.dept_code AND course# = :NEW.course#;

    IF v_course_count = 0 THEN
        DBMS_OUTPUT.PUT_LINE('The course with dept_code ' || :NEW.dept_code || ' and course# ' || :NEW.course# || ' does not exist.');
        RETURN;
    END IF;

    -- Get the next value from the sequence
    SELECT log_sequence.NEXTVAL INTO v_log_id FROM DUAL;

    -- Insert into logs table
    INSERT INTO logs (log#, user_name, op_time, table_name, operation, tuple_keyvalue)
    VALUES (v_log_id, USER, SYSDATE, 'Classes', 'INSERT', :NEW.classid);
END class_insert_logs_trigger;
/
show errors

-- Trigger to delete classes
-- CREATE OR REPLACE TRIGGER class_delete_logs_trigger
-- FOR DELETE ON classes
-- COMPOUND TRIGGER
--     -- Declare variables
--     v_log_id NUMBER;

--     -- Before statement section
--     BEFORE STATEMENT IS
--     BEGIN
--         -- Get the next value from the sequence
--         SELECT log_sequence.NEXTVAL INTO v_log_id FROM DUAL;
--     END BEFORE STATEMENT;

--     -- Before each row section
--     BEFORE EACH ROW IS
--     BEGIN
--         -- Check if the class exists
--         IF :OLD.classid IS NOT NULL THEN
--             -- Insert into logs table
--             INSERT INTO logs (log#, user_name, op_time, table_name, operation, tuple_keyvalue)
--             VALUES (v_log_id, USER, SYSDATE, 'Classes', 'DELETE', :OLD.classid);
--         END IF;
--     END BEFORE EACH ROW;
-- END class_delete_logs_trigger;
-- /
-- show errors

-- Simple trigger to delete class
CREATE OR REPLACE TRIGGER class_delete_logs_trigger
AFTER DELETE ON classes
FOR EACH ROW
DECLARE
    v_log_id NUMBER;
BEGIN
    -- Get the next value from the sequence
    SELECT log_sequence.NEXTVAL INTO v_log_id FROM DUAL;
    
    -- Check if the class exists
    IF :OLD.classid IS NOT NULL THEN
        -- Insert into logs table
        INSERT INTO logs (log#, user_name, op_time, table_name, operation, tuple_keyvalue)
        VALUES (v_log_id, USER, SYSDATE, 'Classes', 'DELETE', :OLD.classid);
    END IF;
END class_delete_logs_trigger;
/
show errors

-- Trigger To add courses 
CREATE OR REPLACE TRIGGER course_insert_logs_trigger
AFTER INSERT ON courses
FOR EACH ROW
DECLARE
    v_log_id NUMBER;
BEGIN
    -- Get the next value from the sequence
    SELECT log_sequence.NEXTVAL INTO v_log_id FROM DUAL;
    
    -- Insert into logs table
    INSERT INTO logs (log#, user_name, op_time, table_name, operation, tuple_keyvalue)
    VALUES (v_log_id, USER, SYSDATE, 'Courses', 'INSERT', :NEW.dept_code || ',' || :NEW.course#);
END course_insert_logs_trigger;
/
show errors