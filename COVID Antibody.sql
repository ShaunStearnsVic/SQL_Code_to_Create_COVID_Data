create TABLE COVID19_Positivity_Data_from_Clinical_Laboratories
(Name varchar ,
pop int4 ,
desc_ varchar ,
attr_date date ,
metric varchar ,
value numeric ,
rep_date date ,
ObjectIf numeric);

copy COVID19_Positivity_Data_from_Clinical_Laboratories
FROM 'D:\Stats Code\Forecasting\COVID19_Positivity_Data_from_Clinical_Laboratories.csv' HEADER CSV DELIMITER ',';


select metric, desc_, attr_date, value
into Antibody_Tests_Performed
from COVID19_Positivity_Data_from_Clinical_Laboratories  
where desc_ = 'Daily COVID-19 Antibody Test Data From Clinical Laboratories'
and metric = 'Antibody Tests Performed';

alter table Antibody_Tests_Performed
RENAME COLUMN value to Antibody_Tests_Performed;

ALTER TABLE Antibody_Tests_Performed
drop column metric,
drop column desc_;

ALTER TABLE Antibody_Tests_Performed ADD COLUMN id SERIAL PRIMARY key;


select metric, desc_, attr_date, value
into Number_of_positive_tests
from COVID19_Positivity_Data_from_Clinical_Laboratories  
where desc_ = 'Daily COVID-19 Antibody Test Data From Clinical Laboratories'
and metric = 'Number of positive tests';

alter table Number_of_positive_tests
RENAME COLUMN value to Number_of_positive_tests;

ALTER TABLE Number_of_positive_tests
drop column metric,
drop column desc_;

ALTER TABLE Number_of_positive_tests ADD COLUMN id SERIAL PRIMARY key;

select Antibody_tests_performed.id, 
Antibody_tests_performed.attr_date, 
Antibody_tests_performed.antibody_tests_performed,
Number_of_positive_tests.number_of_positive_tests 
into Daily_COVID_Antibody
from Antibody_tests_performed
inner join Number_of_positive_tests on Antibody_tests_performed.id = Number_of_positive_tests.id
order by attr_date;


select *
from daily_covid_antibody;

COPY Daily_COVID_Antibody(attr_date, antibody_tests_performed, number_of_positive_tests) 
TO 'D:\Stats Code\Forecasting\Daily_COVID_Antibody.csv' DELIMITER ',' CSV HEADER;

drop table COVID19_Positivity_Data_from_Clinical_Laboratories;
drop table antibody_tests_performed; 
drop table daily_covid_antibody;
drop table number_of_positive_tests;
