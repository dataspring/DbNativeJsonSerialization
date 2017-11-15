
CREATE Database Comments
Go
USE [Comments]
GO
/****** Object:  Table [dbo].[Comments]    Script Date: 11/15/2017 4:45:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Comments](
	[CommentId] [int] IDENTITY(1,1) NOT NULL,
	[ParentId] [int] NULL,
	[UserId] [int] NOT NULL,
	[CourseId] [int] NULL,
	[ProviderId] [int] NULL,
	[CommentType] [nvarchar](20) NOT NULL,
	[Rating] [int] NOT NULL,
	[Title] [nvarchar](256) NULL,
	[Remarks] [nvarchar](2048) NULL,
	[IsFlagged] [bit] NULL,
	[StarterCommentId] [int] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[LastUpdate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Comments] PRIMARY KEY CLUSTERED 
(
	[CommentId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[CommentSnapShots]    Script Date: 11/15/2017 4:45:53 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[CommentSnapShots](
	[SnapShotId] [int] IDENTITY(1,1) NOT NULL,
	[CourseId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[CommentType] [nvarchar](20) NOT NULL,
	[FirstCommentId] [int] NOT NULL,
	[FirstTitle] [nvarchar](256) NULL,
	[FirstRemarks] [nvarchar](2048) NULL,
	[FirstRating] [int] NOT NULL,
	[LastCommentId] [int] NOT NULL,
	[LastTitle] [nvarchar](256) NULL,
	[LastRemarks] [nvarchar](2048) NULL,
	[LastRating] [int] NOT NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[LastUpdate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_CommentSnapShot] PRIMARY KEY CLUSTERED 
(
	[SnapShotId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[Courses]    Script Date: 11/15/2017 4:45:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Courses](
	[CourseId] [int] IDENTITY(1000,1) NOT NULL,
	[ProviderId] [int] NOT NULL,
	[Description] [nvarchar](256) NULL,
	[LastUpdate] [datetime] NOT NULL,
 CONSTRAINT [PK_Courses] PRIMARY KEY CLUSTERED 
(
	[CourseId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[Replies]    Script Date: 11/15/2017 4:45:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Replies](
	[ReplyId] [int] IDENTITY(1,1) NOT NULL,
	[CommentId] [int] NOT NULL,
	[UserId] [int] NOT NULL,
	[CourseId] [int] NULL,
	[ProviderId] [int] NULL,
	[CommentType] [nvarchar](20) NOT NULL,
	[Title] [nvarchar](256) NULL,
	[Remarks] [nvarchar](2048) NULL,
	[IsFlagged] [bit] NULL,
	[CreatedDate] [datetime2](7) NOT NULL,
	[LastUpdate] [datetime2](7) NOT NULL,
 CONSTRAINT [PK_Replies] PRIMARY KEY CLUSTERED 
(
	[ReplyId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[sysdiagrams]    Script Date: 11/15/2017 4:45:55 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[sysdiagrams](
	[name] [sysname] NOT NULL,
	[principal_id] [int] NOT NULL,
	[diagram_id] [int] IDENTITY(1,1) NOT NULL,
	[version] [int] NULL,
	[definition] [varbinary](max) NULL,
PRIMARY KEY CLUSTERED 
(
	[diagram_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON),
 CONSTRAINT [UK_principal_name] UNIQUE NONCLUSTERED 
(
	[principal_id] ASC,
	[name] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
/****** Object:  Table [dbo].[Users]    Script Date: 11/15/2017 4:45:56 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Users](
	[UserId] [int] IDENTITY(90,1) NOT NULL,
	[DisplayName] [nvarchar](100) NULL,
	[FirstName] [nvarchar](100) NULL,
	[LastName] [nvarchar](100) NULL,
	[Uuid] [uniqueidentifier] NOT NULL,
	[Email] [nvarchar](256) NOT NULL,
	[UserName] [nvarchar](256) NOT NULL,
	[LastUpdated] [datetime] NOT NULL,
 CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED 
(
	[UserId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON)
)

GO
ALTER TABLE [dbo].[Comments] ADD  CONSTRAINT [DF_Comments_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Comments] ADD  CONSTRAINT [DF_Comments_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
ALTER TABLE [dbo].[CommentSnapShots] ADD  CONSTRAINT [DF_CommentSnapShots_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[CommentSnapShots] ADD  CONSTRAINT [DF_CommentSnapShots_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
ALTER TABLE [dbo].[Replies] ADD  CONSTRAINT [DF_Replies_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Replies] ADD  CONSTRAINT [DF_Replies_LastUpdate]  DEFAULT (getdate()) FOR [LastUpdate]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_LastUpdated]  DEFAULT (getdate()) FOR [LastUpdated]
GO
