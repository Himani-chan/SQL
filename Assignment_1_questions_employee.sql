
# ASSIGNMENT 1

# 1. Calculate total salary of employees
use employees;
select sum(salary) from employee;

# 2. Retrieve details of all employees who draw a salary which is at least 40000.
select * from employee where salary>=40000;

# 3. Retrieve details of all female employees who draw a salary which is at least 40000.
select * from employee where salary>=40000 and sex='f';

# 4. Retrieve details of "Female" employees or employees who draw a salary which is at least 40000.
select * from employee where salary>=40000 or sex='f';

# 5. Retrieve the details of all dependents of essn 333445555.
select * from dependent where essn=333445555;

# 6. Retrieve details of projects that are based out Houston or Stafford
select * from project where plocation in ('Houston','Stafford');

# 7. Retrieve details of projects that are based out Houston or belongs to deptartment 4.
select * from project where plocation in ('Houston','Stafford') or dnum=4;

# 8. Display the name of the department and the year in which the manager was appointed. 
select dname,year(mgr_start_date) from department;

# 9. Display the SSN of all employees who live in Houston 
select * from employee;
desc employee;
#select * from employee where address like '%Houstan%';

# 10. Display employees whose name begins with J
select * from employee where fname like 'J%';

# 11. Display details of all (male employee who earn more than 40000) or (female employees who earn less than 40000)
select * from employee where (sex='M' and salary>40000) or (sex='F' and salary<40000);

# 12. Display the essn of employees who have worked betwen 25 and 50 hours
select essn from works_on where hours between 25 and 50;

# 13. Display the names of the project that are neither based at Houston nor at Stafford.
select * from project;
select pname from project where plocation not in ('Houston','Stafford');

# 14. Display the ssn and full name of all employees.
select ssn,concat(fname,lname) from employee;

# 15. Display the employee details who does not have supervisor
select * from employee where super_ssn is null;

# 16. Display the ssn of employees sorted by their salary in ascending mode 
# Hint: Use ORDER by SALARY
select ssn from employee order by salary asc;

# 17. Sort the works_on table based on Pno and Hours
select * from works_on order by pno asc,hours asc;

# 18. Display the average project hours
select avg(hours) from works_on;

# 19. Display the number of employees who do not have a manager.
select count(fname) from employee where super_ssn is null; 

# 20. What is the average salary of 'Male' employees.
select avg(salary) from employee where sex='M';

# 21. What is the highest salary of female employees.
select max(salary) from employee where sex='F';

# 22. What is the least salary of male employees
select min(salary) from employee where sex='M';

# 23. Display the highest salary among female employees and the least salary among male employees.
select (select max(salary) from employee where sex='F'),(select min(salary) from employee where sex='M');

# 24. Display the average project hours for each project.
select pno,avg(hours) from works_on group by pno;

# 25. Display the number of employees in each department in decreasing order of no. of employees.
select * from employee;
select count(fname),dno from employee group by dno order by count(fname) desc;

# 26. Display the Dno of those departments that has at least 3 employees.
select dno from employee group by dno having count(fname)>=3;

# 27. Among the people who draw at least 30000 salary, what is the department-wise average?
use employees;
select * from employee;
select * from department;
select avg(salary) from employee left join department on employee.dno=department.dnumber where employee.salary>=30000 group by department.dnumber;

# 28. Display department names where employuees draw atleast 30000 salary. Display Avearge salary by department name
select department.dname,avg(salary) from employee left join department on employee.dno=department.dnumber where employee.salary>=30000 group by department.dname;

# 29. Display the fname of employees working in the Research department.
select fname from department left join employee on department.dnumber=employee.dno where department.dname='Research';

# 30. Display names of employees and project names for each of them.
select * from employee;
select * from project;
select concat(fname,' ',lname) as name,project.pname from employee join project on employee.dno=project.dnum;

# 31. Which project(s) have the least number of employees?
select * from project;
select * from employee;
select project.pname,count(fname) as 'TotalEmployees' from employee left join project on employee.dno=project.dnum  group by project.pname order by count(fname) asc limit 1;

# 32. Display the fname and salary of employees whose salary is more than the average salary of all the employees.
select avg(salary) from employee;
select fname,salary from employee where salary>35125.000000; 

# 33. Display the fname of those employees who work for at least 20 hours
select * from works_on;
select * from project join works_on on project.pnumber=works_on.pno;
select employee.fname from ((project join employee on project.dnum=employee.dno) join works_on on project.pnumber=works_on.pno) where works_on.hours>=20;
select fname from ((employee join project on employee.dno=project.dnum) join works_on on project.pnumber=works_on.pno) where works_on.hours>=20;

# 34. Display the ssn, their department, the project they work on and the name of the department which runs that project
# Hint: Needs a 5 table join. Output heading should be: ssn, emp-dept-name, pname, proj-dept-no

# 35. What is the average salary of those employees who have at least one dependent ?
select * from dependent;
select * from works_on join dependent on works_on.essn= dependent.essn;
select * from ((project join works_on on project.pnumber=works_on.pno) join dependent on works_on.essn= dependent.essn);
select avg(salary) from (((employee join project on employee.dno=project.dnum)
join works_on on project.pnumber=works_on.pno) join dependent on works_on.essn= dependent.essn) 
where dependent_name is not null ;
