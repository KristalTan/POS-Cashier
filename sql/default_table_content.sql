insert into tb_action (action_id, action_code, action_desc, sql_q, group_code, is_in_use, display_seq, created_on, created_by, is_default_func) values
-- Module: Product
('1296c008-4372-485f-91cf-81a544f476c2', 'prod-category::s', 'Product - Category Save', 'pr_prod_category_save', 'Product', 1, '000001', current_timestamp, 'admin', 0),
('1613d531-d05e-4bb7-b36b-42f8315724a7', 'prod-category::l', 'Product - View Category', 'fn_prod_category_list', 'Product', 1, '000002',  current_timestamp, 'admin', 1),
('fc8cce35-389e-4d0b-b069-6b8c0efd27e7', 'prod-category::d', 'Product - Category Delete', 'pr_prod_category_delete', 'Product', 0, '000003', current_timestamp, 'admin', 0),

('bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'prod-setup::s', 'Product - Save', 'pr_product_save', 'Product', 1, '000004', current_timestamp, 'admin', 0),
('346690c3-55c7-4f64-bf7f-f8fd3ddc6790', 'prod-setup::l', 'Product - View', 'fn_product_list', 'Product', 1, '000005',  current_timestamp, 'admin', 1),
('6b19043f-d393-4597-9d2a-c97bb6513f68', 'prod-setup::d', 'Product - Delete', 'pr_product_delete', 'Product', 0, '000006', current_timestamp, 'admin', 0),

('42fb72be-22d0-4f39-95db-377367c2d00f', 'prod-modifier::gs', 'Product - Modifier Group Save', 'pr_product_modifier_group_save', 'Product', 1, '000007', current_timestamp, 'admin', 0),
('86548e95-e944-4ca7-8a17-ea70674a764c', 'prod-modifier::gl', 'Product - View Modifier Group', 'fn_modifier_group_list', 'Product', 1, '000008', current_timestamp, 'admin', 1),
('c2332147-f3fc-415c-aa91-7bb3cd720cdb', 'prod-modifier::gos', 'Product - Modifier Group Option Save', 'pr_product_modifier_item_save', 'Product', 1, '000009', current_timestamp, 'admin', 0),
('4d629468-c4e5-42d7-806f-a17408c31a28', 'prod-modifier::gol', 'Product - View Modifier Group Option', 'fn_product_modifier_item_list', 'Product', 1, '000010', current_timestamp, 'admin', 1),
('199aa45b-7db2-4d2e-9910-f61861b09b4a', 'prod-modifier::lis', 'Product - Modifier Group Link Item Save', 'pr_product_modifier_group_item_link_save', 'Product', 1, '000011', current_timestamp, 'admin', 0),
('aeffb299-d03b-41c1-a50f-3c167bba9b31', 'prod-modifier::lil', 'Product - View Modifier Group Link Item', 'fn_product_modifier_group_item_link_list', 'Product', 1, '000012', current_timestamp, 'admin', 1),

('234acc1f-6311-46d2-9d27-9b156e529e46', 'prod-daily-avail::s', 'Product - Daily Availabilty Save', 'pr_daily_availability_update', 'Product', 1, '000013', current_timestamp, 'admin', 0),
('8bfc56a4-7696-4221-8e9b-58ff1a9197e5', 'prod-daily-avail::l', 'Product - View Daily Availabilty', 'fn_daily_availability_list', 'Product', 1, '000014',  current_timestamp, 'admin', 1),

-- Module: Settings
('c9bf4e0b-b404-442e-9050-8b0294ff6cbb', 'setting-general::s', 'Setting - General Setting Save', 'pr_general_setting_save', 'Setting', 1, '000015', current_timestamp, 'admin', 0),
('f4a0aeb3-e5b8-4dc7-84f9-35440684cb62', 'setting-general::l', 'Setting - View General Setting', 'fn_general_setting_list', 'Setting', 1, '000016', current_timestamp, 'admin', 1),

('bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'setting-store::s', 'Setting - Store Save', 'pr_store_save', 'Setting', 1, '000017', current_timestamp, 'admin', 0),
('13a3d1dc-ef59-4ef1-a3e5-a3d952e0fdef', 'setting-store::l', 'Setting - View Store', 'fn_store_list', 'Setting', 1, '000018', current_timestamp, 'admin', 1),
('5274a0b5-6771-49c1-980d-943e81ba01ad'), 'setting-store::d', 'Setting - Store Delete', 'pr_store_delete', 'Setting', 0, '000019', current_timestamp, 'admin', 0),

('b1b87b82-7bdd-4720-8b1a-a7f7c906aefc', 'setting-tax::s', 'Setting - Tax Save', 'pr_tax_save', 'Setting', 1, '000020', current_timestamp, 'admin', 0),
('06a89868-2f38-438d-8f4c-a00beae51048', 'setting-tax::l', 'Setting - View Tax', 'fn_tax_list', 'Setting', 1, '000021', current_timestamp, 'admin', 1),
('1c26a29f-d5b3-4a0b-8f72-335c0e3610b2', 'setting-tax::d', 'Setting - Tax Delete', 'pr_tax_delete', 'Setting', 0, '000022', current_timestamp, 'admin', 0),

('a4c5b496-c22c-430e-9fd5-7de7c8e92acd', 'setting-pymt-mode::s', 'Setting - Payment Mode Save', 'pr_pymt_mode_save', 'Setting', 1, '000023', current_timestamp, 'admin', 0),
('7e8ca4ae-0e21-4fdf-a60f-ebbbaa88b2f0', 'setting-pymt-mode::l', 'Setting - View Payment Mode', 'fn_pymt_mode_list', 'Setting', 1, '000024', current_timestamp, 'admin', 1),
('97d3f6d4-204d-4c98-a1fc-ec9cdbd1b686', 'setting-pymt-mode::d', 'Setting - Payment Mode Delete', 'pr_pymt_mode_delete', 'Setting', 0, '000025', current_timestamp, 'admin', 0),

('5308e896-1554-403f-9bc3-0417de13bda4', 'setting-pymt-mode::tl', 'Setting - View Payment Type', 'fn_pymt_type_list', 'Setting', 1, '000026', current_timestamp, 'admin', 1),

('7f1fdef5-737d-4fdb-9539-7e8071fccb56', 'setting-meal-period::s', 'Setting - Meal Period Save', 'pr_meal_period_save', 'Setting', 1, '000027', current_timestamp, 'admin', 0),
('29bfae74-e8d0-4912-9f04-b2e28c8222a3', 'setting-meal-period::l', 'Setting - View Meal Period', 'fn_meal_period_list', 'Setting', 1, '000028', current_timestamp, 'admin', 1),
('593c1204-88e7-4ec6-8b92-00f8419d60d4', 'setting-meal-period::d', 'Setting - Meal Period Delete', 'pr_meal_period_delete', 'Setting', 0, '000029', current_timestamp, 'admin', 0),

('c9b99fa5-de79-4196-89b6-8aea912143a5', 'setting-receipt-temp::s', 'Setting - Receipt Template Save', 'pr_receipt_temp_save', 'Setting', 1, '000030', current_timestamp, 'admin', 0),
('884f890f-c874-4f4f-b9a1-b9420cd82841', 'setting-receipt-temp::l', 'Setting - View Receipt Template', 'fn_receipt_temp_list', 'Setting', 1, '000031', current_timestamp, 'admin', 1),
('c73c8c5e-b930-49a2-941c-a03defd775e2', 'setting-receipt-temp::d', 'Setting - Receipt Template Delete', 'pr_receipt_temp_delete', 'Setting', 0, '000032', current_timestamp, 'admin', 0),

('9ec74f79-a1c0-4ff8-ad0c-b97d91771644', 'setting-table-sec::s', 'Setting - Table Section Save', 'pr_table_section_save', 'Setting', 1, '000033', current_timestamp, 'admin', 0),
('4fbfe7a1-fc63-47b2-b739-86350f3103e4', 'setting-table-sec::l', 'Setting - View Table Section', 'fn_table_section_list', 'Setting', 1, '000034', current_timestamp, 'admin', 1),
('f516b87e-21b5-47b8-a330-8d8a7392b5c4', 'setting-table-sec::d', 'Setting - Table Section Delete', 'pr_table_section_delete', 'Setting', 0, '000035', current_timestamp, 'admin', 0),

('4d91c40a-feef-47e5-b542-dba002510b62', 'setting-table::s', 'Setting - Table Save', 'pr_table_save', 'Setting', 1, '000036', current_timestamp, 'admin', 0),
('37af1bbc-f1b5-49f3-87a1-0c3694b56569', 'setting-table::l', 'Setting - View Table', 'fn_table_list', 'Setting', 1, '000037', current_timestamp, 'admin', 1),
('c1e51e41-cf43-44b1-9338-335e248865f4', 'setting-table::d', 'Setting - Table Delete', 'pr_table_delete', 'Setting', 0, '000038', current_timestamp, 'admin', 0),

('5a04fe24-bb9f-4096-8cc2-e8d11704bcd6', 'pos-station::s', 'Setting - POS Station Save', 'pr_pos_station_save', 'Setting', 1, '000039', current_timestamp, 'admin', 0),
('c7f5a137-744f-4822-be2d-4a064688f8b5', 'pos-station::l', 'Setting - View POS Station', 'fn_pos_station_list', 'Setting', 1, '000040', current_timestamp, 'admin', 1),

('38fe1f07-0572-48fe-b97e-dfb576ed535f', 'pos-printer::s', 'Setting - POS Printer Save', 'pr_pos_printer_save', 'Setting', 1, '000041', current_timestamp, 'admin', 0),
('f2cde6c3-c59b-44e5-8611-2855d82d514f', 'pos-printer::l', 'Setting - View POS Printer', 'fn_pos_printer_list', 'Setting', 1, '000042', current_timestamp, 'admin', 1),
('ca286e43-21f8-48e9-8612-faecdc5cb0f0', 'pos-printer::ptl', 'Setting - View POS Printer Type', 'pr_printer_type_list', 'Setting', 1, '000043', current_timestamp, 'admin', 1),

('a99d6e35-825d-4307-b48e-92ab39526cf2', 'other::cl', 'Other - Country List', 'fn_country_list', 'Others', 1, '000044', current_timestamp, 'admin', 1),
('0961b167-8b80-4502-b6d9-8476532634d0', 'other::sl', 'Other - State List', 'fn_state_list', 'Others', 1, '000045', current_timestamp, 'admin', 1),
('e06fe881-dc37-46f3-8567-047ac609f1c5', 'other::ptl', 'Other - Pricing Type List', 'fn_pricing_type_list', 'Others', 1, '000046', current_timestamp, 'admin', 1),
('d79ef2ea-e0e7-43e7-bf84-7b9940411382', 'other::all', 'Other - View Audit Log', 'fn_audit_log_list', 'Others', 1, '000047', current_timestamp, 'admin', 0),

-- Module: Customer
('04032095-2a06-4ac3-bbb0-4873a56b1856', 'app-customer::s', 'Customer - Save', 'pr_guest_save', 'Customer', 1, '000048', current_timestamp, 'admin', 0),
('e88328bd-4398-4dfa-9ce3-7151e2282a72', 'app-customer::l', 'Customer - List', 'fn_guest_list', 'Customer', 1, '000049', current_timestamp, 'admin', 1),
('fe2ed530-d5df-4957-9a6b-7ffffea18d5a', 'app-customer::d', 'Customer - Delete', 'pr_guest_delete', 'Customer', 0, '000050', current_timestamp, 'admin', 0),

-- Module: Supplier
('1f00d776-a17d-4e70-a6a2-0410b630c54d', 'app-supplier::s', 'Supplier - Save', 'pr_supplier_save', 'Supplier', 0, '000051', current_timestamp, 'admin', 0),
('ec276937-f725-423e-b65c-5aa59023ab97', 'app-supplier::l', 'Supplier - List', 'fn_supplier_list', 'Supplier', 0, '000052', current_timestamp, 'admin', 1),
('bd2ec562-245f-4e7e-bf9c-3f77b934acd0', 'app-supplier::d', 'Supplier - Delete', 'pr_supplier_delete', 'Supplier', 0, '000053', current_timestamp, 'admin', 0),

-- Module: Users
('f2737b0c-9359-4486-815c-b38b2015eb4d', 'app-user-group::s', 'Users - User Group Save', 'pr_user_group_save', 'Users', 1, '000054', current_timestamp, 'admin', 0),
('9280fb2c-4e25-45ab-bcd5-a1657e61f23f', 'app-user-group::l', 'Users - View User Group', 'fn_user_group_list', 'Users', 1, '000055', current_timestamp, 'admin', 0),
('c1ff314c-10e6-4203-804b-f406790765ad', 'app-user-group::acs', 'Users - User Group Action Save', 'pr_user_group_action_save', 'Users', 1, '000056', current_timestamp, 'admin', 0),
('e5b11c45-b204-4485-b20f-6652063844c8', 'app-user-group::acl', 'Users - View User Group Action', 'fn_user_group_action_list', 'Users', 1, '000057', current_timestamp, 'admin', 0),
('543abc1b-a347-4ab0-85d1-664362579925', 'app-users::s', 'Users - User Save', 'pr_user_save', 'Users', 1, '000058', current_timestamp, 'admin', 0),
('655abc6d-8ad8-43d6-9bb9-36b55f014fb5', 'app-users::l', 'Users - View User', 'fn_user_list', 'Users', 1, '000059', current_timestamp, 'admin', 0),

-- Module: Action
('69f4b2b3-db4b-4001-b16f-0987ab79bfd5', 'app-axn::l', 'Action - View Action', 'fn_action_list', 'Action', 1, '000060', current_timestamp, 'admin', 0),

-- Module: Order
('20591a3f-f905-487b-930f-d6c5ca02d84a', 'app-order-trans::s', 'Order - Order Transaction Save', 'pr_order_trans_save', 'Order Process', 1, '000061', current_timestamp, 'admin', 1),
('fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'app-order-trans::ails', 'Order - Add Item Line/ Add Payment Save', 'pr_pos_add_trans_item_line', 'Order Process', 1, '000062', current_timestamp, 'admin', 1),
('8c643729-7532-4b80-8895-2869b5f55c40', 'app-order-trans::sa', 'Order - Set Addon', 'pr_pos_addon_trans_set', 'Order Process', 1, '000063', current_timestamp, 'admin', 1),
('7700e5b1-039b-441d-ba3f-f464eda7acfa', 'app-order-trans::ra', 'Order - Remove Addon', 'pr_pos_add_trans_remove', 'Order Process', 1, '000064', current_timestamp, 'admin', 1),
('31544af9-4b84-45fe-9a1d-1807785cd2cf', 'app-order-trans::id', 'Order - Item Discount', 'pr_pos_trans_item_disc', 'Order Process', 1, '000065', current_timestamp, 'admin', 0),
('e4443c40-8521-4bbd-a9ae-3d444e7a0cd2', 'app-order-trans::bd', 'Order - Bill Discount', 'pr_pos_trans_bill_disc', 'Order Process', 1, '000066', current_timestamp, 'admin', 0),
('c7e32761-34a0-44b8-8746-91e40d875a68', 'app-order-trans::vi', 'Order - Void Item', 'pr_pos_trans_void_item', 'Order Process', 1, '000067', current_timestamp, 'admin', 0),
('5a4b20a0-f7d3-425d-b093-022c8160eb6b', 'app-order-trans::vb', 'Order - Void Bill', 'pr_pos_trans_void_bill', 'Order Process', 1, '000068', current_timestamp, 'admin', 0),
('a4ae5797-8bf4-422a-9d75-4234d6eda663', 'app-order-trans::op', 'Order - Override Price', 'pr_pos_trans_override_price', 'Order Process', 1, '000069', current_timestamp, 'admin', 0),
('1b63bd99-9bf7-4a9e-80e8-038fbe1f0b8f', 'app-order-trans::sp', 'Order - Split Bill', 'pr_pos_trans_split_bill', 'Order Process', 1, '000070', current_timestamp, 'admin', 0),
('255e7a66-6e49-467d-b237-205478992a28', 'app-order-trans::tr', 'Order - Transaction Receipt', 'pr_pos_trans_receipt', 'Order Process', 1, '000071', current_timestamp, 'admin', 1),
('838518ed-0760-487b-ab7d-8c28770eda49', 'app-order-trans::ptk', 'Order - Post to Kitchen', 'pr_pos_send_to_kitchen', 'Order Process', 1, '000072', current_timestamp, 'admin', 1),
('3d66bf32-523b-4cd4-a852-c7296ce9573f', 'app-order-trans::l', 'Order - View Order Transaction', 'pr_order_trans_list', 'Order Process', 1, '000073', current_timestamp, 'admin', 1),
('855eded5-c3a8-4b0b-a958-710d105badd6', 'app-order-trans::pl', 'Order - Product List', 'fn_order_product_list', 'Order Process', 1, '000074', current_timestamp, 'admin', 1),
('81a26b63-de75-47e3-88c9-1937e35507f6', 'app-order-trans::ml', 'Order - Modifier List', 'fn_order_modifier_list', 'Order Process', 1, '000075', current_timestamp, 'admin', 1),
('bdf3b996-922a-44c2-87fb-a27902edd8ba', 'app-order-trans::tl', 'Order - View Table Location List', 'fn_order_trans_table_list', 'Order Process', 1, '000081', current_timestamp, 'admin', 0),
('3681cceb-a75e-43d0-9eef-c57293ffb8e0', 'app-order-trans::il', 'Order - View Order Transaction Item', 'fn_order_trans_item_list', 'Order Process', 1, '000082', current_timestamp, 'admin', 0)

-- Module: Cashiering
('53c09823-1cc1-4f81-a29b-68b29d7870a8', 'app-cashiering-shift::o', 'Cashiering - Cashiering Shift Open', 'pr_cashiering_start', 'Cashiering Shift', 1, '000076', current_timestamp, 'admin', 0),
('6e14aa79-422d-4c81-814a-74d58b908ae0', 'app-cashiering-shift::c', 'Cashiering - Cashiering Shift Close', 'pr_cashiering_close', 'Cashiering Shift', 1, '000077', current_timestamp, 'admin', 0),
('13ec0e3c-02b4-4ade-b197-d8a14257c3a5', 'app-cashiering-shift::cp', 'Cashiering - Cashiering Shift Close Prepare Statement', 'fn_cashiering_prepare', 'Cashiering Shift', 1, '000078', current_timestamp, 'admin', 0),
('1d3bdedd-7f39-4316-9116-375379b49219', 'app-cashiering-shift::sc', 'Cashiering - Current Cashiering Shift Show', 'fn_cashiering_current', 'Cashiering Shift', 1, '000079', current_timestamp, 'admin', 0),
('883e499e-6b3d-4ad2-9960-47a1db316565', 'app-cashiering-shift::fc', 'Cashiering - Cashiering Shift Force Close', 'pr_cashiering_force_close', 'Cashiering Shift', 1, '000080', current_timestamp, 'admin', 0),

-- Module: Day-end Closing
('97ccfb72-3ce5-45c7-9032-7683fedd5e5a', 'app-day-end-closing::c', 'Day End Closing - Check', 'fn_day_end_close_prepare', 'Day End Closing', 1, '000095', current_timestamp, 'admin', 1),
('987f34fb-983c-4e53-b8bb-1fd4efeae974', 'app-day-end-closing::d', 'Day End Closing - Do day end closing', 'pr_day_end_close', 'Day End Closing', 1, '000096', current_timestamp, 'admin', 0),

-- Module - Notification
('56891f62-3e3e-4412-82e5-2d50a5c6c670', 'app-notif::l', 'Notification - View Notification', 'fn_notif_list', 'Notification', 1, '000097', current_timestamp, 'admin', 0),
('0229c031-6d02-42a3-863e-16ef262f87e1', 'app-notif::s', 'Notification - Notification Save', 'pr_notif_save', 'Notification', 1, '000098', current_timestamp, 'admin', 0),

-- Module - Schedule Report
('378a64e1-c2c6-4613-aa72-ffd02a72c5c2', 'app-sch-rpt::l', 'Schedule Report - View Schedule Report', 'fn_sch_rpt_list', 'Schedule Report', 1, '000099', current_timestamp, 'admin', 0),
('652676f4-1584-49b9-a6d3-e5e86347358b', 'app-sch-rpt::s', 'Schedule Report - Schedule Report Save', 'pr_sch_rpt_save', 'Schedule Report', 1, '000100', current_timestamp, 'admin', 0),

-- Module: Dashboard
('269a7bc9-03c4-4b08-b630-56ca05a9d14a', 'app-dashboard::l', 'Dashboard - View POS Dashboard', 'fn_pos_dashboard', 'Dashboard', 1, '000101', current_timestamp, 'admin', 0),

-- Module: Reports
('ddd5f198-1447-4d3b-8b79-d1dbc8f41027', 'app-report::dar', 'Report - Daily Availability Report', 'fn_rpt_daily_availability', 'Report', 0, '000083', current_timestamp, 'admin', 0),
('d26ee328-d90d-4cd5-92b2-19e96c402e60', 'app-report::iss', 'Report - Item Sales Summary', 'fn_rpt_daily_availability', 'Report', 0, '000084', current_timestamp, 'admin', 0),
('07074c6f-f8b4-4b52-9942-0aa58637f045', 'app-report::ds', 'Report - Daily Summary', 'fn_rpt_daily_availability', 'Report', 0, '000085', current_timestamp, 'admin', 0),
('300ae174-59f9-4f92-93df-2c1c625319eb', 'app-report::ils', 'Report - Invoice Listing Summary', 'fn_rpt_invoice_listing_summ', 'Report', 0, '000086', current_timestamp, 'admin', 0),
('6a40f2f6-d5d4-4e4f-a863-04bf5c577a6d', 'app-report::i86', 'Report - Item 86', 'fn_rpt_item86', 'Report', 0, '000087', current_timestamp, 'admin', 0),
('a064d444-48a9-4d22-b6c6-763be83a5bb0', 'app-report::ccr', 'Report - Cashiering Collection Report', 'fn_rpt_cashiering_collection', 'Report', 0, '000088', current_timestamp, 'admin', 0),
('583e859c-dc9e-43cd-a0e9-1e39212405c6', 'app-report::ivr', 'Report - Item Void Report', 'fn_rpt_item_void', 'Report', 0, '000089', current_timestamp, 'admin', 0),
('9671ad91-42d9-4454-8ca4-7aab13ac5b18', 'app-report::bvr', 'Report - Bill Void Report', 'fn_rpt_bill_void', 'Report', 0, '000090', current_timestamp, 'admin', 0),
('6c72bbbe-2cda-492f-a23b-2a25854d877d', 'app-report::dr', 'Report - Discount Report', 'fn_rpt_discount', 'Report', 0, '000091', current_timestamp, 'admin', 0),
('f3468548-f8e0-497e-85aa-58aeea6085a9', 'app-report::str', 'Report - Service Tax Report', 'fn_rpt_service_tax', 'Report', 0, '000092', current_timestamp, 'admin', 0),
('4cd4e494-cdb4-44e5-a394-dfeb31dc4de6', 'app-report::sstr', 'Report - Sales & Service Tax Report', 'fn_rpt_sst', 'Report', 0, '000093', current_timestamp, 'admin', 0),
('d46d4192-ddcc-44f1-9b20-23f4247185d1', 'app-report::rss', 'Report - Restaurant Sales Summary', 'fn_rpt_restaurant_sales_summ', 'Report', 0, '000094', current_timestamp, 'admin', 0)

INSERT INTO tb_acn_rlt_tb (created_on, created_by, action_id, rlt_tb) VALUES 
(current_timestamp, 'admin', '1296c008-4372-485f-91cf-81a544f476c2', 'tb_prod_category'),
(current_timestamp, 'admin', 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'tb_product'),
(current_timestamp, 'admin', '42fb72be-22d0-4f39-95db-377367c2d00f', 'tb_modifier_group'),
(current_timestamp, 'admin', 'c2332147-f3fc-415c-aa91-7bb3cd720cdb', 'tb_modifier_option'),
(current_timestamp, 'admin', '199aa45b-7db2-4d2e-9910-f61861b09b4a', 'tb_modifier_item_link'),
(current_timestamp, 'admin', '234acc1f-6311-46d2-9d27-9b156e529e46', 'tb_product_availability'),
(current_timestamp, 'admin', 'c9bf4e0b-b404-442e-9050-8b0294ff6cbb', 'tb_sys_setting'),
(current_timestamp, 'admin', 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'tb_store'),
(current_timestamp, 'admin', 'b1b87b82-7bdd-4720-8b1a-a7f7c906aefc', 'tb_tax'),
(current_timestamp, 'admin', 'a4c5b496-c22c-430e-9fd5-7de7c8e92acd', 'tb_pymt_mode'),
(current_timestamp, 'admin', '7f1fdef5-737d-4fdb-9539-7e8071fccb56', 'tb_meal_period'),
(current_timestamp, 'admin', 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'tb_receipt_temp'),
(current_timestamp, 'admin', '9ec74f79-a1c0-4ff8-ad0c-b97d91771644', 'tb_table_section'),
(current_timestamp, 'admin', '4d91c40a-feef-47e5-b542-dba002510b62', 'tb_table'),
(current_timestamp, 'admin', '5a04fe24-bb9f-4096-8cc2-e8d11704bcd6', 'tb_pos_station'),
(current_timestamp, 'admin', '38fe1f07-0572-48fe-b97e-dfb576ed535f', 'tb_pos_printer'),
(current_timestamp, 'admin', '04032095-2a06-4ac3-bbb0-4873a56b1856', 'tb_guest'),
(current_timestamp, 'admin', 'f2737b0c-9359-4486-815c-b38b2015eb4d', 'tb_user_group'),
(current_timestamp, 'admin', 'c1ff314c-10e6-4203-804b-f406790765ad', 'tb_user_group_action'),
(current_timestamp, 'admin', '543abc1b-a347-4ab0-85d1-664362579925', 'tb_users'),
(current_timestamp, 'admin', '31544af9-4b84-45fe-9a1d-1807785cd2cf', 'tb_ordre_trans_item_line'),
(current_timestamp, 'admin', 'e4443c40-8521-4bbd-a9ae-3d444e7a0cd2', 'tb_order_trans'),
(current_timestamp, 'admin', 'c7e32761-34a0-44b8-8746-91e40d875a68', 'tb_order_trans_item_line_void'),
(current_timestamp, 'admin', '5a4b20a0-f7d3-425d-b093-022c8160eb6b', 'tb_order_trans_void_log'),
(current_timestamp, 'admin', 'a4ae5797-8bf4-422a-9d75-4234d6eda663', 'tb_order_trans_item_line'),
(current_timestamp, 'admin', '53c09823-1cc1-4f81-a29b-68b29d7870a8', 'tb_cashiering'),
(current_timestamp, 'admin', '6e14aa79-422d-4c81-814a-74d58b908ae0', 'tb_cashiering'),
(current_timestamp, 'admin', '883e499e-6b3d-4ad2-9960-47a1db316565', '')

insert into tb_action_param (action_param_id, action_id, action_param_name, data_type, seq, is_compulsory, created_on, created_by) values
-- prod-category::s
(gen_random_uuid(), '1296c008-4372-485f-91cf-81a544f476c2', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '1296c008-4372-485f-91cf-81a544f476c2', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1296c008-4372-485f-91cf-81a544f476c2', 'category_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1296c008-4372-485f-91cf-81a544f476c2', 'category_desc', 'string', 4, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '1296c008-4372-485f-91cf-81a544f476c2', 'is_in_use', 'int', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1296c008-4372-485f-91cf-81a544f476c2', 'display_seq', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1296c008-4372-485f-91cf-81a544f476c2', 'rid', 'int', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1296c008-4372-485f-91cf-81a544f476c2', 'axn', 'string', 8, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '1296c008-4372-485f-91cf-81a544f476c2', 'url', 'string', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1296c008-4372-485f-91cf-81a544f476c2', 'is_debug', 'int', 10, 0, current_timestamp, 'admin'),
-- prod-category::l
(gen_random_uuid(), '1613d531-d05e-4bb7-b36b-42f8315724a7', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '1613d531-d05e-4bb7-b36b-42f8315724a7', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1613d531-d05e-4bb7-b36b-42f8315724a7', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1613d531-d05e-4bb7-b36b-42f8315724a7', 'axn', 'string', 4, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '1613d531-d05e-4bb7-b36b-42f8315724a7', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1613d531-d05e-4bb7-b36b-42f8315724a7', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- prod-category::d
(gen_random_uuid(), 'fc8cce35-389e-4d0b-b069-6b8c0efd27e7', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'fc8cce35-389e-4d0b-b069-6b8c0efd27e7', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fc8cce35-389e-4d0b-b069-6b8c0efd27e7', 'category_id', 'id', 3, 0, current_timestamp, 'admin'),

-- prod-setup::s
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'product_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'product_desc', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'product_code', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'category_id', 'id', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'product_tag', 'string', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'product_img_path', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'inventory_type_id', 'id', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'sku_code', 'string', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'supplier_id', 'id', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'pricing_type_id', 'id', 12, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'cost', 'money', 13, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'sell_price', 'money', 14, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'tax_code1', 'string', 15, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'amt_include_tax1', 'int', 16, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'tax_code2', 'string', 17, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'amt_include_tax2', 'int', 18, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'calc_tax2_after_tax1', 'int', 19, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'is_in_use', 'int', 20, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'display_seq', 'string', 21, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'is_enable_kitchen_printer', 'int', 22, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'is_allow_modifier', 'int', 23, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'is_enable_track_stock', 'int', 24, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'is_enable_daily_avail ', 'int', 25, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'is_popular_item', 'int', 26, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'meal_period', 'text', 27, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'pos_printer', 'text', 28, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'rid', 'int', 29, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'axn', 'string', 30, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'url', 'string', 31, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bcc1296e-0f45-4d02-be5b-f110a1681c0c', 'is_debug', 'int', 32, 0, current_timestamp, 'admin'),
-- prod-setup::l
(gen_random_uuid(), '346690c3-55c7-4f64-bf7f-f8fd3ddc6790', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '346690c3-55c7-4f64-bf7f-f8fd3ddc6790', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '346690c3-55c7-4f64-bf7f-f8fd3ddc6790', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '346690c3-55c7-4f64-bf7f-f8fd3ddc6790', 'axn', 'string', 4, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '346690c3-55c7-4f64-bf7f-f8fd3ddc6790', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '346690c3-55c7-4f64-bf7f-f8fd3ddc6790', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
--prod-setup::d
(gen_random_uuid(), '6b19043f-d393-4597-9d2a-c97bb6513f68', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '6b19043f-d393-4597-9d2a-c97bb6513f68', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '6b19043f-d393-4597-9d2a-c97bb6513f68', 'product_id', 'id', 3, 0, current_timestamp, 'admin'),

-- prod-modifier::gs
(gen_random_uuid(), '42fb72be-22d0-4f39-95db-377367c2d00f', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '42fb72be-22d0-4f39-95db-377367c2d00f', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '42fb72be-22d0-4f39-95db-377367c2d00f', 'modifier_group_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '42fb72be-22d0-4f39-95db-377367c2d00f', 'modifier_group_name', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '42fb72be-22d0-4f39-95db-377367c2d00f', 'is_single_modifier_choice', 'int', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '42fb72be-22d0-4f39-95db-377367c2d00f', 'is_multiple_modifier_choice', 'int', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '42fb72be-22d0-4f39-95db-377367c2d00f', 'is_in_use', 'int', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '42fb72be-22d0-4f39-95db-377367c2d00f', 'display_seq', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '42fb72be-22d0-4f39-95db-377367c2d00f', 'rid', 'int', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '42fb72be-22d0-4f39-95db-377367c2d00f', 'axn', 'string', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '42fb72be-22d0-4f39-95db-377367c2d00f', 'url', 'string', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '42fb72be-22d0-4f39-95db-377367c2d00f', 'is_debug', 'int', 12, 0, current_timestamp, 'admin'),
-- prod-modifier::gl
(gen_random_uuid(), '86548e95-e944-4ca7-8a17-ea70674a764c', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '86548e95-e944-4ca7-8a17-ea70674a764c', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '86548e95-e944-4ca7-8a17-ea70674a764c', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '86548e95-e944-4ca7-8a17-ea70674a764c', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '86548e95-e944-4ca7-8a17-ea70674a764c', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '86548e95-e944-4ca7-8a17-ea70674a764c', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- prod-modifier::gos
(gen_random_uuid(), 'c2332147-f3fc-415c-aa91-7bb3cd720cdb', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'c2332147-f3fc-415c-aa91-7bb3cd720cdb', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c2332147-f3fc-415c-aa91-7bb3cd720cdb', 'modifier_option_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c2332147-f3fc-415c-aa91-7bb3cd720cdb', 'modifier_group_id', 'id', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c2332147-f3fc-415c-aa91-7bb3cd720cdb', 'modifier_option_name', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c2332147-f3fc-415c-aa91-7bb3cd720cdb', 'addon_amt', 'money', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c2332147-f3fc-415c-aa91-7bb3cd720cdb', 'is_default', 'int', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c2332147-f3fc-415c-aa91-7bb3cd720cdb', 'rid', 'int', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c2332147-f3fc-415c-aa91-7bb3cd720cdb', 'axn', 'string', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c2332147-f3fc-415c-aa91-7bb3cd720cdb', 'url', 'string', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c2332147-f3fc-415c-aa91-7bb3cd720cdb', 'is_debug', 'int', 11, 0, current_timestamp, 'admin'),
-- prod-modifier::gol
(gen_random_uuid(), '4d629468-c4e5-42d7-806f-a17408c31a28', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '4d629468-c4e5-42d7-806f-a17408c31a28', 'modifier_group_id', 'id', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4d629468-c4e5-42d7-806f-a17408c31a28', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4d629468-c4e5-42d7-806f-a17408c31a28', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4d629468-c4e5-42d7-806f-a17408c31a28', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4d629468-c4e5-42d7-806f-a17408c31a28', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- prod-modifier::lis
(gen_random_uuid(), '199aa45b-7db2-4d2e-9910-f61861b09b4a', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '199aa45b-7db2-4d2e-9910-f61861b09b4a', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '199aa45b-7db2-4d2e-9910-f61861b09b4a', 'link_item', 'text', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '199aa45b-7db2-4d2e-9910-f61861b09b4a', 'modifier_group_id', 'id', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '199aa45b-7db2-4d2e-9910-f61861b09b4a', 'rid', 'int', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '199aa45b-7db2-4d2e-9910-f61861b09b4a', 'axn', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '199aa45b-7db2-4d2e-9910-f61861b09b4a', 'url', 'string', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '199aa45b-7db2-4d2e-9910-f61861b09b4a', 'is_debug', 'int', 8, 0, current_timestamp, 'admin'),
-- prod-modifier::lil
(gen_random_uuid(), 'aeffb299-d03b-41c1-a50f-3c167bba9b31', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'aeffb299-d03b-41c1-a50f-3c167bba9b31', 'modifier_group_id', 'id', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'aeffb299-d03b-41c1-a50f-3c167bba9b31', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'aeffb299-d03b-41c1-a50f-3c167bba9b31', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'aeffb299-d03b-41c1-a50f-3c167bba9b31', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'aeffb299-d03b-41c1-a50f-3c167bba9b31', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
--prod-daily-avail::s
(gen_random_uuid(), '234acc1f-6311-46d2-9d27-9b156e529e46', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '234acc1f-6311-46d2-9d27-9b156e529e46', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '234acc1f-6311-46d2-9d27-9b156e529e46', 'start_dt', 'dt', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '234acc1f-6311-46d2-9d27-9b156e529e46', 'end_dt', 'dt', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '234acc1f-6311-46d2-9d27-9b156e529e46', 'product_id', 'id', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '234acc1f-6311-46d2-9d27-9b156e529e46', 'qty', 'int', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '234acc1f-6311-46d2-9d27-9b156e529e46', 'rid', 'int', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '234acc1f-6311-46d2-9d27-9b156e529e46', 'axn', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '234acc1f-6311-46d2-9d27-9b156e529e46', 'url', 'string', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '234acc1f-6311-46d2-9d27-9b156e529e46', 'is_debug', 'int', 10, 0, current_timestamp, 'admin'),
-- prod-daily-avail::l
(gen_random_uuid(), '8bfc56a4-7696-4221-8e9b-58ff1a9197e5', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '8bfc56a4-7696-4221-8e9b-58ff1a9197e5', 'start_dt', 'dt', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '8bfc56a4-7696-4221-8e9b-58ff1a9197e5', 'end_dt', 'dt', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '8bfc56a4-7696-4221-8e9b-58ff1a9197e5', 'rid', 'int', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '8bfc56a4-7696-4221-8e9b-58ff1a9197e5', 'axn', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '8bfc56a4-7696-4221-8e9b-58ff1a9197e5', 'url', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '8bfc56a4-7696-4221-8e9b-58ff1a9197e5', 'is_debug', 'int', 7, 0, current_timestamp, 'admin'),

-- setting-general::s
(gen_random_uuid(), 'c9bf4e0b-b404-442e-9050-8b0294ff6cbb', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9bf4e0b-b404-442e-9050-8b0294ff6cbb', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9bf4e0b-b404-442e-9050-8b0294ff6cbb', 'setting_title', 'text', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9bf4e0b-b404-442e-9050-8b0294ff6cbb', 'setting_value', 'text', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9bf4e0b-b404-442e-9050-8b0294ff6cbb', 'rid', 'int', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9bf4e0b-b404-442e-9050-8b0294ff6cbb', 'axn', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9bf4e0b-b404-442e-9050-8b0294ff6cbb', 'url', 'string', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9bf4e0b-b404-442e-9050-8b0294ff6cbb', 'is_debug', 'int', 8, 0, current_timestamp, 'admin'),
-- setting-general::l
(gen_random_uuid(), 'f4a0aeb3-e5b8-4dc7-84f9-35440684cb62', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'f4a0aeb3-e5b8-4dc7-84f9-35440684cb62', 'rid', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f4a0aeb3-e5b8-4dc7-84f9-35440684cb62', 'axn', 'string', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f4a0aeb3-e5b8-4dc7-84f9-35440684cb62', 'url', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f4a0aeb3-e5b8-4dc7-84f9-35440684cb62', 'is_debug', 'int', 5, 0, current_timestamp, 'admin'),

-- setting-store::s
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'store_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'store_code', 'string', 4, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'store_name', 'string', 5, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'addr_line_1', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'addr_line_2', 'string', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'city', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'state', 'id', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'post_code', 'string', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'country', 'id', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'phone_number', 'string', 12, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'email', 'string', 13, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'website', 'string', 14, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'gst_id', 'string', 15, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'sst_id', 'string', 16, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'business_registration_num', 'string', 17, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'receipt_temp_id', 'id', 18, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'curr_code', 'string', 19, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'rid', 'int', 20, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'axn', 'string', 21, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'url', 'string', 22, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd23cb72-e6be-4e1c-b61f-d9c6a21adc85', 'is_debug', 'int', 23, 0, current_timestamp, 'admin'),
-- setting-store::l
(gen_random_uuid(), '13a3d1dc-ef59-4ef1-a3e5-a3d952e0fdef', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '13a3d1dc-ef59-4ef1-a3e5-a3d952e0fdef', 'rid', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '13a3d1dc-ef59-4ef1-a3e5-a3d952e0fdef', 'axn', 'string', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '13a3d1dc-ef59-4ef1-a3e5-a3d952e0fdef', 'url', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '13a3d1dc-ef59-4ef1-a3e5-a3d952e0fdef', 'is_debug', 'int', 5, 0, current_timestamp, 'admin'),
-- setting-store::d
(gen_random_uuid(), '5274a0b5-6771-49c1-980d-943e81ba01ad', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '5274a0b5-6771-49c1-980d-943e81ba01ad', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5274a0b5-6771-49c1-980d-943e81ba01ad', 'store_id', 'id', 3, 0, current_timestamp, 'admin'),

-- setting-tax::s
(gen_random_uuid(), 'b1b87b82-7bdd-4720-8b1a-a7f7c906aefc', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'b1b87b82-7bdd-4720-8b1a-a7f7c906aefc', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'b1b87b82-7bdd-4720-8b1a-a7f7c906aefc', 'tax_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'b1b87b82-7bdd-4720-8b1a-a7f7c906aefc', 'tax_code', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'b1b87b82-7bdd-4720-8b1a-a7f7c906aefc', 'tax_desc', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'b1b87b82-7bdd-4720-8b1a-a7f7c906aefc', 'tax_pct', 'money', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'b1b87b82-7bdd-4720-8b1a-a7f7c906aefc', 'is_in_use', 'int', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'b1b87b82-7bdd-4720-8b1a-a7f7c906aefc', 'display_seq', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'b1b87b82-7bdd-4720-8b1a-a7f7c906aefc', 'rid', 'int', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'b1b87b82-7bdd-4720-8b1a-a7f7c906aefc', 'axn', 'string', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'b1b87b82-7bdd-4720-8b1a-a7f7c906aefc', 'url', 'string', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'b1b87b82-7bdd-4720-8b1a-a7f7c906aefc', 'is_debug', 'int', 12, 0, current_timestamp, 'admin'),
-- setting-tax::l
(gen_random_uuid(), '06a89868-2f38-438d-8f4c-a00beae51048', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '06a89868-2f38-438d-8f4c-a00beae51048', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '06a89868-2f38-438d-8f4c-a00beae51048', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '06a89868-2f38-438d-8f4c-a00beae51048', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '06a89868-2f38-438d-8f4c-a00beae51048', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '06a89868-2f38-438d-8f4c-a00beae51048', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- setting-tax::d
(gen_random_uuid(), '1c26a29f-d5b3-4a0b-8f72-335c0e3610b2', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '1c26a29f-d5b3-4a0b-8f72-335c0e3610b2', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1c26a29f-d5b3-4a0b-8f72-335c0e3610b2', 'tax_id', 'id', 3, 0, current_timestamp, 'admin'),

-- setting-pymt-mode::s
(gen_random_uuid(), 'a4c5b496-c22c-430e-9fd5-7de7c8e92acd', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4c5b496-c22c-430e-9fd5-7de7c8e92acd', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4c5b496-c22c-430e-9fd5-7de7c8e92acd', 'pymt_mode_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4c5b496-c22c-430e-9fd5-7de7c8e92acd', 'pymt_mode_desc', 'string', 4, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4c5b496-c22c-430e-9fd5-7de7c8e92acd', 'pymt_type', 'id', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4c5b496-c22c-430e-9fd5-7de7c8e92acd', 'is_in_use', 'int', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4c5b496-c22c-430e-9fd5-7de7c8e92acd', 'rid', 'int', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4c5b496-c22c-430e-9fd5-7de7c8e92acd', 'axn', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4c5b496-c22c-430e-9fd5-7de7c8e92acd', 'url', 'string', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4c5b496-c22c-430e-9fd5-7de7c8e92acd', 'is_debug', 'int', 10, 0, current_timestamp, 'admin'),
-- setting-pymt-mode::l
(gen_random_uuid(), '7e8ca4ae-0e21-4fdf-a60f-ebbbaa88b2f0', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '7e8ca4ae-0e21-4fdf-a60f-ebbbaa88b2f0', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7e8ca4ae-0e21-4fdf-a60f-ebbbaa88b2f0', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7e8ca4ae-0e21-4fdf-a60f-ebbbaa88b2f0', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7e8ca4ae-0e21-4fdf-a60f-ebbbaa88b2f0', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7e8ca4ae-0e21-4fdf-a60f-ebbbaa88b2f0', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- setting-pymt-mode::d
(gen_random_uuid(), '97d3f6d4-204d-4c98-a1fc-ec9cdbd1b686', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '97d3f6d4-204d-4c98-a1fc-ec9cdbd1b686', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '97d3f6d4-204d-4c98-a1fc-ec9cdbd1b686', 'pymt_mode_id', 'id', 3, 0, current_timestamp, 'admin'),
-- setting-pymt-mode::tl
(gen_random_uuid(), '5308e896-1554-403f-9bc3-0417de13bda4', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '5308e896-1554-403f-9bc3-0417de13bda4', 'rid', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5308e896-1554-403f-9bc3-0417de13bda4', 'axn', 'string', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5308e896-1554-403f-9bc3-0417de13bda4', 'url', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5308e896-1554-403f-9bc3-0417de13bda4', 'is_debug', 'int', 5, 0, current_timestamp, 'admin'),

-- setting-meal-period::s
(gen_random_uuid(), '7f1fdef5-737d-4fdb-9539-7e8071fccb56', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '7f1fdef5-737d-4fdb-9539-7e8071fccb56', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7f1fdef5-737d-4fdb-9539-7e8071fccb56', 'meal_period_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7f1fdef5-737d-4fdb-9539-7e8071fccb56', 'meal_period_desc', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7f1fdef5-737d-4fdb-9539-7e8071fccb56', 'start_time', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7f1fdef5-737d-4fdb-9539-7e8071fccb56', 'end_time', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7f1fdef5-737d-4fdb-9539-7e8071fccb56', 'is_in_use', 'int', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7f1fdef5-737d-4fdb-9539-7e8071fccb56', 'display_seq', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7f1fdef5-737d-4fdb-9539-7e8071fccb56', 'rid', 'int', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7f1fdef5-737d-4fdb-9539-7e8071fccb56', 'axn', 'string', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7f1fdef5-737d-4fdb-9539-7e8071fccb56', 'url', 'string', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7f1fdef5-737d-4fdb-9539-7e8071fccb56', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- setting-meal-period::l
(gen_random_uuid(), '29bfae74-e8d0-4912-9f04-b2e28c8222a3', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '29bfae74-e8d0-4912-9f04-b2e28c8222a3', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '29bfae74-e8d0-4912-9f04-b2e28c8222a3', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '29bfae74-e8d0-4912-9f04-b2e28c8222a3', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '29bfae74-e8d0-4912-9f04-b2e28c8222a3', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '29bfae74-e8d0-4912-9f04-b2e28c8222a3', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- setting-meal-period::d
(gen_random_uuid(), '593c1204-88e7-4ec6-8b92-00f8419d60d4', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '593c1204-88e7-4ec6-8b92-00f8419d60d4', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '593c1204-88e7-4ec6-8b92-00f8419d60d4', 'meal_period_id', 'id', 3, 0, current_timestamp, 'admin'),

-- setting-receipt-temp::s
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'receipt_temp_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'receipt_temp_name', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'logo_img_path', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'extra_information', 'text', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'is_show_store_name', 'int', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'is_show_store_details', 'int', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'is_show_customer_details', 'int', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'is_show_customer_point', 'int', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'is_in_use', 'int', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'rid', 'int', 12, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'axn', 'string', 13, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'url', 'string', 14, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c9b99fa5-de79-4196-89b6-8aea912143a5', 'is_debug', 'int', 15, 0, current_timestamp, 'admin'),
-- setting-receipt-temp::l
(gen_random_uuid(), '884f890f-c874-4f4f-b9a1-b9420cd82841', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '884f890f-c874-4f4f-b9a1-b9420cd82841', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '884f890f-c874-4f4f-b9a1-b9420cd82841', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '884f890f-c874-4f4f-b9a1-b9420cd82841', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '884f890f-c874-4f4f-b9a1-b9420cd82841', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '884f890f-c874-4f4f-b9a1-b9420cd82841', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- setting-receipt-temp::d
(gen_random_uuid(), 'c73c8c5e-b930-49a2-941c-a03defd775e2', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'c73c8c5e-b930-49a2-941c-a03defd775e2', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c73c8c5e-b930-49a2-941c-a03defd775e2', 'receipt_temp_id', 'id', 3, 0, current_timestamp, 'admin'),

-- setting-table-sec::s
(gen_random_uuid(), '9ec74f79-a1c0-4ff8-ad0c-b97d91771644', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '9ec74f79-a1c0-4ff8-ad0c-b97d91771644', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '9ec74f79-a1c0-4ff8-ad0c-b97d91771644', 'table_section_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '9ec74f79-a1c0-4ff8-ad0c-b97d91771644', 'table_section_name', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '9ec74f79-a1c0-4ff8-ad0c-b97d91771644', 'is_in_use', 'int', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '9ec74f79-a1c0-4ff8-ad0c-b97d91771644', 'display_seq', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '9ec74f79-a1c0-4ff8-ad0c-b97d91771644', 'rid', 'int', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '9ec74f79-a1c0-4ff8-ad0c-b97d91771644', 'axn', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '9ec74f79-a1c0-4ff8-ad0c-b97d91771644', 'url', 'string', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '9ec74f79-a1c0-4ff8-ad0c-b97d91771644', 'is_debug', 'int', 10, 0, current_timestamp, 'admin'),
-- setting-table-sec::l
(gen_random_uuid(), '4fbfe7a1-fc63-47b2-b739-86350f3103e4', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '4fbfe7a1-fc63-47b2-b739-86350f3103e4', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4fbfe7a1-fc63-47b2-b739-86350f3103e4', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4fbfe7a1-fc63-47b2-b739-86350f3103e4', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4fbfe7a1-fc63-47b2-b739-86350f3103e4', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4fbfe7a1-fc63-47b2-b739-86350f3103e4', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- setting-table-sec::d
(gen_random_uuid(), 'f516b87e-21b5-47b8-a330-8d8a7392b5c4', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'f516b87e-21b5-47b8-a330-8d8a7392b5c4', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f516b87e-21b5-47b8-a330-8d8a7392b5c4', 'table_section_id', 'id', 3, 0, current_timestamp, 'admin'),

-- setting-table::s
(gen_random_uuid(), '4d91c40a-feef-47e5-b542-dba002510b62', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '4d91c40a-feef-47e5-b542-dba002510b62', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4d91c40a-feef-47e5-b542-dba002510b62', 'table_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4d91c40a-feef-47e5-b542-dba002510b62', 'table_desc', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4d91c40a-feef-47e5-b542-dba002510b62', 'table_section_id', 'id', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4d91c40a-feef-47e5-b542-dba002510b62', 'qr_code', 'text', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4d91c40a-feef-47e5-b542-dba002510b62', 'is_in_use', 'int', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4d91c40a-feef-47e5-b542-dba002510b62', 'display_seq', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4d91c40a-feef-47e5-b542-dba002510b62', 'rid', 'int', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4d91c40a-feef-47e5-b542-dba002510b62', 'axn', 'string', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4d91c40a-feef-47e5-b542-dba002510b62', 'url', 'string', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '4d91c40a-feef-47e5-b542-dba002510b62', 'is_debug', 'int', 12, 0, current_timestamp, 'admin'),
-- setting-table::l
(gen_random_uuid(), '37af1bbc-f1b5-49f3-87a1-0c3694b56569', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '37af1bbc-f1b5-49f3-87a1-0c3694b56569', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '37af1bbc-f1b5-49f3-87a1-0c3694b56569', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '37af1bbc-f1b5-49f3-87a1-0c3694b56569', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '37af1bbc-f1b5-49f3-87a1-0c3694b56569', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '37af1bbc-f1b5-49f3-87a1-0c3694b56569', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- setting-table::d
(gen_random_uuid(), 'c1e51e41-cf43-44b1-9338-335e248865f4', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'c1e51e41-cf43-44b1-9338-335e248865f4', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c1e51e41-cf43-44b1-9338-335e248865f4', 'table_id', 'id', 3, 0, current_timestamp, 'admin'),

-- pos-station::s
(gen_random_uuid(), '5a04fe24-bb9f-4096-8cc2-e8d11704bcd6', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '5a04fe24-bb9f-4096-8cc2-e8d11704bcd6', 'msg', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a04fe24-bb9f-4096-8cc2-e8d11704bcd6', 'pos_station_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a04fe24-bb9f-4096-8cc2-e8d11704bcd6', 'pos_station_desc', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a04fe24-bb9f-4096-8cc2-e8d11704bcd6', 'ip', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a04fe24-bb9f-4096-8cc2-e8d11704bcd6', 'default_printer_id', 'id', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a04fe24-bb9f-4096-8cc2-e8d11704bcd6', 'is_in_use', 'int', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a04fe24-bb9f-4096-8cc2-e8d11704bcd6', 'display_seq', 'int', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a04fe24-bb9f-4096-8cc2-e8d11704bcd6', 'rid', 'int', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a04fe24-bb9f-4096-8cc2-e8d11704bcd6', 'axn', 'string', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a04fe24-bb9f-4096-8cc2-e8d11704bcd6', 'url', 'string', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a04fe24-bb9f-4096-8cc2-e8d11704bcd6', 'is_debug', 'int', 12, 0, current_timestamp, 'admin'),
-- pos-station::l
(gen_random_uuid(), 'c7f5a137-744f-4822-be2d-4a064688f8b5', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'c7f5a137-744f-4822-be2d-4a064688f8b5', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c7f5a137-744f-4822-be2d-4a064688f8b5', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c7f5a137-744f-4822-be2d-4a064688f8b5', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c7f5a137-744f-4822-be2d-4a064688f8b5', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c7f5a137-744f-4822-be2d-4a064688f8b5', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- pos-printer::s
(gen_random_uuid(), '38fe1f07-0572-48fe-b97e-dfb576ed535f', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '38fe1f07-0572-48fe-b97e-dfb576ed535f', 'msg', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '38fe1f07-0572-48fe-b97e-dfb576ed535f', 'pos_printer_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '38fe1f07-0572-48fe-b97e-dfb576ed535f', 'pos_printer_code', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '38fe1f07-0572-48fe-b97e-dfb576ed535f', 'pos_printer_name', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '38fe1f07-0572-48fe-b97e-dfb576ed535f', 'is_in_use', 'int', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '38fe1f07-0572-48fe-b97e-dfb576ed535f', 'display_seq', 'string', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '38fe1f07-0572-48fe-b97e-dfb576ed535f', 'is_default', 'int', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '38fe1f07-0572-48fe-b97e-dfb576ed535f', 'printer_type_id', 'id', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '38fe1f07-0572-48fe-b97e-dfb576ed535f', 'rid', 'int', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '38fe1f07-0572-48fe-b97e-dfb576ed535f', 'axn', 'string', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '38fe1f07-0572-48fe-b97e-dfb576ed535f', 'url', 'string', 12, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '38fe1f07-0572-48fe-b97e-dfb576ed535f', 'is_debug', 'int', 13, 0, current_timestamp, 'admin'),
-- pos-printer::l
(gen_random_uuid(), 'f2cde6c3-c59b-44e5-8611-2855d82d514f', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'f2cde6c3-c59b-44e5-8611-2855d82d514f', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f2cde6c3-c59b-44e5-8611-2855d82d514f', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f2cde6c3-c59b-44e5-8611-2855d82d514f', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f2cde6c3-c59b-44e5-8611-2855d82d514f', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f2cde6c3-c59b-44e5-8611-2855d82d514f', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- pos-printer::ptl
(gen_random_uuid(), 'ca286e43-21f8-48e9-8612-faecdc5cb0f0', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'ca286e43-21f8-48e9-8612-faecdc5cb0f0', 'rid', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'ca286e43-21f8-48e9-8612-faecdc5cb0f0', 'axn', 'string', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'ca286e43-21f8-48e9-8612-faecdc5cb0f0', 'url', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'ca286e43-21f8-48e9-8612-faecdc5cb0f0', 'is_debug', 'int', 5, 0, current_timestamp, 'admin'),

-- other::cl
(gen_random_uuid(), 'a99d6e35-825d-4307-b48e-92ab39526cf2', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'a99d6e35-825d-4307-b48e-92ab39526cf2', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a99d6e35-825d-4307-b48e-92ab39526cf2', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a99d6e35-825d-4307-b48e-92ab39526cf2', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a99d6e35-825d-4307-b48e-92ab39526cf2', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a99d6e35-825d-4307-b48e-92ab39526cf2', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- other::sl
(gen_random_uuid(), '0961b167-8b80-4502-b6d9-8476532634d0', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '0961b167-8b80-4502-b6d9-8476532634d0', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '0961b167-8b80-4502-b6d9-8476532634d0', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '0961b167-8b80-4502-b6d9-8476532634d0', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '0961b167-8b80-4502-b6d9-8476532634d0', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '0961b167-8b80-4502-b6d9-8476532634d0', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- other::ptl
(gen_random_uuid(), 'e06fe881-dc37-46f3-8567-047ac609f1c5', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'e06fe881-dc37-46f3-8567-047ac609f1c5', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e06fe881-dc37-46f3-8567-047ac609f1c5', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e06fe881-dc37-46f3-8567-047ac609f1c5', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e06fe881-dc37-46f3-8567-047ac609f1c5', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e06fe881-dc37-46f3-8567-047ac609f1c5', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- other::all


-- app-customer::s
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'guest_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'first_name', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'last_name', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'full_name', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'title', 'string', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'gender', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'phone_number', 'string', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'email', 'string', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'dob', 'dt', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'addr_line_1', 'string', 12, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'addr_line_2', 'string', 13, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'city', 'string', 14, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'state', 'id', 15, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'post_code', 'string', 16, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'country', 'id', 17, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'guest_tag', 'string', 18, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'rid', 'int', 19, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'axn', 'string', 20, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'url', 'string', 21, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '04032095-2a06-4ac3-bbb0-4873a56b1856', 'is_debug', 'int', 22, 0, current_timestamp, 'admin'),
-- app-customer::l
(gen_random_uuid(), 'e88328bd-4398-4dfa-9ce3-7151e2282a72', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'e88328bd-4398-4dfa-9ce3-7151e2282a72', 'rid', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e88328bd-4398-4dfa-9ce3-7151e2282a72', 'axn', 'string', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e88328bd-4398-4dfa-9ce3-7151e2282a72', 'url', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e88328bd-4398-4dfa-9ce3-7151e2282a72', 'is_debug', 'int', 5, 0, current_timestamp, 'admin'),
-- app-customer::d
(gen_random_uuid(), 'fe2ed530-d5df-4957-9a6b-7ffffea18d5a', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe2ed530-d5df-4957-9a6b-7ffffea18d5a', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe2ed530-d5df-4957-9a6b-7ffffea18d5a', 'guest_id', 'id', 3, 0, current_timestamp, 'admin'),

-- app-supplier::s
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'supplier_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'supplier_name', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'phone_number', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'mobile_number', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'email', 'string', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'fax', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'addr_line_1', 'string', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'addr_line_2', 'string', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'city', 'string', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'state', 'id', 12, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'post_code', 'string', 13, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'country', 'id', 14, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1f00d776-a17d-4e70-a6a2-0410b630c54d', 'display_seq', 'string', 15, 0, current_timestamp, 'admin'),
-- app-supplier::l
-- app-supplier::d
(gen_random_uuid(), 'bd2ec562-245f-4e7e-bf9c-3f77b934acd0', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd2ec562-245f-4e7e-bf9c-3f77b934acd0', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bd2ec562-245f-4e7e-bf9c-3f77b934acd0', 'supplier_id', 'id', 3, 0, current_timestamp, 'admin'),

-- app-user-group::s
(gen_random_uuid(), 'f2737b0c-9359-4486-815c-b38b2015eb4d', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'f2737b0c-9359-4486-815c-b38b2015eb4d', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f2737b0c-9359-4486-815c-b38b2015eb4d', 'user_group_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f2737b0c-9359-4486-815c-b38b2015eb4d', 'user_group_desc', 'string', 4, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'f2737b0c-9359-4486-815c-b38b2015eb4d', 'is_in_use', 'int', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f2737b0c-9359-4486-815c-b38b2015eb4d', 'display_seq', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f2737b0c-9359-4486-815c-b38b2015eb4d', 'rid', 'int', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f2737b0c-9359-4486-815c-b38b2015eb4d', 'axn', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f2737b0c-9359-4486-815c-b38b2015eb4d', 'url', 'string', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'f2737b0c-9359-4486-815c-b38b2015eb4d', 'is_debug', 'int', 10, 0, current_timestamp, 'admin'),
-- app-user-group::l
(gen_random_uuid(), '9280fb2c-4e25-45ab-bcd5-a1657e61f23f', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '9280fb2c-4e25-45ab-bcd5-a1657e61f23f', 'is_in_use', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '9280fb2c-4e25-45ab-bcd5-a1657e61f23f', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '9280fb2c-4e25-45ab-bcd5-a1657e61f23f', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '9280fb2c-4e25-45ab-bcd5-a1657e61f23f', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '9280fb2c-4e25-45ab-bcd5-a1657e61f23f', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),
-- app-user-group::acs
(gen_random_uuid(), 'c1ff314c-10e6-4203-804b-f406790765ad', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'c1ff314c-10e6-4203-804b-f406790765ad', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c1ff314c-10e6-4203-804b-f406790765ad', 'user_group_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c1ff314c-10e6-4203-804b-f406790765ad', 'action_id', 'id', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c1ff314c-10e6-4203-804b-f406790765ad', 'rid', 'int', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c1ff314c-10e6-4203-804b-f406790765ad', 'axn', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c1ff314c-10e6-4203-804b-f406790765ad', 'url', 'string', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c1ff314c-10e6-4203-804b-f406790765ad', 'is_debug', 'int', 8, 0, current_timestamp, 'admin'),
-- app-user-group::acl
(gen_random_uuid(), 'e5b11c45-b204-4485-b20f-6652063844c8', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'e5b11c45-b204-4485-b20f-6652063844c8', 'user_group_id', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e5b11c45-b204-4485-b20f-6652063844c8', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e5b11c45-b204-4485-b20f-6652063844c8', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e5b11c45-b204-4485-b20f-6652063844c8', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e5b11c45-b204-4485-b20f-6652063844c8', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),

-- app-users::s
(gen_random_uuid(), '543abc1b-a347-4ab0-85d1-664362579925', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '543abc1b-a347-4ab0-85d1-664362579925', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '543abc1b-a347-4ab0-85d1-664362579925', 'user_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '543abc1b-a347-4ab0-85d1-664362579925', 'login_id', 'text', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '543abc1b-a347-4ab0-85d1-664362579925', 'user_name', 'text', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '543abc1b-a347-4ab0-85d1-664362579925', 'email', 'text', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '543abc1b-a347-4ab0-85d1-664362579925', 'pwd', 'text', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '543abc1b-a347-4ab0-85d1-664362579925', 'user_group_id', 'id', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '543abc1b-a347-4ab0-85d1-664362579925', 'is_active', 'int', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '543abc1b-a347-4ab0-85d1-664362579925', 'rid', 'int', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '543abc1b-a347-4ab0-85d1-664362579925', 'axn', 'string', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '543abc1b-a347-4ab0-85d1-664362579925', 'url', 'string', 12, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '543abc1b-a347-4ab0-85d1-664362579925', 'is_debug', 'int', 13, 0, current_timestamp, 'admin'),
-- app-users::l
(gen_random_uuid(), '655abc6d-8ad8-43d6-9bb9-36b55f014fb5', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '655abc6d-8ad8-43d6-9bb9-36b55f014fb5', 'rid', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '655abc6d-8ad8-43d6-9bb9-36b55f014fb5', 'axn', 'string', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '655abc6d-8ad8-43d6-9bb9-36b55f014fb5', 'url', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '655abc6d-8ad8-43d6-9bb9-36b55f014fb5', 'is_debug', 'int', 5, 0, current_timestamp, 'admin'),

-- app-axn::l
(gen_random_uuid(), '69f4b2b3-db4b-4001-b16f-0987ab79bfd5', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '69f4b2b3-db4b-4001-b16f-0987ab79bfd5', 'rid', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '69f4b2b3-db4b-4001-b16f-0987ab79bfd5', 'axn', 'string', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '69f4b2b3-db4b-4001-b16f-0987ab79bfd5', 'url', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '69f4b2b3-db4b-4001-b16f-0987ab79bfd5', 'is_debug', 'int', 5, 0, current_timestamp, 'admin'),

-- Save
-- app-order-trans::s
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'order_trans_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'doc_no', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'tr_date', 'dt', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'tr_type', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'tr_status', 'string', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'guest_id', 'id', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'pax', 'integer', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'table_no', 'string', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'room_no', 'string', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'delivery_time', 'dt2', 12, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'delivery_next_day', 'dt2', 13, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'rid', 'int', 14, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'axn', 'string', 15, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'url', 'string', 16, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '20591a3f-f905-487b-930f-d6c5ca02d84a', 'is_debug', 'int', 17, 0, current_timestamp, 'admin'),

-- Add Line Save
-- app-order-trans::ails
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'order_trans_item_line_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'tr_date', 'dt', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'tr_type', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'tr_status', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'order_trans_id', 'id', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'doc_no', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'product_id', 'id', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'cost', 'money', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'sell_price', 'money', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'addon_amt', 'money', 12, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'amt', 'money', 13, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'qty', 'int', 14, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'discount_id', 'id', 15, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'discount_amt', 'money', 16, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'discount_pct', 'money', 17, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'total_disc_amt', 'money', 18, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'is_pymt', 'int', 19, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'pymt_mode_id', 'id', 20, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'ref_no', 'string', 21, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'remarks', 'string', 22, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'coupon_no', 'string', 23, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'coupon_id', 'id', 24, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'rid', 'int', 25, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'axn', 'string', 26, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'url', 'string', 27, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'fe0a9ce3-4e99-49ea-8520-eab8e947bbe6', 'is_debug', 'int', 28, 0, current_timestamp, 'admin'),

-- Set Addon
-- app-order-trans::sa
(gen_random_uuid(), '8c643729-7532-4b80-8895-2869b5f55c40', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '8c643729-7532-4b80-8895-2869b5f55c40', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '8c643729-7532-4b80-8895-2869b5f55c40', 'order_trans_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '8c643729-7532-4b80-8895-2869b5f55c40', 'order_trans_item_line_id', 'id', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '8c643729-7532-4b80-8895-2869b5f55c40', 'modifier_option_id', 'id', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '8c643729-7532-4b80-8895-2869b5f55c40', 'rid', 'int', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '8c643729-7532-4b80-8895-2869b5f55c40', 'axn', 'string', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '8c643729-7532-4b80-8895-2869b5f55c40', 'url', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '8c643729-7532-4b80-8895-2869b5f55c40', 'is_debug', 'int', 9, 0, current_timestamp, 'admin'),

-- Addon Remove
-- app-order-trans::ra
(gen_random_uuid(), '7700e5b1-039b-441d-ba3f-f464eda7acfa', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '7700e5b1-039b-441d-ba3f-f464eda7acfa', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7700e5b1-039b-441d-ba3f-f464eda7acfa', 'order_trans_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7700e5b1-039b-441d-ba3f-f464eda7acfa', 'order_trans_item_line_id', 'id', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7700e5b1-039b-441d-ba3f-f464eda7acfa', 'modifier_option_id', 'id', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7700e5b1-039b-441d-ba3f-f464eda7acfa', 'rid', 'int', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7700e5b1-039b-441d-ba3f-f464eda7acfa', 'axn', 'string', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7700e5b1-039b-441d-ba3f-f464eda7acfa', 'url', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '7700e5b1-039b-441d-ba3f-f464eda7acfa', 'is_debug', 'int', 9, 0, current_timestamp, 'admin'),

-- Item Discount
-- app-order-trans::id
(gen_random_uuid(), '31544af9-4b84-45fe-9a1d-1807785cd2cf', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '31544af9-4b84-45fe-9a1d-1807785cd2cf', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '31544af9-4b84-45fe-9a1d-1807785cd2cf', 'order_trans_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '31544af9-4b84-45fe-9a1d-1807785cd2cf', 'order_trans_item_line_id', 'id', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '31544af9-4b84-45fe-9a1d-1807785cd2cf', 'discount_amt', 'money', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '31544af9-4b84-45fe-9a1d-1807785cd2cf', 'discount_pct', 'money', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '31544af9-4b84-45fe-9a1d-1807785cd2cf', 'discount_id', 'id', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '31544af9-4b84-45fe-9a1d-1807785cd2cf', 'override_by', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '31544af9-4b84-45fe-9a1d-1807785cd2cf', 'override_remarks', 'text', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '31544af9-4b84-45fe-9a1d-1807785cd2cf', 'rid', 'int', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '31544af9-4b84-45fe-9a1d-1807785cd2cf', 'axn', 'string', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '31544af9-4b84-45fe-9a1d-1807785cd2cf', 'url', 'string', 12, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '31544af9-4b84-45fe-9a1d-1807785cd2cf', 'is_debug', 'int', 13, 0, current_timestamp, 'admin'),

-- Bill Discount
-- app-order-trans::bd
(gen_random_uuid(), 'e4443c40-8521-4bbd-a9ae-3d444e7a0cd2', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'e4443c40-8521-4bbd-a9ae-3d444e7a0cd2', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e4443c40-8521-4bbd-a9ae-3d444e7a0cd2', 'order_trans_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e4443c40-8521-4bbd-a9ae-3d444e7a0cd2', 'bill_discount_id', 'id', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e4443c40-8521-4bbd-a9ae-3d444e7a0cd2', 'bill_discount_pct', 'money', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e4443c40-8521-4bbd-a9ae-3d444e7a0cd2', 'bill_discount_amt', 'money', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e4443c40-8521-4bbd-a9ae-3d444e7a0cd2', 'override_by', 'string', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e4443c40-8521-4bbd-a9ae-3d444e7a0cd2', 'override_remarks', 'text', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e4443c40-8521-4bbd-a9ae-3d444e7a0cd2', 'rid', 'int', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e4443c40-8521-4bbd-a9ae-3d444e7a0cd2', 'axn', 'string', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e4443c40-8521-4bbd-a9ae-3d444e7a0cd2', 'url', 'string', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'e4443c40-8521-4bbd-a9ae-3d444e7a0cd2', 'is_debug', 'int', 12, 0, current_timestamp, 'admin'),

-- Void Item
-- app-order-trans::vi
(gen_random_uuid(), 'c7e32761-34a0-44b8-8746-91e40d875a68', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'c7e32761-34a0-44b8-8746-91e40d875a68', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c7e32761-34a0-44b8-8746-91e40d875a68', 'order_trans_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c7e32761-34a0-44b8-8746-91e40d875a68', 'order_trans_item_line_id', 'id', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c7e32761-34a0-44b8-8746-91e40d875a68', 'override_by', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c7e32761-34a0-44b8-8746-91e40d875a68', 'override_remarks', 'text', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c7e32761-34a0-44b8-8746-91e40d875a68', 'rid', 'int', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c7e32761-34a0-44b8-8746-91e40d875a68', 'axn', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c7e32761-34a0-44b8-8746-91e40d875a68', 'url', 'string', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'c7e32761-34a0-44b8-8746-91e40d875a68', 'is_debug', 'int', 10, 0, current_timestamp, 'admin'),

-- Void Bill
-- app-order-trans::vb
(gen_random_uuid(), '5a4b20a0-f7d3-425d-b093-022c8160eb6b', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '5a4b20a0-f7d3-425d-b093-022c8160eb6b', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a4b20a0-f7d3-425d-b093-022c8160eb6b', 'order_trans_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a4b20a0-f7d3-425d-b093-022c8160eb6b', 'override_remarks', 'text', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a4b20a0-f7d3-425d-b093-022c8160eb6b', 'undo', 'int', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a4b20a0-f7d3-425d-b093-022c8160eb6b', 'rid', 'int', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a4b20a0-f7d3-425d-b093-022c8160eb6b', 'axn', 'string', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a4b20a0-f7d3-425d-b093-022c8160eb6b', 'url', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '5a4b20a0-f7d3-425d-b093-022c8160eb6b', 'is_debug', 'int', 9, 0, current_timestamp, 'admin'),

-- Override Price
-- app-order-trans::op
(gen_random_uuid(), 'a4ae5797-8bf4-422a-9d75-4234d6eda663', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4ae5797-8bf4-422a-9d75-4234d6eda663', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4ae5797-8bf4-422a-9d75-4234d6eda663', 'order_trans_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4ae5797-8bf4-422a-9d75-4234d6eda663', 'order_trans_item_line_id', 'id', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4ae5797-8bf4-422a-9d75-4234d6eda663', 'sell_price', 'id', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4ae5797-8bf4-422a-9d75-4234d6eda663', 'override_by', 'id', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4ae5797-8bf4-422a-9d75-4234d6eda663', 'override_remarks', 'id', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4ae5797-8bf4-422a-9d75-4234d6eda663', 'rid', 'int', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4ae5797-8bf4-422a-9d75-4234d6eda663', 'axn', 'string', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4ae5797-8bf4-422a-9d75-4234d6eda663', 'url', 'string', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'a4ae5797-8bf4-422a-9d75-4234d6eda663', 'is_debug', 'int', 11, 0, current_timestamp, 'admin'),

-- Split Bill 
-- app-order-trans::sp
(gen_random_uuid(), '1b63bd99-9bf7-4a9e-80e8-038fbe1f0b8f', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '1b63bd99-9bf7-4a9e-80e8-038fbe1f0b8f', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1b63bd99-9bf7-4a9e-80e8-038fbe1f0b8f', 'order_trans_id', 'id', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1b63bd99-9bf7-4a9e-80e8-038fbe1f0b8f', 'move_to', 'int', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1b63bd99-9bf7-4a9e-80e8-038fbe1f0b8f', 'move_to_doc', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1b63bd99-9bf7-4a9e-80e8-038fbe1f0b8f', 'move_by', 'int', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1b63bd99-9bf7-4a9e-80e8-038fbe1f0b8f', 'move_value', 'money', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1b63bd99-9bf7-4a9e-80e8-038fbe1f0b8f', 'product_ids', 'text', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1b63bd99-9bf7-4a9e-80e8-038fbe1f0b8f', 'rid', 'int', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1b63bd99-9bf7-4a9e-80e8-038fbe1f0b8f', 'axn', 'string', 10, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1b63bd99-9bf7-4a9e-80e8-038fbe1f0b8f', 'url', 'string', 11, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1b63bd99-9bf7-4a9e-80e8-038fbe1f0b8f', 'is_debug', 'int', 12, 0, current_timestamp, 'admin'),

-- Receipt 
-- app-order-trans::tr

-- app-order-trans::ptk

-- app-order-trans::l
(gen_random_uuid(), '3d66bf32-523b-4cd4-a852-c7296ce9573f', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '3d66bf32-523b-4cd4-a852-c7296ce9573f', 'start_dt', 'dt', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '3d66bf32-523b-4cd4-a852-c7296ce9573f', 'end_dt', 'dt', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '3d66bf32-523b-4cd4-a852-c7296ce9573f', 'rid', 'int', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '3d66bf32-523b-4cd4-a852-c7296ce9573f', 'axn', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '3d66bf32-523b-4cd4-a852-c7296ce9573f', 'url', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '3d66bf32-523b-4cd4-a852-c7296ce9573f', 'is_debug', 'int', 7, 0, current_timestamp, 'admin'),

-- app-order-trans::pl
(gen_random_uuid(), '855eded5-c3a8-4b0b-a958-710d105badd6', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '855eded5-c3a8-4b0b-a958-710d105badd6', 'rid', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '855eded5-c3a8-4b0b-a958-710d105badd6', 'axn', 'string', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '855eded5-c3a8-4b0b-a958-710d105badd6', 'url', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '855eded5-c3a8-4b0b-a958-710d105badd6', 'is_debug', 'int', 5, 0, current_timestamp, 'admin'),


-- app-order-trans::ml
(gen_random_uuid(), '81a26b63-de75-47e3-88c9-1937e35507f6', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '81a26b63-de75-47e3-88c9-1937e35507f6', 'product_id', 'id', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '81a26b63-de75-47e3-88c9-1937e35507f6', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '81a26b63-de75-47e3-88c9-1937e35507f6', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '81a26b63-de75-47e3-88c9-1937e35507f6', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '81a26b63-de75-47e3-88c9-1937e35507f6', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),

-- app-order-trans::tl
(gen_random_uuid(), 'bdf3b996-922a-44c2-87fb-a27902edd8ba', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'bdf3b996-922a-44c2-87fb-a27902edd8ba', 'rid', 'int', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bdf3b996-922a-44c2-87fb-a27902edd8ba', 'axn', 'string', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bdf3b996-922a-44c2-87fb-a27902edd8ba', 'url', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'bdf3b996-922a-44c2-87fb-a27902edd8ba', 'is_debug', 'int', 5, 0, current_timestamp, 'admin'),

-- app-order-trans::il
(gen_random_uuid(), '3681cceb-a75e-43d0-9eef-c57293ffb8e0', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '3681cceb-a75e-43d0-9eef-c57293ffb8e0', 'order_trans_id', 'id', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '3681cceb-a75e-43d0-9eef-c57293ffb8e0', 'rid', 'int', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '3681cceb-a75e-43d0-9eef-c57293ffb8e0', 'axn', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '3681cceb-a75e-43d0-9eef-c57293ffb8e0', 'url', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '3681cceb-a75e-43d0-9eef-c57293ffb8e0', 'is_debug', 'int', 6, 0, current_timestamp, 'admin'),

-- app-cashiering-shift::o
(gen_random_uuid(), '53c09823-1cc1-4f81-a29b-68b29d7870a8', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '53c09823-1cc1-4f81-a29b-68b29d7870a8', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '53c09823-1cc1-4f81-a29b-68b29d7870a8', 'tr_date', 'dt', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '53c09823-1cc1-4f81-a29b-68b29d7870a8', 'user_ip', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '53c09823-1cc1-4f81-a29b-68b29d7870a8', 'rid', 'int', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '53c09823-1cc1-4f81-a29b-68b29d7870a8', 'axn', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '53c09823-1cc1-4f81-a29b-68b29d7870a8', 'url', 'string', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '53c09823-1cc1-4f81-a29b-68b29d7870a8', 'is_debug', 'int', 8, 0, current_timestamp, 'admin'),

-- app-cashiering-shift::c
(gen_random_uuid(), '6e14aa79-422d-4c81-814a-74d58b908ae0', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '6e14aa79-422d-4c81-814a-74d58b908ae0', 'msg', 'text', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '6e14aa79-422d-4c81-814a-74d58b908ae0', 'tr_date', 'dt', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '6e14aa79-422d-4c81-814a-74d58b908ae0', 'user_ip', 'string', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '6e14aa79-422d-4c81-814a-74d58b908ae0', 'remarks', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '6e14aa79-422d-4c81-814a-74d58b908ae0', 'total_collection', 'money', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '6e14aa79-422d-4c81-814a-74d58b908ae0', 'rid', 'int', 7, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '6e14aa79-422d-4c81-814a-74d58b908ae0', 'axn', 'string', 8, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '6e14aa79-422d-4c81-814a-74d58b908ae0', 'url', 'string', 9, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '6e14aa79-422d-4c81-814a-74d58b908ae0', 'is_debug', 'int', 10, 0, current_timestamp, 'admin'),

-- app-cashiering-shift::cp
(gen_random_uuid(), '13ec0e3c-02b4-4ade-b197-d8a14257c3a5', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '13ec0e3c-02b4-4ade-b197-d8a14257c3a5', 'tr_date', 'dt', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '13ec0e3c-02b4-4ade-b197-d8a14257c3a5', 'user_ip', 'string', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '13ec0e3c-02b4-4ade-b197-d8a14257c3a5', 'rid', 'int', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '13ec0e3c-02b4-4ade-b197-d8a14257c3a5', 'axn', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '13ec0e3c-02b4-4ade-b197-d8a14257c3a5', 'url', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '13ec0e3c-02b4-4ade-b197-d8a14257c3a5', 'is_debug', 'int', 7, 0, current_timestamp, 'admin'),

-- app-cashiering-shift::sc
(gen_random_uuid(), '1d3bdedd-7f39-4316-9116-375379b49219', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), '1d3bdedd-7f39-4316-9116-375379b49219', 'cashier_id', 'string', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1d3bdedd-7f39-4316-9116-375379b49219', 'tr_date', 'dt', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1d3bdedd-7f39-4316-9116-375379b49219', 'rid', 'int', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1d3bdedd-7f39-4316-9116-375379b49219', 'axn', 'string', 5, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1d3bdedd-7f39-4316-9116-375379b49219', 'url', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), '1d3bdedd-7f39-4316-9116-375379b49219', 'is_debug', 'int', 7, 0, current_timestamp, 'admin'),

-- app-cashiering-shift::fc


-- app-report::das
(gen_random_uuid(), 'ddd5f198-1447-4d3b-8b79-d1dbc8f41027', 'current_uid', 'string', 1, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'ddd5f198-1447-4d3b-8b79-d1dbc8f41027', 'start_dt', 'dt', 2, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'ddd5f198-1447-4d3b-8b79-d1dbc8f41027', 'end_dt', 'dt', 3, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'ddd5f198-1447-4d3b-8b79-d1dbc8f41027', 'rid', 'int', 4, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'ddd5f198-1447-4d3b-8b79-d1dbc8f41027', 'axn', 'string', 5, 1, current_timestamp, 'admin'),
(gen_random_uuid(), 'ddd5f198-1447-4d3b-8b79-d1dbc8f41027', 'url', 'string', 6, 0, current_timestamp, 'admin'),
(gen_random_uuid(), 'ddd5f198-1447-4d3b-8b79-d1dbc8f41027', 'is_debug', 'int', 7, 0, current_timestamp, 'admin'),


insert into tb_pricing_type (pricing_type_id, created_on, created_by, modified_on, modified_by, pricing_type_desc, is_in_use) values
(gen_random_uuid(), current_timestamp, 'admin', current_timestamp, 'admin', 'Fixed', 1),
(gen_random_uuid(), current_timestamp, 'admin', current_timestamp, 'admin', 'Variable', 1),
(gen_random_uuid(), current_timestamp, 'admin', current_timestamp, 'admin', 'By Unit', 1)

insert into tb_country (country_id, created_on, created_by, country_name, country_code, is_in_use, display_seq) VALUES
(gen_random_uuid(), current_timestamp, 'admin', 'Malaysia', 'MY', 1, '000001'),
(gen_random_uuid(), current_timestamp, 'admin', 'Singapore', 'SG', 1, '000002'),
(gen_random_uuid(), current_timestamp, 'admin', 'Thailand', 'TH', 1, '000003');

insert into tb_state (state_id, created_on, created_by, state_name, is_in_use, display_seq) values 
(gen_random_uuid(), current_timestamp, 'admin', 'Kuala Lumpur', 1, '000001'),
(gen_random_uuid(), current_timestamp, 'admin', 'Putrajaya', 1, '000002'),
(gen_random_uuid(), current_timestamp, 'admin', 'Selangor', 1, '000003'),
(gen_random_uuid(), current_timestamp, 'admin', 'Johor', 1, '000004'),
(gen_random_uuid(), current_timestamp, 'admin', 'Melaka', 1, '000005'),
(gen_random_uuid(), current_timestamp, 'admin', 'Negeri Sembilan', 1, '000006'),
(gen_random_uuid(), current_timestamp, 'admin', 'Pahang', 1, '000007'),
(gen_random_uuid(), current_timestamp, 'admin', 'Terengganu', 1, '000008'),
(gen_random_uuid(), current_timestamp, 'admin', 'Perak', 1, '000009'),
(gen_random_uuid(), current_timestamp, 'admin', 'Penang', 1, '000010'),
(gen_random_uuid(), current_timestamp, 'admin', 'Kelantan', 1, '000011'),
(gen_random_uuid(), current_timestamp, 'admin', 'Perlis', 1, '000012'),
(gen_random_uuid(), current_timestamp, 'admin', 'Kedah', 1, '000013'),
(gen_random_uuid(), current_timestamp, 'admin', 'Sarawak', 1, '000014'),
(gen_random_uuid(), current_timestamp, 'admin', 'Sabah', 1, '000015')

insert into tb_sys_setting (created_on, created_by, modified_on, modified_by, sys_setting_title, sys_setting_value, can_customize) values 
(current_timestamp, 'admin', current_timestamp, 'admin', 'CURRENT_TRANS_DATE', '2024-10-16', 1),
--(current_timestamp, 'admin', current_timestamp, 'admin', 'ORDER_NO_PREFIX', 'OR-'),
(current_timestamp, 'admin', current_timestamp, 'admin', 'ORDER_NO_LENGTH', '5', 0),
-- Pay-first or Pay-later
(current_timestamp, 'admin', current_timestamp, 'admin', 'OPERATION_MODE', '', 1),
(current_timestamp, 'admin', current_timestamp, 'admin', 'smtp_server', '', 1),
(current_timestamp, 'admin', current_timestamp, 'admin', 'smtp_port', '', 1),
(current_timestamp, 'admin', current_timestamp, 'admin', 'smtp_mailbox_id', '', 1),
(current_timestamp, 'admin', current_timestamp, 'admin', 'smtp_mailbox_pwd', '', 1),
(current_timestamp, 'admin', current_timestamp, 'admin', 'smtp_use_ssl', '', 1),
(current_timestamp, 'admin', current_timestamp, 'admin', 'smtp_able_service', '', 1),
-- Default (sell as much as) or set daily availability
(current_timestamp, 'admin', current_timestamp, 'admin', 'QR_ORDER_AVAILABILITY', '', 1),
(current_timestamp, 'admin', current_timestamp, 'admin', 'POS_URL', '', 0),
(current_timestamp, 'admin', current_timestamp, 'admin', 'POS_ADMIN_PORTAL_URL', '', 0),
(current_timestamp, 'admin', current_timestamp, 'admin', 'POS_QR_ORDER_URL', '', 0)


INSERT into tb_tr_type (tr_type_id, created_on, created_by, modified_on, modified_by, tr_type_code, tr_type_desc, is_in_use, display_seq) VALUES
(1, current_timestamp, 'admin', current_timestamp, 'admin', 'TS', 'Table Secvice', 1, '000001'),
(2, current_timestamp, 'admin', current_timestamp, 'admin', 'PC', 'Pick at Counter', 1, '000002'),
(3, current_timestamp, 'admin', current_timestamp, 'admin', 'TA', 'Take Away', 1, '000003'),
(4, current_timestamp, 'admin', current_timestamp, 'admin', 'RS', 'Room Service', 1, '000004')

INSERT into tb_tr_status (tr_status_id, created_on, created_by, modified_on, modified_by, tr_status_code, tr_status_desc, is_in_use, display_seq) VALUES
(1, current_timestamp, 'admin', current_timestamp, 'admin', 'C', 'Confirmed', 1, '000001'),
(2, current_timestamp, 'admin', current_timestamp, 'admin', 'X', 'Cancelled', 1, '000002')

-- Default user group 
INSERT INTO tb_user_group (user_group_id, created_on, created_by, modified_on, modified_by, user_group_desc, is_in_use, display_seq) VALUES
(1, current_timestamp, 'admin', current_timestamp, 'admin', 'Admin', 1, '000001'),
(2, current_timestamp, 'admin', current_timestamp, 'admin', 'Manager', 1, '000002'),
(3, current_timestamp, 'admin', current_timestamp, 'admin', 'Cashier', 1, '000003')
(-999, current_timestamp, 'admin', current_timestamp, 'admin', 'All', 1, '000004')

-- Default Printer Type
INSERT INTO tb_pos_printer_type (printer_type_id, created_on, created_by, printer_type, is_in_use, display_seq) VALUES 
(1, current_timestamp, 'admin', 'Kitchen Printer', 1, '000001'),
(2, current_timestamp, 'admin', 'Reception Printer', 1, '000002')

-- Default Inventory Type
INSERT INTO tb_inventory_type (inventory_type_id, created_on, created_by, modified_on, modified_by, inventory_type_desc, is_in_use, display_seq) values
('6b24a5e7-e060-43b4-a2fb-555817e510e0', current_timestamp, 'admin', current_timestamp, 'admin', 'Pyhsical Inventory', 1, '000001'),
('07b41650-bd18-42a9-a2e3-4ac76534301b', current_timestamp, 'admin', current_timestamp, 'admin', 'Daily Product Availability', 1, '000002')

-- Default Mail Type
INSERT INTO tb_mail_type (mail_type_id, created_on, created_by, mail_type_desc, is_in_use) VALUES
(1, current_timestamp, 'admin', 'Notification', 1),
(2, current_timestamp, 'admin', 'Scheduler Report', 1),
(3, current_timestamp, 'admin', 'Receipt', 1)
