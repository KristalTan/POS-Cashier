CREATE OR REPLACE VIEW vw_pymt_mode AS
SELECT pm.pymt_mode_id, pm.pymt_mode_desc, pm.is_in_use, pt.pymt_type_id, pt.pymt_type_desc 
FROM tb_pymt_mode pm
INNER JOIN tb_pymt_type pt ON pt.pymt_type_id = pm.pymt_type_id
ORDER BY pm.pymt_mode_desc;

