CREATE TABLE person (
    person_id    VARCHAR2(10) NOT NULL,
    first_name   VARCHAR2(30) NOT NULL,
    last_name    VARCHAR2(30) NOT NULL,
    dob          DATE NOT NULL,
    gender       VARCHAR2(10) NOT NULL,
    email        VARCHAR2(60) NOT NULL,
    phone_number VARCHAR2(10) NOT NULL
);

ALTER TABLE person ADD CONSTRAINT person_pk PRIMARY KEY ( person_id );

ALTER TABLE person ADD CONSTRAINT person__un UNIQUE ( email,
                                                      gender );

CREATE TABLE address (
    house_id VARCHAR2(10) NOT NULL,
    country  VARCHAR2(75) NOT NULL,
    city     VARCHAR2(100) NOT NULL,
    zip_code VARCHAR2(10) NOT NULL
);

ALTER TABLE address ADD CONSTRAINT adress_pk PRIMARY KEY ( house_id );


CREATE TABLE address_person (
    house_id  VARCHAR2(10) NOT NULL,
    person_id VARCHAR2(10) NOT NULL
);

ALTER TABLE address_person ADD CONSTRAINT address_person_pk PRIMARY KEY ( house_id,
                                                                          person_id );

ALTER TABLE address_person
    ADD CONSTRAINT address_person_address_fk FOREIGN KEY ( house_id )
        REFERENCES address ( house_id );

ALTER TABLE address_person
    ADD CONSTRAINT address_person_person_fk FOREIGN KEY ( person_id )
        REFERENCES person ( person_id );
        
CREATE TABLE module (
    module_id     VARCHAR2(10) NOT NULL,
    module_name   VARCHAR2(100) NOT NULL,
    module_credit INTEGER NOT NULL
);

ALTER TABLE module ADD CONSTRAINT module_pk PRIMARY KEY ( module_id );


CREATE TABLE teacher (
    teacher_id  VARCHAR2(10) NOT NULL,
    hire_date   DATE NOT NULL,
    designation VARCHAR2(75) NOT NULL,
    salary      FLOAT NOT NULL
);

ALTER TABLE teacher ADD CONSTRAINT teacher_pk PRIMARY KEY ( teacher_id );

ALTER TABLE teacher
    ADD CONSTRAINT teacher_person_fk FOREIGN KEY ( teacher_id )
        REFERENCES person ( person_id );
        
        
CREATE TABLE module_teacher (
    module_id  VARCHAR2(10) NOT NULL,
    teacher_id VARCHAR2(10) NOT NULL
);

ALTER TABLE module_teacher ADD CONSTRAINT module_teacher_pk PRIMARY KEY ( module_id,
                                                                          teacher_id );

ALTER TABLE module_teacher
    ADD CONSTRAINT module_teacher_module_fk FOREIGN KEY ( module_id )
        REFERENCES module ( module_id );

ALTER TABLE module_teacher
    ADD CONSTRAINT module_teacher_teacher_fk FOREIGN KEY ( teacher_id )
        REFERENCES teacher ( teacher_id );
        
        
CREATE TABLE student (
    student_id     VARCHAR2(10) NOT NULL,
    enrolment_date DATE NOT NULL
);

ALTER TABLE student ADD CONSTRAINT student_pk PRIMARY KEY ( student_id );

ALTER TABLE student
    ADD CONSTRAINT student_person_fk FOREIGN KEY ( student_id )
        REFERENCES person ( person_id );
        
        
CREATE TABLE department (
    department_id   VARCHAR2(10) NOT NULL,
    department_name VARCHAR2(50) NOT NULL,
    building        VARCHAR2(50) NOT NULL,
    room_number     VARCHAR2(10) NOT NULL
);

ALTER TABLE department ADD CONSTRAINT department_pk PRIMARY KEY ( department_id );


CREATE TABLE assignment_status (
    grade  VARCHAR2(2) NOT NULL,
    status VARCHAR2(20) NOT NULL
);

ALTER TABLE assignment_status ADD CONSTRAINT marking_grade_pk PRIMARY KEY ( grade );


CREATE TABLE assignment_detail (
    assigment_id        VARCHAR2(10) NOT NULL,
    assignment_name     VARCHAR2(75) NOT NULL,
    assigment_type      VARCHAR2(50) NOT NULL,
    assigment_weightage FLOAT(4) NOT NULL
);

ALTER TABLE assignment_detail ADD CONSTRAINT assignment_pk PRIMARY KEY ( assigment_id );


