IF OBJECT_ID('dbo.AdarshTest') IS NOT NULL
	drop procedure AdarshTest
GO
CREATE PROCEDURE dbo.AdarshTest
/*
	This Stored Procedure to backup db.	
*/
@Location varchar(255) ='C:\temp\'
AS
/*
	BEGINSAMPLE
	EXEC [dbo].[AdarshTest] @Location='c:\temp'
	ENDSAMPLE	
*/
SET NOCOUNT ON;
BEGIN TRY	

	Declare @SqlCmd nvarchar(4000),
		@MinID int,
		@MaxID int,
		@DBName varchar(500),
		@FinalMessage varchar(max),
		@ErrorMessage varchar(max),
		@Error int
	Declare @DBList Table 
	(
		ID int,		
		Name varchar(500)
		)

		
	INSERT @DBList
	(
		ID,
		Name
		)		
	SELECT 
		database_id,
		name
	FROM sys.databases
	WHERE state_desc='Online'	
		AND source_database_id is null
		AND database_id <>2

	SELECT
		 @MinId = MIN(ID) ,
		 @MaxId = MAX(ID)
	FROM 
		@DBList 

	WHILE (@MinID <=@MaxID)
	BEGIN
		SELECT 
			@DBName = 	Name
		FROM @DBList
		WHERE ID =@MinID
	
		
		
		SET @SqlCmd = 'Backup Database ' + '['+ @DBName + ']' +  ' to disk =' +''''+ @Location + '.bak''' + ' with init;'

		print @SqlCmd
		Exec sp_Executesql @SqlCmd
	
		
		SELECT 
			@MinId = MIN(ID)
		FROM @DBList
		WHERE ID>@MinID
		
			
	END


END TRY
BEGIN CATCH
	--Raise any error messages	
  SET @FinalMessage = 'DateTime: ' + CONVERT(varchar,GETDATE(),120)
  SET @FinalMessage = REPLACE(@FinalMessage,'%','%%')
  SELECT @FinalMessage = @FinalMessage +' ' + ISNULL(ERROR_PROCEDURE(), '') + ' line:' 
                           + CAST(ISNULL(ERROR_LINE(), '') as varchar(5)) + ':' +' ' 
                           + ISNULL(ERROR_MESSAGE(), '')                      
                      
  RAISERROR(@FinalMessage,16,1) WITH NOWAIT

END CATCH


GO
EXEC [dbo].[AdarshTest] @Location='c:\temp'
go
