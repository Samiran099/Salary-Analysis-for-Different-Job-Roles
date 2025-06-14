/*Import data*/
Proc import datafile='/home/u62771252/Data Science Job Salaries.csv' out=sal dbms=csv;
run;

/* check for missing values*/
data missval;
set sal;
if cmiss(of _all_)>0;
run;

/* check for duplicates*/
proc sort data=sal out=salsort nodup dupout=dup;
by work_year;
run;

/* Drop unwanted column*/
Data Sal1;
set salsort (drop=VAR1);
format salary_in_usd dollar10.;
run;

/*Condition formating for columns*/
proc sql;
create table sal2 as
select * ,
     case 
      when remote_ratio=0 then 'Regular' 
      when remote_ratio=50 then 'Hybrid'
      else 'Remote' 
     end as work_type,
     
     case experience_level
     when 'EN' then 'Entry'
     when 'MI' then 'Mid'
     when 'SE' then 'Senior'
     else 'Executive' end as Exp_Level,
     
     case employment_type
     when 'FL' then 'Freelance'
     when 'FT' then 'Full time'
     when 'PT' then 'Part time'
     else 'Contract' end as Emp_Type,  
 
     
     case company_size
     when 'S' then 'Small'
     when 'M' then 'Medium'
     else 'Large' end as Org_Size

     from work.sal1;
quit;



/* Final dataset*/
proc sql;
create table Fsal as
select work_year,Job_title,work_type,Exp_Level,Emp_Type,employee_residence,Org_Size,company_location,salary_in_usd, 
salary_currency,salary from Sal2;
quit;


/* Highest salary earning employee*/
proc sql;
select * from fsal order by salary_in_usd desc ;
quit;

/* export dataset*/
proc export outfile="/home/u62771252/practiceData scientist salaries.xlsx" data=fsal dbms=xlsx;
sheet='salarydata';
run;





