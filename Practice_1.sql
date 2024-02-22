---EX1
SELECT NAME FROM CITY WHERE Countrycode = 'USA' AND Population > 120000;
---EX2
SELECT * FROM CITY WHERE Countrycode = 'JPN';
---EX3 
SELECT CITY, STATE FROM STATION;
---EX4 
SELECT DISTINCT CITY FROM STATION WHERE CITY LIKE 'A%' OR CITY LIKE 'E%' OR CITY LIKE 'I%' OR CITY LIKE 'O%' OR CITY LIKE 'U%';
---EX5 
SELECT DISTINCT CITY FROM STATION WHERE CITY LIKE '%a' OR CITY LIKE '%e' OR CITY LIKE '%i' OR CITY LIKE '%o' OR CITY LIKE '%u';
---EX6
SELECT DISTINCT CITY FROM STATION WHERE CITY NOT LIKE 'A%' AND CITY NOT LIKE 'E%' AND CITY NOT LIKE 'I%' AND CITY NOT LIKE 'O%' AND CITY NOT LIKE 'U%';
---EX7
SELECT name FROM Employee ORDER BY name ASC;
---EX8
/SELECT name FROM Employee WHERE salary > 2000 and months < 10;
---EX9
SELECT product_id FROM Products WHERE low_fats = 'Y' AND recyclable = "Y";
---EX10
SELECT name FROM Customer WHERE referee_id IS NULL OR referee_id <> 2;
---EX11
SELECT name, population, area FROM World WHERE area >= 3000000 OR population >= 25000000;
---EX12
SELECT DISTINCT author_id AS id FROM Views WHERE author_id = viewer_id ORDER BY author_id;
---EX13
SELECT part, assembly_step FROM parts_assembly WHERE finish_date is NULL;
---EX14
SELECT * FROM lyft_drivers WHERE yearly_salary <= 30000 OR yearly_salary >= 70000;
---EX15
SELECT advertising_channel FROM uber_advertising WHERE money_spent > 100000;
