-- use database Sakila and preview the actor table 
use sakila; 
select*from actor; 

-- 1a. Display the first and last names of all actors from the table actor

select 
	first_name as 'First Name',
    last_name as 'Last Name' 
from 
	actor;

-- 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column Actor Name

select 
	concat(first_name, ' ' , last_name) as 'Actor Name' 
from actor; 

-- 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information? 

select 
	actor_id as 'Actor ID',
    first_name  as 'First Name',
    last_name as 'Last Name' 
from 
	actor 
where 
	first_name = 'Joe'; 

-- 2b. Find all actors whose last name contain the letters GEN

select * from actor where last_name like '%GEN%'; 

-- 2c. Find all actors whose last names contain the letters LI. This time, order the rows by last name and first name, in that order

select * from actor where last_name like '%LI%' 
order by last_name, 
			  first_name; 
              
-- 2d. Using IN, display the country_id and country columns of the following countries: Afghanistan, Bangladesh, and China:

show tables; 
select 
	country_id, 
	country
from 
	country 
where 
	country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a.You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table actor named description and use the data type BLOB (Make sure to research the type BLOB, as the difference between it and VARCHAR are significant). 

alter table actor 
add column description blob; 
select * from actor; 

-- 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the description column

alter table actor 
drop column description; 
select * from actor; 

-- 4a. List the last names of actors, as well as how many actors have that last name

select last_name,  count(last_name) as 'Total Number' 
from actor group by last_name; 

-- 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

select last_name, count(last_name) as 'Total Number'
from actor group by last_name 
having count(last_name) >= 2; 

-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS. Write a query to fix the record.

update actor 
set first_name = 'HARPO', last_name = 'WILLIAMS' 
where first_name = 'GROUCHO' and last_name = 'WILLIAMS'; 
select*from actor; 

-- 4d. 
update actor 
set first_name = 'GROUCHO', last_name = 'WILLIAMS' 
where first_name = 'HARPO' and last_name = 'WILLIAMS'; 
select * from actor;

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
describe address; 

-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. Use the tables staff and address 

select staff.first_name, staff.last_name, address.address
from staff 
inner join address on address.address_id= staff.address_id;  

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. Use tables staff and payment

select staff.first_name, staff.last_name, sum(payment.amount) as 'Total Amount'
from staff 
inner join payment on payment.staff_id = staff.staff_id 
group by staff.first_name, staff.last_name; 

-- 6c. List each film and the number of actors who are listed for that film. Use tables film_actor and film. Use inner join

select film.title, count(film_actor.film_id) as 'Number of Actors' 
from  film 
inner join film_actor on film.film_id = film_actor.film_id 
group by film.title; 

-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?

select film.title, count(inventory.film_id) as 'Number of Film' 
from  film 
inner join inventory on film.film_id = inventory.film_id 
where film.title = 'Hunchback Impossible'; 

-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. List the customers alphabetically by last name:

select customer.first_name, customer.last_name, sum(payment.amount) as 'Total Amount Paid' 
from customer 
inner join payment on payment.customer_id = customer.customer_id 
group by customer.first_name, customer.last_name
order by last_name asc; 

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. As an unintended consequence, films starting with the letters K and Q have also soared in popularity. Use subqueries to display the titles of movies starting with the letters K and Q whose language is English.
select title 
from film 
where (title like 'K%' or title like 'Q%') and 
			language_id =  
						(select language_id from language where name = 'English');

-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.

select first_name as 'First Name', 
		  last_name as 'Last Name',
          actor_id as 'Actor ID' 
from actor 
where actor_id in
		(select actor_id from film_actor 
				where film_id in 
							(select film_id from film where title = 'Alone Trip'));
                            
-- 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. Use joins to retrieve this information

select customer.first_name, 
		  customer.last_name, 
          customer. email 
from customer 
inner join customer_list on customer.customer_id = customer_list.id 
where customer_list.country = 'Canada'; 

-- 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as family films.

select title, category from film_list where category = 'family'; 

-- 7e. Display the most frequently rented movies in descending order.

select film.title, count(rental.inventory_id) as 'Most Rented Films'
from inventory  
join film on inventory.film_id = film.film_id
join rental on inventory.inventory_id = rental.inventory_id 
group by film.title
order by count(rental.inventory_id) desc;

-- 7f. Write a query to display how much business, in dollars, each store brought in.

select payment.staff_id, sum(payment.amount) 
from payment 
join store on store.manager_staff_id = payment.staff_id
group by payment.staff_id; 

-- 7g. Write a query to display for each store its store ID, city, and country

select store.store_id as 'Store ID', city.city, country.country 
from store 
join address on address.address_id = store.address_id 
join city on address.city_id = city.city_id
join country on city.country_id = country.country_id;

-- 7h. List the top five genres in gross revenue in descending order. (Hint: you may need to use the following tables: category, film_category, inventory, payment, and rental.)

select category.name, sum(payment.amount) as 'Gross Revenue'
from category 
join film_category on category.category_id = film_category.category_id
join inventory on film_category.film_id = inventory.film_id
join rental on rental.inventory_id = inventory.inventory_id 
join payment on rental.rental_id = payment.rental_id 
group by category.name 
order by sum(payment.amount) desc
limit 5;

-- 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.

create view Top5_Genres_by_Revenue as 

select category.name, sum(payment.amount) as 'Gross Revenue'
from category 
join film_category on category.category_id = film_category.category_id
join inventory on film_category.film_id = inventory.film_id
join rental on rental.inventory_id = inventory.inventory_id 
join payment on rental.rental_id = payment.rental_id 
group by category.name 
order by sum(payment.amount) desc
limit 5;

-- 8b. How would you display the view that you created in 8a?

select*from Top5_Genres_by_Revenue;

-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.

drop view Top5_Genres_by_Revenue; 


