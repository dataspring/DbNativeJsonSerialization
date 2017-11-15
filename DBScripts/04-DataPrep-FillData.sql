	DECLARE @courseCount int = 1, @courseTotalRow int = 0, @comCount int = 1, @comTotalRow int = 0, @custCount int = 1, @custTotalRow int = 0; 
	DECLARE @startDate datetime, @endDate datetime, @createDate datetime; 
	DECLARE @ProviderId int = 11272, @CourseId int, @UserId int, @Comment NVARCHAR(300), @Title NVARCHAR(300), @Rating int
	DECLARE @commentSnapId int, @commentId int
	DECLARE @tickCount int, @tickTotal int, @tickDynaComment nvarchar(300);

	Select @courseTotalRow = 40000, @courseCount = 1 -- number of courses/provider 50,000
	WHILE @courseCount <= @courseTotalRow
	BEGIN
		--------------------- insert into course --------------------
		Insert into [dbo].[CoursesAlt]	(ProviderId, LastUpdate) Select @ProviderId, getdate()
		Update Courses Set [Description] = 'Description for Course : ' + RTRIM(CAST(SCOPE_IDENTITY() as CHAR(10))) + CAST(NEWID() AS char(36)) from Courses c where c.CourseId = SCOPE_IDENTITY()
		Select @CourseId = SCOPE_IDENTITY()

		
		Select @custTotalRow = 10, @custCount = 1
		WHILE @custCount <= @custTotalRow
		BEGIN
			SET @UserId = [dbo].[Random_Range](50200,98500)

			------------- insert 15 comments in thread for a customer ---------------------------
			Select @comTotalRow = [dbo].[Random_Range_With_Default](3, 10, 5, 3), @comCount = 1, @startDate = getdate() - 400
			WHILE @comCount <= @comTotalRow
			BEGIN
				SET @endDate = @startDate + 7 * @comCount 
				SELECT @Title = 'Comment from user : ' + CAST(@UserId AS CHAR(6)) + ' -- ' + CAST(NEWID() AS char(36)) + ' -- ' + CAST([dbo].[GetTicks]() AS CHAR(18))
				
				---------- dynamic comment length with multiple ticks appended based on random number -----------------
				Select @tickCount = 1, @tickTotal =  [dbo].[Random_Range](1,5), @tickDynaComment = ''			
				WHILE @tickCount <= @tickTotal 
				BEGIN
					@tickDynaComment = @tickDynaComment + ' tick no. ' + cast(@tickCount as Char(1)) + ' : ' + CAST([dbo].[GetTicks]() AS CHAR(18))
					SET @tickCount =  @tickCount + 1
				END
				-------------------------------------------------------------------------------------------------------

				SELECT @Comment = 'Comments as follows : ' + CAST(@UserId AS CHAR(6)) + ' -- ' + CAST(NEWID() AS char(36)) + ' -- ' + CAST([dbo].[GetTicks]() AS CHAR(18)) + ' dyna : ' + @tickDynaComment 
				

				SELECT @createDate = [dbo].[Random_Date] (@startDate, @endDate), @Rating = [dbo].[Random_Range](0,5)
				---------------- insert into comments table ---------------------------
				Insert into [dbo].[Comments]
						([UserId]
						,[CourseId]
						,[ProviderId]
						,[CommentType]
						,[Rating]
						,[Title]
						,[Remarks]
						,[IsFlagged]
						,[CreatedDate])
						Select
							@UserId
						,@CourseId 
						,@ProviderId
						,'Course'
						,@Rating
						,@Title
						,@Comment
						,0
						,@createDate

				Select @commentId = SCOPE_IDENTITY()

				---------------- insert into commentsnapshot table ---------------------------
				IF @comCount = 1
				BEGIN
					Insert into [dbo].[CommentSnapShots]
							([UserId]
							,[CourseId]
							,[CommentType]
							,[FirstCommentId]
							,[FirstTitle]
							,[FirstRemarks]
							,[FirstRating]
							,[LastCommentId]
							,[LastTitle]
							,[LastRemarks]
							,[LastRating]
							,[CreatedDate])
							Select
								@UserId
							,@CourseId 
							,'Course'
							,@commentId
							,@Title
							,@Comment
							,@Rating
							,0
							,''
							,''
							,0
							,@createDate

					Select @commentSnapId = SCOPE_IDENTITY()

				END

				---------------- Update into commentsnapshot table ---------------------------
				IF @comCount = @comTotalRow
				BEGIN
					Update [dbo].[CommentSnapShots] Set
							[LastCommentId] = @commentId
							,[LastTitle] = @Title
							,[LastRemarks] = @Comment
							,[LastRating] = @Rating
							,[LastUpdate] = @createDate
					WHERE [SnapShotId] = @commentSnapId

					--Select @commentSnapId = SCOPE_IDENTITY()

				END

				---------------- insert a reply ----------------------------

				SELECT @Title = 'Thanks for comment and reply : ' + CAST(@UserId AS CHAR(6)) + ' -- ' + CAST(NEWID() AS char(36)) + ' -- ' + CAST([dbo].[GetTicks]() AS CHAR(18))
				SELECT @Comment = 'Reply as follows : ' + CAST(@UserId AS CHAR(6)) + ' -- ' + CAST(NEWID() AS char(36)) + ' -- ' + CAST([dbo].[GetTicks]() AS CHAR(18))

				IF ([dbo].[Random_Range_With_Default](1, 8, 7, 3) = 7)
				BEGIN
				Insert into [dbo].[Comments]
						([ParentId]
						,[UserId]
						,[CourseId]
						,[ProviderId]
						,[CommentType]
						,[Rating]
						,[Title]
						,[Remarks]
						,[IsFlagged]
						,[CreatedDate])
						Select
							@commentId
						,@ProviderId
						,@CourseId 
						,null
						,'CourseReply'
						,0
						,@Title
						,@Comment
						,0
						,@createDate+1
				END
				---------------- insert a reply ends ----------------------------

				SET @comCount = @comCount + 1
				SET @startDate = @endDate
			END
			------------------------------------------------------------

			SET @custCount = @custCount + 1
		END

		SET @courseCount = @courseCount + 1
		SET @ProviderId = @ProviderId + 1
	END