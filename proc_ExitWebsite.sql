set serveroutput on size 1000000 format wrap
create or replace procedure proc_ExitWebsite (user_name in users.uname%type)			
 			as appcount number;
      temp number(10);                              
begin     
     select COUNT(*) into appcount from users where uname = user_name;
     if appcount>0 then
     	select COUNT(*) into appcount from users where user_name = uname and pname is null;
     	if appcount=0 then 
		update pages set exit_count = exit_count+1 where pname in(select pname from users where uname=user_name);		
		update users set pname = null where uname = user_name;
		dbms_output.put_line('User exited the website.');
     	else
		dbms_output.put_line('User doesnot exists or has already exited the website.');
	end if;
      else
		dbms_output.put_line('User doesnot exists');   		
     end if;
end;
/
show errors;