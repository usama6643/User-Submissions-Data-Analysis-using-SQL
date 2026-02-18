CREATE TABLE user_submissions 
(
    id SERIAL PRIMARY KEY,
    user_id BIGINT,
    question_id INT,
    points INT,
    submitted_at TIMESTAMP WITH TIME ZONE,
    username VARCHAR(50)
);

SELECT * FROM user_submissions;
--Display all submissions made by a specific user_id
SELECT * FROM user_submissions
where user_id = '1235457227733860000'

--Show submissions where points are greater than 50
SELECT * FROM user_submissions
where points > 50

--List all unique usernames
SELECT distinct(username) FROM user_submissions

--Find total number of submissions
select count(*) as total_submissions from user_submissions

--Show submissions made after a specific date
select 
count(*) as total_submissions,
submitted_at::date as submission_date from user_submissions
where submitted_at > '2024-10-26 05:36:14.10267+05:30'
group by submitted_at 

--Display submissions where points are between 10 and 100
select * from user_submissions
where points between 10 and 100

--Count total submissions for each user_id
select count(*),user_id from user_submissions
group by 2

--Find total points scored by each user
select sum(points),user_id from user_submissions
group by user_id

--Display submissions for a specific question_id
select count(*) from user_submissions
where question_id = '31'

-- Show submissions ordered by submitted_at (latest first)
select submitted_at::date from user_submissions
order by submitted_at::date desc

-- Find users who have made more than 5 submissions
select user_id,count(*) as submissions from user_submissions
group by user_id
having count(*) > 5

--Find users whose total points are greater than 200
select user_id,sum(points) from user_submissions
group by 1
having sum(points) > 200

--Count number of submissions for each question_id
select count(*),question_id from user_submissions
group by 2

-- Find average points scored per user
select avg(points),user_id from user_submissions
group by 2

--Show question_ids that received more than 10 submissions
select question_id,count(*) from user_submissions
group by 1
having count(*) > 5

-- Find usernames who submitted more than once
select count(*),username from user_submissions
group by 2
having count(*) > 2

--Display users who scored an average of more than 40 points
select user_id,avg(points) from user_submissions
group by 1
having avg(points) > 40

--Find total points scored per question_id
select sum(points),question_id from user_submissions
group by 2

--Show users who have at least one submission with 0 points
select distinct(user_id) from user_submissions
where points = 0

--Count submissions per day
select count(*),submitted_at::date from user_submissions
group by 2
ORDER BY 2;

--Categorize submissions as Low, Medium, or High based on points
select user_id,points,
case 
when points < 50 then 'Low'
when points between 50 and 100 then 'Medium'
else 'High'
end as Category
from user_submissions

--Classify users as Active or Inactive based on total submissions
select user_id,count(*),
case 
when count(*) <= 50 then 'Inactive'
else 'Active'
end as Submissions
from user_submissions
group by user_id

--Using a CTE, calculate total submissions per user
select count(*),user_id from user_submissions
group by user_id

--find users whose total points are greater than the overall average points
select sum(points),user_id from user_submissions
group by user_id
having sum(points) > (select avg(points) from user_submissions)

--calculate daily submission counts
select date(submitted_at),count(*) from user_submissions
group by date(submitted_at)

--find users with more than 3 submissions in a single day
select date(submitted_at),count(*) as submissions,user_id from user_submissions
group by date(submitted_at),user_id
having count(*) > 3

-- calculate total points per question and filter only high scoring questions
-- select * from user_submissions
select sum(points),question_id from user_submissions
group by question_id
having question_id > 100

-- Assign a row number to each submission ordered by submitted_at
SELECT
    id,
    user_id,
    question_id,
    points,
    submitted_at,
    ROW_NUMBER() OVER (ORDER BY submitted_at) AS row_num
FROM user_submissions;

-- Rank submissions based on points (highest first)
SELECT
    user_id,
    question_id,
    points,
    DENSE_RANK() OVER (ORDER BY points DESC) AS rank
FROM user_submissions;
-- Rank submissions per user based on points
SELECT
    user_id,
    question_id,
    points,
    DENSE_RANK() OVER (
        PARTITION BY user_id
        ORDER BY points DESC
    ) AS user_rank
FROM user_submissions;
-- Show each submission along with the maximum points of that user
SELECT
    user_id,
    question_id,
    points,
    submitted_at,
    MAX(points) OVER (PARTITION BY user_id) AS max_points_of_user
FROM user_submissions;
-- Display each submission with the average points of that user
SELECT
    user_id,
    question_id,
    points,
    submitted_at,
    AVG(points) OVER (PARTITION BY user_id) AS avg_points_of_user
FROM user_submissions;
-- Agar tumhein har user ki exactly 3 submissions
SELECT *
FROM (
    SELECT
        user_id,
        question_id,
        points,
        submitted_at,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY points DESC
        ) AS rn
    FROM user_submissions
) t
WHERE rn <= 3;

--Find the highest points scored in the table
select max(points) from user_submissions

--Count how many submissions have NULL username
-- select * from user_submissions
select count(*) from user_submissions
where username is NULL

--Show submissions where username starts with 'A'
SELECT *
FROM user_submissions
WHERE username LIKE 'A%';

--Show submissions where username contains 'ali'
SELECT *
FROM user_submissions
WHERE username LIKE 'ali%';

--Find total submissions between two dates
SELECT COUNT(*) AS total_submissions
FROM user_submissions
WHERE submitted_at BETWEEN '2024-10-25' AND '2024-10-27';

--Show top 5 highest scoring submissions
select username,points from user_submissions
order by points desc
limit 5

--Find users who have both scored above 80 AND below 30 at least once
select user_id from user_submissions
group by user_id
having max (points) > 80 and min (points) < 30

--Find duplicate usernames
select username,count(*) from user_submissions
group by username
having count(*) > 1

--Find the latest submission per user
select * from (select user_id,submitted_at,
row_number() over(partition by user_id order by submitted_at desc) as rn
from user_submissions) submissions
where rn=1

--Find users whose average points is greater than overall average points
select user_id from user_submissions
group by user_id
having avg(points) > (select avg(points) from user_submissions
);

--Show cumulative submission count per user
SELECT  user_id, submitted_at,
    COUNT(*) OVER (PARTITION BY user_id ORDER BY submitted_at) AS cumulative_submission_count
FROM user_submissions;

--Find users who submitted on more than 3 different days
select user_id FROM user_submissions
group by user_id
having count(distinct submitted_at::date) > 3

--Second highest points
select count(*) from
(select points,
dense_rank() over(order by points desc) as rank
from user_submissions) t
where rank=2













