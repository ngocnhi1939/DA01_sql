---EX1
Select Distinct replacement_cost
From film
Order By replacement_cost;

---EX2
Select
Case WHEN replacement_cost Between 9.99 And 19.99 Then 'Low'
WHEN replacement_cost Between 20.00 And 24.99 Then 'Medium'
WHEN replacement_cost Between 25.00 And 29.99 Then 'High'
END As replacement_cost_type,
Count(*)
From film
Group By replacement_cost_type;

---EX3
Select a.title, a.length, c.name as category_name
FROM
film As a 
Join film_category as b ON a.film_id=b.film_id
Join category as c On b.category_id=c.category_id
Where c.name In('Drama', 'Sports')
Order By a.length DESC;

---EX4
Select Count(a.title) As title, c.name as category
FROM
film As a 
Join film_category as b ON a.film_id=b.film_id
Join category as c On b.category_id=c.category_id
Group By c.name
Order By title DESC

---EX5
Select a.first_name, a.last_name, COUNT(DISTINCT(c.title)) as movies
FROM actor as a
JOIN film_actor as b On a.actor_id=b.actor_id
JOIN film as c On b.film_id=c.film_id
GROUP By a.first_name, a.last_name
ORDER By movies DESC;

--EX6
select Count(Distinct(a.address_id)) - COUNT(Distinct(b.customer_id))
FROm address as a
LEFT JOIN customer as b ON a.address_id=b.address_id

---EX7
select a.city as city, Sum(d.amount) as total_amount
FROm city as a
JOIN address as b ON a.city_id=b.city_id
JOIN customer as c On b.address_id=c.address_id
JOIN payment as d ON c.customer_id = d.customer_id
GROUP By a.city
ORDER By total_amount DESC

---EX8
select a.city as city, Sum(d.amount) as total_amount
FROm city as a
JOIN address as b ON a.city_id=b.city_id
JOIN customer as c On b.address_id=c.address_id
JOIN payment as d ON c.customer_id = d.customer_id
JOIN country as e ON a.country_id = e.country_id
GROUP By a.city
ORDER By total_amount DESC;
