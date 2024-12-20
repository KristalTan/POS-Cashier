CREATE OR REPLACE PROCEDURE pr_pos_station_save (
	IN p_current_uid character varying(255),
	OUT p_msg text,
	INOUT p_pos_station_id uuid,
	IN p_pos_station_desc character varying(255),
	IN p_ip character varying(50),
	IN p_default_printer_id uuid,
	IN p_is_in_use integer,
	IN p_display_seq character varying(6),
	IN p_rid integer,
	IN p_axn character varying(255),
	IN p_url character varying(255),
	IN p_is_debug integer DEFAULT 0
)
LANGUAGE 'plpgsql'
AS $BODY$
-- -------------------------------------
-- init
-- -------------------------------------
DECLARE
	v_now CONSTANT timestamp = current_timestamp;
	audit_log text;
	module_code text;
	v_pos_station_desc_old character varying(255);
	v_ip_old character varying(50);
	v_default_printer_id_old uuid;
	v_is_in_use_old integer;
	v_display_seq_old character varying(6);
BEGIN
/* 0100_0058_pr_pos_station_save

*/	

	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_station_save - start';
	END IF;
	
	module_code := 'Setting - Pos Station';

	-- -------------------------------------
	-- validation
	-- -------------------------------------
	IF LENGTH(COALESCE(p_pos_station_desc, '')) = 0 THEN
		p_msg := 'Pos Station Name cannot be blank!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT pos_station_desc
		FROM tb_pos_station
		WHERE 
			pos_station_desc = p_pos_station_desc
			AND pos_station_id <> fn_to_guid(p_pos_station_id)
	) THEN
		p_msg := 'Pos Station Name: ' || p_pos_station_desc || ' already exists!!';
		RETURN;
	END IF;
	
	IF EXISTS (
		SELECT ip
		FROM tb_pos_station
		WHERE 
			ip = p_ip
			AND pos_station_id <> fn_to_guid(p_pos_station_id)
	) THEN
		p_msg := 'IP Address: ' || p_ip || ' already exists!!';
		RETURN;
	END IF;
	
	IF NOT EXISTS (
		SELECT pos_printer_id 
		FROM tb_pos_printer
		WHERE pos_printer_id = p_default_printer_id
	) THEN
		p_msg := 'Invalid Printer!!';
		RETURN;
	END IF;

	-- -------------------------------------
	-- process
	-- -------------------------------------
	IF fn_to_guid(p_pos_station_id) = fn_empty_guid() THEN
	
		p_pos_station_id := gen_random_uuid();
		
		-- Insert new record
		INSERT INTO tb_pos_station (
			pos_station_id, created_on, created_by, modified_on, modified_by, pos_station_desc, ip, default_printer_id, is_in_use, display_seq
		) VALUES (
			p_pos_station_id, v_now, p_current_uid, v_now, p_current_uid, p_pos_station_desc, p_ip, p_default_printer_id, COALESCE(p_is_in_use, 0), p_display_seq
		);
		
		audit_log := 'Added Pos Station: ' || p_pos_station_desc || '.';
	
	ELSE
	
		-- Get old record for audit log purpose
		SELECT pos_station_desc, ip, default_printer_id, is_in_use, display_seq
		INTO v_pos_station_desc_old, v_ip_old, v_default_printer_id_old, v_is_in_use_old, v_display_seq_old
		FROM tb_pos_station
		WHERE pos_station_id = p_pos_station_id;
		
		UPDATE tb_pos_station
		SET 
			modified_on = v_now,
			modified_by = p_current_uid,
			pos_station_desc = p_pos_station_desc,
			ip = p_ip,
			default_printer_id = p_default_printer_id,
			is_in_use = p_is_in_use,
			display_seq = p_display_seq
		WHERE pos_station_id = p_pos_station_id;
		
		audit_log := 'Updated Pos Station Description from ' || v_pos_station_desc_old || ' to ' || p_pos_station_desc || ', ' ||
						'Updated Pos Station IP from ' || v_ip_old || ' to ' || p_ip || ', ' ||
						'Updated Default Printer from ' || v_default_printer_id_old || ' to ' || p_default_printer_id || ', ' ||
						'Updated Is In Use from ' || v_is_in_use_old || ' to ' || p_is_in_use || ', ' ||
						'Updated Display Sequence from ' || v_display_seq_old || ' to ' || p_display_seq || '.';
	
	END IF;
	
	p_msg := 'ok';
	
	-- Create Audit Log
	CALL pr_sys_append_audit_log (
		p_msg => audit_log
		, p_remarks => 'pr_pos_station_save'
		, p_uid => p_current_uid
		, p_id1 => p_pos_station_id
		, p_id2 => null
		, p_id3 => null
        , p_app_id => null
		, p_module_code => module_code
	); 

	-- -------------------------------------
	-- cleanup
	-- -------------------------------------
	IF p_is_debug = 1 THEN
		RAISE NOTICE 'pr_pos_station_save - end';
	END IF;

END
$BODY$;