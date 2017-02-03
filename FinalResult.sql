SQL> drop table pages;

Table dropped.

SQL> create table pages(
  2  pname varchar2(3) primary key, exit_count number(2), entry_count number(2), deleteflag number(1));

Table created.

SQL> 
SQL> drop table links;

Table dropped.

SQL> create table links(
  2  pfrom varchar2(3), pto varchar2(3), count number(2));

Table created.

SQL> 
SQL> drop table users;

Table dropped.

SQL> create table users(
  2  uname varchar2(3) primary key, pname varchar2(3), access_count number(2));

Table created.

SQL> 
SQL> 
SQL> set serveroutput on size 1000000 format wrap
SQL> create or replace procedure proc_AddLink (page_from in links.pfrom%type,
  2  page_to in links.pto%type) as appcount number;
  3  
  4  begin
  5  select COUNT(*) into appcount from pages where page_from = pname and deleteflag = 0;
  6  if appcount = 1 then
  7    select COUNT(*) into appcount from pages where page_to = pname and deleteflag = 0;
  8    if appcount = 1 then
  9      select COUNT(*) into appcount from links where page_from = pfrom and page_to = pto;
 10      if appcount = 0 then
 11          insert into links values(page_from, page_to, 0);
 12  dbms_output.put_line('The link is added');
 13      else
 14         dbms_output.put_line('The link already exists.');
 15      end if;
 16    else
 17      dbms_output.put_line('Page doesnot exists in table Pages or is deleted.');
 18    end if;
 19  else
 20      dbms_output.put_line('Page doesnot exists in table Pages or is deleted.');
 21  end if;
 22  end;
 23   /

Procedure created.

SQL> show errors;
No errors.
SQL> create or replace procedure proc_AddPage (page_name in pages.pname%type)
  2                                       as
  3       appcount number;
  4  
  5  begin
  6       select COUNT(*) into appcount from pages where page_name = pname;
  7        if appcount = 0 then
  8             insert into pages values(page_name, 0, 0, 0);
  9        else
 10     select COUNT(*) into appcount from pages where page_name = pname and deleteflag = 1;
 11     if appcount = 1 then
 12  update pages set deleteflag = 0 where pname = page_name;
 13  dbms_output.put_line('The page has been reactivated.');
 14     else
 15             dbms_output.put_line('The page is already in the table Pages.');
 16     end if;
 17        end if;
 18  end;
 19  /

Procedure created.

SQL> show errors;
No errors.
SQL> set serveroutput on size 1000000 format wrap
SQL> create or replace procedure proc_EnterWebsite (user_name in users.uname%type, page_name in users.pname%type)
  2  
  3   as appcount number;
  4  
  5  begin
  6       --check page exists and is not deleted in table pages
  7  select COUNT(*) into appcount from pages where page_name=pname and deleteflag=0;
  8  if appcount=1 then
  9  --if user doesnot exists, insert in table Users
 10       select COUNT(*) into appcount from users where user_name=uname;
 11       if appcount=0 then
 12  insert into users values (user_name, page_name, 1);
 13  update pages set entry_count = entry_count+1 where pname = page_name;
 14     dbms_output.put_line('User added.');
 15       else
 16  --if user exists and is inactive, update the existing record
 17  select COUNT(*) into appcount from users where user_name=uname and pname is null;
 18  if appcount=1 then
 19  update users set pname = page_name, access_count = access_count+1 where user_name=uname;
 20   update pages set entry_count = entry_count+1 where pname = page_name;
 21  dbms_output.put_line('User activated and entered page '|| page_name);
 22  else
 23  dbms_output.put_line('User already present.');
 24  end if;
 25  end if;
 26  else
 27  dbms_output.put_line('Page doesnot exists.');
 28  
 29       end if;
 30  end;
 31  /

Procedure created.

SQL> show errors;
No errors.
SQL> set serveroutput on size 1000000 format wrap
SQL> create or replace procedure proc_ExitWebsite (user_name in users.uname%type)
  2   as appcount number;
  3        temp number(10);
  4  begin
  5       select COUNT(*) into appcount from users where uname = user_name;
  6       if appcount>0 then
  7       select COUNT(*) into appcount from users where user_name = uname and pname is null;
  8       if appcount=0 then
  9  update pages set exit_count = exit_count+1 where pname in(select pname from users where uname=user_name);
 10  update users set pname = null where uname = user_name;
 11  dbms_output.put_line('User exited the website.');
 12       else
 13  dbms_output.put_line('User doesnot exists or has already exited the website.');
 14  end if;
 15        else
 16  dbms_output.put_line('User doesnot exists');
 17       end if;
 18  end;
 19  /

Procedure created.

