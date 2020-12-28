---- DDL Commands --------

create table Employee --create new table 
(
	Empid int,
	Empname char(10),
	Empsalary money,
	Empage tinyint,
);

sp_help EmployeeDB --used to show structure of schema

select * from Employee;

alter table dbo.EmployeeDB alter column Empname varchar(50);  --alter col datatype

alter table EmployeeDB add Empaddress varchar(50) --add new col in existing table

sp_rename 'Employee.Empname','Empnfirstame' --change the name of existing col

sp_rename 'Employee','EmployeeDB' --change the name of existing table

alter table EmployeeDB drop column Empaddress --delete the table col

truncate table EmployeeDB --delete all the rows in the table 

drop table EmployeeDB --delete the schema of table 


---- DML Commands --------

Insert into Employee values(1,'jahanzaib',30000,24); -- allowed into is optional in sql server

Insert into Employee(Empid,Empname,Empage) values(1,'jahanzaib',24); -- allowed

Insert Employee values(2,'talal',20000,23); -- allowed

select * from Employee 

update Employee set Empsalary = 25000 where Empid = 2 -- where is optional 

update Employee set Empsalary = 20000 where Empsalary is null -- is used with null keyword

delete from Employee where Empid = 1


---- Identity function -----

create table Student 
(
	Sid int identity,
	Same char(10),
	Ssalary money,
	Sage tinyint,
);

select * from Student

Insert into Student values('jahanzaib',30000,24); -- allowed into is optional in sql server
Insert into Student values('jahanzaib',30000,24); -- allowed into is optional in sql server
Insert into Student values('jahanzaib',30000,24); -- allowed into is optional in sql server
Insert into Student values('jahanzaib',30000,24); -- allowed into is optional in sql server


---- Primary key and Forign key -----

create table Department -- parent table
(
	Did int primary key,
	Dname varchar(50),
	Dlocation varchar(50)
);

insert Department values(1,'HR','karachi');
insert Department values(2,'SAP','Lahore');
insert Department values(3,'IT','Islamabad');
insert Department values(4,'SQA','Pindi');
 
create table Employees -- child table can access all property of parent tables
(
	Eid int primary key,
	Ename varchar(50),
	Esalary money,
	Did int foreign key references Department(Did) -- both tables have common col and same datatypes
);

insert Employees values(10,'jahanzaib',25000,1);
insert Employees values(20,'Talal',20000,2);
insert Employees values(30,'Saad',15000,3);
insert Employees values(40,'Ayesha',30000,1);
insert Employees values(50,'Zeehsan',15000,1);
insert Employees values(60,'Ali',20000,3);

select * from Department
select * from Employees


---- Ansi Commands -----

select * from Department Inner Join Employees ON Department.Did = Employees.Did

select * from Department Left Join Employees ON Department.Did = Employees.Did

select * from Department Right Join Employees ON Department.Did = Employees.Did

select * from Department Full Join Employees ON Department.Did = Employees.Did

select * from Department Cross Join Employees

---- NON Ansi Commands -----


select * from Employees, Department where Employees.Did = Department.Did -- Equi Join have = operator

select * from Employees, Department where Employees.Did > Department.Did --Non Equi Join have all operator except = operator

select e1.Eid,e1.Ename,e1.Esalary,e1.Did from Employees as e1, Employees as e2 
where e1.Esalary = e2.Esalary and e2.Ename = 'Talal'  --This is called Self Joined apply on Single Table


---- Where and Having Clauses -----

create table Emp --create new table 
(
	Empid int,
	Empname nvarchar(50),
	Job nvarchar(50),
	Empsalary money,
	Deptno int,
);

insert Emp values(1,'jahanzaib','it',25000,1);
insert Emp values(2,'Talal','hr',20000,2);
insert Emp values(3,'Saad','sales',15000,3);
insert Emp values(4,'Ayesha','hr',30000,2);
insert Emp values(5,'Zeehsan','marketing',15000,5);
insert Emp values(6,'Ali','manager',20000,4);
insert Emp values(7,'Aiman','it',15000,1);
insert Emp values(8,'Neha','sales',20000,3);


select * from Emp


select Job,count(*) as Numofemp from Emp group by job -- no of people in one dept

select job,sum(Empsalary) as Totalsalary from Emp group by job -- sum of salary of every dept 

select job, sum(Empsalary) as Totalsalary,
 max(Empsalary) as maxsal, 
 min(Empsalary) as minsal 
 from Emp group by job


select  Job, count(*) as Numofemp, Deptno from Emp group by Job, Deptno  -- group by multipe column