CREATE TABLE module_student (
    module_id  VARCHAR2(10) NOT NULL,
    student_id VARCHAR2(10) NOT NULL
);

ALTER TABLE module_student ADD CONSTRAINT module_student_pk PRIMARY KEY ( module_id,
                                                                          student_id );

ALTER TABLE module_student
    ADD CONSTRAINT module_student_module_fk FOREIGN KEY ( module_id )
        REFERENCES module ( module_id );

ALTER TABLE module_student
    ADD CONSTRAINT module_student_student_fk FOREIGN KEY ( student_id )
        REFERENCES student ( student_id );
        
        
CREATE TABLE marking (
    assignment_id  VARCHAR2(10) NOT NULL,
    student_id     VARCHAR2(10) NOT NULL,
    module_id      VARCHAR2(10) NOT NULL,
    department_id  VARCHAR2(10) NOT NULL,
    grade          VARCHAR2(2) NOT NULL,
    submitted_date DATE NOT NULL,
    due_date       DATE NOT NULL
);

ALTER TABLE marking
    ADD CONSTRAINT assignment_marks_pk PRIMARY KEY ( assignment_id,
                                                     student_id,
                                                     module_id );

ALTER TABLE marking
    ADD CONSTRAINT marking_assignment_detail_fk FOREIGN KEY ( assignment_id )
        REFERENCES assignment_detail ( assigment_id );

ALTER TABLE marking
    ADD CONSTRAINT marking_assignment_status_fk FOREIGN KEY ( grade )
        REFERENCES assignment_status ( grade );

ALTER TABLE marking
    ADD CONSTRAINT marking_department_fk FOREIGN KEY ( department_id )
        REFERENCES department ( department_id );

ALTER TABLE marking
    ADD CONSTRAINT marking_module_student_fk FOREIGN KEY ( module_id,
                                                           student_id )
        REFERENCES module_student ( module_id,
                                    student_id );


                                    
                                    
CREATE TABLE fee_detail (
    bill_no       VARCHAR2(10) NOT NULL,
    student_id    VARCHAR2(10) NOT NULL,
    department_id VARCHAR2(10) NOT NULL,
    fee_type      VARCHAR2(50) NOT NULL,
    fee_amount    FLOAT NOT NULL,
    payment_type  VARCHAR2(30) NOT NULL,
    payment_date  DATE NOT NULL
);

ALTER TABLE fee_detail ADD CONSTRAINT fee_payment_detail_pk PRIMARY KEY ( bill_no );

ALTER TABLE fee_detail
    ADD CONSTRAINT fee_detail_department_fk FOREIGN KEY ( department_id )
        REFERENCES department ( department_id );

ALTER TABLE fee_detail
    ADD CONSTRAINT fee_detail_student_fk FOREIGN KEY ( student_id )
        REFERENCES student ( student_id );
        

CREATE TABLE attendance (
    attendance_id VARCHAR2(10) NOT NULL,
    student_id    VARCHAR2(10) NOT NULL,
    total_days    INTEGER NOT NULL,
    attended_days INTEGER NOT NULL
);

ALTER TABLE attendance ADD CONSTRAINT attendance_pk PRIMARY KEY ( attendance_id );

ALTER TABLE attendance
    ADD CONSTRAINT attendance_student_fk FOREIGN KEY ( student_id )
        REFERENCES student ( student_id );


        


CREATE SEQUENCE Person_Sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Address_Sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Module_Sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Department_Sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Fee_Detail_Sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Assignment_Detail_Sequence START WITH 1 INCREMENT BY 1;
CREATE SEQUENCE Attendance_Sequence START WITH 1 INCREMENT BY 1;




CREATE OR REPLACE TRIGGER Person_on_insert
    BEFORE INSERT ON Person
    FOR EACH ROW
BEGIN
    SELECT CONCAT('Per-', CAST(Person_Sequence.nextval as varchar(10)))
    INTO :new.Person_ID
    FROM Dual;
END;

CREATE OR REPLACE TRIGGER Address_on_insert
    BEFORE INSERT ON Address
    FOR EACH ROW
BEGIN
    SELECT CONCAT('Hou-', CAST(Address_Sequence.nextval as varchar(10)))
    INTO :new.House_ID
    FROM Dual;
END;

CREATE OR REPLACE TRIGGER Module_on_insert
    BEFORE INSERT ON Module
    FOR EACH ROW
