set serveroutput on size 1000000 format wrap
create or replace procedure proc_Move (user_name in users.uname%type, page_from in links.pfrom%type, page_to in links.pto%type)			
 			as appcount number;
begin
     select COUNT(*) into appcount from users where user_name = uname;
     if appcount = 1 then
	select COUNT(*) into appcount from users where user_name = uname and page_from = pname;
	if appcount = 1 then
		select COUNT(*) into appcount from links where pfrom = page_from and pto = page_to;
      		if appcount = 1 then 
	        	update links set count = count + 1 where pfrom = page_from and pto = page_to;
			update users set pname = page_to where user_name = uname;
			dbms_output.put_line('User moved from '|| page_from || ' to ' || page_to);
		else
			dbms_output.put_line('Link doesnot exists.');
      		end if;
	else
		dbms_output.put_line('User is inactive or is on some other page.');
        end if;  
     else
	dbms_output.put_line('User doesnot exists is users table.');         		
     end if;
end;
/
show errors;