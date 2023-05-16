

USE ReportServer$MSSQLSERVER2016

SELECT 
    S.[SubscriptionID]
    ,C.[Name] + ' (' + S.[Description] + ')' AS [DisplayName]
FROM [dbo].[Subscriptions] S
INNER JOIN [dbo].[Catalog] C ON S.[Report_OID] = C.[ItemID]
ORDER BY [DisplayName]

USE ReportServer$MSSQLSERVER2016
exec dbo.AddEvent 
    @EventType='TimedSubscription', 
    @EventData='64A3B73D-5628-47B2-B174-9ADBB49232BE'