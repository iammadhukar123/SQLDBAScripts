

USE ReportServer
GO
SELECT Path, 
  Name
FROM dbo.Catalog
WHERE Type = 2
Order by Path

SELECT
   cat.TYPE,
   cat.Name,  
   cat.Path  
FROM  ReportServer..Catalog AS cat (NOLOCK)
WHERE TYPE = 1 --folders only
AND ISNULL(cat.Name, '') <> ''
ORDER BY path  