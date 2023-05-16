

SELECT j.[name] AS 'JobName',
Enabled = CASE
WHEN j.enabled = 0 THEN 'No'
ELSE 'Yes'
END,
l.[name] AS 'OwnerName'
FROM   msdb.dbo.sysjobs j
INNER JOIN master.dbo.syslogins l
ON j.owner_sid = l.sid
ORDER  BY j.[name]

SET nocount ON

SELECT 'EXEC MSDB.dbo.sp_update_job ' + Char(13)
+ '@job_name = ' + Char(39) + j.[name] + Char(39)
+ ',' + Char(13) + '@owner_login_name = '
+ Char(39) + 'Account Name' + Char(39) + Char(13) + Char(13)
FROM   msdb.dbo.sysjobs j
INNER JOIN master.dbo.syslogins l
ON j.owner_sid = l.sid
--WHERE  l.[name] <> 'sa'
ORDER  BY j.[name]