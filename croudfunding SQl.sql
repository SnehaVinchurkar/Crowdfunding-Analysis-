use croudfunding;
Select * from croudfunding.projects;
--  Total Number of Projects based on outcome
select state, count(name) as number_of_project from projects group by state;

--  Total Number of Projects based on Locations
SELECT COUNT(*) AS total_projects_based_on_location
FROM projects
INNER JOIN crowdfunding_location
ON projects.Location_id = crowdfunding_location.Location_id;

-- Total Number of Projects based on  Category
ALTER TABLE crowdfunding_category
RENAME COLUMN name TO category_name;
select Category_name,count(*) as based_on_category
from projects inner join crowdfunding_category using (category_id)
group by category_name;

-- Convert the Goal amount into USD using the Static USD Rate.
select goal * 83.54665 as New_Goal
from projects;


-- successful projects (amount raised,number of backers,avg days of successful projects)
select name,count(backers_count) as Number_of_backers,avg(goal)
from projects
where state= "successful"
group by name;


-- Top Successful Projects :Based on Number of Backers,Based on Amount Raised.
select name,count(backers_count) as Number_backers,avg(goal)
from  projects
where state = "successful"
group by name
limit 10;

-- Percentage of Successful Projects overall
SELECT (COUNT(CASE WHEN state= 'successful' THEN 1 END) / COUNT(*)) * 100 AS success_percentage
FROM projects;


--   Percentage of Successful Projects  by Categor
SELECT name,state,category_name,
    COUNT(CASE
        WHEN state = 'successful' THEN 1
    END) / COUNT(*) * 100 AS Success_percentage
FROM
    projects
        INNER JOIN
    crowdfunding_category USING (Category_id)
GROUP BY name , state , category_name;


-- Percentage of Successful projects by Goal Range
select state,name,goal,COUNT(CASE
        WHEN state = 'successful' THEN 1
    END) / COUNT(*) * 100 AS Success_percentage
    from projects
    where state='successful'
    group by state,name,goal;
    
--   Convert the Date fields to Natural Time 
SELECT DATE_FORMAT(FROM_UNIXTIME(Created_at), '%Y-%m-%d %H:%h:%S') AS natural_time
FROM projects;

--    Total Number of Projects created by Year , Quarter , Month
SELECT 
    YEAR(created_at) AS year,
    QUARTER(created_at) AS quarter,
    MONTH(created_at) AS month,
    COUNT(*) AS total_projects_by_year_month_quarter 
FROM projects
GROUP BY YEAR(created_at),QUARTER(created_at),MONTH(created_at)
ORDER BY year, quarter, month;