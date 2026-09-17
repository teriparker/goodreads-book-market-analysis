-- Data imported using DBeaver GUI import wizard
-- Created the books_raw table, holding the raw data from the Goodreads dataset csv file

select *
from books_raw;

-- Checking to see if any data is null
SELECT *
FROM books_raw
WHERE column2 IS NULL
LIMIT 20;

-- Creating new table from the data in the books_raw table
create table books_cleaning as
select *
from books_raw;

select *
from books_cleaning;

--Renaming column names
alter table books_cleaning
rename column column2 to book_id;

alter table books_cleaning
rename column column3 to cover_image_url;

select *
from books_cleaning;

alter table books_cleaning
rename column column4 to title;

alter table books_cleaning
rename column column5 to summary;

alter table books_cleaning
rename column column6 to book_format;

alter table books_cleaning
rename column column7 to publication_date;

alter table books_cleaning
rename column column8 to author_page;

alter table books_cleaning
rename column column9 to author;

alter table books_cleaning
rename column column10 to num_pages;

alter table books_cleaning
rename column column11 to genres;

alter table books_cleaning
rename column column12 to num_ratings;

alter table books_cleaning
rename column column13 to num_reviews;

alter table books_cleaning
rename column column14 to avg_rating;

alter table books_cleaning
rename column column15 to rating_dis;

-- Checking to see the changes
select *
from books_cleaning
limit 10;


-- Shorten the publication date to show only the year
-- Added a new column to transfer the YYYY over
alter table books_cleaning
add column publication_year INTEGER;

--Using substring function and Set function to pull the year, then assign to the newly created column, CASTing as a #
update books_cleaning
set publication_year = cast(substring(publication_date FROM '([0-9]{4})') as INTEGER);

select title,
publication_date,
publication_year
from books_cleaning;

-- Noticed some values were NULL, called where clause to see which ones
select *
from books_cleaning
where publication_year is null;

--A total of 58 results are have null for the publication date. These are all historical texts that were written before the YYYY date format. Not relevant to analysis, so will leave as NULL

select *
from books_cleaning
where publication_year is not null;

--NORMALIZING THE DATA
-- Creating a table for the genres
create table book_genres (
	book_id TEXT,
	genre text
	);

select genres
from books_cleaning
limit 40;

select book_id,
genres
from books_cleaning;

-- splitting the genre string to have individual genres
select book_id,
replace(replace(genres, '[', ''), ']', '') --replacing the brackets ([]) with nothing
from books_cleaning;

select book_id,
replace(removal, '''', '') as genres_clean --taking the results from the inside query and removing the quotes (''), giving alias genres_clean
from (
	select book_id,
	replace(replace(genres, '[', ''), ']', '') as removal --inside query replacing the brackets ([]) with nothing, giving it removal alias
	from books_cleaning)
books_cleaning;

select 
book_id,
replace(replace(replace(genres, '[', ''), ']', ''), '''', '') as genres_clean -- simplifying the replace functions instead of subquerying
from books_cleaning;

select 
book_id,
string_to_array(replace(replace(replace(genres, '[', ''), ']', ''), '''', ''), ', ') -- taking the replace function and turning the genres into an array
from books_cleaning;

select *
from book_genres;

select
book_id,
TRIM(
	unnest(
		string_to_array(replace(replace(replace(genres, '[', ''), ']', ''), '''', ''), ', ')
		)
	) as genres -- unnest the array elements to be in different rows, then trim excess space around text
from books_cleaning;


-- Received an error when converting book_id to int in cleaning table via dbeaver gui
-- to find which row did not only contain numbers so I can delete/fix it
select book_id
from books_cleaning
limit 5;

SELECT DISTINCT book_id
FROM books_cleaning
WHERE book_id !~ '^[0-9]+$';

select *
from books_cleaning
where book_id = 'book_id'; -- provides the row that has the book_id string

delete from books_cleaning
where book_id = 'book_id'; -- delete the row that had book_id in it

select *
from books_cleaning
where book_id = 'book_id'; -- want to confirm that the row is deleted

ALTER TABLE public.books_cleaning 
ALTER COLUMN book_id TYPE integer USING book_id::integer; -- changing data type from text to int

-- Inputting book_id and genres into book_genre table
insert into book_genres (book_id, genre)
select
book_id,
TRIM(
	unnest(
		string_to_array(replace(replace(replace(genres, '[', ''), ']', ''), '''', ''), ', ')
		)
	)
from books_cleaning;

select *
from book_genres
limit 100; --checking to see if the insert is successful

select *
from books_cleaning
limit 20;


--Determining top genre tags
select
genre,
count(*) as frequency
from book_genres
group by genre
order by frequency desc;

--Examining the fantasy genre
select *
from book_genres
where genre = 'Fantasy';

--creating a table specifically for the fantasy genre, inserting the subg
create table fantasy_genres (genre TEXT primary key);

alter table fantasy_genres
add	column fantasy_subgenre TEXT,
add column tag_role TEXT;

alter table fantasy_genres
rename column genre to genre_tag;

select *
from books_cleaning
limit 20;


-- Creating Ratings Distribution Table
create table book_ratings (
	book_id TEXT,
	rating INTEGER,
	rating_count INTEGER);

select *
from book_ratings; -- testing to see if the table was successfully created


select 
	book_id,
	replace(rating_dis, '''', '' ) as cleaned -- removing the "" from the text
from books_cleaning
where rating_dis is not null
limit 2;

replace(rating_dis, '{', '')


select 
	book_id,
	replace(
		replace(
			replace(rating_dis, '''', '' ) 
			, '{', '')
		, '}', '') as cleaned -- removing the { and } from the text
from books_cleaning
where rating_dis is not null
limit 2;




select
	book_id,
	split_part(
		split_part (cleaned, '5: ', 2),
	
	', 4', 1)
from (
	select 
		book_id,
		replace(
			replace(
				replace(rating_dis, '''', '' ) 
				, '{', '')
			, '}', '') as cleaned -- removing the { and } from the text
	from books_cleaning
	where rating_dis is not null
	limit 2);