BEGIN
    SELECT CONCAT('Mod-',CAST(Module_Sequence.nextval as varchar(10)))
    INTO :new.Module_ID
    FROM Dual;
END;

CREATE OR REPLACE TRIGGER Department_on_insert
    BEFORE INSERT ON Department
    FOR EACH ROW
BEGIN
    SELECT CONCAT('Dep-',CAST(Department_Sequence.nextval as varchar(10)))
    INTO :new.Department_ID
    FROM Dual;
END;

CREATE OR REPLACE TRIGGER Fee_Detail_on_insert
    BEFORE INSERT ON Fee_Detail
    FOR EACH ROW
BEGIN
    SELECT CONCAT('Bil-',CAST(Fee_Detail_Sequence.nextval as varchar(10)))
    INTO :new.Bill_No
    FROM Dual;
END;

CREATE OR REPLACE TRIGGER Assignment_Detail_on_insert
    BEFORE INSERT ON Assignment_Detail
    FOR EACH ROW
BEGIN
    SELECT CONCAT('AS-',CAST(Assignment_Detail_Sequence.nextval as varchar(10)))
    INTO :new.Assigment_ID
    FROM Dual;
END;


CREATE OR REPLACE TRIGGER Attendance_on_insert
    BEFORE INSERT ON Attendance
    FOR EACH ROW
BEGIN
    SELECT CONCAT('Att-',CAST(Attendance_Sequence.nextval as varchar(10)))
    INTO :new.Attendance_ID
    FROM Dual;
END;

COMMIT;        



INSERT ALL
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Kamala', 'Shrestha', TO_DATE('1/5/1999', 'DD/MM/YYYY'), 'Female', 'kamala@gmail.com', '9835222332')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Suresh', 'Malotra', TO_DATE('1/2/2000', 'DD/MM/YYYY'), 'Male', 'suresh123@gmail.com', '9814403353')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Abhishek', 'Rai', TO_DATE('13/6/1986', 'DD/MM/YYYY'), 'Male', 'abhishek__12@gmail.com', '9570083532')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Dipesh', 'Maharjan', TO_DATE('2/8/2001', 'DD/MM/YYYY'), 'Male', 'dipesh_mar@gmail.com', '9115455656')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Stuti', 'Piya', TO_DATE('22/12/2000', 'DD/MM/YYYY'), 'Other', 'stuti12@hotmail.com', '9947402717')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Rabina', 'Tamang', TO_DATE('21/1/1999', 'DD/MM/YYYY'), 'Female', 'rabintam@gmail.com', '9860595199')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Stutee', 'Bhandari', TO_DATE('13/11/2000', 'DD/MM/YYYY'), 'Female', 'stutee123@gmail.com', '9157662952')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Aroja', 'Shrestha', TO_DATE('2/2/1990', 'DD/MM/YYYY'), 'Female', 'shresaroja@gmail.com', '9557231435')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Suku', 'Shrestha', TO_DATE('24/6/2000', 'DD/MM/YYYY'), 'Female', 'sukushth@gmail.com', '9174227632')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Prajwol', 'Sharma', TO_DATE('9/4/1990', 'DD/MM/YYYY'), 'Male', 'sharmap@gmail.com', '9680941040')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Ajal', 'Giri', TO_DATE('16/5/1975', 'DD/MM/YYYY'), 'Other', 'ajalgiri@hotmail.com', '9514497148')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Bibek', 'Pandit', TO_DATE('19/9/1998', 'DD/MM/YYYY'), 'Female', 'bibek398@gmail.com', '9127365979')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Ankita', 'Maskey', TO_DATE('22/12/1995', 'DD/MM/YYYY'), 'Female', 'shadow_ankita@gmail.com', '9686613321')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Arora', 'Rai', TO_DATE('2/9/1998', 'DD/MM/YYYY'), 'Other', 'raiarora@gmail.com', '9813161987')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Neha', 'Gurung', TO_DATE('1/3/1997', 'DD/MM/YYYY'), 'Female', 'neha_teddy@gmail.com', '9828332173')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Abhey', 'Gupta', TO_DATE('7/11/1999', 'DD/MM/YYYY'), 'Male', 'abh.gupta@gmail.com', '9862465503')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Sabin', 'Basnet', TO_DATE('25/10/1978', 'DD/MM/YYYY'), 'Male', 'sunshine_sabin@hotmail.com', '9946195225')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Radhika', 'Dangol', TO_DATE('14/9/2001', 'DD/MM/YYYY'), 'Female', 'dangol_radhika@yahoo.com', '9877686082')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Iswori', 'Dhakal', TO_DATE('14/9/1970', 'DD/MM/YYYY'), 'Female', 'dhakal_is@yahoo.com', '9877667082')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Gunther', 'Dangol', TO_DATE('14/9/2001', 'DD/MM/YYYY'), 'Male', 'guntherdangol@yahoo.com', '9856686082')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Zenith', 'Malla', TO_DATE('14/9/1988', 'DD/MM/YYYY'), 'Male', 'zenithmalla@yahoo.com', '9877896082')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Jakriti', 'Shrestha', TO_DATE('1/4/1999', 'DD/MM/YYYY'), 'Female', 'jskshretha@gmail.com', '9835222122')
    INTO Person (First_Name, Last_Name, DOB, Gender, Email, Phone_Number) VALUES('Jiya', 'Malotra', TO_DATE('11/2/2000', 'DD/MM/YYYY'), 'Female', 'jiyamal123@gmail.com', '9814403334')
