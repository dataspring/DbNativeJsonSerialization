USE [Comments]
GO
	
/****** Object:  UserDefinedFunction [dbo].[GetTicks]    Script Date: 11/15/2017 4:51:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



CREATE FUNCTION [dbo].[GetTicks]
()
RETURNS BIGINT
AS
BEGIN

	DECLARE @date datetime, @ticksPerDay bigint
	set @date = getdate()
	set @ticksPerDay = 864000000000

	declare @date2 datetime2 = @date

	declare @dateBinary binary(9) = cast(reverse(cast(@date2 as binary(9))) as binary(9))
	declare @days bigint = cast(substring(@dateBinary, 1, 3) as bigint)
	declare @time bigint = cast(substring(@dateBinary, 4, 5) as bigint)
	
    RETURN @days * @ticksPerDay + @time

END
GO
/****** Object:  UserDefinedFunction [dbo].[Random_Date]    Script Date: 11/15/2017 4:51:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE function [dbo].[Random_Date] ( @fromDate smalldatetime, @toDate smalldatetime) returns smalldatetime
as
begin

 declare @days_between int
 declare @days_rand int

 set @days_between = datediff(day,@fromDate,@toDate)
 select @days_rand  = CAST(v.rndResult * 10000 AS INT) % @days_between from rndView v

 --set @days_rand  = cast(RAND()*10000 as int)  % @days_between

 return dateadd( day, @days_rand, @fromDate )
end
GO
/****** Object:  UserDefinedFunction [dbo].[Random_Range]    Script Date: 11/15/2017 4:51:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION  [dbo].[Random_Range](@start int, @end int)

RETURNS int

AS

BEGIN
  
	DECLARE @rndValue float;

	SELECT @rndValue = rndResult
	FROM rndView;

	return @start + @rndValue * (@end - @start + 1)

END
GO
/****** Object:  UserDefinedFunction [dbo].[Random_Range_With_Default]    Script Date: 11/15/2017 4:51:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE FUNCTION  [dbo].[Random_Range_With_Default](@start int, @end int, @ValMost int, @ValMostTimes int = 0)

RETURNS int

AS

BEGIN

	DECLARE @rndValue float, @RetValue int, @startIns int, @endIns int, @i int = 0;
	DECLARE @randTable table (id int IDENTITY(0,1), RangeVal int)


	Select @endIns = @end, @startIns = @start

	if (@start < 0 and @end > 0)
	BEGIN
		Select @endIns = @end + -1 * @start, @startIns = 0
		--SET @ValMost = @ValMost + -1 * @start
	END

    IF  @ValMostTimes = 0
		BEGIN
		
			SELECT @rndValue = rndResult
			FROM rndView;
			if (@start < 0 and @end > 0)
				BEGIN
					SET @RetValue = @startIns + @rndValue * (@endIns - @startIns + 1)
					SET @RetValue = @RetValue - (-1 * @start)
				END
			ELSE
				BEGIN
					SET @RetValue = @start + @rndValue * (@end - @start + 1)
				END
		END
	ELSE
		BEGIN
			
			SELECT @rndValue = rndResult
			FROM rndView;

			IF @rndValue * 10 <= @ValMostTimes
				BEGIN
					SET @RetValue =  @ValMost;
				END
			ELSE
				BEGIN
					SELECT @rndValue = rndResult
					FROM rndView;

					if (@start < 0 and @end > 0)
						BEGIN
							SET @RetValue = @startIns + @rndValue * (@endIns - @startIns + 1)
							SET @RetValue = @RetValue - (-1 * @start)
						END
					ELSE
						BEGIN
							SET @RetValue = @start + @rndValue * (@end - @start + 1)
						END
				END
			END

	return @RetValue

END
GO
/****** Object:  View [dbo].[RndView]    Script Date: 11/15/2017 4:51:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE VIEW [dbo].[RndView]
AS
SELECT RAND() rndResult
GO



USE [Comments]
GO

GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Comments_CourseComType_Include]    Script Date: 11/15/2017 4:55:01 PM ******/
CREATE NONCLUSTERED INDEX [IX_Comments_CourseComType_Include] ON [dbo].[Comments]
(
	[CourseId] ASC,
	[CommentType] ASC
)
INCLUDE ( 	[Rating],
	[Title],
	[Remarks],
	[CreatedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Comments_CourseComTypeParentId_Include]    Script Date: 11/15/2017 4:55:01 PM ******/
CREATE NONCLUSTERED INDEX [IX_Comments_CourseComTypeParentId_Include] ON [dbo].[Comments]
(
	[CourseId] ASC,
	[CommentType] ASC,
	[ParentId] ASC
)
INCLUDE ( 	[UserId],
	[Title],
	[Remarks],
	[CreatedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Comments_CourseUserComType_Include]    Script Date: 11/15/2017 4:55:01 PM ******/
CREATE NONCLUSTERED INDEX [IX_Comments_CourseUserComType_Include] ON [dbo].[Comments]
(
	[CourseId] ASC,
	[UserId] ASC,
	[CommentType] ASC
)
INCLUDE ( 	[Rating],
	[Title],
	[Remarks],
	[CreatedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_CommentSnapShots_CourseComType]    Script Date: 11/15/2017 4:55:01 PM ******/
CREATE NONCLUSTERED INDEX [IX_CommentSnapShots_CourseComType] ON [dbo].[CommentSnapShots]
(
	[CourseId] ASC,
	[CommentType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_CommentSnapShots_CourseUserComType]    Script Date: 11/15/2017 4:55:01 PM ******/
CREATE NONCLUSTERED INDEX [IX_CommentSnapShots_CourseUserComType] ON [dbo].[CommentSnapShots]
(
	[CourseId] ASC,
	[UserId] ASC,
	[CommentType] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
/****** Object:  Index [IX_CommentSnapShots_LastUpdate]    Script Date: 11/15/2017 4:55:01 PM ******/
CREATE NONCLUSTERED INDEX [IX_CommentSnapShots_LastUpdate] ON [dbo].[CommentSnapShots]
(
	[LastUpdate] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
SET ANSI_PADDING ON

GO
/****** Object:  Index [IX_Replies_CourseComTypeComId_Include]    Script Date: 11/15/2017 4:55:01 PM ******/
CREATE NONCLUSTERED INDEX [IX_Replies_CourseComTypeComId_Include] ON [dbo].[Replies]
(
	[CourseId] ASC,
	[CommentType] ASC,
	[CommentId] ASC
)
INCLUDE ( 	[UserId],
	[Title],
	[Remarks],
	[CreatedDate]) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
GO
