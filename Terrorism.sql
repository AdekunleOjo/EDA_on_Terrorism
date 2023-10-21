 select * from terrorism

--Data cleaning

--deleted columns
alter table dbo.terrorism 
drop column extended
alter table dbo.terrorism 
drop column nkillter, INT_MISC, INT_LOG, INT_ANY
alter table dbo.terrorism 
drop column corp1
--renaming column name
use customer
exec sp_rename
'terrorism.targtype1',
'TargetType'

--replacing value
 update terrorism
 set success = REPLACE(success, '0', 'No')

 select success from terrorism
 where ISNUMERIC(success) = 0;
update terrorism
set success = cast(replace(success, ',', '') as float)
where isnumeric(replace(success, ',', '')) = 1


--Data Analysis and problem solution

--Top 10 countries and cities by casuality
select country_txt, city, sum(total_casualties) as total_casualities
from terrorism
group by country_txt, city
order by total_casualities desc

--region affected by casuality
select region_txt, sum(total_casualties) as total_casualties
from terrorism
group by region_txt
order by total_casualties desc

--suicide commited by region
select region_txt, sum(suicide) as Total_suicide 
from dbo.terrorism
group by region_txt
order by Total_suicide desc

--suicide commited by country and city
select country_txt, city, sum(suicide) as Total_suicide 
from dbo.terrorism
where suicide > 0
group by city, country_txt
order by Total_suicide desc


---Targettype by Total target
select targtype1_txt, sum(TargetType) as Total_target from dbo.terrorism
group by targtype1_txt
order by Total_target desc

select * from dbo.terrorism

---attacktype by number of which the attack is carried out
select attacktype1_txt, count(attacktype1_txt) as number_of_attacks from dbo.terrorism 
group by attacktype1_txt
order by number_of_attacks desc

---total_target by sub-saharan Africa region and Country
select region_txt, country_txt, attacktype1_txt, count(TargetType) as numbers_of_targets from dbo.terrorism
where region_txt = 'Sub-saharan Africa'
group by attacktype1_txt, country_txt, region_txt
order by numbers_of_targets desc

--- total_target by country and city
select country_txt, city, sum(targettype) as total_target
from terrorism
group by city, country_txt
order by total_target desc

---attack severity
select attack_severity, count(attack_severity) as attack_severity_numbers
from terrorism
group by attack_severity
order by attack_severity_numbers desc

--Attack type and target type
select targtype1_txt, attacktype1_txt,  count(attacktype1_txt) as attack_type_numbers
from terrorism
group by attacktype1_txt, targtype1_txt
order by attack_type_numbers desc

--year by total casualities and successful operations
select year, sum(total_casualties) as total_casualities, count(success) as successful_operations
from terrorism
where year is not null and success = 1
group by year
order by total_casualities desc

--successful operations by terrorist group   
select gname, sum(success) as successful_operations 
from terrorism
where success = 1 and gname not like 'Unknown'
group by gname
order by successful_operations desc

--Unsuccessful operations by terrorist group 
select gname, count(success) as Unsuccessful_operations 
from terrorism
where success = 0 and gname not like 'Unknown'
group by gname
order by Unsuccessful_operations desc

--region by successful operations carried out by terrorists
select region_txt, count(success) as successful_operations
from terrorism
where success = 1 
group by region_txt
order by successful_operations desc

--successful operations by region
select region_txt, count(success) as successful_operations
from terrorism
where success = 1 
group by region_txt
order by successful_operations desc
