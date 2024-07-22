create database qlbh;
use qlbh;

create table customer(
	id int primary key auto_increment,
    name varchar(25),
    age int
);

create table orders(
	id int primary key auto_increment,
    c_id int,
    o_date date,
    total_price int,
    constraint fk_o1 foreign key(c_id) references customer(id)
);

create table product (
	id int primary key auto_increment,
    name varchar(25),
    price int
);

create table order_detail(
	orders_id int,
    product_id int,
    quantity int,
    constraint fk_od1 foreign key(orders_id) references orders(id),
    constraint fk_od2 foreign key(product_id) references product(id)
);


insert into customer(name,age) values
('Minh Quan',10),
('Ngoc Oanh',20),
('Hong Ha',50);

insert into orders(c_id,o_date) values
(1,str_to_date('3/21/2006','%c/%d/%Y')),
(2,str_to_date('3/23/2006','%c/%d/%Y')),
(1,str_to_date('3/16/2006','%c/%d/%Y'));

insert into product(name,price) values
('May Giat',3),('Tu Lanh',5),
('Dieu Hoa',7),('Quat',1),('Bep Dien',2);

insert into order_detail(orders_id,product_id,quantity) values
(1,1,3),(1,3,7),(1,4,2),(2,1,1),(3,1,8),(2,5,4),(2,3,3);

select od.orders_id , od.product_id , o.o_date, o.total_price from orders as o 
inner join order_detail as od on o.id = od.orders_id
order by o.o_date desc;

select name ,price from product where price = (select Max(price) from product);

select c.name , p.name  from customer as c 
join orders as o on c.id = o.c_id
join order_detail as od on o.id = od.orders_id
join product as p on p.id = od.product_id;

select name from customer where id NOT IN (select distinct c_id from orders);

select o.id, o.o_date, od.quantity, p.name, p.price from orders as o 
join order_detail as od on o.id = od.orders_id
join product as p on p.id = od.product_id;

select o.id , o.o_date,Sum(od.quantity * p.price) as total from orders as o 
join order_detail as od on o.id = od.orders_id
join product as p on p.id = od.product_id
group by o.id;

CREATE VIEW sales AS
SELECT SUM(total) as sales from 
(select o.id , o.o_date ,Sum(od.quantity * p.price) as total from orders as o 
join order_detail as od on o.id = od.orders_id
join product as p on p.id = od.product_id
group by o.id) as total_price;

alter table orders drop foreign key fk_o1;
alter table order_detail drop foreign key fk_od1;
alter table order_detail drop foreign key fk_od2;
ALTER TABLE customer
MODIFY COLUMN id INT;
ALTER TABLE customer
DROP PRIMARY KEY;
ALTER TABLE orders
MODIFY COLUMN id INT;
ALTER TABLE orders
DROP PRIMARY KEY;
ALTER TABLE product
MODIFY COLUMN id INT;
ALTER TABLE product
DROP PRIMARY KEY;

delimiter //

create trigger cusUpdate
before update on customer
for each row
begin
	update orders set c_id = new.id where c_id = old.id;
end//
delimiter ;
update customer set id = 4 where id =1;
select * from orders

delimiter //
create procedure delProduct (IN product_name varchar(20))
begin
	IF not exists ( select * from product where name = product_name)
    then signal sqlstate '45000' set message_text = 'Cant find this product name';
    else
		delete from order_detail where product_id = (select id from product where name = product_name);
		delete from product where name = product_name;
	end if;
end //
delimiter ;