SQL> show errors;
No errors.
SQL> set serveroutput on size 1000000 format wrap
SQL> create or replace procedure proc_Move (user_name in users.uname%type, page_from in links.pfrom%type, page_to in links.pto%type)
  2   as appcount number;
  3  begin
  4       select COUNT(*) into appcount from users where user_name = uname;
  5       if appcount = 1 then
  6  select COUNT(*) into appcount from users where user_name = uname and page_from = pname;
  7  if appcount = 1 then
  8  select COUNT(*) into appcount from links where pfrom = page_from and pto = page_to;
  9        if appcount = 1 then
 10          update links set count = count + 1 where pfrom = page_from and pto = page_to;
 11  update users set pname = page_to where user_name = uname;
 12  dbms_output.put_line('User moved from '|| page_from || ' to ' || page_to);
 13  else
 14  dbms_output.put_line('Link doesnot exists.');
 15        end if;
 16  else
 17  dbms_output.put_line('User is inactive or is on some other page.');
 18          end if;
 19       else
 20  dbms_output.put_line('User doesnot exists is users table.');
 21       end if;
 22  end;
 23  /

Procedure created.

SQL> show errors;
No errors.
SQL> set serveroutput on size 1000000 format wrap
SQL> create or replace procedure proc_RemoveLink (page_from in links.pfrom%type, page_to in links.pto%type) as appcount number;
  2  
  3  begin
  4       select COUNT(*) into appcount from links where page_from=pfrom and page_to=pto;
  5       if appcount = 1 then
  6  delete from links where pfrom = page_from and pto = page_to;
  7     dbms_output.put_line('The link has been deleted.');
  8       else
  9             dbms_output.put_line('The link is already deleted or doesnot exists.');
 10        end if;
 11  end;
 12  /

Procedure created.

SQL> set serveroutput on size 1000000 format wrap
SQL> create or replace procedure proc_RemovePage (page_name in pages.pname%type)
  2   as appcount number;
  3  begin
  4       select COUNT(*) into appcount from pages where page_name = pname and deleteflag = 0;
  5       if appcount = 1 then
  6  update users set pname = null where pname = page_name;
  7  delete links where pfrom = page_name or pto = page_name;
  8  update pages set deleteflag = 1 where pname = page_name;
  9  dbms_output.put_line('Page ' || page_name || ' is deleted');
 10  
 11       else
 12  dbms_output.put_line('Page is already deleted or doesnot exists.');
 13  
 14       end if;
 15  end;
 16  /

Procedure created.

SQL> show errors;
No errors.
SQL> execu proc_AddPage('p01');

PL/SQL procedure successfully completed.

SQL> execu proc_AddPage('p01');
The page is already in the table Pages.                                         

PL/SQL procedure successfully completed.

SQL> execu proc_AddPage('p02');

PL/SQL procedure successfully completed.

SQL> execu proc_AddPage('p03');

PL/SQL procedure successfully completed.

SQL> execu proc_AddPage('p04');

PL/SQL procedure successfully completed.

SQL> execu proc_AddPage('p05');

PL/SQL procedure successfully completed.

SQL> execu proc_AddPage('p06');

PL/SQL procedure successfully completed.

SQL> execu proc_AddPage('p07');

PL/SQL procedure successfully completed.

SQL> execu proc_AddPage('p08');

PL/SQL procedure successfully completed.

SQL> execu proc_AddPage('p09');

PL/SQL procedure successfully completed.

SQL> execu proc_RemovePage('p05');
Page p05 is deleted                                                             

PL/SQL procedure successfully completed.

SQL> execu proc_AddPage('p05');
The page has been reactivated.                                                  

PL/SQL procedure successfully completed.

SQL> execu proc_RemovePage('p06');
Page p06 is deleted                                                             

PL/SQL procedure successfully completed.

SQL> execu proc_RemoveLink('p01','p02');
The link is already deleted or doesnot exists.                                  

PL/SQL procedure successfully completed.

SQL> execu proc_AddLink('p10','p02');
Page doesnot exists in table Pages or is deleted.                               

PL/SQL procedure successfully completed.

SQL> execu proc_AddLink('p01','p02');
The link is added                                                               

PL/SQL procedure successfully completed.

SQL> execu proc_AddLink('p01','p03');
The link is added                                                               

PL/SQL procedure successfully completed.

SQL> execu proc_AddLink('p02','p03');
The link is added                                                               

PL/SQL procedure successfully completed.

SQL> execu proc_AddLink('p03','p04');
The link is added                                                               

PL/SQL procedure successfully completed.

SQL> execu proc_AddLink('p06','p07');
Page doesnot exists in table Pages or is deleted.                               

PL/SQL procedure successfully completed.

SQL> execu proc_RemoveLink('p01','p02');
The link has been deleted.                                                      

PL/SQL procedure successfully completed.

SQL> execu proc_EnterWebsite('u01','p01');
User added.                                                                     

PL/SQL procedure successfully completed.

SQL> execu proc_EnterWebsite('u02','p02');
User added.                                                                     

PL/SQL procedure successfully completed.

SQL> execu proc_EnterWebsite('u03','p03');
User added.                                                                     

PL/SQL procedure successfully completed.

SQL> execu proc_EnterWebsite('u01','p02');
User already present.                                                           

PL/SQL procedure successfully completed.

SQL> execu proc_EnterWebsite('u04','p05');
User added.                                                                     