SELECT 1 FROM dual;


INSERT ALL
    INTO Address (Country, City, Zip_Code) VALUES ('Nepal', 'Kuleshwor, Kathmandu', '44600')
    INTO Address (Country, City, Zip_Code) VALUES ('The USA', 'Louisiania, New Orleans', '70118')
    INTO Address (Country, City, Zip_Code) VALUES ('The UK', 'West Midlands, Wednesbury', 'LE14')
    INTO Address (Country, City, Zip_Code) VALUES ('China', 'Qingdao, Shandong province', '260043')
    INTO Address (Country, City, Zip_Code) VALUES ('Germany', 'Finkenwerder, Hamburg', '20095')
    INTO Address (Country, City, Zip_Code) VALUES ('Italy', 'Narni, Province of Terni', '05035')
    INTO Address (Country, City, Zip_Code) VALUES ('Bangladesh', 'Gulshan, Dhaka', '1212')
    INTO Address (Country, City, Zip_Code) VALUES ('Australia', 'Norwood, Adelaide', '5067')
    INTO Address (Country, City, Zip_Code) VALUES ('Nepal', 'Banepa, Kavre', '45210')
    INTO Address (Country, City, Zip_Code) VALUES ('Venezuela', 'Broad Street West, Somerset', '93143')
    INTO Address (Country, City, Zip_Code) VALUES ('Nepal', 'Sauraha, Chitwan', '44200')
SELECT 1 FROM dual; 

INSERT ALL
    INTO Module(Module_Name, Module_Credit) VALUES ('Data Structure and Algorithm',15) 
    INTO Module(Module_Name, Module_Credit) VALUES ('Fundamentals of Computing',30)
    INTO Module(Module_Name, Module_Credit) VALUES ('Logic and Problem Solving',15)
    INTO Module(Module_Name, Module_Credit) VALUES ('Networks and Operating Systems',15)
    INTO Module(Module_Name, Module_Credit) VALUES ('Advanced Database Systems Development',30)
    INTO Module(Module_Name, Module_Credit) VALUES ('Artificial Intelligence',15)
SELECT 1 FROM dual; 


INSERT ALL 
    INTO Department(Department_Name, Building, Room_Number)VALUES('Student Service','Himalayan Block', 'S10')
    INTO Department(Department_Name, Building, Room_Number)VALUES('Routine And Examination','Golden Gate', 'S15')
    INTO Department(Department_Name, Building, Room_Number)VALUES('Student Counselling','Times Sqaures', 'S20')
    INTO Department(Department_Name, Building, Room_Number)VALUES('Finance','Grand Canyon', 'R10')
    INTO Department(Department_Name, Building, Room_Number)VALUES('External Patnership','High Land', 'H10')
    
SELECT 1 FROM dual;

INSERT ALL
    INTO Assignment_Detail(Assignment_Name, Assigment_Type,Assigment_Weightage)VALUES('Research and Proposal','Individual Coursework',40.00)
    INTO Assignment_Detail(Assignment_Name, Assigment_Type,Assigment_Weightage)VALUES('Practical Experiment','In Class Test',50.00)
    INTO Assignment_Detail(Assignment_Name, Assigment_Type,Assigment_Weightage)VALUES('Practical Exam','Examination',50.00)
    INTO Assignment_Detail(Assignment_Name, Assigment_Type,Assigment_Weightage)VALUES('Practical Coursework and Report','Group Coursework',30.00)
    INTO Assignment_Detail(Assignment_Name, Assigment_Type,Assigment_Weightage)VALUES('Pratical Report','Individual Coursework',50.00)
