INSERT INTO audit_log_entries (
	instance_id,
	id,
	payload,
	created_at,
	ip_address
	)
VALUES (
	'instance_id:uuid',
	'id:uuid',
	'payload:json',
	'created_at:timestamp with time zone',
	'ip_address:character varying'
	);
