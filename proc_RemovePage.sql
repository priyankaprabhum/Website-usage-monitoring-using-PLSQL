set serveroutput on size 1000000 format wrap
create or replace procedure proc_RemovePage (page_name in pages.pname%type)			
 			as appcount number;                                    
begin     
     select COUNT(*) into appcount from pages where page_name = pname and deleteflag = 0;
     if appcount = 1 then 
		update users set pname = null where pname = page_name;
		delete links where pfrom = page_name or pto = page_name;
		update pages set deleteflag = 1 where pname = page_name;	
		dbms_output.put_line('Page ' || page_name || ' is deleted');	
		
     else
		dbms_output.put_line('Page is already deleted or doesnot exists.');
         		
     end if;
end;
/
show errors;