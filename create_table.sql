drop table pages;
create table pages(
	pname varchar2(3) primary key, exit_count number(2), entry_count number(2), deleteflag number(1));

drop table links;
create table links(
	pfrom varchar2(3), pto varchar2(3), count number(2));

drop table users;
create table users(
	uname varchar2(3) primary key, pname varchar2(3), access_count number(2));

