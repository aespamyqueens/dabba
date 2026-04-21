Library Management System

Tables:
Books (bid (PK), bname, price, stock)
Members (mid (PK), mname, contact)
Borrow (borrow_id (PK), bid (FK), mid (FK), quantity, borrow_date)

1. Print mid, mname, and total_purchase of all members who have done a total purchase greater than 3000.

2. Print mid, mname, and total_qty of members who have borrowed the most number of books in the year 2025.

3. Create a procedure to fetch book stock and print bid, bname, and stock for each book. If no books are present, print 'No books found'.

4. If during insertion in the Borrow table the borrow_date is NULL, replace it with SYSDATE


1) select m.mid, m.mname SUM(b.quantity * bk.price) AS total_purchase
from members m join borrow on m.mid = b.mid join books bk on b.bid = bk.bid 
group by m.mid, m.mname having sum(b.quantity *bk.price) >3000;



3) create or replace procedure book_audit as
b_count number;

BEGIN
select count(*) into b_count from Books;
if b_count = 0 then
raise_application_error(-20001, 'No books');
end if;
else
for r1 in (select stock, bid, bname from Books) loop
dbms_output.put_line(r1.stock || r1.bid || r1.bname);
end loop;
end if;
end;
/


begin
book_audit;
end;
/

4) create or replace trigger borrow_trg before insert on Borrow for each row

begin
if :new.borrow_date IS NULL then
:new.borrow_date = SYSDATE;
end if;
end;
/
