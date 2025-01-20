use IMDB;

/*1.Find the total number of rows in each table of the schema.*/


SELECT 'director_mapping' as tablename,count(*)as tablerows from director_mapping
union all
SELECT 'genre' as tablename,count(*)as tablerows from genre
union all
SELECT 'movie' as tablename,count(*)as tablerows from movie
union all
SELECT 'names' as tablename,count(*)as tablerows from names
union all
SELECT 'ratings' as tablename,count(*)as tablerows from ratings
union all
SELECT 'role_mapping' as tablename,count(*)as tablerows from role_mapping;


/*2.Which columns in the movie table have null values?*/


select 'country' as 'id',count(*) as count from movie
where country is null
union all
select 'date_published' as 'id',count(*) as count from movie
where date_published is null
union all
select 'duration' as 'id',count(*) as count from movie
where duration is null
union all
select 'id' as 'id',count(*) as count from movie
where id is null
union all
select 'languages' as 'id',count(*) as count from movie
where languages is null
union all
select 'production_company' as 'id',count(*) as count from movie
where  production_company is null
union all
select 'title' as 'id',count(*) as count from movie
where title is null
union all
select 'worlwide_gross_income' as 'id',count(*) as count from movie
where worlwide_gross_income is null
union all
select 'year' as 'id',count(*) as count from movie
where year is null;


/*3.Find the total number of movies released each year.*/ 

select year, count(*)as  total_movies from movie
group by
year;

/*How does the trend look month-wise?*/

select month(date_published) as month,count(*) as total_movies from movie
group by
month(date_published) order by month asc ;


/*4.How many movies were produced in the USA or India in the year 2019?*/

SELECT year, country, COUNT(*) as TOTAL_MOVIES FROM movie 
WHERE (country = 'USA' OR country = 'India') AND year = 2019
group by country;



/*5.Find the unique list of genres present in the dataset */

select distinct genre from genre;

/*how many movies belong to only one genre.*/

select count(*) as singel_movies
from genre
where genre='drama'
group by genre;



/*6.Which genre had the highest number of movies produced overall?*/

select genre, count(*) as no_of_movies
from genre 
group by genre
order by no_of_movies desc
limit 1;



/*7.What is the average duration of movies in each genre?*/

select g.genre,avg(m.duration) as average_duration
from genre g
join movie m on m.id=g.movie_id
group by genre
order by average_duration desc;


/*8.Identify actors or actresses who have worked in more than three movies with an average rating below 5?*/

select n.name, count(ro.movie_id) as Low_rated_movies
from names n 
join role_mapping ro on ro.name_id = n.id
join ratings ra on ra.movie_id = ro.movie_id
where ra.avg_rating < 5


/*9.Find the minimum and maximum values in each column of the ratings table except the movie_id column.*/

select min(avg_rating) as min_rating,max(avg_rating) as max_rating,
       min(total_votes) as min_total,max(total_votes) as max_total,
       min(median_rating) as min_median,max(median_rating)as max_median
       from ratings;
       
       
       
       
/*10.Which are the top 10 movies based on average rating?*/

select m.title,r.avg_rating
from movie m
join ratings r on m.id=r.movie_id
group by m.id
order by r.avg_rating desc
limit 10;



/*11.Summarise the ratings table based on the movie counts by median ratings.*/

select median_rating,count(*) as moviecounts
from ratings
group by median_rating
order by median_rating;



/*12.How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?*/

select g.genre,count(*) as totalmovies
from genre g
join movie m on g.movie_id=m.id
join ratings r on r.movie_id=m.id
where m.year=2017 and m.country='USA' and (r.total_votes)>1000 and  month(date_published)=3
group by g.genre
order by totalmovies desc;



/*13.Find movies of each genre that start with the word ‘The ’ and which have an average rating > 8.*/

select g.genre,m.title,r.avg_rating
	from genre g
	join movie m on g.movie_id=m.id
	join ratings r on r.movie_id=m.id
	where (m.title like "The %")and r.avg_rating>8
	order by g.genre;



/*14.Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?*/

select count(*) as totalmovies
from movie m 
join ratings r on m.id=r.movie_id
where date_published between '2018-04-01' and '2019-04-01' and r.median_rating =8;



/*15.Do German movies get more votes than Italian movies?*/

select m.country,sum(r.total_votes) as totalvotes
from movie m
join ratings r on m.id=r.movie_id
where m.country in("Germany","italy")
group by m.country
order by m.country;



/*16.Which columns in the names table have null values?*/

select 'id' as id ,count(*) as null_id
from names
where id is null
union all
select 'name' as id ,count(*) as null_id
from names
where name is null
union all
select 'height' as id ,count(*) as null_id
from names
where height is null
union all
select 'date_of_birth' as id ,count(*) as null_id
from names
where date_of_birth is null
union all
select 'known_for_movies' as id ,count(*) as null_id
from names
where known_for_movies is null;



/*17.Who are the top two actors whose movies have a median rating >= 8?*/

select n.name ,count(*) as totalmovies                                                         
from names n
join role_mapping rm on rm. name_id=n.id
join ratings r on rm.movie_id=r.movie_id
where rm.category='actor' and r.median_rating>=8
group by n.name
order by totalmovies desc
limit 2;



/*18.	Which are the top three production houses based on the number of votes received by their movies?*/

select m.production_company, sum(r.total_votes) as totalvotes
from movie m
join ratings r on r.movie_id=m.id
group by m.production_company
order by totalvotes desc
limit 3;



/*19.How many directors worked on more than three movies?*/

select n.name,count(*) as totalmovies
from names n
join director_mapping dm on n.id=dm.name_id
group by n.name
having count(dm.movie_id)>3
order by totalmovies desc;



/*20.Find the average height of actors and actresses separately.*/

select rm.category,round(avg(n.height),2) as avg_height
from role_mapping  rm
join names n on rm.name_id=n.id
group by rm.category
order by avg_height desc;



/*21.Identify the 10 oldest movies in the dataset along with its title, country, and director.*/

select m.title,m.country,(n.name) as director_name,m.date_published
from movie m 
join director_mapping dm on m.id=dm.movie_id
join names n on dm.name_id=n.id
order by m.date_published,m.country
limit 10;



/*22.List the top 5 movies with the highest total votes and their genres.*/

Select m.title, g.genre, r.total_votes
	from movie m join genre g on 
    m.id = g.movie_id join ratings r on
    g.movie_id = r.movie_id 
    order by g.genre,total_votes desc
    limit 5;
    
    
       
/* 23. Find the movie with the longest duration, along with its genre and production company. */

Select m.title, m.duration, g.genre, m.production_company 
		from movie m join genre g on 
        m.id = g.movie_id
        order by duration desc
        limit 1;
        
        
        
/* 24. Determine the total votes received for each movie released in 2018 */    

Select m.title, sum(r.total_votes) as totalvotes
	from movie m join ratings r on
    m.id = r.movie_id 
    where year = 2018
    group by m.title
    order by totalvotes desc;
    
    
/* 25. Find the most common language in which movies were produced. */    

Select languages, count(*) as total_movies
	from movie
    group by languages
    order by total_movies desc
    limit 1;