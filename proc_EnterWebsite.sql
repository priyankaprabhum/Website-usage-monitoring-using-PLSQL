set serveroutput on size 1000000 format wrap
create or replace procedure proc_EnterWebsite (user_name in users.uname%type, page_name in users.pname%type)
			
 			as appcount number;
                                    
begin
     	--check page exists and is not deleted in table pages
	select COUNT(*) into appcount from pages where page_name=pname and deleteflag=0;
	if appcount=1 then
		--if user doesnot exists, insert in table Users
     		select COUNT(*) into appcount from users where user_name=uname;
     		if appcount=0 then 	
			insert into users values (user_name, page_name, 1);
			update pages set entry_count = entry_count+1 where pname = page_name;
	   		dbms_output.put_line('User added.');	
     		else
			--if user exists and is inactive, update the existing record
			select COUNT(*) into appcount from users where user_name=uname and pname is null;
			if appcount=1 then
				update users set pname = page_name, access_count = access_count+1 where user_name=uname;
	 			update pages set entry_count = entry_count+1 where pname = page_name;
				dbms_output.put_line('User activated and entered page '|| page_name);
			else
				dbms_output.put_line('User already present.');
			end if;
		end if;
	else
		dbms_output.put_line('Page doesnot exists.');
         		
     end if;
end;
/
show errors;