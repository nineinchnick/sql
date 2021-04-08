SELECT MAX(CAST(pf.boundary_value_on_right AS INT)) FROM sys.tables t
INNER JOIN sys.schemas s ON t.schema_id = s.schema_id
INNER JOIN sys.partitions p ON p.object_id = t.object_id
INNER JOIN sys.indexes i ON i.object_id = p.object_id AND i.index_id = p.index_id
INNER JOIN sys.index_columns ic ON ic.object_id = t.object_id AND ic.index_id = i.index_id
INNER JOIN sys.columns c ON c.object_id = t.object_id AND c.column_id = ic.column_id
INNER JOIN sys.data_spaces ds ON ds.data_space_id = i.data_space_id
INNER JOIN sys.partition_schemes ps ON ps.data_space_id = ds.data_space_id
INNER JOIN sys.partition_functions pf ON pf.function_id = ps.function_id
WHERE s.name = 'dbo' AND t.name = 'test_table_options_1peeh' AND i.index_id IN (0, 1)
GROUP BY p.index_id
