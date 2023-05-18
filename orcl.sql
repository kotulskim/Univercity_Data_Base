create sequence grades_seq start with 90 maxvalue 100000;
/
Create or replace trigger check_viability
before insert or update on grades for each row
declare
 lect_id integer;
begin
    select lecturer_id  into lect_id from subjects where (subject_id=:new.subject_id);
    
    if lect_id != :new.lecturer_id then
        dbms_output.put_line("proba dodania oceny przez niewlasciwa osobe");
        raise_application_error(-20005, 'Wystawiajacy ocene nie prowadzi danego przedmiotu');
    end if;
end;
/
Create or replace function add_grade(grade_val float,lecturer_id number,subject_id number,student_id number)
return number
as
    grade_key number;
    
begin
    select grades_seq.nextval into grade_key from dual;
    INSERT INTO grades VALUES(grade_key, grade_val, sysdate, student_id, subject_id, lecturer_id);
    return 0;
end;
/
Create or replace function calculate_avg(stud_id number)
return number
as
    average number;
    cnt number;
begin
    select avg(avg_value) into average from AVG_Grades where (student_id=stud_id);
    return average;
end;
/
Create or replace function calculate_avg(stud_id number)
return number
as
    average number;
    cnt number;
begin
    select avg(avg_value) into average from AVG_Grades where (student_id=stud_id);
    return average;
end;
/
select calculate_avg(321023) from dual;
/
INSERT INTO avg_grades VALUES(321023,301,5);
/
CREATE OR REPLACE PROCEDURE avg_grade 
AS
    avgs NUMBER;
    summ NUMBER :=0;
    coun NUMBER :=0;
    is_avg NUMBER :=0;
 
BEGIN 
    FOR grade IN (Select student_id, subject_id  from grades group by student_id, subject_id) LOOP 
        summ:=0;
        is_avg:=0;
        for grades IN(select value from grades  where student_id = grade.student_id and subject_id = grade.subject_id) LOOP
            summ := summ + grades.value;
        END Loop; 
        select count(value) INTO coun from grades  where student_id = grade.student_id and subject_id = grade.subject_id;
        select count(*) INTO is_avg  from AVG_grades where student_id = grade.student_id and subject_id = grade.subject_id;
        avgs := (summ / coun );
        IF is_avg  = 0 then 
            insert INTO AVG_grades values (grade.student_id, grade.subject_id, avgs);
        ELSE 
            UPDATE AVG_GRADES SET AVG_value = avgs where student_id = grade.student_id and subject_id = grade.subject_id;
        END IF;
    END LOOP;

END;
/

CREATE OR REPLACE PROCEDURE add_bonus
AS
    avgs NUMBER;
    summ NUMBER :=0;
    grade_key number;
    coun NUMBER :=0;
BEGIN 
    FOR grade IN (Select  student_id, subject_id  from grades group by student_id, subject_id) LOOP 
        summ:=0;
        for grades IN(select value from grades  where student_id = grade.student_id and subject_id = grade.subject_id) LOOP
            summ := summ + grades.value;
        END Loop; 
        select count(value) INTO coun from grades  where student_id = grade.student_id and subject_id = grade.subject_id;
        avgs := (summ / coun );
        IF avgs >= 4.5 then
            select grades_seq.nextval into grade_key from dual;
            INSERT INTO grades values (grade_key, 5, sysdate, grade.student_id, grade.subject_id, (select lecturer_id from subjects where subject_id = grade.subject_id ));
            
        END IF;
    END LOOP;
END;
/


create or replace trigger add_stud_sub 
before insert ON stud_sub FOR EACH ROW
declare 
    is_stud boolean := false;
    is_sub boolean := false ;
begin 
    for stud IN (select student_id from students) LOOP 
        IF stud.student_id = :new.student_id THEN 
            is_stud := true ;
        END IF;
    END LOOP;
    
    for sub IN (select subject_id from subjects) LOOP 
        IF sub.subject_id = :new.subject_id  THEN 
            is_sub := true ;
        END IF;
    END LOOP;
    
    IF is_stud = false OR is_sub=false THEN 
        raise_application_error(-20001, 'Przedmiot lub student o takim ID nie istnieje');
    END IF;
END;
/




