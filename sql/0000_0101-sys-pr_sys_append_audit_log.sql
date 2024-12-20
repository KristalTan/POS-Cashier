CREATE OR REPLACE PROCEDURE public.pr_sys_append_audit_log(
	IN p_msg text,
	IN p_remarks text DEFAULT NULL::text,
	IN p_uid text DEFAULT NULL::text,
	IN p_id1 uuid DEFAULT NULL::uuid,
	IN p_id2 uuid DEFAULT NULL::uuid,
	IN p_id3 uuid DEFAULT NULL::uuid,
	IN p_app_id uuid DEFAULT NULL::uuid,
	IN p_module_code text DEFAULT NULL::text
)
LANGUAGE 'sql'
AS $BODY$
/*#0000_0101-sys-pr_sys_append_audit_log

- append the record into tb_audit_log.

1) with p_msg param only.

	DO
	$test$
	BEGIN
		CALL pr_sys_append_audit_log(
			p_msg => ('audit log-' || localtimestamp::text)::text
		);
	END
	$test$;

2) with all param.

	DO
	$test$
	BEGIN
		CALL pr_sys_append_audit_log(
			p_msg => ('audit log-' || localtimestamp::text)::text
			, p_remarks => 'this is remarks'::text
			, p_uid => 'testER'::text
			, p_id1 => '1001'
			, p_id2 => '1002'
			, p_id3 => '1003'
            , p_app_id => 'AR'
			, p_module_id => 'issue-invoice'
			, p_db_id => '70da0a89-276a-41b6-996e-43c24a2abb1d'::uuid
		);
	END
	$test$;

select *
from tb_audit_log
order by audit_log_id desc
limit 10;

*/

    INSERT INTO tb_audit_log (
        created_on, created_by
		, task, remarks
        , id1, id2, id3
		, app_id, module_code
    ) VALUES (
        localtimestamp
        , lower(p_uid)

        , p_msg
		, p_remarks
        , p_id1
        , p_id2
        , p_id3

        , p_app_id
		, p_module_code
    );

$BODY$;
