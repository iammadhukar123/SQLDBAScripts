SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE proc [dbo].[sp_DBBackup]
--exec sp_DBBackup
as
declare @DBString varchar(max),
@DelString varchar(400),
@FinalBackup varchar(max),
@dbnAME VARCHAR (max),
@MonthlyFolde varchar(500),
@DailyFolderName varchar(500),
@CreateFolder varchar(2000),
@CopyCommand varchar(500),
@destination varchar(200),
@DatabaseName varchar(50)
declare CursorName cursor for
SELECT name FROM sys.databases WHERE name IN ('emiPAC')
open CursorName

Fetch NEXT FROM CursorName into @DatabaseName
WHILE @@FETCH_STATUS = 0
BEGIN
set @MonthlyFolde = DATENAME(MONTH,GETDATE()) + DATENAME(YEAR,GETDATE())
set @DailyFolderName = DATENAME(DAY,GETDATE()) + DATENAME(MONTH,GETDATE()) + DATENAME(YEAR,GETDATE())

set @CreateFolder = 'IF exist S:\DB_Backups\' + @MonthlyFolde + '\' + @DailyFolderName + ' (cd S:\DB_Backups\' + @MonthlyFolde + '\' + @DailyFolderName + ') ELSE (MKDIR S:\DB_Backups\' + @MonthlyFolde + '\' + @DailyFolderName + ')'
EXEC xp_cmdshell @CreateFolder
set @dbnAME = @DatabaseName + '_'+ CONVERT(varchar(12),GETDATE(),112) + '_' + SUBSTRING( CONVERT(varchar(12),GETDATE(),108) ,1,2) + SUBSTRING( CONVERT(varchar(12),GETDATE(),108) ,4,2) +
SUBSTRING( CONVERT(varchar(12),GETDATE(),108) ,7,2)
set @DBString = 'S:\DB_Backups\' + @MonthlyFolde + '\' + @DailyFolderName + '\' + @dbnAME
set @FinalBackup = @DBString + '.bak'
set @DelString = 'DEL ' + @FinalBackup

BACKUP DATABASE @DatabaseName TO DISK = @FinalBackup WITH COMPRESSION
-- COMPAC RAR
DECLARE @SERVER VARCHAR(100), @COMMAND VARCHAR(300), @FILE VARCHAR(100)
SET @SERVER = @@SERVERNAME
SET @COMMAND = '”S:\DB_Backups\Rar” a S:\DB_Backups\' + @MonthlyFolde + '\' + @DailyFolderName + '\' + @dbnAME + '.rar S:\DB_Backups\' + @MonthlyFolde + '\' + @DailyFolderName + '\' + @dbnAME + '.bak'

----select @COMMAND
--EXEC xp_cmdshell @COMMAND
----- EXCLUIR FILE BACKUP
--EXEC xp_cmdshell @DelString

Fetch NEXT FROM CursorName into @DatabaseName
END
CLOSE CursorName
DEALLOCATE CursorName