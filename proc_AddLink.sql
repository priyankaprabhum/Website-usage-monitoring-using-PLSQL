set serveroutput on size 1000000 format wrap
create or replace procedure proc_AddLink (page_from in links.pfrom%type, 
page_to in links.pto%type) as appcount number;

begin
select COUNT(*) into appcount from pages where page_from = pname and deleteflag = 0;
if appcount = 1 then
  select COUNT(*) into appcount from pages where page_to = pname and deleteflag = 0;
  if appcount = 1 then
    select COUNT(*) into appcount from links where page_from = pfrom and page_to = pto;
    if appcount = 0 then 
        insert into links values(page_from, page_to, 0);
	dbms_output.put_line('The link is added');
    else
       dbms_output.put_line('The link already exists.');
    end if;  
  else
    dbms_output.put_line('Page doesnot exists in table Pages or is deleted.');
  end if;
else
    dbms_output.put_line('Page doesnot exists in table Pages or is deleted.');
end if;
end;
 /
show errors;