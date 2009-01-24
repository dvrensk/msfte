IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[msfte_comments]') AND type in (N'U'))
DROP TABLE [dbo].[msfte_comments]
GO
CREATE TABLE [dbo].[msfte_comments] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[msfte_post_id] [int] NOT NULL,
	[title] [nvarchar](500) COLLATE Finnish_Swedish_CI_AI NOT NULL,
	[text]  [nvarchar](500) COLLATE Finnish_Swedish_CI_AI NOT NULL,
 CONSTRAINT [msfte_comments_PK] PRIMARY KEY CLUSTERED ([id] ASC))
GO
IF not EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[msfte_comments]'))
CREATE FULLTEXT INDEX ON [dbo].[msfte_comments]([title],[text])
KEY INDEX [msfte_comments_PK]
WITH CHANGE_TRACKING AUTO
