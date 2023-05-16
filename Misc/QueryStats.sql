

use tempdb
go

select * from sys.database_files

select * from sys.dm_os_wait_stats
where wait_type in ('PAGELATCH_SH','PAGELATCH_UP','PAGELATCH_EX')

--NO. OF DATA FILES ALIGN WITH NO. OF LOGICAL CPUS

select * from sys.dm_exec_query_stats qs
cross apply sys.dm_exec_query_plan (qs.plan_handle)
order by execution_count desc

select * from sys.dm_exec_query_plan (0x050004001230F32430BED2BAE700000001000000000000000000000000000000000000000000000000000000)

SP_CONFIGURE 'MAX SERVER MEMORY'