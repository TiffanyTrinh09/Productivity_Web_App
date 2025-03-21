USE [Scheduler]
GO
/****** Object:  Table [dbo].[Event]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Event](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[Start_Date] [datetime] NULL,
	[End_Date] [datetime] NULL,
	[Category] [nvarchar](50) NULL,
	[Notification_Sent] [int] NOT NULL,
 CONSTRAINT [PK_Event] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[Task]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Task](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Description] [nvarchar](500) NULL,
	[Date] [datetime] NULL,
	[Category] [nvarchar](50) NULL,
	[Is_Completed] [int] NOT NULL,
	[Name] [nvarchar](50) NULL,
	[Color] [nvarchar](50) NULL,
	[Notification_Sent] [int] NOT NULL,
 CONSTRAINT [PK_Task] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
SET IDENTITY_INSERT [dbo].[Event] ON 

INSERT [dbo].[Event] ([Id], [Description], [Start_Date], [End_Date], [Category], [Notification_Sent]) VALUES (11, N'Friend''s Birthday', CAST(N'2025-03-15T10:00:00.000' AS DateTime), CAST(N'2025-03-15T15:30:00.000' AS DateTime), N'Party', 0)
INSERT [dbo].[Event] ([Id], [Description], [Start_Date], [End_Date], [Category], [Notification_Sent]) VALUES (12, N'Group Study', CAST(N'2025-03-14T16:25:00.000' AS DateTime), CAST(N'2025-03-14T15:25:00.000' AS DateTime), N'CS150', 1)
SET IDENTITY_INSERT [dbo].[Event] OFF
GO
SET IDENTITY_INSERT [dbo].[Task] ON 

INSERT [dbo].[Task] ([Id], [Description], [Date], [Category], [Is_Completed], [Name], [Color], [Notification_Sent]) VALUES (21, N'Find Path Constraints', CAST(N'2025-03-14T23:59:00.000' AS DateTime), N'CS180', 0, N'Homework 2', N'33FFE3', 0)
INSERT [dbo].[Task] ([Id], [Description], [Date], [Category], [Is_Completed], [Name], [Color], [Notification_Sent]) VALUES (22, N'Get Nike Shoes for Friend''s Birthday', CAST(N'2025-03-15T08:30:00.000' AS DateTime), N'Party', 0, N'Get birthday gift', N'FFDD33', 0)
SET IDENTITY_INSERT [dbo].[Task] OFF
GO
ALTER TABLE [dbo].[Event] ADD  CONSTRAINT [DF_Event_Notification_Sent]  DEFAULT ((0)) FOR [Notification_Sent]
GO
ALTER TABLE [dbo].[Task] ADD  CONSTRAINT [DF_Task_status]  DEFAULT ((0)) FOR [Is_Completed]
GO
ALTER TABLE [dbo].[Task] ADD  CONSTRAINT [DF_Task_Notification_Sent]  DEFAULT ((0)) FOR [Notification_Sent]
GO
/****** Object:  StoredProcedure [dbo].[DeleteEventInfo]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteEventInfo]
	@eventId INT
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM [Event] WHERE Id=@eventId;
END
GO
/****** Object:  StoredProcedure [dbo].[DeleteTaskInfo]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[DeleteTaskInfo]
	@taskId INT
AS
BEGIN
	SET NOCOUNT ON;
	DELETE FROM Task WHERE Id=@taskId;
END
GO
/****** Object:  StoredProcedure [dbo].[GetCompletedTasksList]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCompletedTasksList] 
	@displayTypeId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		id,
		description,
		date,
		category,
		name,
		color
	FROM Task
	WHERE 
		is_completed = 1
END
GO
/****** Object:  StoredProcedure [dbo].[GetEventInfo]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetEventInfo]
	@eventId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		vv.Id AS id,
		vv.Description AS description,
		vv.Start_date AS startDate,
		vv.End_date AS endDate,
		vv.Category AS category
	FROM
		Event vv
	WHERE
		vv.Id=@eventId;
END
GO
/****** Object:  StoredProcedure [dbo].[GetEventList]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetEventList] -- get events for that day/week/month
	@displayTypeId INT --view type: day/week/month
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@displayTypeId = 0)
	BEGIN
		SELECT 
			Id AS id,
			Description AS description,
			Start_Date AS startDate,
			End_Date AS endDate,
			Category AS category
		FROM
			Event
	END
	ELSE IF (@displayTypeId = 1)
	BEGIN
		SELECT 
			Id AS id,
			Description AS description,
			Start_Date AS startDate,
			End_Date AS endDate,
			Category AS category
		FROM
			Event
		WHERE
			CONVERT(DATE, Start_Date) = CONVERT(DATE, GETDATE())
	END
END
GO
/****** Object:  StoredProcedure [dbo].[GetEventReminder]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetEventReminder]
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		ee.Id,
		ee.Description,
		ee.Start_Date,
		ee.End_Date,
		ee.Category

	FROM Event ee
	WHERE
		ee.Notification_Sent=0
		AND DATEDIFF(MINUTE,SYSDATETIME(),Start_Date) > 0 AND DATEDIFF(MINUTE,SYSDATETIME(),Start_Date) < 5
END
GO
/****** Object:  StoredProcedure [dbo].[GetTaskInfo]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTaskInfo]
	@taskId INT
AS
BEGIN
	SET NOCOUNT ON;

	SELECT 
		vv.Id AS id,
		vv.Description AS description,
		vv.color AS color,
		vv.date AS date,
		vv.is_completed AS isCompleted,
		vv.name AS name,
		vv.Category As category
	FROM
		Task vv
	WHERE
		vv.Id=@taskId;
END
GO
/****** Object:  StoredProcedure [dbo].[GetTaskList]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTaskList] 
	@displayTypeId INT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@displayTypeId = 0)
	BEGIN
		SELECT 
			Id AS id,
			Description AS description,
			Date AS date,
			Category AS category,
			Is_Completed AS isCompleted,
			Name AS name,
			Color AS color
		FROM
			Task
	END
	ELSE IF (@displayTypeId = 1)
	BEGIN
		SELECT 
			Id AS id,
			Description AS description,
			Date AS date,
			Category AS category,
			Is_Completed AS isCompleted,
			Name AS name,
			Color AS color
		FROM
			Task
		WHERE
			CONVERT(DATE, Date) = CONVERT(DATE, GETDATE())
	END
END
GO
/****** Object:  StoredProcedure [dbo].[GetTaskReminder]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTaskReminder]
	
AS
BEGIN
	SET NOCOUNT ON;

	SELECT
		tt.Id,
		tt.Description,
		tt.Date,
		tt.Category,
		tt.Color,
		tt.Is_Completed,
		tt.Name

	FROM Task tt
	WHERE
		tt.Notification_Sent=0
		AND tt.Is_Completed=0
		AND DATEDIFF(MINUTE,SYSDATETIME(),tt.Date) > 0 AND DATEDIFF(MINUTE,SYSDATETIME(),tt.Date) < 5
END
GO
/****** Object:  StoredProcedure [dbo].[GetTasksStatistics]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetTasksStatistics] 
	@displayTypeId INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here

	SELECT 
		SUM(is_completed) AS Completed_Count,
		COUNT(*) AS Total_Count
	FROM Task tt
	WHERE 
		tt.date ='';
END
GO
/****** Object:  StoredProcedure [dbo].[SaveEventInfo]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveEventInfo] 
	-- Add the parameters for the stored procedure here
	@eventId int,
	@category nvarchar(50),
	@description nvarchar(50),
	@startDate DateTime,
	@endDate DateTime

AS
BEGIN
	SET NOCOUNT ON;

	IF (EXISTS (SELECT * FROM Event WHERE Id=@eventId))
		BEGIN
			UPDATE Event
			SET
				description=@description,
				category=@category,
				start_date=@startDate,
				end_date=@endDate
			WHERE Id=@eventId
		END
	ELSE
		BEGIN
			INSERT INTO Event (description, category, start_date, end_date)
			VALUES (@description, @category, @startDate, @endDate)
		END
END
GO
/****** Object:  StoredProcedure [dbo].[SaveTaskInfo]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SaveTaskInfo] 
	-- Add the parameters for the stored procedure here
	@taskId int,
	@category nvarchar(50),
	@description nvarchar(50),
	@completionStatus int,
	@date DateTime,
	@name nvarchar(50),
	@color nvarchar(50)

AS
BEGIN
	SET NOCOUNT ON;

	IF (EXISTS (SELECT * FROM Task WHERE Id=@taskId))
		BEGIN
			UPDATE Task
			SET
				description=@description,
				category=@category,
				date=@date,
				is_completed=@completionStatus,
				name=@name,
				color=@color
			WHERE Id=@taskId
		END
	ELSE
		BEGIN
			INSERT INTO Task (description, category, date, is_completed, name, color)
			VALUES (@description, @category, @date, @completionStatus, @name, @color)
		END
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateEventReminder]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
Create PROCEDURE [dbo].[UpdateEventReminder]
	@eventId INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE Event 
	SET Notification_Sent=1
	WHERE Id = @eventId
END
GO
/****** Object:  StoredProcedure [dbo].[UpdateTaskReminder]    Script Date: 3/14/2025 4:47:46 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[UpdateTaskReminder]
	@taskId INT
AS
BEGIN
	SET NOCOUNT ON;

	UPDATE Task 
	SET Notification_Sent=1
	WHERE Id = @taskId
END
GO
