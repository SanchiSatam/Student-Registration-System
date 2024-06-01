CREATE OR REPLACE PACKAGE project_package AS
    PROCEDURE show_students(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE show_classes(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE show_courses(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE show_course_credit(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE show_g_enrollments(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE show_score_grade(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE show_prerequisites(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE show_logs(p_cursor OUT SYS_REFCURSOR);
    PROCEDURE show_students_in_class(class_id_in IN Classes.classid%TYPE, p_cursor OUT SYS_REFCURSOR);
    PROCEDURE get_prerequisites(p_dept_code IN Prerequisites.dept_code%TYPE,p_course_num IN Prerequisites.course#%TYPE);
    PROCEDURE enroll_student(p_b_num IN VARCHAR2,p_classid IN VARCHAR2);
    PROCEDURE drop_student(p_b_num IN VARCHAR2,p_classid IN VARCHAR2,p_cursor OUT SYS_REFCURSOR);
    PROCEDURE delete_student(p_b_num IN VARCHAR2);
    PROCEDURE add_student (p_b_number IN VARCHAR2,p_first_name IN VARCHAR2,p_last_name IN VARCHAR2,p_st_level IN VARCHAR2,p_gpa IN NUMBER,p_email IN VARCHAR2,p_birth_date IN DATE);
    PROCEDURE manage_courses(p_dept_code IN VARCHAR2,p_course_num IN NUMBER,p_title IN VARCHAR2,p_action IN VARCHAR2);
    PROCEDURE manage_classes(p_classid IN CHAR,p_dept_code IN VARCHAR2,p_course_num IN NUMBER,p_sect_num IN NUMBER,p_year IN NUMBER,p_semester IN VARCHAR2,p_limit IN NUMBER,p_class_size IN NUMBER,p_room IN VARCHAR2,p_action IN VARCHAR2);
    PROCEDURE delete_course_data (p_dept_code IN courses.dept_code%TYPE,p_course_num IN courses.course#%TYPE);
    PROCEDURE delete_class_data (p_classid IN classes.classid%TYPE);
END project_package;
/

CREATE OR REPLACE PACKAGE BODY project_package AS
    PROCEDURE show_students(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR SELECT * FROM Students;
    END show_students;

    PROCEDURE show_classes(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR SELECT * FROM Classes;
    END show_classes;

    PROCEDURE show_courses(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR SELECT * FROM Courses;
    END show_courses;

    PROCEDURE show_course_credit(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR SELECT * FROM Course_Credit;
    END show_course_credit;

    PROCEDURE show_g_enrollments(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR SELECT * FROM G_Enrollments;
    END show_g_enrollments;

    PROCEDURE show_score_grade(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR SELECT * FROM Score_Grade;
    END show_score_grade;

    PROCEDURE show_prerequisites(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR SELECT * FROM Prerequisites;
    END show_prerequisites;

    PROCEDURE show_logs(p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        OPEN p_cursor FOR SELECT * FROM Logs;
    END show_logs;
    
    -- Req 3
    PROCEDURE show_students_in_class(class_id_in IN Classes.classid%TYPE, p_cursor OUT SYS_REFCURSOR) IS
    BEGIN
        -- Check if the provided classid exists in the Classes table
        DECLARE
            v_class_exists NUMBER;
        BEGIN
            SELECT COUNT(*)
            INTO v_class_exists
            FROM Classes
            WHERE classid = class_id_in;

            IF SUBSTR(class_id_in, 1, 1) != 'c' THEN
                DBMS_OUTPUT.PUT_LINE('Class ID must start with ''c''.');
                RETURN;
            END IF;        

            -- If the class does not exist, raise an exception
            IF v_class_exists = 0 THEN
                DBMS_OUTPUT.PUT_LINE('The classid is invalid.');
            END IF;
        END;

        -- If the classid is valid, proceed to list the students in the class
        OPEN p_cursor FOR
        SELECT Students."B#", Students.first_name, Students.last_name, Students.st_level, Students.gpa, Students.email, Students.bdate
        FROM Students
        INNER JOIN G_Enrollments ON Students."B#" = G_Enrollments."G_B#"
        WHERE G_Enrollments.classid = class_id_in;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE(SQLERRM);
    END show_students_in_class;

    PROCEDURE get_prerequisites(
        p_dept_code IN Prerequisites.dept_code%TYPE,
        p_course_num IN Prerequisites.course#%TYPE
    ) IS
        v_course_exists NUMBER;
        -- Temporary variables to store direct prerequisites
        TYPE direct_prerequisites_type IS TABLE OF VARCHAR2(100);
        direct_prerequisites direct_prerequisites_type := direct_prerequisites_type();
        
        -- Cursor variable for indirect prerequisites
        CURSOR indirect_prerequisites_cur IS
            SELECT DISTINCT pre_dept_code || pre_course# AS prerequisite
            FROM Prerequisites
            START WITH dept_code = p_dept_code AND course# = p_course_num
            CONNECT BY NOCYCLE dept_code = PRIOR pre_dept_code
                AND course# = PRIOR pre_course#
                AND (dept_code, course#) NOT IN (
                    SELECT dept_code, course#
                    FROM Prerequisites
                    WHERE pre_dept_code = p_dept_code
                    AND pre_course# = p_course_num
                );
    BEGIN
        -- Check if the provided course exists in the Prerequisites table as a direct prerequisite

        SELECT COUNT(*)
        INTO v_course_exists
        FROM courses
        WHERE dept_code = p_dept_code AND course# = p_course_num;

        IF v_course_exists = 0 THEN
            DBMS_OUTPUT.PUT_LINE('The course does not exist.');
            RETURN;
        END IF;        
        SELECT pre_dept_code || pre_course#
        BULK COLLECT INTO direct_prerequisites
        FROM Prerequisites
        WHERE dept_code = p_dept_code
        AND course# = p_course_num;

        IF direct_prerequisites.COUNT = 0 THEN
            DBMS_OUTPUT.PUT_LINE(p_dept_code || p_course_num || ' does not exist.');
            RETURN;
        END IF;

        -- Retrieve direct prerequisites
        DBMS_OUTPUT.PUT_LINE('Direct Prerequisites:');
        FOR i IN 1..direct_prerequisites.COUNT LOOP
            DBMS_OUTPUT.PUT_LINE(direct_prerequisites(i));
        END LOOP;

        -- Retrieve indirect prerequisites excluding direct prerequisites
        DBMS_OUTPUT.PUT_LINE('Indirect Prerequisites:');
        FOR indirect_rec IN indirect_prerequisites_cur LOOP
            -- Check if the indirect prerequisite is not also a direct prerequisite
            IF indirect_rec.prerequisite NOT MEMBER OF direct_prerequisites THEN
                DBMS_OUTPUT.PUT_LINE(indirect_rec.prerequisite);
            END IF;
        END LOOP;
    END get_prerequisites;


-- req5 
    PROCEDURE enroll_student(
        p_b_num IN VARCHAR2,
        p_classid IN VARCHAR2
    ) IS
        v_student_count INTEGER;
        v_class_size INTEGER;
        v_student_enrolled_count INTEGER;
        v_prerequisite_count INTEGER := 0;
        v_dept_code classes.dept_code%TYPE;
        v_course# classes.course#%TYPE;
        v_year classes.year%TYPE;
        v_semester classes.semester%TYPE;
        
    BEGIN
        -- Check if the student exists
        SELECT COUNT(*)
        INTO v_student_count
        FROM students
        WHERE B# = p_b_num;

        IF v_student_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('The B# is invalid.');
            RETURN;
        END IF;

        -- Check if the student is a graduate student
        SELECT COUNT(*)
        INTO v_student_count
        FROM students
        WHERE B# = p_b_num AND st_level IN ('master', 'PhD');

        IF v_student_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('This is not a graduate student.');
            RETURN;
        END IF;

        -- Check if the class exists
        BEGIN
            SELECT limit, class_size
            INTO v_class_size, v_student_count
            FROM classes
            WHERE classid = p_classid;
            
            IF v_class_size = 0 OR v_student_count = 0 THEN
                DBMS_OUTPUT.PUT_LINE('The classid is invalid.');
                RETURN;
            END IF;	
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('The classid is invalid.');
                RETURN;
        END;

        -- Check if the class is offered in the current semester (Assuming Spring 2021 is the current semester)
        BEGIN
            SELECT COUNT(*)
            INTO v_student_count
            FROM classes
            WHERE classid = p_classid
            AND semester = 'Spring'
            AND year = 2021;
            
            IF v_student_count = 0 THEN
                DBMS_OUTPUT.PUT_LINE('Cannot enroll into a class from a previous semester (i.e not from Spring 2021).');
                RETURN;
            END IF;	
            
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Cannot enroll into a class from a previous semester (i.e not from Spring 2021).');
                RETURN;
        END;

-- Check if the class is already full
        BEGIN
            SELECT limit, class_size
            INTO v_class_size, v_student_count
            FROM classes
            WHERE classid = p_classid;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_student_count := 0;
        END;

        IF v_student_count >= v_class_size THEN
            DBMS_OUTPUT.PUT_LINE('The class is already full.');
            RETURN;
        END IF;

        -- Check if the student is already in the class
        BEGIN
            SELECT COUNT(*)
            INTO v_student_count
            FROM g_enrollments
            WHERE g_B# = p_b_num
            AND classid = p_classid;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_student_count := 0;
        END;

        IF v_student_count > 0 THEN
            DBMS_OUTPUT.PUT_LINE('The student is already in the class.');
            RETURN;
        END IF;

        -- Check if the student is already enrolled in five other classes in the same semester and year (Assuming Spring 2021 is the current semester)
        BEGIN
            SELECT COUNT(*)
            INTO v_student_count
            FROM g_enrollments ge
            JOIN classes c ON ge.classid = c.classid
            WHERE g_B# = p_b_num
            AND c.year = 2021
            AND c.semester = 'Spring'
            GROUP BY g_B#;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                v_student_count := 0;
        END;

        IF v_student_count >= 5 THEN
            DBMS_OUTPUT.PUT_LINE('Students cannot be enrolled in more than five classes in the same semester.');
            RETURN;
        END IF;

        -- Check if the student has completed the required prerequisite courses with at least a grade 'C'. 
        BEGIN
            -- Fetch prerequisite details
            FOR prerequisite IN (
                SELECT pre.pre_dept_code, pre.pre_course#, cl.year, cl.semester
                FROM Prerequisites pre 
                JOIN classes cl ON pre.dept_code = cl.dept_code AND pre.course# = cl.course#
                WHERE cl.classid = p_classid
            ) LOOP
            
                -- Check if student has completed the prerequisite course
                SELECT COUNT(*)
                INTO v_prerequisite_count
                FROM classes cl
                JOIN g_enrollments ge ON cl.classid = ge.classid
                JOIN score_grade sg ON ge.score = sg.score
                WHERE cl.dept_code = prerequisite.pre_dept_code
                AND cl.course# = prerequisite.pre_course#
                AND ge.g_B# = p_b_num
                -- AND cl.year <> prerequisite.year
                -- AND cl.semester <> prerequisite.semester
                AND sg.lgrade IN ('A', 'A-', 'B', 'B+', 'B-', 'C+', 'C');

                IF v_prerequisite_count <= 0 THEN
                    DBMS_OUTPUT.PUT_LINE('Prerequisite not satisfied for ' || prerequisite.pre_dept_code || ' ' || prerequisite.pre_course#);
                    RETURN;
                END IF;
            END LOOP;
        EXCEPTION
            WHEN NO_DATA_FOUND THEN
                DBMS_OUTPUT.PUT_LINE('Prerequisite details not found.');
                RETURN;
        END;

        -- If all checks pass, enroll the student into the class
        INSERT INTO g_enrollments (g_B#, classid)
        VALUES (p_b_num, p_classid);

        DBMS_OUTPUT.PUT_LINE('Student enrolled successfully!');

    END enroll_student;

-- req6
    PROCEDURE drop_student(
        p_b_num IN VARCHAR2,
        p_classid IN VARCHAR2,
        p_cursor OUT SYS_REFCURSOR
    ) IS
        v_student_count INTEGER;
        v_class_count INTEGER;
        v_last_class_count INTEGER;
        v_class_semester VARCHAR2(10);
        v_class_year NUMBER;
    BEGIN
        -- Check if the student exists
        SELECT COUNT(*)
        INTO v_student_count
        FROM students
        WHERE B# = p_b_num;

        IF v_student_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('The B# is invalid.');
            RETURN;
        END IF;

        -- Check if the student is a graduate student
        SELECT COUNT(*)
        INTO v_student_count
        FROM students
        WHERE B# = p_b_num AND st_level IN ('master', 'PhD');

        IF v_student_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('This is not a graduate student.');
            RETURN;
        END IF;

        -- Check if the class exists
        SELECT COUNT(*)
        INTO v_class_count
        FROM classes
        WHERE classid = p_classid;

        IF v_class_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('The classid is invalid.');
            RETURN;
        END IF;

        -- Check if the student is enrolled in the class
        SELECT COUNT(*)
        INTO v_student_count
        FROM g_enrollments
        WHERE g_B# = p_b_num AND classid = p_classid;

        IF v_student_count = 0 THEN
            DBMS_OUTPUT.PUT_LINE('The student is not enrolled in the class.');
            RETURN;
        END IF;

        -- Check if the class is not offered in Spring 2021 i.e current semester
        -- Get class semester and year
        SELECT semester, year
        INTO v_class_semester, v_class_year
        FROM classes
        WHERE classid = p_classid;

        -- Check if the class is offered in Spring 2021
        IF v_class_semester != 'Spring' OR TO_CHAR(v_class_year) != '2021' THEN
            DBMS_OUTPUT.PUT_LINE('Only enrollment in the current semester can be dropped.');
            RETURN;
        END IF;

        -- Check if it's the last class for the student in Spring 2021
        SELECT COUNT(*)
        INTO v_last_class_count
        FROM g_enrollments ge
        JOIN CLASSES cl ON cl.classid = ge.classid
        WHERE ge.g_B# = p_b_num
        AND cl.year = 2021 
        AND cl.semester = 'Spring'
        GROUP BY ge.g_B#;

        IF v_last_class_count <= 1 THEN
            DBMS_OUTPUT.PUT_LINE('This is the only class for this student in Spring 2021 and cannot be dropped.');
            RETURN;
        END IF;

        -- If all checks pass, drop the student from the class
        DELETE FROM g_enrollments
        WHERE g_B# = p_b_num AND classid = p_classid;
        
        DBMS_OUTPUT.PUT_LINE('Student dropped successfully from the class.');

        -- Open the refcursor and select the enrollment details
        OPEN p_cursor FOR
        SELECT * FROM g_enrollments WHERE g_B# = p_b_num AND classid = p_classid;
    END drop_student;

-- req7
    PROCEDURE delete_student(
    p_b_num IN VARCHAR2
    ) IS
        v_student_count INTEGER;
        BEGIN
            -- Check if the student exists
            SELECT COUNT(*)
            INTO v_student_count
            FROM students
            WHERE B# = p_b_num;

            IF v_student_count = 0 THEN
                DBMS_OUTPUT.PUT_LINE('The B# is invalid.');
                RETURN;
            END IF;

            -- Delete student from Students table
            DELETE FROM students
            WHERE B# = p_b_num;

            DBMS_OUTPUT.PUT_LINE('Student deleted successfully from the Students table.');

            DBMS_OUTPUT.PUT_LINE('');
        END delete_student;

--bonus 1
    PROCEDURE add_student (
        p_b_number IN VARCHAR2,
        p_first_name IN VARCHAR2,
        p_last_name IN VARCHAR2,
        p_st_level IN VARCHAR2,
        p_gpa IN NUMBER,
        p_email IN VARCHAR2,
        p_birth_date IN DATE
    ) IS
        l_count INTEGER;
        v_student_count INTEGER;
    BEGIN
        -- Check if B# starts with 'B'
        IF SUBSTR(p_b_number, 1, 1) != 'B' OR LENGTH(p_b_number) > 9 THEN
            dbms_output.put_line('B# must start with ''B'' and should be 9 characters long');
            RETURN;
        END IF;

        SELECT COUNT(*)
            INTO v_student_count
            FROM students
            WHERE B# = p_b_number;

            IF v_student_count != 0 THEN
                DBMS_OUTPUT.PUT_LINE('The B# already exists.');
                RETURN;
            END IF;

        -- Check student level
        IF NOT (p_st_level IN ('freshman', 'sophomore', 'junior', 'senior', 'master', 'PhD')) THEN
            dbms_output.put_line('Invalid student level');
            RETURN;
        END IF;

        -- Check GPA range
        IF p_gpa < 0 OR p_gpa > 4.0 THEN
            dbms_output.put_line('GPA must be between 0 and 4.0');
            RETURN;
        END IF;

        -- Check email uniqueness
        SELECT COUNT(*) INTO l_count FROM students WHERE email = p_email;
        IF l_count > 0 THEN
            dbms_output.put_line('Email already exists');
            RETURN;
        END IF;

        -- Insert the record
        INSERT INTO students (B#, first_name, last_name, st_level, gpa, email, bdate)
        VALUES (p_b_number, p_first_name, p_last_name, p_st_level, p_gpa, p_email, p_birth_date);
        dbms_output.put_line('Student added successfully');

        COMMIT;
    END add_student;

--bonus2
    PROCEDURE manage_courses(
        p_dept_code IN VARCHAR2,
        p_course_num IN NUMBER,
        p_title IN VARCHAR2,
        p_action IN VARCHAR2
    ) AS
        v_course_exists NUMBER;
    BEGIN
        IF p_course_num < 100 OR p_course_num > 799 THEN
            DBMS_OUTPUT.PUT_LINE('Course number must be between 100 and 799.');
            RETURN; -- Exit the procedure if course number is invalid
        END IF;
        
        IF LENGTH(p_dept_code) > 4 THEN
            DBMS_OUTPUT.PUT_LINE('Department code must not exceed 4 characters.');
            RETURN;
        END IF;

        IF p_action = 'ADD' THEN
            SELECT COUNT(*)
            INTO v_course_exists
            FROM courses
            WHERE dept_code = p_dept_code AND course# = p_course_num;

            IF v_course_exists != 0 THEN
                DBMS_OUTPUT.PUT_LINE('The course already exists.');
                RETURN;
            END IF;
            
            INSERT INTO courses (dept_code, course#, title)
            VALUES (p_dept_code, p_course_num, p_title);
            DBMS_OUTPUT.PUT_LINE('Course added: ' || p_dept_code || ' ' || p_course_num || ' - ' || p_title);
        END IF;
        COMMIT;
    EXCEPTION
        WHEN OTHERS THEN
            DBMS_OUTPUT.PUT_LINE('Error: ' || SQLERRM);
            ROLLBACK;
            RAISE;
    END manage_courses;

    PROCEDURE manage_classes(
        p_classid IN CHAR,
        p_dept_code IN VARCHAR2,
        p_course_num IN NUMBER,
        p_sect_num IN NUMBER,
        p_year IN NUMBER,
        p_semester IN VARCHAR2,
        p_limit IN NUMBER,
        p_class_size IN NUMBER,
        p_room IN VARCHAR2,
        p_action IN VARCHAR2
    ) AS
        v_class_exists NUMBER;
        v_course_exists NUMBER;
    BEGIN
        -- Check if the action is valid
        IF UPPER(p_action) NOT IN ('ADD', 'DELETE') THEN
            DBMS_OUTPUT.PUT_LINE('Invalid action specified.');
            RETURN;
        END IF;

        IF p_action = 'ADD' THEN
            -- Check if the class already exists before adding
            SELECT COUNT(*)
            INTO v_class_exists
            FROM classes
            WHERE classid = p_classid;

            IF v_class_exists != 0 THEN
                DBMS_OUTPUT.PUT_LINE('The class already exists.');
                RETURN;
            END IF;

            -- Validate each column value
            IF SUBSTR(p_classid, 1, 1) != 'c' OR LENGTH(p_classid) > 5 THEN
                DBMS_OUTPUT.PUT_LINE('Class ID must start with ''c'' and should be maximum 4 characters long ');
                RETURN;
            END IF;

            IF p_dept_code IS NULL OR LENGTH(p_dept_code) > 4 THEN
                DBMS_OUTPUT.PUT_LINE('Invalid department code.');
                RETURN;
            END IF;

            IF p_course_num < 100 OR p_course_num > 799 THEN
                DBMS_OUTPUT.PUT_LINE('Course number must be between 100 and 799.');
                RETURN;
            END IF;

            IF p_sect_num < 1 OR p_sect_num > 99 THEN
                DBMS_OUTPUT.PUT_LINE('Section number must be between 1 and 99.');
                RETURN;
            END IF;

            IF p_year < 1900 OR p_year > 2100 THEN
                DBMS_OUTPUT.PUT_LINE('Invalid year.');
                RETURN;
            END IF;

            IF p_semester NOT IN ('Spring', 'Fall', 'Summer 1', 'Summer 2', 'Winter') THEN
                DBMS_OUTPUT.PUT_LINE('Invalid semester.');
                RETURN;
            END IF;

            IF p_limit < 1 OR p_limit > 999 THEN
                DBMS_OUTPUT.PUT_LINE('Invalid limit.');
                RETURN;
            END IF;

            IF p_class_size < 1 OR p_class_size > 999 THEN
                DBMS_OUTPUT.PUT_LINE('Invalid class size.');
                RETURN;
            END IF;

            IF LENGTH(p_room) > 10 THEN
                DBMS_OUTPUT.PUT_LINE('Room name must be up to 10 characters.');
                RETURN;
            END IF;

            SELECT COUNT(*)
            INTO v_course_exists
            FROM courses
            WHERE dept_code = p_dept_code AND course# = p_course_num;

            IF v_course_exists = 0 THEN
                DBMS_OUTPUT.PUT_LINE('The course does not exist.');
                RETURN;
            END IF;

            -- Insert the class
            INSERT INTO classes (classid, dept_code, course#, sect#, year, semester, limit, class_size, room)
            VALUES (p_classid, p_dept_code, p_course_num, p_sect_num, p_year, p_semester, p_limit, p_class_size, p_room);
            DBMS_OUTPUT.PUT_LINE('Class added: ' || p_classid || ' - ' || p_dept_code || ' ' || p_course_num || ' Section ' || p_sect_num);
        END IF;
    END manage_classes;

-- to delete courses
    PROCEDURE delete_course_data (
        p_dept_code IN courses.dept_code%TYPE,
        p_course_num IN courses.course#%TYPE
    )
    IS
        v_log_id NUMBER;
        v_course_exists NUMBER;
    BEGIN

            SELECT COUNT(*)
            INTO v_course_exists
            FROM courses
            WHERE dept_code = p_dept_code AND course# = p_course_num;

            IF v_course_exists = 0 THEN
                DBMS_OUTPUT.PUT_LINE('The course does not exist.');
                RETURN;
            END IF;
        -- Delete from g_enrollments table
        DELETE FROM g_enrollments WHERE classid IN (
            SELECT classid FROM classes WHERE dept_code = p_dept_code AND course# = p_course_num
        );

        -- Delete from classes table
        DELETE FROM classes WHERE dept_code = p_dept_code AND course# = p_course_num;

        -- Delete from prerequisites table
        DELETE FROM prerequisites WHERE dept_code = p_dept_code AND course# = p_course_num;

        -- Delete from course_credit table (if necessary)
        DELETE FROM course_credit WHERE course# = p_course_num;

        -- Delete from courses table
        DELETE FROM courses WHERE dept_code = p_dept_code AND course# = p_course_num;
        DBMS_OUTPUT.PUT_LINE('Course deleted successfully');

        SELECT log_sequence.NEXTVAL INTO v_log_id FROM DUAL;

        INSERT INTO logs (log#, user_name, op_time, table_name, operation, tuple_keyvalue)
        VALUES (v_log_id, USER, SYSDATE, 'Courses', 'DELETE', p_dept_code || ',' || p_course_num);
    END delete_course_data;

 -- Procedure to delete classes and respective data
    PROCEDURE delete_class_data (
        p_classid IN classes.classid%TYPE
    )
    IS
        v_class_exists NUMBER;
    BEGIN
            SELECT COUNT(*)
            INTO v_class_exists
            FROM classes
            WHERE classid = p_classid;

            IF v_class_exists = 0 THEN
                DBMS_OUTPUT.PUT_LINE('The class does not exist.');
                RETURN;
            END IF;
        -- Delete from g_enrollments table
        DELETE FROM g_enrollments WHERE classid = p_classid;

        -- Delete from classes table
        DELETE FROM classes WHERE classid = p_classid;
        DBMS_OUTPUT.PUT_LINE('Class deleted successfully');
    END delete_class_data;
    
END project_package;
/
show errors