select Job, count(*) as Numofemp from Emp group by Job having count(*) >= 2 -- havinf clause is used to filter data after group the data


---- Transaction Control langauge -----

create table Branch --create new table 
(
	Bid int,
	Bname nvarchar(50),
	Blocation nvarchar(50),
);

select * from Branch  -- by default DML operations are commit and cannot deleted

begin transaction
insert Branch values(1,'Jahanzaib','Karachi')  -- begin transaction is used for user can cancel transaction as needed

begin transaction
insert Branch values(1,'Jahanzaib','Karachi') -- commit is used for used cannot cancel transaction as needed
commit

begin transaction
rollback


---- Rollup and Cube Functions -----

select Job, count(*) as numofemp from Emp group by rollup(Job) -- Rollup is used for sub and grand total for single col after group

select Job, count(*) as numofemp from Emp group by cube(Job)  -- Cube is used for sub and grand total for multiple col after group

select Job, count(*) as numofemp, Deptno from Emp group by rollup(Job,Deptno) 

select Job,count(*) as numofemp, Deptno from Emp group by cube(Job,Deptno)


---- Stored Functions ----- its only perform on select command DRL return value is must

-- 1) Table valued functions return multiple value and mulitple col value 

CREATE FUNCTION TVF1(@Job varchar(50))
returns table
as
return(select * from Emp where Job = @Job)


select * from TVF1('it');  -- calling Table value functions

-- 2) Scalar valued functions return single value and single col value 


Create Function F_GROSSSAL(@Empid int)
returns money
as
begin
Declare @Basic money, @Hra money, @Pr money, @Da money, @Gross money
select @Basic=Empsalary from Emp where Empid = @Empid
set @Hra = @Basic * 0.1
set @Da = @Basic * 0.2
set @Pr = @Basic * 0.1
set @Gross = @Basic + @Hra + @Da + @Pr
return @Gross
end


select dbo.F_GROSSSAL(4) -- calling scalar valued functions 


---- Stored Procedure ----- its only perform on DDL command return value is not must

Create Procedure GrossSalary( 
	@Empid int, 
	@PF int out, 
	@PT int out
)
As
Begin
Declare @Sal money
Select @Sal = Empsalary from Emp where Empid = @Empid
Set @PF = @Sal * 0.1
Set @PT = @Sal * 0.2
End

-- for return we use out parameters

Declare @newPF int, @newPT int 
Execute GrossSalary 1, @newPF out, @newPT out
Print 'P Fund : ' + Cast(@newPF as varchar)
Print 'P Tax : ' + Cast(@newPT as varchar)


---- Views in SQL ----- is used to hide sensitive data 

-- Simple Views -- operation can perform on single table and all DML operation can perform on simple view

create view V1 as select * from Emp

insert V1 values(9,'wali','hr',35000,2) 

update V1 set Empname = 'jahanzeb' where Empid = 1

insert V1 values(9,'wali','hr',35000,2) 

delete from V1 where Empid = 4 

select * from V1


-- Complex Views -- operation can perform on multiple table and not all DML operation can perform on complex view

create view C1 as
select * from EmpKhi
union
select * from EmpLhr


insert C1 values(9,'wali',35000) 
update C1 set name = 'jahanzeb' where id = 1 -- these operations are not perform on complex view
delete from C1 where id = 3 

select * from C1


-------- Cursors ------- it is temp memory allocate by user to perform DML operations

declare c1 cursor scroll for select * from Emp
open c1
fetch first from c1
fetch next from c1
fetch last from c1
fetch prior from c1
fetch absolute 5 from c1 
fetch relative -2 from c1
close c1
deallocate c1 


declare c1 cursor scroll for select Empname,Empsalary from Emp
declare @name varchar(20), @esal money 
open c1
fetch first from c1 into @name, @esal
print 'name : ' + @name + ' salary : ' + cast(@esal as varchar(20))
fetch next from c1 into @name, @esal
print 'name : ' + @name + ' salary : ' + cast(@esal as varchar(20))
fetch last from c1 into @name, @esal
print 'name : ' + @name + ' salary : ' + cast(@esal as varchar(20))
fetch prior from c1 into @name, @esal
print 'name : ' + @name + ' salary : ' + cast(@esal as varchar(20))
fetch absolute 5 from c1 into @name, @esal
print 'name : ' + @name + ' salary : ' + cast(@esal as varchar(20))
fetch relative -2 from c1 into @name, @esal
print 'name : ' + @name + ' salary : ' + cast(@esal as varchar(20))
close c1
deallocate c1 