-- use database Sakila and preview the actor table 
use sakila; 
select*from actor; 

-- 1a. Display the first and last name of all actors from table actor 

select 
	first_name as 'Actor First Name',
    last_name as 'Actor Last Name' 
from 
	actor;

-- 1b. Display the first and last name actor in a single column 

select 
	first_name, 
    last_name, 
	concat(first_name, ' ' , last_name) as actor_name
from actor; 

-- 2a. 
select 
	actor_id as 'Actor ID',
    first_name  as 'First Name',
    last_name as 'Last Name' 
from 
	actor 
where 
	first_name = 'Joe'; 

-- 2b. 

select * from actor where last_name like '%GEN%'; 

-- 2c. 

select * from actor where last_name like '%LI%' 
order by last_name, 
			  first_name; 
              
-- 2d. 

show tables; 
select 
	country_id, 
	country
from 
	country 
where 
	country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. 

alter table actor 
add column description blob; 
select * from actor; 

-- 3b. 

alter table actor 
drop column description; 
select * from actor; 

-- 4a. 

select last_name,  count(last_name)
from actor group by last_name; 

-- 4b. (not done yet!) 

select last_name, count(last_name) 
from actor group by last_name; 












-- 4c.
update actor 
set first_name = 'HARPO', last_name = 'WILLIAMS' 
where first_name = 'GROUCHO' and last_name = 'WILLIAMS'; 

-- 4d. 
update actor 
set first_name = 'GROUCHO', last_name = 'WILLIAMS' 
where first_name = 'HARPO' and last_name = 'WILLIAMS'; 

select * from actor;





-- 5.a (not done yet!) 




-- 6.a 

select staff.first_name, staff.last_name, address.address
from staff 
inner join address on address.address_id= staff.address_id;  

-- 6.b 

select staff.first_name, staff.last_name, payment.amount
from staff 
inner join payment on payment.staff_id = staff.staff_id;

select*from payment; 



