 USE ReportServer$MSSQLSERVER2016

 SELECT * FROM dbo.Users
 
 DECLARE @OldUserID uniqueidentifier
 DECLARE @NewUserID uniqueidentifier
 SELECT @OldUserID =UserID FROM dbo.Users WHERE UserID ='HQ\abc'
 SELECT  @NewUserID=UserID FROM dbo.Users WHERE UserName = 'HQ\def'
 UPDATE dbo.Subscriptions SET OwnerID = @NewUserID WHERE OwnerID = @OldUserID

  UPDATE dbo.Subscriptions SET OwnerID = ''