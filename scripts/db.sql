--liquibase formatted sql
--changeset verushan:1

CREATE TABLE [dbo].[Team] (
    [TeamID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
    [Name] [varchar](120) NOT NULL,
    [IsOurClub] [bit] NOT NULL DEFAULT 1
);

CREATE TABLE [dbo].[StaffCode] (
    [StaffCodeID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
    [StaffCodeType] [varchar](120) NOT NULL
);

CREATE TABLE [dbo].[Staff] (
    [StaffID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
    [StaffCodeID] [int] NOT NULL,
    [TeamID] [int] NOT NULL,
    [Name] [varchar](120) NOT NULL,
    [Surname] [varchar](120) NOT NULL,

    FOREIGN KEY (TeamID) REFERENCES [dbo].Team(TeamID),
    FOREIGN KEY (StaffCodeID) REFERENCES [dbo].StaffCode(StaffCodeID)
);

CREATE TABLE [dbo].[PositionCode] (
    [PositionID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
    [PositionName] [varchar](120) NOT NULL
);

CREATE TABLE [dbo].[Player] (
    [PlayerID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
    [PositionCodeID] [int] NOT NULL, 
    [TeamID] [int] NOT NULL,
    [Name] [varchar](120) NOT NULL,
    [Surname] [varchar](120) NOT NULL,
    [DateOfBirth] [date] NULL,

    FOREIGN KEY (PositionCodeID) REFERENCES [dbo].PositionCode(PositionID),
    FOREIGN KEY (TeamID) REFERENCES [dbo].Team(TeamID),

    CONSTRAINT ChkDatePast CHECK ([DateOfBirth] < GETDATE() OR [DateOfBirth] IS NULL)
);

CREATE TABLE [dbo].[Fixture] (
    [FixtureID] [int] IDENTITY(1,1) PRIMARY KEY NOT NULL,
    [TeamID] [int] NOT NULL, 
    [OpponentID] [int] NOT NULL,
    [Away] [bit] NOT NULL,
    [Date] [datetime2] NULL,

    FOREIGN KEY (TeamID) REFERENCES [dbo].Team(TeamID),
    FOREIGN KEY (OpponentID) REFERENCES [dbo].Team(TeamID)
);

CREATE TABLE [dbo].[Result] (
    [ResultID] [int] IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    [FixtureID] [int] NOT NULL,
    [GoalsFor] [int] NOT NULL DEFAULT 0, 
    [GoalsAgainst] [int] NOT NULL DEFAULT 0,

    FOREIGN KEY (FixtureID) REFERENCES [dbo].Fixture(FixtureID),

    CONSTRAINT ChkPositiveGoalsFor CHECK ([GoalsFor] >= 0),
    CONSTRAINT ChkPositiveGoalsAgainst CHECK ([GoalsAgainst] >= 0),
    CONSTRAINT UniqueFixtureConstraint UNIQUE (FixtureID)
);

CREATE TABLE [dbo].[PlayerFixtureStats] (
    [PlayerFixtureStatsID] [int] IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    [PlayerID] [int] NOT NULL, 
    [FixtureID] [int] NOT NULL, 
    [Saves] [int] NOT NULL DEFAULT 0,
    [Assists] [int] NOT NULL DEFAULT 0,
    [Goals] [int] NOT NULL DEFAULT 0,
    [Tackles] [int] NOT NULL DEFAULT 0,
    [YellowCards] [int] NOT NULL DEFAULT 0,
    [RedCards] [int] NOT NULL DEFAULT 0,
    [Fouls] [int] NOT NULL DEFAULT 0,
    [GameTimeInMinutes] [int] NOT NULL DEFAULT 0,

    FOREIGN KEY (PlayerID) REFERENCES [dbo].Player(PlayerID),
    FOREIGN KEY (FixtureID) REFERENCES [dbo].Fixture(FixtureID),

    CONSTRAINT UniqueFixturePlayerConstraint UNIQUE (PlayerID, FixtureID),
    CONSTRAINT ChkPositiveSaves CHECK ([Saves] >= 0),
    CONSTRAINT ChkPositiveAssists CHECK ([Assists] >= 0),
    CONSTRAINT ChkPositiveGoals CHECK ([Goals] >= 0),
    CONSTRAINT ChkPositiveTackles CHECK ([Tackles] >= 0),
    CONSTRAINT ChkPositiveYellowCards CHECK ([YellowCards] >= 0),
    CONSTRAINT ChkPositiveRedCards CHECK ([RedCards] >= 0),
    CONSTRAINT ChkPositiveFouls CHECK ([Fouls] >= 0),
    CONSTRAINT ChkPositiveGameTime CHECK ([GameTimeInMinutes] >= 0)
);