declare
    c number;
begin
    c := add_grade('3,5',987000,300,321023);
end;
/
declare
    c number;
begin
    c := add_grade('3,5',987005,300,321023);
end;
/
select calculate_avg(321023) from dual;
/
exec avg_grade;
/
exec add_bonus;
/
insert INTO stud_sub values(300585, 300);
/
select s.name, s.surname, su.name, l.name, l.surname from students s join stud_sub using (student_id) join subjects su using (subject_id) join lecturers l using (lecturer_id);
/
select count(Student_id) , s.name from stud_sub st join subjects s using( subject_id) group by s.name;
/
UPDATE grades SET value = 5 where value = 4.5;
/ 
select to_number('3,5') from dual;