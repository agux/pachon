package util

//GetPartitionsFor the specified schema and table. Optionally excluding partitions with empty rows.
func GetPartitionsFor(schema, table string, excludeEmpty bool) (partitions []string, e error) {
	q := `
	SELECT 
		partition_name
	FROM
		information_schema.partitions
	WHERE
		table_schema = ?
		AND table_name = ?
	`
	if excludeEmpty {
		q += ` AND table_rows > 0`
	}
	_, e = dbmap.Select(&partitions, q, schema, table)
	return
}
