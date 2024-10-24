CREATE DATABASE IF NOT EXISTS student_performance;

USE student_performance;

DROP TABLE IF EXISTS school;
DROP TABLE IF EXISTS performance;
DROP TABLE IF EXISTS geography;
DROP TABLE IF EXISTS family;
DROP TABLE IF EXISTS students;


CREATE TABLE IF NOT EXISTS students(
	student_id INT AUTO_INCREMENT PRIMARY KEY,
    sex CHAR(1),
    age INT,
    reason VARCHAR(30),
    guardian VARCHAR(8),
    studytime INT,
    failures INT,
    schoolsup CHAR(3),
    higher CHAR(3),
    romantic CHAR(3),
    free_time int,
    gouout int,
    dalc int,
    walc int,
    health int);


CREATE TABLE IF NOT EXISTS school (
		student_ID int auto_increment,
        school_name char(2),
        activities varchar(3),
        FOREIGN KEY (student_id) references students(student_id));


CREATE TABLE IF NOT EXISTS performance (
		student_ID int auto_increment,
        absences_m int,
        g1_m float,
        g2_m float,
        g3_m float,
        absences_p int,
        g1_p float,
        g2_p float,
        g3_p float,
        FOREIGN KEY (student_id) references students(student_id));

select * from performance;


CREATE TABLE IF NOT EXISTS geography (
		student_ID int auto_increment,
        traveltime int,
        address char(1),
        FOREIGN KEY (student_id) references students(student_id));
        

CREATE TABLE IF NOT EXISTS family (
		student_ID int auto_increment,
        fam_size char(3),
        parent_status char(1),
        mother_edu int,
        father_edu int,
        mother_job varchar(10),
        father_job varchar(10),
        family_sup char(3),
        extra_paid char(3),
        internet char(3),
        rel_quality int,
        FOREIGN KEY (student_id) references students(student_id));
      
      
SELECT  school_name , sex, COUNT(*) AS num_students
FROM students
inner join school
on students.student_id = school.student_ID

GROUP BY school_name,sex;
         
###Students in Relationships by School       
        
SELECT  school_name , sex, COUNT(*) AS num_students_in_relationships
FROM students
inner join school
on students.student_id = school.student_ID
WHERE romantic = 'yes'
GROUP BY school_name,sex;


Select school_name, sex, round(AVG(Nullif(p.G3_m,0)),1) AS avg_math,round(AVG(Nullif(p.G3_p,0)) ,1)AS avg_portuguese
from performance p 
inner join ( 
			SELECT sex, school_name ,name_school.student_Id
				from students st
				inner join (Select school_name ,student_id
							from school sc) name_school 
				on st.student_ID= name_school.student_ID) sx_sch
on p.student_id = sx_sch.student_id
group by school_name, sex;
            
select school_name, sex, round(AVG(Nullif(p.G3_m,0)),1) AS avg_math_nodate, round(AVG(Nullif(p.G3_p,0)) ,1)AS avg_portuguese_nodate
from performance p 
inner join ( 
			SELECT sex, school_name ,name_school.student_Id
				from students st
				inner join (Select school_name ,student_id
							from school sc) name_school 
				on st.student_ID= name_school.student_ID
                where st.romantic = 'no'
			) sx_sch
on p.student_id = sx_sch.student_id
group by school_name, sex;

select school_name, sex, round(AVG(Nullif(p.G3_m,0)),1) AS avg_math_dating, round(AVG(Nullif(p.G3_p,0)) ,1)AS avg_portuguese_dating
from performance p 
inner join ( 
			SELECT sex, school_name ,name_school.student_Id
				from students st
				inner join (Select school_name ,student_id
							from school sc) name_school 
				on st.student_ID= name_school.student_ID
                where st.romantic = 'yes'
			) sx_sch
on p.student_id = sx_sch.student_id
group by school_name, sex;


#Reasons for Choosing School by School
SELECT school, reason, COUNT(*) AS num_students
FROM students
GROUP BY school, reason
order by school;

#Among students in a romantic relationship, which gender is more represented?

#Alcohol Consumption and Health Status Impact on Performance 

#Workday Alcohol Consumption

SELECT s.Dalc,round( AVG(nullif (p.G3_m,0)),1) AS avg_final_grade_math, round(AVG(nullif(p.G3_p,0)),1) AS avg_final_grade_portuguese
FROM students s
JOIN performance p ON s.student_id = p.student_id
GROUP BY s.Dalc
ORDER BY DALC;


#Health Status

SELECT s.health, round( AVG(nullif(p.G3_m,0)),1) AS avg_final_grade_math, round(AVG(nullif(p.G3_p,0)),1) AS avg_final_grade_portuguese
FROM students s
JOIN performance p ON s.student_id = p.student_id
GROUP BY s.health
order by health desc;

select * from performance;

#GEOGRAPHICAL DATA
#travel time vs performance
SELECT traveltime, AVG(G3) AS avg_final_grade
FROM student_performance
GROUP BY traveltime;

#grades by location, internet access, and family size
SELECT address, internet, famsize, AVG(G3) AS avg_final_grade
FROM student_performance
GROUP BY address, internet, famsize;

SELECT s.school, AVG(s.freetime) AS avg_free_time
FROM students s
GROUP BY s.school;

select s.school_name, round( AVG(nullif(p.G3_m,0)),1) AS avg_math,round(AVG(nullif(p.G3_p,0)),1) AS avg_portuguese
from school s
inner join performance p
on s.student_ID = p.student_ID
group by s.school_name;
    
    select max(g3_m) from performance;
    
    -- Math
SELECT  f.mother_job, round( AVG(nullif(p.G3_m,0)),1) AS avg_final_grade_math,round(AVG(nullif(p.G3_p,0)),1) AS avg_final_grade_portuguese
FROM family f
JOIN performance p ON f.student_id = p.student_id
GROUP BY  f.mother_job;

SELECT  f.father_job, round( AVG(nullif(p.G3_m,0)),1) AS avg_final_grade_math,round(AVG(nullif(p.G3_p,0)),1) AS avg_final_grade_portuguese
FROM family f
JOIN performance p ON f.student_id = p.student_id
GROUP BY  f.father_job;


select * from geography;
#travel time vs performance
-- Math
SELECT g.traveltime , round(AVG(nullif(p.G3_m,0)),1) AS avg_final_grade_math,round(AVG(nullif(p.G3_p,0)),1) AS avg_final_grade_portuguese
FROM geography g
JOIN performance p ON g.student_ID = p.student_id
GROUP BY g.traveltime
order by traveltime;


select count(distinct schoolsup)
from students;


select school,schoolsup,sum( failures) as failed_in_past
from students
group by school,schoolsup;

select avg(g3_m) from performance;

select s.school_name, round( AVG(nullif(p.G3_m,0)),1) AS avg_math,round(AVG(nullif(p.G3_p,0)),1) AS avg_portuguese
from school s
inner join performance p
on s.student_ID = p.student_ID
group by s.school_name;

SELECT age, COUNT(*) AS number_of_students
FROM students
GROUP BY age
ORDER BY age;


SELECT shoolsup, sum(failures);

SELECT 
    student_id, 
    (Dalc + Walc) / 2 AS average_alcohol_consumption,
    health
FROM 
    students;
SELECT 
    health AS health_status,
    avg(Dalc + Walc) AS total_alcohol_consumption,
    count
    FROM 
    students
GROUP BY 
    health
ORDER BY 
    health;
    
    
SELECT school, age, round(AVG(Dalc) ,1) AS average_alcohol_consumption_days
FROM students
GROUP BY school,  age
order by age;

SELECT * from performance;