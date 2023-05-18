/*
Created: 27.05.2021
Modified: 31.05.2021
Model: University_Study_System_logiczny
Database: Oracle 19c
*/


-- Create tables section -------------------------------------------------

-- Table Systems

CREATE TABLE Systems(
  System_id Integer NOT NULL,
  Name Varchar2(50 ) NOT NULL,
  Short_name Char(10 ) NOT NULL
)
/

-- Add keys for table Systems

ALTER TABLE Systems ADD CONSTRAINT System_PK PRIMARY KEY (System_id)
/

-- Table Universities

CREATE TABLE Universities(
  University_id Integer NOT NULL,
  Name Varchar2(100 ) NOT NULL,
  Shortest_name Varchar2(10 ),
  Street Varchar2(40 ) NOT NULL,
  Building_number Varchar2(10 ) NOT NULL,
  City Varchar2(30 ) NOT NULL,
  System_id Integer NOT NULL
)
/

-- Create indexes for table Universities

CREATE INDEX IX_Jest_przypisany_do ON Universities (System_id)
/

-- Add keys for table Universities

ALTER TABLE Universities ADD CONSTRAINT University_PK PRIMARY KEY (University_id)
/

-- Table Students

CREATE TABLE Students(
  Student_id Integer NOT NULL,
  Name Varchar2(20 ) NOT NULL,
  Surname Varchar2(30 ) NOT NULL,
  Gender Varchar2(1 ) NOT NULL
        CHECK (Gender IN ('K','M')),
  Cource Varchar2(30 ),
  System_id Integer NOT NULL
)
/

-- Create indexes for table Students

CREATE INDEX IX_Belongs_to ON Students (System_id)
/

-- Add keys for table Students

ALTER TABLE Students ADD CONSTRAINT Student_PK PRIMARY KEY (Student_id)
/

-- Table Lecturers

CREATE TABLE Lecturers(
  Lecturer_id Integer NOT NULL,
  Name Varchar2(20 ) NOT NULL,
  Surname Varchar2(30 ) NOT NULL,
  System_id Integer NOT NULL
)
/

-- Create indexes for table Lecturers

CREATE INDEX IX_Nalezy_do ON Lecturers (System_id)
/

-- Add keys for table Lecturers

ALTER TABLE Lecturers ADD CONSTRAINT Lecturer_PK PRIMARY KEY (Lecturer_id)
/

-- Table Subjects

CREATE TABLE Subjects(
  Subject_id Integer NOT NULL,
  Name Varchar2(100 ) NOT NULL,
  Shortest_name Varchar2(10 ) NOT NULL,
  System_id Integer NOT NULL,
  University_id Integer NOT NULL,
  Lecturer_id Integer NOT NULL
)
/

-- Create indexes for table Subjects

CREATE INDEX IX_Wystepuje_w ON Subjects (System_id)
/

CREATE INDEX IX_Jest_wykladany_w ON Subjects (University_id)
/

CREATE INDEX IX_Wykladany_przez ON Subjects (Lecturer_id)
/

-- Add keys for table Subjects

ALTER TABLE Subjects ADD CONSTRAINT Subject_PK PRIMARY KEY (Subject_id)
/

-- Table Grades

CREATE TABLE Grades(
  Grade_id Integer NOT NULL,
  Value Number NOT NULL
        CHECK (Value IN (2, 3, 3.5, 4, 4.5, 5)),
  Date_issue Date NOT NULL,
  Student_id Integer NOT NULL,
  Subject_id Integer NOT NULL,
  Lecturer_id Integer NOT NULL
)
/

-- Create indexes for table Grades

CREATE INDEX IX_Ma_ocene ON Grades (Student_id)
/

CREATE INDEX IX_Z_przedmiotu ON Grades (Subject_id)
/

CREATE INDEX IX_Wystawiona_przez ON Grades (Lecturer_id)
/

-- Add keys for table Grades

ALTER TABLE Grades ADD CONSTRAINT Grade_PK PRIMARY KEY (Grade_id)
/

-- Table Registrations

CREATE TABLE Registrations(
  Registration_id Integer NOT NULL,
  Name Varchar2(50 ) NOT NULL,
  Date_from Date NOT NULL,
  Date_to Date NOT NULL,
  System_id Integer NOT NULL,
  University_id Integer NOT NULL
)
/

-- Create indexes for table Registrations

CREATE INDEX IX_Jest_w ON Registrations (System_id)
/

CREATE INDEX IX_Nalezy_do2 ON Registrations (University_id)
/

-- Add keys for table Registrations

ALTER TABLE Registrations ADD CONSTRAINT Registration_PK PRIMARY KEY (Registration_id)
/

-- Table Uni_Lec

CREATE TABLE Uni_Lec(
  University_id Integer NOT NULL,
  Lecturer_id Integer NOT NULL
)
/

-- Table Uni_Stud

CREATE TABLE Uni_Stud(
  University_id Integer NOT NULL,
  Student_id Integer NOT NULL
)
/

-- Table Reg_Stud

CREATE TABLE Reg_Stud(
  Registration_id Integer NOT NULL,
  Student_id Integer NOT NULL
)
/

-- Table Reg_Sub

CREATE TABLE Reg_Sub(
  Registration_id Integer NOT NULL,
  Subject_id Integer NOT NULL
)
/

-- Table Stud_Sub

CREATE TABLE Stud_Sub(
  Student_id Integer NOT NULL,
  Subject_id Integer NOT NULL
)
/


-- Create foreign keys (relationships) section ------------------------------------------------- 

ALTER TABLE Students ADD CONSTRAINT Belongs_to FOREIGN KEY (System_id) REFERENCES Systems (System_id)
/



ALTER TABLE Universities ADD CONSTRAINT Jest_przypisany_do FOREIGN KEY (System_id) REFERENCES Systems (System_id)
/



ALTER TABLE Lecturers ADD CONSTRAINT Nalezy_do FOREIGN KEY (System_id) REFERENCES Systems (System_id)
/



ALTER TABLE Registrations ADD CONSTRAINT Jest_w FOREIGN KEY (System_id) REFERENCES Systems (System_id)
/



ALTER TABLE Subjects ADD CONSTRAINT Wystepuje_w FOREIGN KEY (System_id) REFERENCES Systems (System_id)
/



ALTER TABLE Subjects ADD CONSTRAINT Jest_wykladany_w FOREIGN KEY (University_id) REFERENCES Universities (University_id)
/



ALTER TABLE Grades ADD CONSTRAINT Ma_ocene FOREIGN KEY (Student_id) REFERENCES Students (Student_id)
/



ALTER TABLE Grades ADD CONSTRAINT Z_przedmiotu FOREIGN KEY (Subject_id) REFERENCES Subjects (Subject_id)
/



ALTER TABLE Subjects ADD CONSTRAINT Wykladany_przez FOREIGN KEY (Lecturer_id) REFERENCES Lecturers (Lecturer_id)
/



ALTER TABLE Grades ADD CONSTRAINT Wystawiona_przez FOREIGN KEY (Lecturer_id) REFERENCES Lecturers (Lecturer_id)
/



ALTER TABLE Registrations ADD CONSTRAINT Nalezy_do2 FOREIGN KEY (University_id) REFERENCES Universities (University_id)
/




