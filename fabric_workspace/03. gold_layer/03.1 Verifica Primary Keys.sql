
-- Verifica Primary Key definite sulle tabelle dello schema _Marketing
SELECT 
    s.name AS SchemaName,
    t.name AS TableName,
    c.name AS ColumnName,
    i.name AS ConstraintName,
    i.type_desc
FROM sys.indexes i
INNER JOIN sys.index_columns ic 
    ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c 
    ON ic.object_id = c.object_id AND ic.column_id = c.column_id
INNER JOIN sys.tables t 
    ON i.object_id = t.object_id
INNER JOIN sys.schemas s 
    ON t.schema_id = s.schema_id
WHERE i.is_primary_key = 1;

-- Verifica Foreign Key definite
SELECT 
    fk.name AS ForeignKeyName,
    OBJECT_NAME(fk.parent_object_id) AS TabellaFiglia,
    OBJECT_NAME(fk.referenced_object_id) AS TabellaGenitore,
    fk.is_disabled,
    fk.is_not_trusted
FROM sys.foreign_keys fk
WHERE OBJECT_SCHEMA_NAME(fk.parent_object_id) = '_Marketing';