SELECT 1 FROM dual;

INSERT ALL 
    INTO Assignment_Status(Grade, Status) VALUES('A+', 'Pass')
    INTO Assignment_Status(Grade, Status) VALUES('A', 'Pass')
    INTO Assignment_Status(Grade, Status) VALUES('B+', 'Pass')
    INTO Assignment_Status(Grade, Status) VALUES('B', 'Pass')
    INTO Assignment_Status(Grade, Status) VALUES('C+', 'Pass')
    INTO Assignment_Status(Grade, Status) VALUES('C', 'Pass')
    INTO Assignment_Status(Grade, Status) VALUES('D', 'Pass')
    INTO Assignment_Status(Grade, Status) VALUES('E', 'Pass')
    INTO Assignment_Status(Grade, Status) VALUES('F', 'Fail')
SELECT 1 FROM dual;

COMMIT;


INSERT ALL 
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-1','Per-1')
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-2','Per-1')
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-2','Per-2')
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-3','Per-3')
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-4','Per-4')
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-4','Per-5')
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-5','Per-5')
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-6','Per-6')
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-7','Per-7')
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-8','Per-7')
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-9','Per-8')
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-10','Per-9')
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-11','Per-9')
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-11','Per-10')
    INTO Address_Person(House_ID, Person_ID) VALUES ('Hou-6','Per-20')
SELECT 1 FROM dual;


INSERT ALL
    INTO Teacher(Teacher_ID, Hire_Date, Designation, Salary) VALUES('Per-3', TO_DATE('10/8/2015', 'DD/MM/YYYY'), 'Lecturer', 66000)
    INTO Teacher(Teacher_ID, Hire_Date, Designation, Salary) VALUES('Per-8', TO_DATE('19/9/2017', 'DD/MM/YYYY'), 'Tutor', 49000)
    INTO Teacher(Teacher_ID, Hire_Date, Designation, Salary) VALUES('Per-10', TO_DATE('23/10/2016', 'DD/MM/YYYY'), 'Tutor', 48000)
    INTO Teacher(Teacher_ID, Hire_Date, Designation, Salary) VALUES('Per-11', TO_DATE('2/7/2003', 'DD/MM/YYYY'), 'Module Leader', 95000)
    INTO Teacher(Teacher_ID, Hire_Date, Designation, Salary) VALUES('Per-13', TO_DATE('1/3/2019', 'DD/MM/YYYY'), 'Tutor', 39000)
    INTO Teacher(Teacher_ID, Hire_Date, Designation, Salary) VALUES('Per-15', TO_DATE('18/12/2019', 'DD/MM/YYYY'), 'Lecturer', 69000)
    INTO Teacher(Teacher_ID, Hire_Date, Designation, Salary) VALUES('Per-17', TO_DATE('19/11/2005', 'DD/MM/YYYY'), 'Lecturer', 69000)
    INTO Teacher(Teacher_ID, Hire_Date, Designation, Salary) VALUES('Per-19', TO_DATE('12/10/2002', 'DD/MM/YYYY'), 'Module Leader', 99000)
    INTO Teacher(Teacher_ID, Hire_Date, Designation, Salary) VALUES('Per-21', TO_DATE('23/6/2005', 'DD/MM/YYYY'), 'Lecturer', 79000)
    INTO Teacher(Teacher_ID, Hire_Date, Designation, Salary) VALUES('Per-22', TO_DATE('3/5/2020', 'DD/MM/YYYY'), 'Tutor', 39000)  
SELECT 1 FROM dual;

