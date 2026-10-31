
-- Verificy Foreign Keys: tables, columns and constraint status
SELECT 
    s_parent.name              AS SchemaTabellaFiglia,
    OBJECT_NAME(fk.parent_object_id)      AS TabellaFiglia,
    c_parent.name              AS ColonnaFiglia,
    s_ref.name                 AS SchemaTabellaGenitore,
    OBJECT_NAME(fk.referenced_object_id)  AS TabellaGenitore,
    c_ref.name                 AS ColonnaGenitore,
    fk.name                    AS NomeVincoloFK,
    fk.is_disabled             AS Disabilitato,
    fk.is_not_trusted          AS NonTrusted  
FROM sys.foreign_keys fk
INNER JOIN sys.foreign_key_columns fkc 
    ON fk.object_id = fkc.constraint_object_id
INNER JOIN sys.columns c_parent 
    ON fkc.parent_object_id = c_parent.object_id 
    AND fkc.parent_column_id = c_parent.column_id
INNER JOIN sys.columns c_ref 
    ON fkc.referenced_object_id = c_ref.object_id 
    AND fkc.referenced_column_id = c_ref.column_id
INNER JOIN sys.tables t_parent 
    ON fk.parent_object_id = t_parent.object_id
INNER JOIN sys.schemas s_parent 
    ON t_parent.schema_id = s_parent.schema_id
INNER JOIN sys.tables t_ref 
    ON fk.referenced_object_id = t_ref.object_id
INNER JOIN sys.schemas s_ref 
    ON t_ref.schema_id = s_ref.schema_id
ORDER BY TabellaFiglia, NomeVincoloFK;
