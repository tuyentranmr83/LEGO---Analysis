create database Lego
use Lego
go

/*
# Answer some Questions
- 1) What is the total number of parts per theme?
- 2) What is the total number of parts per year?
- 3) How many sets where created in each Century in the dataset?
- 4) What percentage of sets ever released in the 21st Century were Trains Themed?
- 5) What percentage of sets ever released in the 21st Century were Disney Themed?
- 6) What is the popular theme by year in terms of sets released in the 21st Century?
- 7) What is the most produced color of lego ever in terms of quantity of parts? 
*/

-- 1) What is the total number of parts per theme?

select th.name as Theme_name, SUM(ss.num_parts) as Number_of_parts 

from Sets ss left join Themes th 

on ss.theme_id = th.id

group by th.name

order by 2 desc

go

-- 2) What is the total number of parts per year?

select year as Theme_name, SUM(num_parts) as Number_of_parts 

from Sets

group by year

order by 2 desc

go

-- 3) How many sets where created in each Century in the dataset?

with temp as (select *,
					case when year between 2001 and 2100 then '21st Century'
						else '20th Century'
					end as Century

			from [dbo].[sets])

select Century, COUNT(set_num) as Number_of_Sets from temp group by Century order by 2 desc

-- 4) What percentage of sets ever released in the 21st Century were Trains Themed?

with temp as (select *,
					case when year between 2001 and 2100 then '21st Century'
						else '20th Century'
					end as Century

			from [dbo].[sets])

select COUNT(*) as Total_records,
No_of_name_trains = (select COUNT(*) from temp tp join [dbo].[themes] th on tp.theme_id=th.id where Century='21st Century' and th.name like '%Train%'),
Percentage_trains = cast((select COUNT(*) from temp tp join [dbo].[themes] th on tp.theme_id=th.id where Century='21st Century' and th.name like '%Train%') * 100.0 / COUNT(*) as decimal(8,2))

from temp where Century='21st Century'
Go

-- 5) What percentage of sets ever released in the 21st Century were Disney Themed?


with temp as (select *,
					case when year between 2001 and 2100 then '21st Century'
						else '20th Century'
					end as Century

			from [dbo].[sets])

select COUNT(*) as Total_records,
No_of_name_Disney = (select COUNT(*) from temp tp join [dbo].[themes] th on tp.theme_id=th.id where Century='21st Century' and th.name like '%Disney%'),
Percentage_Disney = cast((select COUNT(*) from temp tp join [dbo].[themes] th on tp.theme_id=th.id where Century='21st Century' and th.name like '%Disney%') * 100.0 / COUNT(*) as decimal(8,2))

from temp where Century='21st Century'
Go

-- 6) What is the popular theme by year in terms of sets released in the 21st Century?

with temp as (select *,
					case when year between 2001 and 2100 then '21st Century'
						else '20th Century'
					end as Century

			from [dbo].[sets])

select Years, Theme_Name, Number_0f_Sets

from
	(select 

	tp.year Years,
	th.name Theme_Name,
	COUNT(tp.set_num) as Number_0f_Sets,
	row_number() over(partition by tp.year order by COUNT(tp.set_num) desc) as Rn

	from temp tp join [dbo].[themes] th

	on tp.theme_id = th.id

	where Century='21st Century'

	group by tp.year, th.name) m

where rn = 1

order by 1
Go
-- 7) What is the most produced color of lego ever in terms of quantity of parts? 

select

		C.name,
		SUM(ip.quantity) Quantity

from [dbo].[inventory_parts] ip join [dbo].[colors] c

on ip.color_id = c.id

group by C.name

order by 2 desc

Go