INSERT ALL 
    INTO Student(Student_ID, Enrolment_Date) VALUES('Per-1',  TO_DATE('20/4/2019', 'DD/MM/YYYY'))
    INTO Student(Student_ID, Enrolment_Date) VALUES('Per-2',  TO_DATE('18/3/2020', 'DD/MM/YYYY'))
    INTO Student(Student_ID, Enrolment_Date) VALUES('Per-4',  TO_DATE('1/2/2021', 'DD/MM/YYYY'))
    INTO Student(Student_ID, Enrolment_Date) VALUES('Per-5',  TO_DATE('2/3/2020', 'DD/MM/YYYY'))
    INTO Student(Student_ID, Enrolment_Date) VALUES('Per-6',  TO_DATE('12/3/2020', 'DD/MM/YYYY'))
    INTO Student(Student_ID, Enrolment_Date) VALUES('Per-7',  TO_DATE('22/4/2020', 'DD/MM/YYYY'))
    INTO Student(Student_ID, Enrolment_Date) VALUES('Per-9',  TO_DATE('29/1/2019', 'DD/MM/YYYY'))
    INTO Student(Student_ID, Enrolment_Date) VALUES('Per-12',  TO_DATE('16/2/2018', 'DD/MM/YYYY'))
    INTO Student(Student_ID, Enrolment_Date) VALUES('Per-14',  TO_DATE('19/4/2019', 'DD/MM/YYYY'))
    INTO Student(Student_ID, Enrolment_Date) VALUES('Per-16',  TO_DATE('11/5/2020', 'DD/MM/YYYY'))
    INTO Student(Student_ID, Enrolment_Date) VALUES('Per-20',  TO_DATE('2/3/2021', 'DD/MM/YYYY'))
    INTO Student(Student_ID, Enrolment_Date) VALUES('Per-22',  TO_DATE('15/4/2018', 'DD/MM/YYYY'))
    INTO Student(Student_ID, Enrolment_Date) VALUES('Per-15',  TO_DATE('11/5/2016', 'DD/MM/YYYY'))  
SELECT 1 FROM dual;

INSERT ALL 
    INTO Module_Teacher(Module_ID, Teacher_ID) VALUES('Mod-1', 'Per-10') 
    INTO Module_Teacher(Module_ID, Teacher_ID) VALUES('Mod-1', 'Per-11')
    INTO Module_Teacher(Module_ID, Teacher_ID) VALUES('Mod-2', 'Per-8')
    INTO Module_Teacher(Module_ID, Teacher_ID) VALUES('Mod-3', 'Per-19')
    INTO Module_Teacher(Module_ID, Teacher_ID) VALUES('Mod-3', 'Per-13')
    INTO Module_Teacher(Module_ID, Teacher_ID) VALUES('Mod-4', 'Per-3')
    INTO Module_Teacher(Module_ID, Teacher_ID) VALUES('Mod-5', 'Per-17')
    INTO Module_Teacher(Module_ID, Teacher_ID) VALUES('Mod-6', 'Per-11')
    INTO Module_Teacher(Module_ID, Teacher_ID) VALUES('Mod-6', 'Per-22')
    INTO Module_Teacher(Module_ID, Teacher_ID) VALUES('Mod-6', 'Per-15')
SELECT 1 FROM dual;


INSERT ALL 
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-1', 'Per-1')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-2', 'Per-1')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-3', 'Per-1')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-1', 'Per-2')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-1', 'Per-4')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-4', 'Per-2')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-5', 'Per-4')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-6', 'Per-5')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-2', 'Per-6')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-3', 'Per-9')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-4', 'Per-12')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-5', 'Per-12')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-1', 'Per-16')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-3', 'Per-16')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-5', 'Per-16')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-6', 'Per-15')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-1', 'Per-12')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-4', 'Per-16')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-6', 'Per-1')
    INTO Module_Student(Module_ID, Student_ID) VALUES('Mod-6', 'Per-2')
SELECT 1 FROM dual;


