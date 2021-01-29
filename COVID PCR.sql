create TABLE COVID19_Positivity_Data_from_Clinical_Laboratories
(Name varchar ,
pop numeric ,
desc_ varchar ,
attr_date date ,
metric varchar ,
value numeric ,
rep_date date ,
ObjectIf numeric);

copy COVID19_Positivity_Data_from_Clinical_Laboratories
FROM 'D:\Stats Code\Forecasting\COVID19_Positivity_Data_from_Clinical_Laboratories.csv' HEADER CSV DELIMITER ',';


select metric, desc_, attr_date, value
into Nasal_Tests_Performed_State
from COVID19_Positivity_Data_from_Clinical_Laboratories  
where desc_ = 'Daily COVID-19 PCR Test Data From Clinical Laboratories'
and metric = 'People Tested at CDPHE State Lab';

alter table Nasal_Tests_Performed_State
RENAME COLUMN value to Nasal_Tests_Performed_State;

ALTER TABLE Nasal_Tests_Performed_State
drop column metric,
drop column desc_;

ALTER TABLE Nasal_Tests_Performed_State ADD COLUMN id SERIAL PRIMARY key;





select metric, desc_, attr_date, value
into Nasal_Tests_Performed_Nonstate
from COVID19_Positivity_Data_from_Clinical_Laboratories  
where desc_ = 'Daily COVID-19 PCR Test Data From Clinical Laboratories'
and metric = 'People Tested at Non-CDPHE (Commerical) Labs';

alter table Nasal_Tests_Performed_Nonstate
RENAME COLUMN value to Nasal_Tests_Performed_Nonstate;

ALTER TABLE Nasal_Tests_Performed_Nonstate
drop column metric,
drop column desc_;

ALTER TABLE Nasal_Tests_Performed_Nonstate ADD COLUMN id SERIAL PRIMARY key;





select Pop, metric, desc_, attr_date, value
into Percent_Positive
from COVID19_Positivity_Data_from_Clinical_Laboratories  
where desc_ = 'Daily COVID-19 PCR Test Data From Clinical Laboratories'
and metric = 'Percent Positivity';

alter table Percent_Positive
RENAME COLUMN value to Percent_Positive;

ALTER TABLE Percent_Positive
add column Num_Positive numeric,
drop column metric,
drop column desc_;

update Percent_Positive
set Num_Positive = (Percent_Positive*Pop);

ALTER TABLE Percent_Positive ADD COLUMN id SERIAL PRIMARY key;





select Nasal_Tests_Performed_State.id, Nasal_Tests_Performed_State.attr_date, Nasal_Tests_Performed_State.Nasal_Tests_Performed_State, 
Nasal_Tests_Performed_Nonstate.Nasal_Tests_Performed_Nonstate, Percent_Positive.Num_Positive
into Daily_COVID_PCR
from Nasal_Tests_Performed_State
inner join Nasal_Tests_Performed_Nonstate on Nasal_Tests_Performed_State.id = Nasal_Tests_Performed_Nonstate.id
inner join Percent_Positive on Nasal_Tests_Performed_Nonstate.id = Percent_Positive.id
order by attr_date;


select *
from daily_covid_PCR;

COPY Daily_COVID_PCR(attr_date, Num_Positive, Nasal_Tests_Performed_State, Nasal_Tests_Performed_Nonstate) 
TO 'D:\Stats Code\Forecasting\Daily_COVID_Antibody.csv' DELIMITER ',' CSV HEADER;

drop table COVID19_Positivity_Data_from_Clinical_Laboratories;
drop table Nasal_Tests_Performed_State; 
drop table Nasal_Tests_Performed_Nonstate;
drop table Percent_Positive;
drop table daily_covid_PCR;

