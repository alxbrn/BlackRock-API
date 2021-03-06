USE [master]
GO
/****** Object:  Database [BlackRock]    Script Date: 06-04-2018 12.26.45 PM ******/
CREATE DATABASE [BlackRock]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'CodePlex', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\CodePlex.mdf' , SIZE = 4096KB , MAXSIZE = UNLIMITED, FILEGROWTH = 1024KB )
 LOG ON 
( NAME = N'CodePlex_log', FILENAME = N'C:\Program Files (x86)\Microsoft SQL Server\MSSQL11.MSSQLSERVER\MSSQL\DATA\CodePlex_log.ldf' , SIZE = 1024KB , MAXSIZE = 2048GB , FILEGROWTH = 10%)
GO
ALTER DATABASE [BlackRock] SET COMPATIBILITY_LEVEL = 110
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [BlackRock].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [BlackRock] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [BlackRock] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [BlackRock] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [BlackRock] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [BlackRock] SET ARITHABORT OFF 
GO
ALTER DATABASE [BlackRock] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [BlackRock] SET AUTO_CREATE_STATISTICS ON 
GO
ALTER DATABASE [BlackRock] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [BlackRock] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [BlackRock] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [BlackRock] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [BlackRock] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [BlackRock] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [BlackRock] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [BlackRock] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [BlackRock] SET  DISABLE_BROKER 
GO
ALTER DATABASE [BlackRock] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [BlackRock] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [BlackRock] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [BlackRock] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [BlackRock] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [BlackRock] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [BlackRock] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [BlackRock] SET RECOVERY SIMPLE 
GO
ALTER DATABASE [BlackRock] SET  MULTI_USER 
GO
ALTER DATABASE [BlackRock] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [BlackRock] SET DB_CHAINING OFF 
GO
ALTER DATABASE [BlackRock] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [BlackRock] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO
USE [BlackRock]
GO
/****** Object:  StoredProcedure [dbo].[GetAllUsers]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetAllUsers]
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT U.Id, U.FirstName, U.LastName, U.Email, R.RoleName, U.ContactNumber, U.RegisteredOn, U.IsActive
	FROM Users U
	JOIN UserRoles Ur ON U.Id = Ur.UserId
	JOIN Roles R ON R.Id = Ur.RoleId
END

GO
/****** Object:  StoredProcedure [dbo].[GetCompleteFundDetails]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetCompleteFundDetails] 
	-- Add the parameters for the stored procedure here
	@fundId bigint
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT S.Id, S.Title, St.Title [Type], Sc.Title [Category], Sp.Title [Plan], B.Title [Benchmark], Ih.Title [Investment Horizone], 
	Ig.Title [Goal], MinLumpsumAmount [Lumpsum], MinSipAmount [SIP], AUM [Asset Under Management], InceptionDate [Inception Date], 
	U.FirstName + ' ' + U.LastName [Fund Manager], U.Bio, ExpenseRatio [Expense Ratio], EntryLoad [Entry Load], ExitLoad [Exit Load], Description
	FROM Schemes S
	JOIN SchemeTypes St ON S.SchemeTypeId = st.Id
	JOIN SchemeCategories Sc ON S.SchemeCategoryId = Sc.Id
	JOIN SchemePlans Sp ON S.SchemePlanId = Sp.Id
	JOIN RiskLabels R ON S.RiskId = R.Id
	JOIN Benchmarks B ON S.BenchmarkId = B.Id
	JOIN InvestmentHorizones Ih ON S.HorizoneId = Ih.Id
	JOIN InvestmentGoals Ig ON S.GoalId = Ig.Id
	JOIN Users U ON S.FundManagerId = U.Id
	WHERE S.Id = @fundId
END

GO
/****** Object:  StoredProcedure [dbo].[GetFunds]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[GetFunds] 
	-- Add the parameters for the stored procedure here
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT S.Id, S.Title, St.Title [Type], Sc.Title [Category], Sp.Title [Plan], B.Title [Benchmark], Ih.Title [Investment Horizone], 
	Ig.Title [Goal], MinLumpsumAmount [Lumpsum], MinSipAmount [SIP], AUM [Asset Under Management], CONVERT(NVARCHAR(15),InceptionDate, 106) [Inception Date], 
	U.Id [FundManagerId], U.FirstName + ' ' + U.LastName [Fund Manager], ExpenseRatio [Expense Ratio], EntryLoad [Entry Load], ExitLoad [Exit Load], Description
	FROM Schemes S
	JOIN SchemeTypes St ON S.SchemeTypeId = st.Id
	JOIN SchemeCategories Sc ON S.SchemeCategoryId = Sc.Id
	JOIN SchemePlans Sp ON S.SchemePlanId = Sp.Id
	JOIN Risks R ON S.RiskId = R.Id
	JOIN Benchmarks B ON S.BenchmarkId = B.Id
	JOIN InvestmentHorizones Ih ON S.HorizoneId = Ih.Id
	JOIN InvestmentGoals Ig ON S.GoalId = Ig.Id
	JOIN Users U ON U.Id = S.FundManagerId
	ORDER BY Sc.Id
END


GO
/****** Object:  StoredProcedure [dbo].[ValidateUser]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[ValidateUser]
	-- Add the parameters for the stored procedure here
	@username nvarchar(30),
	@password nvarchar(30)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT U.Id, U.FirstName, U.LastName, U.Email, R.RoleName, U.ContactNumber, U.RegisteredOn, U.IsActive
	FROM Users U
	JOIN UserRoles Ur ON U.Id = Ur.UserId
	JOIN Roles R ON R.Id = Ur.RoleId
	WHERE U.Email = @username AND U.Password = @password
END

GO
/****** Object:  UserDefinedFunction [dbo].[GetNewFundEssentials]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE FUNCTION [dbo].[GetNewFundEssentials]()
RETURNS @NewFund TABLE 
(
	Id BigInt,
	Title NVARCHAR(200),
	Identifier NVARCHAR(20)	
)
AS
BEGIN
	-- Fill the table variable with the rows for your result set

	INSERT INTO @NewFund SELECT Id, Title, 'benchmark' [Benchmark] FROM Benchmarks
	INSERT INTO @NewFund SELECT Id, FirstName + ' ' + LastName [Title], 'fundmanager' [FundManager] FROM Users WHERE RoleId = (SELECT Id FROM Roles WHERE RoleName = 'FundManager')
	INSERT INTO @NewFund SELECT Id, Title, 'goal' [Goal] FROM InvestmentGoals
	INSERT INTO @NewFund SELECT Id, Title, 'horizone' [Horizone] FROM InvestmentHorizones
	INSERT INTO @NewFund SELECT Id, RiskLabel, 'risk' [Risk] FROM Risks
	INSERT INTO @NewFund SELECT Id, Title, 'category' [Category] FROM SchemeCategories
	INSERT INTO @NewFund SELECT Id, Title, 'plan' [Plan] FROM SchemePlans
	INSERT INTO @NewFund SELECT Id, Title, 'type' [Type] FROM SchemeTypes

	RETURN 
END

GO
/****** Object:  Table [dbo].[Benchmarks]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Benchmarks](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](150) NOT NULL,
 CONSTRAINT [PK_Benchmarks_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[emp]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[emp](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Surname] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_emp] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[InvestmentGoals]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvestmentGoals](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_InvestmentGoals_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[InvestmentHorizones]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[InvestmentHorizones](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_InvestmentHorizones_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Navigations]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Navigations](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
	[Url] [nvarchar](150) NOT NULL,
	[FontAwesome] [nvarchar](50) NOT NULL,
	[AssignedToUserRole] [bigint] NOT NULL,
 CONSTRAINT [PK_Navigation] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[PhysicalPaths]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PhysicalPaths](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[BaseUrl] [nvarchar](150) NULL,
	[Identifier] [nvarchar](50) NULL,
 CONSTRAINT [PK_PhysicalPaths] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Risks]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Risks](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[RiskLabel] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_Risks] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Roles]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Roles](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[RoleName] [varchar](50) NOT NULL,
 CONSTRAINT [PK_Role] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
/****** Object:  Table [dbo].[salary]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[salary](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[empId] [bigint] NOT NULL,
	[Salary] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_salary] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SchemeCategories]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SchemeCategories](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_SchemeCategories] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SchemePlans]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SchemePlans](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_SchemePlans_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Schemes]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Schemes](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](200) NOT NULL,
	[SchemeTypeId] [bigint] NOT NULL,
	[SchemeCategoryId] [bigint] NOT NULL,
	[SchemePlanId] [bigint] NOT NULL,
	[RiskId] [bigint] NOT NULL,
	[BenchmarkId] [bigint] NOT NULL,
	[HorizoneId] [bigint] NOT NULL,
	[GoalId] [bigint] NOT NULL,
	[MinLumpsumAmount] [decimal](18, 2) NOT NULL,
	[MinSipAmount] [decimal](18, 2) NOT NULL,
	[ExpenseRatio] [decimal](18, 2) NOT NULL,
	[AUM] [decimal](18, 2) NOT NULL,
	[InceptionDate] [datetime] NOT NULL,
	[EntryLoad] [decimal](18, 2) NOT NULL,
	[ExitLoad] [decimal](18, 2) NOT NULL,
	[FundManagerId] [bigint] NOT NULL,
	[Description] [nvarchar](4000) NOT NULL,
	[IsOpenEndedFund] [bit] NOT NULL,
	[QuandlCode] [numeric](18, 0) NOT NULL,
	[isGrowth] [bit] NOT NULL,
	[isDividend] [bit] NOT NULL,
	[CreatedBy] [bigint] NOT NULL,
	[ManagingSince] [datetime] NOT NULL,
 CONSTRAINT [PK_Schemes_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[SchemeTypes]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[SchemeTypes](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_SchemeTypes_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Transactions]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Transactions](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[UserId] [bigint] NOT NULL,
	[SchemeId] [bigint] NOT NULL,
	[Amount] [decimal](18, 2) NOT NULL,
	[Units] [decimal](18, 2) NOT NULL,
	[TransactionType] [bigint] NOT NULL,
	[TransactionDate] [datetime] NOT NULL,
	[InvestmentType] [bigint] NOT NULL,
 CONSTRAINT [PK_Transactions] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[TransactionTypes]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[TransactionTypes](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[Title] [nvarchar](50) NOT NULL,
 CONSTRAINT [PK_TransactionTypes] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[Users]    Script Date: 06-04-2018 12.26.45 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Users](
	[Id] [bigint] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[LastName] [varchar](50) NOT NULL,
	[Email] [nvarchar](50) NOT NULL,
	[ContactNumber] [nvarchar](10) NOT NULL,
	[Password] [nvarchar](50) NOT NULL,
	[RegisteredOn] [datetime] NOT NULL,
	[IsActive] [bit] NOT NULL,
	[LastLoggedOn] [datetime] NULL,
	[RoleId] [bigint] NOT NULL,
	[Bio] [nvarchar](4000) NULL,
	[ImageUrl] [nvarchar](150) NULL,
 CONSTRAINT [PK_Users_1] PRIMARY KEY CLUSTERED 
(
	[Id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
SET ANSI_PADDING OFF
GO
SET IDENTITY_INSERT [dbo].[Benchmarks] ON 

INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (1, N'S&P BSE Smallcap TRI')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (2, N'S&P BSE 200 TRI')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (3, N'S&P BSE 100 TRI')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (4, N'Russell 1000 TR Index')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (5, N'NIFTY FREE FLOAT MIDCAP 100 TRI')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (6, N'NIFTY 50 Equal Weight TRI')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (7, N'NIFTY 500 TRI')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (8, N'I-SEC Li-Bex')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (9, N'FTSE Gold Mine TRI')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (10, N'Euromoney Global Mining Constrained Weights Net-TRI')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (11, N'DAX Global Agribusiness Index TRI')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (12, N'CRISIL Short Term Bond Fund Index')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (13, N'CRISIL Liquid Fund Index')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (14, N'CRISIL Hybrid 85+15 - Conservative TR Index')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (15, N'CRISIL Hybrid 35+65 - Aggressive TR Index')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (16, N'CRISIL Composite Bond Fund Index')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (17, N'CRISIL 1 Year T-Bill')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (18, N'CRISIL 10 Year Gilt')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (19, N'70% MSCI World Energy TRI, 30% MSCI World TRI')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (20, N'50% of CRISIL Short Term Bond Fund Index + 50% of CRISIL Composite Bond Fund Index')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (21, N'36% S&P 500 Composite TRI, 24% FTSE World TRI (ex-US), 24% ML US Treasury Current 5 Year TRI, 16% Citigroup Non-USD World Government Bond Index-TRI')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (22, N'35% S&P BSE Oil & Gas TRI, 35% MSCI World Energy TRI, 30% S&P BSE Metal TRI')
INSERT [dbo].[Benchmarks] ([Id], [Title]) VALUES (23, N'30% Nifty 500 TRI + 70% CRISIL Liquid Fund Index')
SET IDENTITY_INSERT [dbo].[Benchmarks] OFF
SET IDENTITY_INSERT [dbo].[InvestmentGoals] ON 

INSERT [dbo].[InvestmentGoals] ([Id], [Title]) VALUES (1, N'Captial Growth & Income')
INSERT [dbo].[InvestmentGoals] ([Id], [Title]) VALUES (2, N'Income Generation')
INSERT [dbo].[InvestmentGoals] ([Id], [Title]) VALUES (3, N'Capital Appreciation')
SET IDENTITY_INSERT [dbo].[InvestmentGoals] OFF
SET IDENTITY_INSERT [dbo].[InvestmentHorizones] ON 

INSERT [dbo].[InvestmentHorizones] ([Id], [Title]) VALUES (1, N'Long Term')
INSERT [dbo].[InvestmentHorizones] ([Id], [Title]) VALUES (2, N'Medium Term')
INSERT [dbo].[InvestmentHorizones] ([Id], [Title]) VALUES (3, N'Short Term')
SET IDENTITY_INSERT [dbo].[InvestmentHorizones] OFF
SET IDENTITY_INSERT [dbo].[Navigations] ON 

INSERT [dbo].[Navigations] ([Id], [Title], [Url], [FontAwesome], [AssignedToUserRole]) VALUES (1, N'Dashboard', N'investor-dashboard', N'fa fa-dashboard fa-fw', 3)
INSERT [dbo].[Navigations] ([Id], [Title], [Url], [FontAwesome], [AssignedToUserRole]) VALUES (2, N'Portfolio', N'investor-portfolio', N'fa fa-folder fa-fw', 3)
INSERT [dbo].[Navigations] ([Id], [Title], [Url], [FontAwesome], [AssignedToUserRole]) VALUES (3, N'Transactions', N'investor-transactions', N'fa fa-rupee fa-fw', 3)
INSERT [dbo].[Navigations] ([Id], [Title], [Url], [FontAwesome], [AssignedToUserRole]) VALUES (4, N'Systematic Plans', N'investor-systematicplans', N'fa fa-bell fa-fw', 3)
INSERT [dbo].[Navigations] ([Id], [Title], [Url], [FontAwesome], [AssignedToUserRole]) VALUES (5, N'Settings', N'investor-settings', N'fa fa-gear fa-fw', 3)
INSERT [dbo].[Navigations] ([Id], [Title], [Url], [FontAwesome], [AssignedToUserRole]) VALUES (6, N'Browse Funds', N'investor-browse', N'fa fa-external-link fa-fw', 3)
INSERT [dbo].[Navigations] ([Id], [Title], [Url], [FontAwesome], [AssignedToUserRole]) VALUES (8, N'Dashboard', N'admin-dashboard', N'fa fa-dashboard fa-fw', 1)
INSERT [dbo].[Navigations] ([Id], [Title], [Url], [FontAwesome], [AssignedToUserRole]) VALUES (9, N'Funds', N'admin-funds', N'fa fa-database fa-fw', 1)
INSERT [dbo].[Navigations] ([Id], [Title], [Url], [FontAwesome], [AssignedToUserRole]) VALUES (10, N'Investors', N'admin-investors', N'fa fa-users fa-fw', 1)
INSERT [dbo].[Navigations] ([Id], [Title], [Url], [FontAwesome], [AssignedToUserRole]) VALUES (11, N'Fund Managers', N'admin-fund-managers', N'fa fa-user-secret fa-fw', 1)
INSERT [dbo].[Navigations] ([Id], [Title], [Url], [FontAwesome], [AssignedToUserRole]) VALUES (13, N'Settings', N'admin-settings', N'fa fa-gear fa-fw', 1)
SET IDENTITY_INSERT [dbo].[Navigations] OFF
SET IDENTITY_INSERT [dbo].[PhysicalPaths] ON 

INSERT [dbo].[PhysicalPaths] ([Id], [BaseUrl], [Identifier]) VALUES (1, N'http://localhost:49296', N'Image')
SET IDENTITY_INSERT [dbo].[PhysicalPaths] OFF
SET IDENTITY_INSERT [dbo].[Risks] ON 

INSERT [dbo].[Risks] ([Id], [RiskLabel]) VALUES (1, N'High Risk')
INSERT [dbo].[Risks] ([Id], [RiskLabel]) VALUES (2, N'Moderately High Risk')
INSERT [dbo].[Risks] ([Id], [RiskLabel]) VALUES (3, N'Moderate Risk')
INSERT [dbo].[Risks] ([Id], [RiskLabel]) VALUES (4, N'Moderately Low Risk')
INSERT [dbo].[Risks] ([Id], [RiskLabel]) VALUES (5, N'Low Risk')
SET IDENTITY_INSERT [dbo].[Risks] OFF
SET IDENTITY_INSERT [dbo].[Roles] ON 

INSERT [dbo].[Roles] ([Id], [RoleName]) VALUES (1, N'Admin')
INSERT [dbo].[Roles] ([Id], [RoleName]) VALUES (2, N'FundManager')
INSERT [dbo].[Roles] ([Id], [RoleName]) VALUES (3, N'Investor')
SET IDENTITY_INSERT [dbo].[Roles] OFF
SET IDENTITY_INSERT [dbo].[SchemeCategories] ON 

INSERT [dbo].[SchemeCategories] ([Id], [Title]) VALUES (1, N'Sectoral / Thematic')
INSERT [dbo].[SchemeCategories] ([Id], [Title]) VALUES (2, N'Short Term')
INSERT [dbo].[SchemeCategories] ([Id], [Title]) VALUES (3, N'Tax Saving')
INSERT [dbo].[SchemeCategories] ([Id], [Title]) VALUES (4, N'Liquid')
INSERT [dbo].[SchemeCategories] ([Id], [Title]) VALUES (5, N'Debt Oriented')
INSERT [dbo].[SchemeCategories] ([Id], [Title]) VALUES (6, N'Income')
INSERT [dbo].[SchemeCategories] ([Id], [Title]) VALUES (7, N'Global Asset Allocation')
INSERT [dbo].[SchemeCategories] ([Id], [Title]) VALUES (8, N'Diversified')
INSERT [dbo].[SchemeCategories] ([Id], [Title]) VALUES (9, N'Ultra Short Term')
INSERT [dbo].[SchemeCategories] ([Id], [Title]) VALUES (10, N'Dynamic')
INSERT [dbo].[SchemeCategories] ([Id], [Title]) VALUES (11, N'Government Securities')
INSERT [dbo].[SchemeCategories] ([Id], [Title]) VALUES (12, N'Equity Oriented')
SET IDENTITY_INSERT [dbo].[SchemeCategories] OFF
SET IDENTITY_INSERT [dbo].[SchemePlans] ON 

INSERT [dbo].[SchemePlans] ([Id], [Title]) VALUES (1, N'Direct')
INSERT [dbo].[SchemePlans] ([Id], [Title]) VALUES (2, N'Regular')
SET IDENTITY_INSERT [dbo].[SchemePlans] OFF
SET IDENTITY_INSERT [dbo].[Schemes] ON 

INSERT [dbo].[Schemes] ([Id], [Title], [SchemeTypeId], [SchemeCategoryId], [SchemePlanId], [RiskId], [BenchmarkId], [HorizoneId], [GoalId], [MinLumpsumAmount], [MinSipAmount], [ExpenseRatio], [AUM], [InceptionDate], [EntryLoad], [ExitLoad], [FundManagerId], [Description], [IsOpenEndedFund], [QuandlCode], [isGrowth], [isDividend], [CreatedBy], [ManagingSince]) VALUES (1, N'Natural Resources & New Energy Fund', 1, 1, 1, 1, 7, 1, 1, CAST(5000.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), CAST(552.00 AS Decimal(18, 2)), CAST(N'2018-02-21 17:21:56.320' AS DateTime), CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), 6, N'An open ended diversified equity growth scheme seeking to generate long term capital appreciation from a portfolio that is substantially constituted of equity and equity related securities, which are not part of the top 300 companies by market capitalization. From time to time, the Investment Manager will also seek participation in other equity and equity related securities to achieve optimal portfolio construction.', 1, CAST(198990 AS Numeric(18, 0)), 0, 0, 1, CAST(N'2018-04-01 15:34:54.177' AS DateTime))
INSERT [dbo].[Schemes] ([Id], [Title], [SchemeTypeId], [SchemeCategoryId], [SchemePlanId], [RiskId], [BenchmarkId], [HorizoneId], [GoalId], [MinLumpsumAmount], [MinSipAmount], [ExpenseRatio], [AUM], [InceptionDate], [EntryLoad], [ExitLoad], [FundManagerId], [Description], [IsOpenEndedFund], [QuandlCode], [isGrowth], [isDividend], [CreatedBy], [ManagingSince]) VALUES (2, N'Micro Cap Fund', 1, 5, 2, 2, 10, 2, 2, CAST(5000.00 AS Decimal(18, 2)), CAST(500.00 AS Decimal(18, 2)), CAST(3.00 AS Decimal(18, 2)), CAST(550.00 AS Decimal(18, 2)), CAST(N'2018-02-21 18:13:02.483' AS DateTime), CAST(0.00 AS Decimal(18, 2)), CAST(1.00 AS Decimal(18, 2)), 6, N'Perhaps a little late, but in JavaScript you declare variables or functions by using the keywords var, let or function. In typescript classes you declare class members or methods without these keywords followed by a colon and the type or interface of that class member.', 1, CAST(198990 AS Numeric(18, 0)), 0, 0, 1, CAST(N'2018-04-01 15:34:54.177' AS DateTime))
SET IDENTITY_INSERT [dbo].[Schemes] OFF
SET IDENTITY_INSERT [dbo].[SchemeTypes] ON 

INSERT [dbo].[SchemeTypes] ([Id], [Title]) VALUES (1, N'Equity')
INSERT [dbo].[SchemeTypes] ([Id], [Title]) VALUES (2, N'Debt')
INSERT [dbo].[SchemeTypes] ([Id], [Title]) VALUES (3, N'Hybrid / FoF')
INSERT [dbo].[SchemeTypes] ([Id], [Title]) VALUES (4, N'Internation FoF')
SET IDENTITY_INSERT [dbo].[SchemeTypes] OFF
SET IDENTITY_INSERT [dbo].[TransactionTypes] ON 

INSERT [dbo].[TransactionTypes] ([Id], [Title]) VALUES (1, N'SIP')
INSERT [dbo].[TransactionTypes] ([Id], [Title]) VALUES (2, N'STP')
INSERT [dbo].[TransactionTypes] ([Id], [Title]) VALUES (3, N'SWP')
INSERT [dbo].[TransactionTypes] ([Id], [Title]) VALUES (4, N'Lumpsum')
SET IDENTITY_INSERT [dbo].[TransactionTypes] OFF
SET IDENTITY_INSERT [dbo].[Users] ON 

INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (1, N'Vijay', N'Yadav', N'yadavgvijay@gmail.com', N'9960992043', N' 80 88 57 79 91135100109 76 35 78198187 59 66 41', CAST(N'2018-01-01 00:00:00.000' AS DateTime), 1, NULL, 1, NULL, NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (5, N'Vinay', N'Raut', N'vinay.raut@wwindia.com', N'9561291809', N' 80 88 57 79 91135100109 76 35 78198187 59 66 41', CAST(N'2018-01-26 00:00:00.000' AS DateTime), 1, NULL, 3, NULL, NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (6, N'Abhijits', N'Deshmukh', N'abhijitdeshmukh3@gmail.com', N'8983300093', N' 80 88 57 79 91135100109 76 35 78198187 59 66 41', CAST(N'2018-01-26 20:40:23.097' AS DateTime), 0, CAST(N'2018-01-01 10:00:00.000' AS DateTime), 2, N'Abhijeet Deshmukh, Vice President & Product Strategist -Jay has been with DSP BlackRock Investment Managers since May 2005, and has been with the Investment function since January 2011. Jay joined the firm as a member of the Sales team (Banking) in May 2005. Prior to joining DSPBRIM, Jay worked for Standard Chartered Bank for a year in the Priority Banking division. Jay completed his Bachelor of Management Studies (Finance & International Finance) from Mumbai University, followed by an MBA in Finance from Mumbai University.

Jay is currently the Dedicated Fund Manager for overseas investments for the following schemes of DSP BlackRock Mutual Fund.', N'/UserData/6/ProfileImage/modi.jpg')
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (9, N'Shruti', N'Mundhada', N'smundhada89@gmail.com', N'8055940950', N' 80 88 57 79 91135100109 76 35 78198187 59 66 41', CAST(N'2018-01-28 17:07:09.157' AS DateTime), 0, CAST(N'2018-01-01 08:00:00.000' AS DateTime), 2, N'Shruti Mundhada is a Research Analyst focusing on sectors like Auto, Auto Ancillaries, Metals, Infrastructure, Sugar and Hotels. He is the Co-Fund Manager for DSP BlackRock India T.I.G.E.R. Fund since June 2010. Rohit joined DSP BlackRock Investment Managers in September 2005, as Portfolio Analyst for the firm''s Portfolio Management Services (PMS) division, which manages discretionary accounts and provides advisory services to institutional clients. He was transferred to the Institutional Equities Team of DSP BlackRock Investment Managers in June 2009.

Previously, he was with HDFC Securities Limited as a part of its Institutional Equities Research Desk. He spent 13 months at HDFC Securities as Sr. Equity Analyst.', N'/UserData/9/ProfileImage/sage icon.png')
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (10, N'Gaurav', N'Raut', N'gaurav.raut@wwindia.com', N'9028123123', N' 80 88 57 79 91135100109 76 35 78198187 59 66 41', CAST(N'2018-01-28 17:32:54.593' AS DateTime), 0, NULL, 3, NULL, NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (11, N'Abhishek', N'Tiwary', N'abhishektiwary@wwindia.com', N'8920948732', N' 80 88 57 79 91135100109 76 35 78198187 59 66 41', CAST(N'2018-02-10 23:40:16.847' AS DateTime), 0, CAST(N'2018-01-01 05:00:00.000' AS DateTime), 2, N'Let''s look at some SQL Server YEAR function examples and explore how to use the YEAR function in SQL Server (Transact-SQL', N'/UserData/11/ProfileImage/lord-shiva-93a.jpg')
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (12, N'Sachin', N'Ninawe', N'sachin.ninawe@wwindia.com', N'8983457656', N' 80 88 57 79 91135100109 76 35 78198187 59 66 41', CAST(N'2018-02-11 11:21:28.917' AS DateTime), 0, NULL, 3, NULL, NULL)
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (13, N'Amol', N'Raut', N'amol.autade@wwindia.com', N'8983457656', N' 27239208161100 34177250234  7186165 11236104252', CAST(N'2018-03-27 16:41:52.490' AS DateTime), 0, NULL, 2, N'Amol Autade is a Research Analyst focusing on sectors like Auto, Auto Ancillaries, Metals, Infrastructure, Sugar and Hotels. He is the Co-Fund Manager for DSP BlackRock India T.I.G.E.R. Fund since June 2010. Rohit joined DSP BlackRock Investment Managers in September 2005, as Portfolio Analyst for the firm''s Portfolio Management Services (PMS) division, which manages discretionary accounts and provides advisory services to institutional clients. He was transferred to the Institutional Equities Team of DSP BlackRock Investment Managers in June 2009.

Previously, he was with HDFC Securities Limited as a part of its Institutional Equities Research Desk. He spent 13 months at HDFC Securities as Sr. Equity Analyst.', N'/UserData/13/ProfileImage/1.png')
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (14, N'Jinita', N'Mehta', N'jinita.mehta@gmail.com', N'8983457657', N' 27239208161100 34177250234  7186165 11236104252', CAST(N'2018-03-27 16:42:47.363' AS DateTime), 0, NULL, 2, N'Jinita is a Research Analyst focusing on sectors like Auto, Auto Ancillaries, Metals, Infrastructure, Sugar and Hotels. He is the Co-Fund Manager for DSP BlackRock India T.I.G.E.R. Fund since June 2010. Rohit joined DSP BlackRock Investment Managers in September 2005, as Portfolio Analyst for the firm''s Portfolio Management Services (PMS) division, which manages discretionary accounts and provides advisory services to institutional clients. He was transferred to the Institutional Equities Team of DSP BlackRock Investment Managers in June 2009.

Previously, he was with HDFC Securities Limited as a part of its Institutional Equities Research Desk. He spent 13 months at HDFC Securities as Sr. Equity Analyst.', N'/UserData/14/ProfileImage/Abstract heart wall.jpg')
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (17, N'Santosh', N'Deshmane', N'santosh.deshmane@gmail.com', N'8983457600', N' 27239208161100 34177250234  7186165 11236104252', CAST(N'2018-03-27 17:24:16.870' AS DateTime), 1, NULL, 2, N'Jinita is a Research Analyst focusing on sectors like Auto, Auto Ancillaries, Metals, Infrastructure, Sugar and Hotels. He is the Co-Fund Manager for DSP BlackRock India T.I.G.E.R. Fund since June 2010. Rohit joined DSP BlackRock Investment Managers in September 2005, as Portfolio Analyst for the firm''s Portfolio Management Services (PMS) division, which manages discretionary accounts and provides advisory services to institutional clients. He was transferred to the Institutional Equities Team of DSP BlackRock Investment Managers in June 2009.

Previously, he was with HDFC Securities Limited as a part of its Institutional Equities Research Desk. He spent 13 months at HDFC Securities as Sr. Equity Analyst.', N'/UserData/17/ProfileImage/black18.png')
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (18, N'Sumit', N'Ukarde', N'sumit.ukarde@gmail.com', N'8983300091', N' 27239208161100 34177250234  7186165 11236104252', CAST(N'2018-03-28 11:57:29.647' AS DateTime), 0, NULL, 2, N'some things always went wrong', N'/UserData/18/ProfileImage/test.png')
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (19, N'Aditya', N'Chand', N'aditya.chand@wwindia.com', N'9876543200', N' 27239208161100 34177250234  7186165 11236104252', CAST(N'2018-03-29 17:26:19.240' AS DateTime), 0, NULL, 2, N'Bio', N'/UserData/19/ProfileImage/modi-l.jpg')
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (20, N'Vishal', N'Dubey', N'vishal.dubey@wwindia.com', N'9487654321', N' 27239208161100 34177250234  7186165 11236104252', CAST(N'2018-03-29 17:42:33.607' AS DateTime), 0, NULL, 2, N'For easy reference, we have provided a list of all SQL Server (Transact-SQL) functions. The list of SQL Server functions is sorted into the type of function based on categories such as string, conversion, advanced, numeric/mathematical, and date/time functions.', N'/UserData/20/ProfileImage/black18.png')
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (21, N'Akshay', N'Bibekar', N'akshay.bibekar@gmail.com', N'8983399903', N' 27239208161100 34177250234  7186165 11236104252', CAST(N'2018-04-04 16:45:37.997' AS DateTime), 0, NULL, 2, N'The program schedule for Radio Mirchii - TEST-1 will be affected by daylight saving time changes that take place at 3:00 AM on Sunday, April 01, 2018: the transition period.
The program schedule should be unaffected after the transition period. The on-going schedule will auto-adjust to match the new timezone rules.
If your usual programming spans the entire transition period then the schedule will automatically track. Otherwise, you may need to schedule once-off special programming arrangements around the transition period. Any up-coming gaps and conflicts in the schedule will be reported as usual by separate email. ', N'/UserData/21/ProfileImage/1.png')
INSERT [dbo].[Users] ([Id], [FirstName], [LastName], [Email], [ContactNumber], [Password], [RegisteredOn], [IsActive], [LastLoggedOn], [RoleId], [Bio], [ImageUrl]) VALUES (22, N'Mahesh', N'Ambole', N'mahesh.ambole@gmail.com', N'4563798765', N' 27239208161100 34177250234  7186165 11236104252', CAST(N'2018-04-06 12:16:31.387' AS DateTime), 0, NULL, 2, N'In principle, they are the same and are handled in the same way by your application. The only difference is that NVARCHAR can handle unicode characters, allowing you to use multiple languages in the database (Arabian, Chinese, etc.). NVARCHAR takes twice as much space when compared to VARCHAR. Use NVARCHAR only if you are using foreign languages.', N'/UserData/22/ProfileImage/600-2.jpg')
SET IDENTITY_INSERT [dbo].[Users] OFF
SET ANSI_PADDING ON

GO
/****** Object:  Index [UK_Users]    Script Date: 06-04-2018 12.26.45 PM ******/
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [UK_Users] UNIQUE NONCLUSTERED 
(
	[Email] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, IGNORE_DUP_KEY = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO
ALTER TABLE [dbo].[Navigations] ADD  CONSTRAINT [DF_Navigations_AssignedToUserRole]  DEFAULT ((0)) FOR [AssignedToUserRole]
GO
ALTER TABLE [dbo].[Schemes] ADD  CONSTRAINT [DF_Schemes_InceptionDate]  DEFAULT (sysdatetime()) FOR [InceptionDate]
GO
ALTER TABLE [dbo].[Schemes] ADD  CONSTRAINT [DF_Schemes_EntryLoad]  DEFAULT ((0)) FOR [EntryLoad]
GO
ALTER TABLE [dbo].[Schemes] ADD  CONSTRAINT [DF_Schemes_isGrowth]  DEFAULT ((0)) FOR [isGrowth]
GO
ALTER TABLE [dbo].[Schemes] ADD  CONSTRAINT [DF_Schemes_isDividend]  DEFAULT ((0)) FOR [isDividend]
GO
ALTER TABLE [dbo].[Schemes] ADD  CONSTRAINT [DF_Schemes_CreatedBy]  DEFAULT ((1)) FOR [CreatedBy]
GO
ALTER TABLE [dbo].[Schemes] ADD  CONSTRAINT [DF_Schemes_ManagingSince]  DEFAULT (sysdatetime()) FOR [ManagingSince]
GO
ALTER TABLE [dbo].[Transactions] ADD  CONSTRAINT [DF_Transactions_TransactionDate]  DEFAULT (sysdatetime()) FOR [TransactionDate]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_IsActive]  DEFAULT ((0)) FOR [IsActive]
GO
ALTER TABLE [dbo].[Users] ADD  CONSTRAINT [DF_Users_RoleId]  DEFAULT ((3)) FOR [RoleId]
GO
ALTER TABLE [dbo].[emp]  WITH CHECK ADD  CONSTRAINT [FK_emp_emp] FOREIGN KEY([Id])
REFERENCES [dbo].[emp] ([Id])
GO
ALTER TABLE [dbo].[emp] CHECK CONSTRAINT [FK_emp_emp]
GO
ALTER TABLE [dbo].[Schemes]  WITH CHECK ADD  CONSTRAINT [FK_Schemes_Benchmarks] FOREIGN KEY([BenchmarkId])
REFERENCES [dbo].[Benchmarks] ([Id])
GO
ALTER TABLE [dbo].[Schemes] CHECK CONSTRAINT [FK_Schemes_Benchmarks]
GO
ALTER TABLE [dbo].[Schemes]  WITH CHECK ADD  CONSTRAINT [FK_Schemes_InvestmentGoals] FOREIGN KEY([GoalId])
REFERENCES [dbo].[InvestmentGoals] ([Id])
GO
ALTER TABLE [dbo].[Schemes] CHECK CONSTRAINT [FK_Schemes_InvestmentGoals]
GO
ALTER TABLE [dbo].[Schemes]  WITH CHECK ADD  CONSTRAINT [FK_Schemes_InvestmentHorizones] FOREIGN KEY([HorizoneId])
REFERENCES [dbo].[InvestmentHorizones] ([Id])
GO
ALTER TABLE [dbo].[Schemes] CHECK CONSTRAINT [FK_Schemes_InvestmentHorizones]
GO
ALTER TABLE [dbo].[Schemes]  WITH CHECK ADD  CONSTRAINT [FK_Schemes_Risks] FOREIGN KEY([RiskId])
REFERENCES [dbo].[Risks] ([Id])
GO
ALTER TABLE [dbo].[Schemes] CHECK CONSTRAINT [FK_Schemes_Risks]
GO
ALTER TABLE [dbo].[Schemes]  WITH CHECK ADD  CONSTRAINT [FK_Schemes_SchemeCategories] FOREIGN KEY([SchemeCategoryId])
REFERENCES [dbo].[SchemeCategories] ([Id])
GO
ALTER TABLE [dbo].[Schemes] CHECK CONSTRAINT [FK_Schemes_SchemeCategories]
GO
ALTER TABLE [dbo].[Schemes]  WITH CHECK ADD  CONSTRAINT [FK_Schemes_SchemePlans] FOREIGN KEY([SchemePlanId])
REFERENCES [dbo].[SchemePlans] ([Id])
GO
ALTER TABLE [dbo].[Schemes] CHECK CONSTRAINT [FK_Schemes_SchemePlans]
GO
ALTER TABLE [dbo].[Schemes]  WITH CHECK ADD  CONSTRAINT [FK_Schemes_SchemeTypes] FOREIGN KEY([SchemeTypeId])
REFERENCES [dbo].[SchemeTypes] ([Id])
GO
ALTER TABLE [dbo].[Schemes] CHECK CONSTRAINT [FK_Schemes_SchemeTypes]
GO
ALTER TABLE [dbo].[Schemes]  WITH CHECK ADD  CONSTRAINT [FK_Schemes_Users] FOREIGN KEY([FundManagerId])
REFERENCES [dbo].[Users] ([Id])
GO
ALTER TABLE [dbo].[Schemes] CHECK CONSTRAINT [FK_Schemes_Users]
GO
USE [master]
GO
ALTER DATABASE [BlackRock] SET  READ_WRITE 
GO
