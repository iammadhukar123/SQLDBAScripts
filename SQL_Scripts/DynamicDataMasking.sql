
--Dynamic Data Masking:
/*
https://learn.microsoft.com/en-us/azure/azure-sql/database/dynamic-data-masking-overview?view=azuresql
*/


SELECT c.name, tbl.name as table_name, c.is_masked, c.masking_function
FROM sys.masked_columns AS c
JOIN sys.tables AS tbl
    ON c.[object_id] = tbl.[object_id]
WHERE is_masked = 1; 

--Test Table:
CREATE TABLE [dbo].[Madhu_TestTable](
	[Name] [varchar](50) MASKED WITH (FUNCTION = 'partial(0, "xxxx-xxxx-xxxx-", 4)') NULL,
	[DOB] [date] NULL,
	[Email] [varchar](50) MASKED WITH (FUNCTION = 'email()') NULL
) ON [PRIMARY]
GO

alter table Madhu_TestTable
alter column DOB ADD MASKED WITH (FUNCTION = 'default()')

create user TestUser_RO without login
alter role db_datareader add member TestUser_RO

execute as user = 'TestUser_RO'
select * from Madhu_TestTable
REVERT;

--Grant column level UNMASK permission to TestUser_RO
GRANT UNMASK ON [dbo].[Madhu_TestTable]([Name]) TO TestUser_RO;

execute as user = 'TestUser_RO'
select * from Madhu_TestTable
REVERT;
--Madhukar Rajanaku	1900-01-01	mXXX@XXXX.com

REVOKE UNMASK ON [dbo].[Madhu_TestTable]([Name]) TO TestUser_RO;

execute as user = 'TestUser_RO'
select * from Madhu_TestTable
REVERT;
--xxxx-xxxx-xxxx-naku	1900-01-01	mXXX@XXXX.com

--
alter role dbreader_unmasked add member TestUser_RO

GRANT UNMASK TO dbreader_unmasked;

execute as user = 'TestUser_RO'
select * from Madhu_TestTable
REVERT;

alter role db_datareader drop member TestUser_RO

execute as user = 'TestUser_RO'
select * from Madhu_TestTable
REVERT;
--The SELECT permission was denied on the object 'Madhu_TestTable', database 'fusionprod', schema 'dbo'.

GRANT SELECT TO dbreader_unmasked

execute as user = 'TestUser_RO'
select * from Madhu_TestTable
REVERT;

--
create role dbreader_masked

GRANT SELECT TO dbreader_masked

alter role db_datareader drop member TestUser_RO
alter role dbreader_unmasked drop member TestUser_RO

alter role dbreader_masked add member TestUser_RO

execute as user = 'TestUser_RO'
select * from Madhu_TestTable
REVERT;

SELECT
  name,
  principal_id,
  type,
  type_desc,
  owning_principal_id
FROM sys.database_principals

select * from sys.database_role_members