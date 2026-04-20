Tables:
FACULTY(faculty_id, faculty_name, department, salary)
COURSES(course_id, course_name, year)
ASSIGNMENTS(assignment_id, faculty_id, course_id, hours_per_week)

faculty_id in ASSIGNMENTS is a foreign key referencing FACULTY
course_id in ASSIGNMENTS is a foreign key referencing COURSES

Q1
Write an SQL query to display details of faculty members
whose salary is greater than 90000.

Q2
Write an SQL query to find faculty members who are not
assigned to any course in the year 2025.

Q3
Write a PL/SQL block to:
1) Increase salary of faculty in 'CS' department by 10%
2) Display faculty_id and faculty_name after the update

Q4
Write a trigger on ASSIGNMENTS table to:
1) Prevent duplicate entries based on assignment_id
2) If hours_per_week > 20, set it to 20
   and display a warning message

1) SELECT * FROM faculty WHERE salary > 90000;

2) SELECT * FROM faculty f WHERE NOT EXISTS (
    SELECT 1 FROM assignments a JOIN courses c ON a.course_id = c.course_id
    WHERE a.faculty_id = f.faculty_id AND c.year = 2025);

3) BEGIN
    -- Update salaries
    UPDATE faculty SET salary = salary * 1.10 WHERE department = 'CS';

    -- Display results
    FOR rec IN (
        SELECT faculty_id, faculty_name FROM faculty WHERE department = 'CS'
    )
    LOOP
        dbms_output.put_line('ID: ' || rec.faculty_id || ' Name: ' || rec.faculty_name);
    END LOOP;
END;
/

4) CREATE OR REPLACE TRIGGER assignment_trg
BEFORE INSERT ON assignments
FOR EACH ROW
DECLARE
    v_count NUMBER;
BEGIN
    -- Prevent duplicate assignment_id
    SELECT COUNT(*) INTO v_count FROM assignments WHERE assignment_id = :NEW.assignment_id;

    IF v_count > 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Duplicate assignment_id');
    END IF;

    -- Limit hours_per_week
    IF :NEW.hours_per_week > 20 THEN
        :NEW.hours_per_week := 20;
        dbms_output.put_line('Warning: hours_per_week reduced to 20');
    END IF;
END;
/
