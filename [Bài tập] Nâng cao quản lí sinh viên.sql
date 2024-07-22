CREATE DATABASE test2;
use test2;
create table subjects(
	subject_id int auto_increment primary key,
    subject_name nvarchar(50)
);
create table students(
	student_id int primary key auto_increment,
    student_name nvarchar(50),
    age int(4),
    email varchar(100)
);

create table marks(
	mark int,
    subject_id int,
    FOREIGN KEY (subject_id) references subjects(subject_id),
    student_id int,
    foreign key(student_id) references students(student_id)
);

create table classes(
	class_id int primary key auto_increment,
    class_name nvarchar(50)
);

create table class_student(
	student_id int,
    foreign key(student_id) references students(student_id),
    class_id int,
    foreign key(class_id) references classes(class_id)
);

insert into students(student_name,age,email) values
('nguyen quang an',18,'an@gmail.com'),
('Nguyen cong vinh',20,'vinh@gmail.com'),
('nguyen van quang',19,'quyen'),
('pham thanh binh',25,'binh@com'),
('Nguyen van tai em',30,'taiem@gmail.com');

insert into classes(class_name) values ('C0706L'),('C0708G');

insert into class_student(student_id,class_id) values
(1,1),(2,1),(3,2),(4,2),(5,2);

insert into subjects(subject_name) values
('SQL'),('Java'),('C'),('Visual Basic');

insert into marks(mark,subject_id,student_id) values
(8,1,1),(4,2,1),(9,1,1),(7,1,3),(3,1,4),(5,2,5),(8,3,3),(1,3,5),(3,2,4);

-- Hien thi danh sach tat ca cac hoc vien
SELECT * FROM students;

-- Hiển thị danh sách tất cả môn học
SELECT * FROM subjects;

-- Tính điểm trung bình theo từng học viên
SELECT s.student_name,AVG(mark) as diemtrungbinh from marks as m
join students as s on m.student_id = s.student_id
group by m.student_id;

-- Hiển thị môn học có học sinh thi được điểm cao nhất
select s.subject_name,m.mark from marks as m
join subjects as s on m.subject_id = s.subject_id
where mark = (select MAX(mark) from marks);

-- Đánh số thứ tự của điểm theo chiều giảm
SELECT mark from marks order by mark desc;

-- Thay đổi kiểu dữ liệu của cột SubjectName trong bang subjects thanh 7
alter table subjects modify column subject_name varchar(7);

-- Cap nhat them dong chu « Day la mon hoc « vao truoc cac ban ghi tren cot SubjectName trong bang Subjects
UPDATE subjects set subject_name = concat('Đây là môn học ',subject_name);

-- Viet Check Constraint de kiem tra do tuoi nhap vao trong bang Student yeu cau Age >15 va Age < 50
Alter table students modify column age int check (age >15 AND age < 50);

-- Loai bo tat ca quan he giua cac bang
alter table marks DROP foreign key fk_m1;
alter table marks DROP foreign key fk_m2;
alter table class_student DROP foreign key fk_s1;
alter table class_student DROP foreign key fk_s2;

-- Xoa hoc vien co StudentID la 1
delete from students where student_id = 1;

-- Trong bang Student them mot column Status co kieu du lieu la Bit va co gia tri Default la 1
alter table students add column status bit default(1);

-- Cap nhap gia tri Status trong bang Student thanh 0
update students set status = 0;