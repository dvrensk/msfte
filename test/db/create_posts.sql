IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[msfte_posts]') AND type in (N'U'))
DROP TABLE [dbo].[msfte_posts]
GO
CREATE TABLE [dbo].[msfte_posts] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[title] [nvarchar](500) COLLATE Finnish_Swedish_CI_AI NOT NULL,
	[text]  [nvarchar](500) COLLATE Finnish_Swedish_CI_AI NOT NULL,
 CONSTRAINT [msfte_posts_PK] PRIMARY KEY CLUSTERED ([id] ASC))
GO
IF not EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[msfte_posts]'))
CREATE FULLTEXT INDEX ON [dbo].[msfte_posts]([title],[text])
KEY INDEX [msfte_posts_PK]
WITH CHANGE_TRACKING AUTO
