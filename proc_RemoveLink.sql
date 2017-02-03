set serveroutput on size 1000000 format wrap
create or replace procedure proc_RemoveLink (page_from in links.pfrom%type, page_to in links.pto%type) as appcount number;
                                     
begin
     select COUNT(*) into appcount from links where page_from=pfrom and page_to=pto;
     if appcount = 1 then 
		delete from links where pfrom = page_from and pto = page_to;
	   	dbms_output.put_line('The link has been deleted.');
     else
           dbms_output.put_line('The link is already deleted or doesnot exists.');
      end if;
end;
/