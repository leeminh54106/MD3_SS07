create database studenttest;
use studenttest;
create table students(
	id int primary key auto_increment,
    name varchar(20),
    age int,
    status bit
);

create table test(
	id int primary key auto_increment,
    name varchar(20)
);

create table student_test(
	student_id int,
    test_id int,
    dates date,
    mark double,
    constraint fk_s01 foreign key (student_id) references students(id),
    constraint fk_s02 foreign key (test_id) references test(id)
);

-- insert 
insert into students(name,age,status) values
('Nguyen Hong Ha',20,1),('Truong Ngoc Anh',30,1),
('Tuan Minh',25,1),('Dan Truong',22,1);

insert into test(name) values('EPC'),('DWMX'),('SQL1'),('SQL2');

insert into student_test(student_id,test_id,dates,mark)
values
(1,1,str_to_date('7/17/2006','%c/%d/%Y'),8),
(1,2,str_to_date('7/18/2006','%c/%d/%Y'),5),
(1,3,str_to_date('7/19/2006','%c/%d/%Y'),7),
(2,1,str_to_date('7/17/2006','%c/%d/%Y'),7),
(2,2,str_to_date('7/18/2006','%c/%d/%Y'),4),
(2,3,str_to_date('7/19/2006','%c/%d/%Y'),2),
(3,1,str_to_date('7/17/2006','%c/%d/%Y'),10),
(3,3,str_to_date('7/18/2006','%c/%d/%Y'),1);

-- alter de sua
alter table students modify age int check(age>14 AND age < 56);
alter table student_test modify mark double default 0;
alter table student_test ADD primary key(student_id,test_id);
alter table test modify name varchar(20) unique;
alter table test drop index name;

# hoc vien da tham gia
select s.name as'Student Name', t.name as 'Test Name', st.mark as'Mark',st.dates as'Date' from students as s 
join student_test as st on s.id = st.student_id
join test as t on t.id = st.test_id;

-- hoc vien chua thi mon nao
select * from students where id not in (select distinct student_id from student_test);

-- hoc vien thi lai, ten mon, diem (< 5)
select s.name as 'Student Name', t.name as 'Test Name', st.mark as'Mark',st.dates as'Date' from students as s 
join student_test as st on s.id = st.student_id
join test as t on t.id = st.test_id
where st.mark <5;

-- hoc vien, diem trung binh, cac mon thi
select s.name as 'StudentName', AVG(st.mark) as 'Average' from students as s
join student_test as st on s.id = st.student_id
group by st.student_id order by Average desc;

-- hoc vien co diem trung binh lon nhat
select s.name as 'Studen tName', AVG(st.mark) as 'Average' from students as s
inner join student_test as st on s.id = st.student_id
group by st.student_id order by Average desc limit 1;

-- diem cao nhat, asc
select t.name as 'Test Name', mp.Mark from test as t
join (select test_id,Max(mark) as Mark from student_test group by test_id) as mp
on t.id = mp.test_id order by t.name asc;

-- hoc vien va diem thi, chua thi de null
select s.name as 'Student Name', t.name as 'Test Name' from students as s 
left join student_test as st on s.id = st.student_id
left join test as t on t.id = st.test_id;

-- hoc vien age + 1
update students set age = age + 1;

-- <30 young > old
alter table students modify status varchar(10);
update students set status = CASE 
WHEN age < 30 then 'Young'
else 'Old'
END;

-- hoc vien va diem thi
select s.name as'Student Name', t.name as 'Test Name', st.mark as'Mark',st.dates as'Date' from students as s 
inner join student_test as st on s.id = st.student_id
inner join test as t on t.id = st.test_id order by st.dates asc;

-- Hiển thị thông tin sinh viên có tên bắt đầu bằng ký tự 'T' và điểm thi trung bình > 4.5
select s.name as'Student Name', s.age as 'Tuổi', AVG(mark) as 'Average' from students as s 
inner join student_test as st on s.id = st.student_id
group by st.student_id
having s.name LIKE 'T%' AND Average > 4.5;	

-- thong tin, dem trung binh, no 1
select s.name as 'StudentName', AVG(st.mark) as 'Average', RANK() OVER (ORDER BY AVG(st.mark) DESC) AS ranking from students as s
inner join student_test as st on s.id = st.student_id
group by st.student_id order by ranking;


alter table students modify name varchar(255);


UPDATE students 
SET 
    name = CASE
        WHEN age > 20 THEN CONCAT('Old', ' ', name)
        ELSE CONCAT('Young', ' ', name)
    END;


delete from test where id NOT IN (select distinct test_id from student_test);


DELETE from student_test where mark < 5;