INSERT ALL 
    INTO Fee_Detail(Student_ID, Department_ID, Fee_Type, Fee_amount, Payment_Type, Payment_Date) VALUES('Per-1', 'Dep-4', 'Semester Fee', 120000, 'Cash', TO_DATE('21/8/2019', 'DD/MM/YYYY'))
    INTO Fee_Detail(Student_ID, Department_ID, Fee_Type, Fee_amount, Payment_Type, Payment_Date) VALUES('Per-1', 'Dep-4', 'University Fee', 150000, 'E-banking', TO_DATE('21/2/2020', 'DD/MM/YYYY'))
    INTO Fee_Detail(Student_ID, Department_ID, Fee_Type, Fee_amount, Payment_Type, Payment_Date) VALUES('Per-2', 'Dep-4', 'Semester Fee', 120000, 'Cash', TO_DATE('13/5/2020', 'DD/MM/YYYY'))
    INTO Fee_Detail(Student_ID, Department_ID, Fee_Type, Fee_amount, Payment_Type, Payment_Date) VALUES('Per-4', 'Dep-4', 'Semester Fee', 120000, 'Cash', TO_DATE('22/8/2021', 'DD/MM/YYYY'))
    INTO Fee_Detail(Student_ID, Department_ID, Fee_Type, Fee_amount, Payment_Type, Payment_Date) VALUES('Per-6', 'Dep-4', 'Semester Fee', 120000, 'Cash', TO_DATE('12/9/2020', 'DD/MM/YYYY'))
    INTO Fee_Detail(Student_ID, Department_ID, Fee_Type, Fee_amount, Payment_Type, Payment_Date) VALUES('Per-6', 'Dep-4', 'University Fee', 150000, 'E-Banking', TO_DATE('19/12/2020', 'DD/MM/YYYY'))
    INTO Fee_Detail(Student_ID, Department_ID, Fee_Type, Fee_amount, Payment_Type, Payment_Date) VALUES('Per-7', 'Dep-4', 'University Fee', 150000, 'Cash', TO_DATE('21/1/2021', 'DD/MM/YYYY'))
    INTO Fee_Detail(Student_ID, Department_ID, Fee_Type, Fee_amount, Payment_Type, Payment_Date) VALUES('Per-9', 'Dep-4', 'Semester Fee', 120000, 'Cash', TO_DATE('17/4/2019', 'DD/MM/YYYY'))
    INTO Fee_Detail(Student_ID, Department_ID, Fee_Type, Fee_amount, Payment_Type, Payment_Date) VALUES('Per-9', 'Dep-4', 'University Fee', 150000, 'Cash', TO_DATE('29/9/2019', 'DD/MM/YYYY'))
    INTO Fee_Detail(Student_ID, Department_ID, Fee_Type, Fee_amount, Payment_Type, Payment_Date) VALUES('Per-12', 'Dep-4', 'Semester Fee', 120000, 'Cash', TO_DATE('11/5/2018', 'DD/MM/YYYY'))
    INTO Fee_Detail(Student_ID, Department_ID, Fee_Type, Fee_amount, Payment_Type, Payment_Date) VALUES('Per-12', 'Dep-4', 'University Fee', 150000, 'E-Banking', TO_DATE('17/10/2018', 'DD/MM/YYYY'))
    INTO Fee_Detail(Student_ID, Department_ID, Fee_Type, Fee_amount, Payment_Type, Payment_Date) VALUES('Per-16', 'Dep-4', 'Semester Fee', 120000, 'Cash', TO_DATE('19/10/2020', 'DD/MM/YYYY'))
    INTO Fee_Detail(Student_ID, Department_ID, Fee_Type, Fee_amount, Payment_Type, Payment_Date) VALUES('Per-20', 'Dep-4', 'Semester Fee', 120000, 'E-Banking', TO_DATE('13/8/2021', 'DD/MM/YYYY'))
    
SELECT 1 FROM dual;

