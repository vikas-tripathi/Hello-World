--Find a text in stored procedure
SELECT OBJECT_NAME(id) 
    FROM SYSCOMMENTS 
    WHERE [text] LIKE '%openrowset%' 
  --  AND OBJECTPROPERTY(id, 'IsProcedure') = 1 
    GROUP BY OBJECT_NAME(id)
---------------------------------------------------------------------------------------------------------------------------

SELECT * FROM fn_helpcollations()

--Check Server Collation
SELECT SERVERPROPERTY('COLLATION')

--Check Database Collation
SELECT DATABASEPROPERTYEX('AdventureWorks', 'Collation') SQLCollation;

--Get collation at column level
select table_name, column_name, collation_name
from information_schema.columns
where table_name = 'K_GIDW3'
and COLLATION_NAME = 'Latin1_General_BIN2'



--generate ALTER TABLE statements for collation
DECLARE @collate SYSNAME
SELECT @collate = 'Latin1_General_CI_AI'

SELECT 
      '[' + SCHEMA_NAME(o.[schema_id]) + '].[' + o.name + '] -> ' + c.name
    , 'ALTER TABLE [' + SCHEMA_NAME(o.[schema_id]) + '].[' + o.name + ']
        ALTER COLUMN [' + c.name + '] ' +
        UPPER(t.name) + 
        CASE WHEN t.name NOT IN ('ntext', 'text') 
            THEN '(' + 
                CASE 
                    WHEN t.name IN ('nchar', 'nvarchar') AND c.max_length != -1 
                        THEN CAST(c.max_length / 2 AS VARCHAR(10))
                    WHEN t.name IN ('nchar', 'nvarchar') AND c.max_length = -1 
                        THEN 'MAX'
                    ELSE CAST(c.max_length AS VARCHAR(10)) 
                END + ')' 
            ELSE '' 
        END + ' COLLATE ' + @collate + 
        CASE WHEN c.is_nullable = 1 
            THEN ' NULL'
            ELSE ' NOT NULL'
        END
FROM sys.columns c WITH(NOLOCK)
JOIN sys.objects o WITH(NOLOCK) ON c.[object_id] = o.[object_id]
JOIN sys.types t WITH(NOLOCK) ON c.system_type_id = t.system_type_id AND c.user_type_id = t.user_type_id
WHERE t.name IN ('char', 'varchar', 'text', 'nvarchar', 'ntext', 'nchar')
    AND c.collation_name != @collate
    AND o.[type] = 'U'
	AND o.object_id = OBJECT_ID(N'[trg.K_GIDW3]')

	--++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
	--get the list of procedures which references a table or maybe any other object
	select * from sys.Procedures
WHERE OBJECT_DEFINITION(OBJECT_ID) LIKE '%Changes_ChangedSubcons%'

-----------------------------------------------------------------------------------------
--properties of the table:

SELECT * 
    FROM tempdb.sys.columns 
    WHERE [object_id] = OBJECT_ID(N'tempdb..#ru');

	EXEC tempdb.dbo.sp_help N'#ru';

--***************************************************************************************
--Get all references to stored procedure which references a table
SELECT Name
FROM sys.procedures
WHERE OBJECT_DEFINITION(OBJECT_ID) LIKE '%[Monitoring].[Mapping].[Account]%'

