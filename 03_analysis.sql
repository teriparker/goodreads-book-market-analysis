--Fantasy market size
select
	count(distinct book_id)
from book_genres
where genre = 'Fantasy';

/* There are 5090 books in the fantasy genre */

--Fantasy publishing by decade
select 
	(LEFT(publication_year::TEXT, 3) || '0')::INTEGER AS decade, -- keeps the first three digits, adds a 0 as a string, converts it back to an integer
	count(*)
from books_cleaning	bc
inner join book_genres bg 
	on bg.book_id = bc.book_id
where bc.publication_year is not null 
and bg.genre = 'Fantasy'
group by LEFT(publication_year::TEXT, 3)
order by decade DESC;
/* Takes the decades from the books cleaning table and joins it on to the book genres table by book id, limiting to only fantasy genre */

--Subgenre size

--Subgenre publishing growth

--Average rating by subgenere

--Review activity by subgenre

--Ratings activity by subgenre