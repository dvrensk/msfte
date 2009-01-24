IF EXISTS (SELECT * FROM sys.objects WHERE object_id = OBJECT_ID(N'[dbo].[msfte_pingbacks]') AND type in (N'U'))
DROP TABLE [dbo].[msfte_pingbacks]
GO
CREATE TABLE [dbo].[msfte_pingbacks] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[msfte_post_id] [int] NOT NULL,
	[url] [nvarchar](500) COLLATE Finnish_Swedish_CI_AI NOT NULL,
	[excerpt] [nvarchar](500) COLLATE Finnish_Swedish_CI_AI NOT NULL,
 CONSTRAINT [msfte_pingbacks_PK] PRIMARY KEY CLUSTERED ([id] ASC))
GO
IF not EXISTS (SELECT * FROM sys.fulltext_indexes fti WHERE fti.object_id = OBJECT_ID(N'[dbo].[msfte_pingbacks]'))
CREATE FULLTEXT INDEX ON [dbo].[msfte_pingbacks]([excerpt])
KEY INDEX [msfte_pingbacks_PK]
WITH CHANGE_TRACKING AUTO
