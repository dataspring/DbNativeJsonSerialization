USE [Comments]
GO

/****** Object:  StoredProcedure [dbo].[GetComments]    Script Date: 11/15/2017 9:11:50 PM ******/
DROP PROCEDURE [dbo].[GetComments]
GO

/****** Object:  StoredProcedure [dbo].[GetComments]    Script Date: 11/15/2017 9:11:50 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO




CREATE PROC [dbo].[GetComments] (
	 @RatingType NVARCHAR(20)
	,@CourseId INT = null
	,@UserId INT = null
	,@Skip INT = 0
	,@Size INT = 20
	,@SkipThread INT = 0
	,@SizeThread INT = 10
	)
AS
SELECT u.displayName
	,c.courseId
	--,c.UserId
	,c.commentType
	,c.lastTitle
	,c.lastRating
	,c.lastRemarks
	,c.lastUpdate
	,c.lastCommentId
	----------------------------
	,(
		SELECT t.commentId
			,t.title
			,t.rating
			,t.remarks
			,t.createdDate
			---------------------------------
			,(
				SELECT r.commentId
					,(Select top 1 displayName from Users usr where usr.UserId = r.UserId) as displayName 
					,r.title
					,r.remarks
					,r.createdDate
				FROM Comments AS r
				WHERE r.CourseId = t.CourseId
					--AND r.UserId = t.UserId
					AND r.CommentType = t.CommentType + 'Reply'
					AND r.ParentId = t.CommentId
				FOR JSON PATH, INCLUDE_NULL_VALUES
				) AS reply
		----------------------------------
		FROM Comments AS t
		WHERE t.CourseId = c.CourseId
			AND t.UserId = c.UserId
			AND t.CommentType = c.CommentType
			--AND t.ParentId = 0
		ORDER BY t.CreatedDate DESC
		OFFSET @SkipThread ROWS
		FETCH NEXT @SizeThread ROWS ONLY
		FOR JSON PATH, INCLUDE_NULL_VALUES
		) AS thread
---------------------------
FROM CommentSnapShots AS c
INNER JOIN Users AS u ON c.UserId = u.UserId
WHERE c.CourseId = @CourseId
	--AND c.UserId = @UserId
	AND c.CommentType = @RatingType
ORDER BY c.LastUpdate DESC 
OFFSET @Skip ROWS
FETCH NEXT @Size ROWS ONLY
FOR JSON PATH, INCLUDE_NULL_VALUES



GO


