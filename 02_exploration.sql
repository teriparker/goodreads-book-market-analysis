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
order by num_pages DESC
limit 3;
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
	count(book_id)
from book_genres
where genre ilike ALL 
	(array ['%fantasy%', '%romance%']); --used and array to find the substrings

select
	book_genres.book_id,
	title
from book_genres
inner join books_cleaning on book_genres.book_id = books_cleaning.book_id --joining genre and cleaning table to see the names of the titles
where genre ilike ALL 
	(array ['%fantasy%', '%romance%']); 

-- How many fantasy + young adult tag books
select
	count(book_id)
from book_genres
where genre ilike ALL 
	(array ['%fantasy%', '%young adult%']); --used and array to find the substrings

select
	book_genres.book_id,
	title
from book_genres
inner join books_cleaning on book_genres.book_id = books_cleaning.book_id --joining genre and cleaning table to see the names of the titles
where genre ilike ALL 
	(array ['%fantasy%', '%young adult%']); 

-- How many fantasy + dragons
select
	count(book_id)
from book_genres
where genre ilike ALL 
	(array ['%fantasy%', '%dragon%']);

-- How many fantasy + vampires
select
	count(book_id)
from book_genres
where genre ilike ALL 
	(array ['%fantasy%', '%vampire%']); --used and array to find the substrings

select
	book_genres.book_id,
	title
from book_genres
inner join books_cleaning on book_genres.book_id = books_cleaning.book_id --joining genre and cleaning table to see the names of the titles
where genre ilike ALL 
	(array ['%fantasy%', '%vampire%']); 

-- Publication Trends
-- How many books where published each year

-- Which decade had the most books


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
where genre ilike any
	(array ['%fiction%', '%vampire%']);

select 
	distinct genre,
	count(genre)
from book_genres
where genre ilike '%fiction%'
group by genre;