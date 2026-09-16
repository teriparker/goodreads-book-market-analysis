--Data Exploration
select *
from books_cleaning
limit 20;


--Dataset overview
-- How many books are in the dataset?
select count(*)
from books_cleaning;
/* There is a total of 16,225 books in this dataset */


-- Average number of reviews
select
	round(AVG(num_reviews))
from books_cleaning;
/* The average number of reviews rounded to the nearst whole number is 5,156 */

-- Average number of ratings
select 
	round(AVG(num_ratings))
from books_cleaning;
/* The average number of reviews rounded to the nearest whole numbe is...*/

-- Most recent publication year
select
	max(publication_year)
from books_cleaning;

/* The most recent publication year is 2025 */

-- Earliest publication year
select 
	min(publication_year)
from books_cleaning;
/* The earlist publication year is 1000 BC */

-- How many unique authors
select
	count(distinct author)
from books_cleaning;
/* There are 7615 unique authors. */

-- Mode of publication year

-- Mean of publication year
select
	round(AVG(publication_year))
from books_cleaning;
/* The average publication year is 1989. */

-- Median of publication year


-- Which books have the most pages
select 
	title,
	author,
	num_pages
from books_cleaning
order by num_pages DESC;
/* The top 3 books with the most pages are */

-- Which books have the least pages
select 
	title,
	author,
	num_pages
from books_cleaning
order by num_pages ASC
limit 3;

-- Average number of pages

-- Mode of pages

-- Mean of pages


-- Data Quality
-- How many books are missing the publication year
select
	count(publication_year)
from books_cleaning
where publication_year is null;
/* There are no rows with missing publication years*/


-- Are there duplicate titles
select
	title,
	author,
	count(*)
from books_cleaning
group by title, author
having count(*) >1;
/* There are several duplicate titles. The query pulled 357 rows. This could possibly be attributed to different editions, multiple listing on goodreads, etc. */


-- Which columns have missing values

-- Which books have a large number of genre tags

-- Are there 0 rating books
select
	count(*)
from books_cleaning
where avg_rating = '0';
/* There are no books that contain a 0 average rating */


--Genre Exploration
-- How many unique genre tags

-- 20 most common genre tags

-- Average amount of genres

-- Which genres appear together most often


-- Fiction Exploration
-- How many books tagged fiction
select
	count(distinct book_id)
from book_genres
where genre = 'Fiction';
/* There are 11,399 books with the fiction genre tag*/

-- How many not tagged fiction
select 
(select count(*)
	from books_cleaning)
-
(select
	count(distinct book_id)
from book_genres
where genre = 'Fiction');
/* There are 4,826 non fiction books */


-- % of fiction books
select 
(select
	count(distinct book_id)
from book_genres
where genre = 'Fiction') *100.0
/
(select count(*)
	from books_cleaning);
/* The percentage of fiction books is 70.26% */


-- Fantasy Exploration
-- How many have fantasy tag
select
	count(distinct book_id)
from book_genres
where genre ilike '%Fantasy%'; -- fantasy anywhere in the substring and in any case
/* 5,258 books with a fantasy tag, including the specific fantasy subgenre tags like epic fantasy, young adult fantasy, etc */

-- How many fantasy + romance tagged books
select
	count(distinct bg2.book_id)
from book_genres bg1
inner join book_genres bg2
	on bg1.book_id = bg2.book_id -- this join connects the two genres together
inner join books_cleaning bc
	on bg1.book_id = bc.book_id -- this join connects the book id + book title from the genre + cleaning tables
where bg1.genre ilike '%fantasy%'
and bg2.genre ilike '%romance%';

/* There are 1760 books tagged fantasy + romance.*/

-- How many fantasy + young adult tag books
select
	count(distinct bg2.book_id)
from book_genres bg1
inner join book_genres bg2
	on bg1.book_id = bg2.book_id -- this join connects the two genres together
