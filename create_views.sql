
create or replace view Users_On_Each_Page as
select pname, uname from users where pname is not null;

create or replace view Users_Visits as
select uname, access_count from users;

create or replace view Largest_Visits as
select uname from users where access_count = (select max(access_count) from users);

create or replace view Page_Data as
select pname, entry_count, exit_count from pages where deleteflag = 0;


create or replace view Page_With_Highest_Entry as
select pname from pages where entry_count = (select max(entry_count) from pages where deleteflag = 0) and deleteflag = 0;

create or replace view Link_Data as
select pfrom, pto, count from links;
