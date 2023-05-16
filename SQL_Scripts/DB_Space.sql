
--Database Space:
exec sys.sp_spaceused 
--EnvisionExperienceStaging	140468.00 MB	137696.26 MB	~ 140 GB

Exec Sp_spaceused @oneresultset=1

--Space used by objects:
select obj.name, sum(reserved_page_count) * 8.0 as "size in KB" ,sum(reserved_page_count) * 8.0/1048576 as "size in GB"
from sys.dm_db_partition_stats part, sys.objects obj 
where part.object_id = obj.object_id 
group by obj.name
order by 2 DESC