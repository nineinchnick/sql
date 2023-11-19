SELECT c.name, ic.is_descending_key FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
INNER JOIN sys.indexes i ON i.object_id = t.object_id
INNER JOIN sys.index_columns ic ON ic.object_id = t.object_id AND ic.index_id = i.index_id
INNER JOIN sys.columns c ON c.object_id = t.object_id AND c.column_id = ic.column_id
WHERE s.name = 'dbo' AND t.name = 'orders' AND i.index_id = 1 AND ic.column_store_order_ordinal != 0
ORDER BY ic.column_store_order_ordinal