INSERT ALL 
    INTO Marking(Assignment_ID, Student_ID, Module_ID, Department_ID, Grade, Submitted_Date, Due_Date ) VALUES('AS-2', 'Per-1', 'Mod-1', 'Dep-2', 'A', TO_DATE('21/05/2020', 'DD/MM/YYYY'), TO_DATE('21/05/2020', 'DD/MM/YYYY'))
    INTO Marking(Assignment_ID, Student_ID, Module_ID, Department_ID, Grade, Submitted_Date, Due_Date ) VALUES('AS-1', 'Per-1', 'Mod-3', 'Dep-2', 'A', TO_DATE('18/07/2019', 'DD/MM/YYYY'), TO_DATE('25/07/2029', 'DD/MM/YYYY'))
    INTO Marking(Assignment_ID, Student_ID, Module_ID, Department_ID, Grade, Submitted_Date, Due_Date ) VALUES('AS-2', 'Per-4', 'Mod-1', 'Dep-2', 'D', TO_DATE('13/07/2021', 'DD/MM/YYYY'), TO_DATE('13/07/2021', 'DD/MM/YYYY'))
    INTO Marking(Assignment_ID, Student_ID, Module_ID, Department_ID, Grade, Submitted_Date, Due_Date ) VALUES('AS-2', 'Per-6', 'Mod-2', 'Dep-2', 'B', TO_DATE('02/01/2021', 'DD/MM/YYYY'), TO_DATE('02/01/2021', 'DD/MM/YYYY'))
    INTO Marking(Assignment_ID, Student_ID, Module_ID, Department_ID, Grade, Submitted_Date, Due_Date ) VALUES('AS-3', 'Per-9', 'Mod-3', 'Dep-2', 'C', TO_DATE('23/06/2019', 'DD/MM/YYYY'), TO_DATE('23/06/2019', 'DD/MM/YYYY'))
    INTO Marking(Assignment_ID, Student_ID, Module_ID, Department_ID, Grade, Submitted_Date, Due_Date ) VALUES('AS-3', 'Per-12', 'Mod-1', 'Dep-2', 'A+', TO_DATE('19/08/2018', 'DD/MM/YYYY'), TO_DATE('19/08/2018', 'DD/MM/YYYY'))
    INTO Marking(Assignment_ID, Student_ID, Module_ID, Department_ID, Grade, Submitted_Date, Due_Date ) VALUES('AS-3', 'Per-12', 'Mod-5', 'Dep-2', 'C+', TO_DATE('13/02/2019', 'DD/MM/YYYY'), TO_DATE('13/02/2019', 'DD/MM/YYYY'))
    INTO Marking(Assignment_ID, Student_ID, Module_ID, Department_ID, Grade, Submitted_Date, Due_Date ) VALUES('AS-4', 'Per-15', 'Mod-6', 'Dep-2', 'B', TO_DATE('20/04/2017', 'DD/MM/YYYY'), TO_DATE('25/04/2021', 'DD/MM/YYYY'))
    INTO Marking(Assignment_ID, Student_ID, Module_ID, Department_ID, Grade, Submitted_Date, Due_Date ) VALUES('AS-5', 'Per-16', 'Mod-5', 'Dep-2', 'C', TO_DATE('11/08/2020', 'DD/MM/YYYY'), TO_DATE('11/08/2021', 'DD/MM/YYYY'))
    INTO Marking(Assignment_ID, Student_ID, Module_ID, Department_ID, Grade, Submitted_Date, Due_Date ) VALUES('AS-4', 'Per-16', 'Mod-3', 'Dep-2', 'B+', TO_DATE('21/10/2020', 'DD/MM/YYYY'), TO_DATE('21/10/2020', 'DD/MM/YYYY'))
    INTO Marking(Assignment_ID, Student_ID, Module_ID, Department_ID, Grade, Submitted_Date, Due_Date ) VALUES('AS-2', 'Per-16', 'Mod-1', 'Dep-2', 'D', TO_DATE('10/01/2021', 'DD/MM/YYYY'), TO_DATE('10/01/2021', 'DD/MM/YYYY'))
    
SELECT 1 FROM dual;

INSERT ALL 
    INTO Attendance(Student_ID, Total_Days, Attended_Days) VALUES('Per-1',  145, 129)
    INTO Attendance(Student_ID, Total_Days, Attended_Days) VALUES('Per-2',  140, 138)
    INTO Attendance(Student_ID, Total_Days, Attended_Days) VALUES('Per-4',  145, 125)
    INTO Attendance(Student_ID, Total_Days, Attended_Days) VALUES('Per-6',  140, 126)
    INTO Attendance(Student_ID, Total_Days, Attended_Days) VALUES('Per-7',  140, 113)
    INTO Attendance(Student_ID, Total_Days, Attended_Days) VALUES('Per-9',  145, 131)
    INTO Attendance(Student_ID, Total_Days, Attended_Days) VALUES('Per-12',  160, 154)
    INTO Attendance(Student_ID, Total_Days, Attended_Days) VALUES('Per-14',  145, 125)
    INTO Attendance(Student_ID, Total_Days, Attended_Days) VALUES('Per-16',  140, 119)
    INTO Attendance(Student_ID, Total_Days, Attended_Days) VALUES('Per-20',  145, 112)
    INTO Attendance(Student_ID, Total_Days, Attended_Days) VALUES('Per-22',  125, 111)
SELECT 1 FROM dual;



Commit;



DROP TABLE Marking;
DROP TABLE Assignment_detail;
DROP TABLE assignment_status;
DROP TABLE Fee_detail;
DROP TABLE Department;
DROP TABLE Module_Student;
DROP TABLE Module_Teacher;
DROP TABLE Module;
DROP TABLE Attendance;
DROP TABLE Student;
DROP TABLE Teacher;
DROP TABLE Address_person;
DROP TABLE Address;
DROP TABLE Person;

Drop Sequence Person_Sequence;
Drop Sequence Address_Sequence;
Drop Sequence Module_Sequence;
Drop Sequence Department_Sequence;
Drop Sequence Fee_Detail_Sequence;
Drop Sequence Assignment_Detail_Sequence;
Drop Sequence Attendance_Sequence;
