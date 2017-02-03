set serveroutput on;

execu proc_AddPage('p01');
execu proc_AddPage('p01');
execu proc_AddPage('p02');
execu proc_AddPage('p03');
execu proc_AddPage('p04');
execu proc_AddPage('p05');
execu proc_AddPage('p06');
execu proc_AddPage('p07');
execu proc_AddPage('p08');
execu proc_AddPage('p09');
execu proc_RemovePage('p05');
execu proc_AddPage('p05');
execu proc_RemovePage('p06');

execu proc_RemoveLink('p01','p02');
execu proc_AddLink('p10','p02');
execu proc_AddLink('p01','p02');
execu proc_AddLink('p01','p03');
execu proc_AddLink('p02','p03');
execu proc_AddLink('p03','p04');
execu proc_AddLink('p06','p07');
execu proc_RemoveLink('p01','p02');

execu proc_EnterWebsite('u01','p01');
execu proc_EnterWebsite('u02','p02');
execu proc_EnterWebsite('u03','p03');
execu proc_EnterWebsite('u01','p02');
execu proc_EnterWebsite('u04','p05');
execu proc_EnterWebsite('u05','p06');
execu proc_EnterWebsite('u06','p06');
execu proc_EnterWebsite('u07','p05');
execu proc_EnterWebsite('u08','p07');
execu proc_EnterWebsite('u09','p01');

execu proc_ExitWebsite('u01');
execu proc_ExitWebsite('u07');
execu proc_ExitWebsite('u08');
execu proc_EnterWebsite('u01','p03');
execu proc_Move('u01','p01','p02');
execu proc_Move('u02','p02','p03');
execu proc_Move('u02','p03','p04');
execu proc_Move('u05','p06','p07');
execu proc_Move('u06','p06','p07');