inner join books_cleaning bc
	on bg1.book_id = bc.book_id -- this join connects the book id + book title from the genre + cleaning tables
where bg1.genre ilike '%fantasy%'
and bg2.genre ilike '%young adult%'; 

/* There are 2244 books tagged fantasy + young adult */

-- How many fantasy + dragons
select
	count(distinct bg2.book_id)
from book_genres bg1
inner join book_genres bg2
	on bg1.book_id = bg2.book_id -- this join connects the two genres together
inner join books_cleaning bc
	on bg1.book_id = bc.book_id -- this join connects the book id + book title from the genre + cleaning tables
where bg1.genre ilike '%fantasy%'
and bg2.genre ilike '%dragon%'; 

/* There are 156 books tagged fantasy + dragon.*/

-- How many fantasy + vampires
select
	count(distinct bg2.book_id)
from book_genres bg1
inner join book_genres bg2
	on bg1.book_id = bg2.book_id -- this join connects the two genres together
inner join books_cleaning bc
	on bg1.book_id = bc.book_id -- this join connects the book id + book title from the genre + cleaning tables
where bg1.genre ilike '%fantasy%'
and bg2.genre ilike '%vampire%'; 

/* There are 523 books tagged fantasy + vampire. */

-- Publication Trends
-- How many books where published each year
select
	publication_year,
	count(*)
from books_cleaning
group by publication_year
order by publication_year DESC;


-- Which decade had the most books
select 
	(LEFT(publication_year::TEXT, 3) || '0')::INTEGER AS decade, -- keeps the first three digits, adds a 0 as a string, converts it back to an integer
	count(*)
from books_cleaning	
where publication_year is not null
group by LEFT(publication_year::TEXT, 3)
order by decade DESC;
	
-- Reader Engagement
-- Which books have the most reviews
select
	title,
	author,
	num_reviews
from books_cleaning
order by num_reviews DESC
limit 10;
/* The top three books with the most reviews are The Seven Husbands of Evelyn Hugo, It Ends with Us, and Verity. There are multiple editions of each of these books, all with different review counts. */

-- Which books have the least reviews
select
	title,
	author,
	num_reviews
from books_cleaning
order by num_reviews
limit 3;
/* There are several books with no reviews. The ones that came up when the query ran are Rush to Us: Americans Hail Rush Limbaugh, Strange Dreams, and Vampires Adversaries */

-- Which books have the most ratings
select
	title,
	author,
	count(num_ratings)
from books_cleaning
order by num_ratings DESC
limit 3;

-- Is there a relationship between rating an review count

-- Which book has the highest average rating


-- Notes




select
	book_genres.book_id,
	title,
	genre
from book_genres
inner join books_cleaning on book_genres.book_id = books_cleaning.book_id
where genre ilike all
	(array ['%fiction%', '%vampire%']);


select
	count(distinct book_id)
from book_genres
where genre ilike '%Vampire%';


select distinct
	bg1.book_id,
	bc.title,
	bc.author
from book_genres bg1
inner join book_genres bg2
	on bg1.book_id = bg2.book_id -- this join connects the two genres together
inner join books_cleaning bc
	on bg1.book_id = bc.book_id -- this join connects the book id + book title from the genre + cleaning tables
where bg1.genre ilike '%fiction%'
and bg2.genre ilike '%vampire%';

select
	count(distinct bg2.book_id)
from book_genres bg1
inner join book_genres bg2
	on bg1.book_id = bg2.book_id -- this join connects the two genres together
inner join books_cleaning bc
	on bg1.book_id = bc.book_id -- this join connects the book id + book title from the genre + cleaning tables
where bg1.genre ilike '%fiction%'
and bg2.genre ilike '%vampire%';

-- Find the broad genres under fantasy
select distinct 
	genre
from book_genres
where genre ilike '%fantasy%'
order by genre;

--Find the broad romance genres
select distinct 
	genre
from book_genres
where genre ilike '%romance%'
order by genre;
