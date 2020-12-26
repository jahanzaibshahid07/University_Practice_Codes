--order by 

select * from propertydata_tbl order by Area 

select * from propertydata_tbl order by Price desc


--group by

select MAX(Area), MIN(Area) from propertydata_tbl

select Location ,MAX(Area), MIN(Area) from propertydata_tbl group by Location

select Location ,MAX(Area), MIN(Area) from propertydata_tbl group by Location order by Location desc

-- Round and Truncate 

select Round(123.613,-1) -- 120.000

select Round(123.613,-2) -- 100.000

select Round(123.613,-3) -- 0.000

select Round(123.613, 1) -- 123.600

select Round(123.693, 1) -- 123.700

select Round(123.653, 1) -- 123.700

select Round(123.613, 2) -- 123.610

select Round(123.695, 2) -- 123.700

select Round(123.657, 2) -- 123.660

-- Equi Join

-- select city, area, name  from gab1, gab2 where snoll == rollno 

-- Cross Join 

select c.name, c.email, c.address, d.party_id  from Citizens as c cross join Candidate as d



-- View and security and hide info

Create View Employee_public AS
select Id, LastName, Address, Email 
from Employee_tbl

select * from Employee_public

