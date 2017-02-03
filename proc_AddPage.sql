create or replace procedure proc_AddPage (page_name in pages.pname%type)
                                     as
     appcount number;

begin
     select COUNT(*) into appcount from pages where page_name = pname;
      if appcount = 0 then 
           insert into pages values(page_name, 0, 0, 0);
      else
	   select COUNT(*) into appcount from pages where page_name = pname and deleteflag = 1;
	   if appcount = 1 then
		update pages set deleteflag = 0 where pname = page_name;
		dbms_output.put_line('The page has been reactivated.');
	   else
           	dbms_output.put_line('The page is already in the table Pages.');
	   end if;
      end if;
end;
/
show errors;