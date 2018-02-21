CREATE OR REPLACE VIEW record_counts
AS
SELECT COUNT(id), 'assets' AS `table` FROM assets
UNION
SELECT COUNT(id), 'vulnerabilities' AS `table` FROM vulnerabilities
