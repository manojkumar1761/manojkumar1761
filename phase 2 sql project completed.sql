create database creating;

use creating;

create table publisher(
publisher_PublisherName varchar(255)  primary key ,
publisher_PublisherAddress varchar(255), 
publisher_Publisherphone varchar(255)
);



select * from publisher;

create table library_branch(
library_branch_branchid int not null primary key auto_increment,
library_branch_BranchName varchar(255) ,
library_branch_BranchAddress varchar(255)
);

select * from library_branch; 

create table borrower (
borrower_CardNo int primary key,
borrower_BorrowerName varchar(255), 
borrower_BorrowerAddress varchar(255),
borrower_BorrowerPhone varchar(255)
);

select * from borrower;

create table books(
book_BookID int primary key,
book_Title varchar(255),
book_PublisherName varchar(255),
foreign key (book_publishername) references publisher(publisher_PublisherName) on delete cascade
);
alter table books add foreign key (book_publishername) references publisher(publisher_PublisherName) on DELETE CASCADE;


select * from books;
desc books;
drop table books;

create table books_loans(
book_loans_loansid int primary key auto_increment,
book_loans_BookID int,
book_loans_BranchID int,
book_loans_CardNo int ,
book_loans_DateOut varchar(255),
book_loans_DueDate varchar(255),

foreign key (book_loans_bookid) references books(book_bookid) on delete cascade,
foreign key (book_loans_cardno) references borrower(borrower_CardNo) on delete cascade,
foreign key (book_loans_branchid) references library_branch(library_branch_branchid) on delete cascade

);

select * from books_loans;



create table books_copies(
book_copies_copiesid int primary key auto_increment ,
book_copies_BookID int  ,
book_copies_BranchID int ,
book_copies_No_Of_Copies int ,

foreign key (book_copies_bookid) references books(book_bookid) on delete cascade,
foreign key (book_copies_branchid) references library_branch(library_branch_branchid) on delete cascade
);

select * from books_copies;

create table authors(
book_authors_authorid int not null primary key auto_increment ,
book_authors_BookID int ,
book_authors_AuthorName varchar(255),

foreign key (book_authors_bookid) references books(book_BookID) on delete cascade
);


select * from authors;

select * from books;
select * from library_branch;
select * from books_copies;
select * from books_loans;
select * from authors;
select * from borrower;
select * from publisher;


-- 1. How many copies of the book titled "The Lost Tribe" are owned by the library branch whose name is "Sharpstown"?

select * from books;
select * from library_branch;
select * from books_copies;

select * from books_copies as bc join library_branch as lb on bc.book_copies_BranchID = lb.library_branch_branchid 
join books as b on b.book_BookID = bc.book_copies_BookID ;

select lb.library_branch_BranchName , b.book_Title ,book_copies_No_Of_Copies from books_copies as bc 
join library_branch as lb on bc.book_copies_BranchID = lb.library_branch_branchid 
join books as b on b.book_BookID = bc.book_copies_BookID where library_branch_BranchName = 'sharpstown' and b.book_title = 'The Lost Tribe'  ;





-- 2. How many copies of the book titled "The Lost Tribe" are owned by each librarybranch


select bc.book_copies_No_Of_Copies ,b.book_Title ,lb.library_branch_BranchName from books_copies as bc join library_branch as lb on bc.book_copies_BranchID = lb.library_branch_branchid 
join books as b on b.book_BookID = bc.book_copies_BookID where b.book_Title = 'the lost tribe';


-- 3. Retrieve the names of all borrowers who do not have any books checked out.

select * from borrower;
select * from books;
select * from books_loans;

select * from borrower as b join books_loans as bl on b.borrower_CardNo = bl.book_loans_CardNo;

select b.borrower_BorrowerName from borrower as b left join books_loans as bl on b.borrower_CardNo = bl.book_loans_CardNo
where bl.book_loans_CardNo is null ;


-- 4. For each book that is loaned out from the "Sharpstown" branch and whoseDueDate is 2/3/18, retrieve the book title, the borrower's name, and theborrower's address.



select * from borrower;
select * from books_loans;
desc books_loans;
select * from library_branch;
select * from books;


select  distinct(lb.library_branch_BranchName) , bk.book_Title ,bl.book_loans_DueDate,b.borrower_BorrowerName,b.borrower_BorrowerAddress from books_loans as bl 
join library_branch as lb on bl.book_loans_BranchID = lb.library_branch_branchid
join borrower as b on b.borrower_CardNo = bl.book_loans_CardNo join books as bk on bk.book_BookID = bl.book_loans_BookID
where  lb.library_branch_BranchName = 'sharpstown' and bl.book_loans_duedate = '2/3/18' ;



-- 5. For each library branch, retrieve the branch name and the total number of booksloaned out from that branch.
select  * from library_branch;
select * from books_loans;

select lb.library_branch_BranchName, count(b1) from library_branch as lb join books_loans as bl ;

select lb.library_branch_BranchName , count(bl.book_loans_BranchID) as count_of_books from library_branch as lb join books_loans as
bl on lb.library_branch_branchid=bl.book_loans_BranchID group by lb.library_branch_branchid;



-- 6. Retrieve the names, addresses, and number of books checked out for allborrowers who have more than five books checked out.

select * from books_loans;
select * from borrower;

select * from borrower as b join  books_loans as bl on b.borrower_CardNo = bl.book_loans_CardNo ;

select b.borrower_BorrowerName, b.borrower_Borroweraddress,count(bl.book_loans_DateOut) as count_books from borrower as b 
join  books_loans as bl on b.borrower_CardNo = bl.book_loans_CardNo  group by (b.borrower_Borroweraddress) ,(b.borrower_BorrowerName) having count_books > 5;

select  b.borrower_BorrowerName,b.borrower_Borroweraddress,count(bl.book_loans_CardNo) as count_books from borrower as b 
join  books_loans as bl on b.borrower_CardNo = bl.book_loans_CardNo  group by (b.borrower_CardNo)  having count_books > 5;



-- 7. For each book authored by "Stephen King", retrieve the title and the number ofcopies owned by the library branch whose name is "Central"

select * from books;
select * from authors ;
select * from library_branch;
select * from books_copies;

select * from library_branch as lb join books_copies as bc on lb.library_branch_branchid = bc.book_copies_BranchID 
join books as b on b.book_BookID = bc.book_copies_BookID join authors as a on a.book_authors_BookID = b.book_BookID   ;


select distinct (a.book_authors_AuthorName),b.book_Title, lb.library_branch_BranchName , bc.book_copies_No_Of_Copies from library_branch as lb 
join books_copies as bc on lb.library_branch_branchid = bc.book_copies_BranchID 
join books as b on b.book_BookID = bc.book_copies_BookID join authors as a on a.book_authors_BookID = b.book_BookID  
where lb.library_branch_BranchName = 'Central' and  a.book_authors_AuthorName = 'Stephen King';