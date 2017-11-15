Insert into [Comments].[dbo].[Users]
([DisplayName]
      ,[FirstName]
      ,[LastName]
      ,[Uuid]
      ,[Email]
      ,[UserName]
      ,[LastUpdated])

SELECT 
	   [GivenName] + ' ' + [SurName]
      ,[GivenName]
      ,[SurName]
      ,[CustomerGuid]
      ,c.[Email]
      ,Isnull([UserName], c.[Email])
	  ,getdate()
  FROM [BigTestData].[Retail].[Customer] c inner join 
  (Select Email, count(*) as cna from [BigTestData].[Retail].[Customer]
  GROUP BY Email
  HAVING count(*) = 1) a on c.Email = a.Email