PL/SQL procedure successfully completed.

SQL> execu proc_EnterWebsite('u05','p06');
Page doesnot exists.                                                            

PL/SQL procedure successfully completed.

SQL> execu proc_EnterWebsite('u06','p06');
Page doesnot exists.                                                            

PL/SQL procedure successfully completed.

SQL> execu proc_EnterWebsite('u07','p05');
User added.                                                                     

PL/SQL procedure successfully completed.

SQL> execu proc_EnterWebsite('u08','p07');
User added.                                                                     

PL/SQL procedure successfully completed.

SQL> execu proc_EnterWebsite('u09','p01');
User added.                                                                     

PL/SQL procedure successfully completed.

SQL> execu proc_ExitWebsite('u01');
User exited the website.                                                        

PL/SQL procedure successfully completed.

SQL> execu proc_ExitWebsite('u07');
User exited the website.                                                        

PL/SQL procedure successfully completed.

SQL> execu proc_ExitWebsite('u08');
User exited the website.                                                        

PL/SQL procedure successfully completed.

SQL> execu proc_EnterWebsite('u01','p03');
User activated and entered page p03                                             

PL/SQL procedure successfully completed.

SQL> execu proc_Move('u01','p01','p02');
User is inactive or is on some other page.                                      

PL/SQL procedure successfully completed.

SQL> execu proc_Move('u02','p02','p03');
User moved from p02 to p03                                                      

PL/SQL procedure successfully completed.

SQL> execu proc_Move('u02','p03','p04');
User moved from p03 to p04                                                      

PL/SQL procedure successfully completed.

SQL> execu proc_Move('u05','p06','p07');
User doesnot exists is users table.                                             

PL/SQL procedure successfully completed.

SQL> execu proc_Move('u06','p06','p07');
User doesnot exists is users table.                                             

PL/SQL procedure successfully completed.

SQL> select * from users;

UNA PNA ACCESS_COUNT                                                            
--- --- ------------                                                            
u01 p03            2                                                            
u02 p04            1                                                            
u03 p03            1                                                            
u04 p05            1                                                            
u07                1                                                            
u08                1                                                            
u09 p01            1                                                            

7 rows selected.

SQL> select * from pages;

PNA EXIT_COUNT ENTRY_COUNT DELETEFLAG                                           
--- ---------- ----------- ----------                                           
p01          1           2          0                                           
p02          0           1          0                                           
p03          0           2          0                                           
p04          0           0          0                                           
p05          1           2          0                                           
p06          0           0          1                                           
p07          1           1          0                                           
p08          0           0          0                                           
p09          0           0          0                                           

9 rows selected.

SQL> select * from links;

PFR PTO      COUNT                                                              
--- --- ----------                                                              
p01 p03          0                                                              
p02 p03          1                                                              
p03 p04          1                                                              

SQL> 
SQL> create or replace view Users_On_Each_Page as
  2  select pname, uname from users where pname is not null;

View created.

SQL> 
SQL> create or replace view Users_Visits as
  2  select uname, access_count from users;

View created.

SQL> 
SQL> create or replace view Largest_Visits as
  2  select uname from users where access_count = (select max(access_count) from users);

View created.

SQL> 
SQL> create or replace view Page_Data as
  2  select pname, entry_count, exit_count from pages where deleteflag = 0;

View created.

SQL> 
SQL> 
SQL> create or replace view Page_With_Highest_Entry as
  2  select pname from pages where entry_count = (select max(entry_count) from pages where deleteflag = 0) and deleteflag = 0;

View created.

SQL> 
SQL> create or replace view Link_Data as
  2  select pfrom, pto, count from links;

View created.

SQL> 
SQL> select * from Users_On_Each_Page;

PNA UNA                                                                         
--- ---                                                                         
p03 u01                                                                         
p04 u02                                                                         
p03 u03                                                                         
p05 u04                                                                         
p01 u09                                                                         

SQL> select * from Users_Visits;

UNA ACCESS_COUNT                                                                
--- ------------                                                                
u01            2                                                                
u02            1                                                                
u03            1                                                                
u04            1                                                                
u07            1                                                                
u08            1                                                                
u09            1                                                                

7 rows selected.

SQL> select * from Largest_Visits;

UNA                                                                             
---                                                                             
u01                                                                             

SQL> select * from Page_Data;

PNA ENTRY_COUNT EXIT_COUNT                                                      
--- ----------- ----------                                                      
p01           2          1                                                      
p02           1          0                                                      
p03           2          0                                                      
p04           0          0                                                      
p05           2          1                                                      
p07           1          1                                                      
p08           0          0                                                      
p09           0          0                                                      

8 rows selected.

SQL> select * from Page_With_Highest_Entry;

PNA                                                                             
---                                                                             
p01                                                                             
p03                                                                             
p05                                                                             

SQL> select * from Link_Data;

PFR PTO      COUNT                                                              
--- --- ----------                                                              
p01 p03          0                                                              
p02 p03          1                                                              
p03 p04          1                                                              

SQL> spool off;
