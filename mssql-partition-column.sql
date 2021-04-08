SELECT MAX(c.name) AS name
FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
INNER JOIN sys.partitions p ON p.object_id = t.object_id
INNER JOIN sys.indexes i ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.index_columns ic ON ic.object_id = t.object_id AND ic.index_id = i.index_id
INNER JOIN sys.columns c ON c.object_id = t.object_id AND c.column_id = ic.column_id
WHERE s.name = 'dbo' AND t.name = 'orders' AND i.index_id IN (0, 1) AND ic.partition_ordinal != 0
GROUP BY p.index_id
