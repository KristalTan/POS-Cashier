-- Action tb
create table if not exists tb_action (
	action_id uuid primary key
	, action_code text
	, action_desc text
	, sql_q text
	, group_code text
	, is_in_use int
	, display_seq varchar(6)
	, created_on timestamp not null
	, created_by varchar(255)
);

create table if not exists tb_action_param (
	action_param_id uuid primary key
	, action_id uuid 
	, action_param_name text
	, data_type varchar(255)
	, seq int
	, is_compulsory int
	, created_on timestamp not null
	, created_by varchar(255)
);

-- Product
create table if not exists tb_prod_category (
	category_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255) not null
	, category_desc varchar(255) not null
	, is_in_use int
	, display_seq varchar(6)
);

create table if not exists tb_modifier_group (
	modifier_group_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255) not null
	, modifier_group_name varchar(255) not null
	, is_single_modifier_choice int
	, is_multiple_modifier_choice int
);

create table if not exists tb_modifier_option (
	modifier_option_id uuid primary key,
	created_on timestamp, 
	created_by varchar(255), 
	modified_on timestamp, 
	modified_by varchar(255), 
	modifier_group_id uuid, 
	modifier_option_name varchar(255), 
	addon_amt numeric(15, 4), 
	is_default integer
);

create table if not exists tb_modifier_item_link (
	modifier_item_link_id uuid primary key,
	created_on timestamp not null, 
	created_by varchar(255) not null, 
	modified_on timestamp not null, 
	modified_by varchar(255) not null, 
	modifier_group_id uuid,
	product_id uuid
);

create table if not exists tb_pricing_type (
	pricing_type_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255) not null
	, pricing_type_desc varchar(255) not null
	, is_in_use int
	, display_seq varchar(6)
);

create table if not exists tb_product (
	product_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255) not null
	, product_desc varchar(255) not null
	, product_code varchar(50)
	, category_id uuid not null
	, product_tag varchar(255)
	, product_img_path varchar(255)
	, supplier_id uuid
	, pricing_type_id uuid not null
	, cost numeric(15, 4)
	, sell_price numeric(15, 4)
	, tax_code1 varchar(50)
	, amt_include_tax1 int
	, tax_code2 varchar(50)
	, amt_include_tax2 int
	, calc_tax2_after_tax1 int
	, is_in_use int
	, display_seq varchar(6)
	, is_enable_kitchen_printer int
	, is_allow_modifier int
	, is_enable_track_stock int
	, is_popular_item int
);

create table if not exists tb_supplier (
	supplier_id uuid not null primary key
	, supplier_name varchar(255) not null
	, phone_number varchar(50)
	, mobile_number varchar(50)
	, email varchar(50)
	, fax varchar(50)
	, addr_line_1 varchar(255)
	, addr_line_2 varchar(255)
	, city varchar(255)
	, state varchar(255)
	, post_code varchar(50)
	, country varchar(255)
	, display_seq varchar(6)
);

-- inventory
create table if not exists tb_inventory_type (
	inventory_type_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255) not null
	, inventory_type_desc varchar(255) not null
	, is_in_use int
	, display_seq varchar(6)
);

create table if not exists tb_inventory (
	inventory_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255) not null
	, product_id uuid not null
	, quantity int
	, min_quantity int
	, max_quantity int
	, display_seq int
);

-- Settings
-- CEO setup
create table if not exists tb_general_setting (
	general_setting_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255) not null
	, setting_grp varchar(255) not null
	, setting_title varchar(255)
	, setting_value varchar(255)
	, is_in_use integer
);

create table if not exists tb_store_status (
	store_status_id int not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255) not null
	, store_status_desc varchar(255) not null
	, is_in_use int
	, display_seq varchar(6)
);

-- Store
create table if not exists tb_store (
	store_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255) not null
	, store_name varchar(255) not null
	, addr_line_1 varchar(255)
	, addr_line_2 varchar(255)
	, city varchar(255)
	, state uuid
	, post_code varchar(50)
	, country uuid
	, phone_number varchar(50)
	, email varchar(255)
	, website varchar(255)
	, gst_id varchar(255)
	, sst_id varchar(255)
	, business_registration_num varchar(255)
	, receipt_temp_id uuid
);

-- Payment Options
create table if not exists tb_pymt_type (
	pymt_mode_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255) not null
	, pymt_mode_desc varchar(255) not null
	, pymt_type uuid
	, for_store text 
	, is_in_use int 
);

-- Tax
create table if not exists tb_tax (
	tax_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255) not null
	, tax_code varchar(50) not null
	, tax_desc varchar(255) not null
	, tax_pct numeric(15, 2) not null
	, is_in_use int
	, display_seq varchar(6)
);

-- Receipt Template
create table if not exists tb_receipt_temp (
	receipt_temp_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255) not null
	, receipt_temp_name varchar(255) not null
	, logo_img_path varchar(255)
	, extra_information text
	, is_show_store_name int
	, is_show_store_details int
	, is_show_customer_details int
	, is_show_customer_point int
	, is_in_use int
);

-- Printer Setup
create table if not exists tb_pos_printer (
	pos_printer_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255) not null
	, printer_ip_address varchar(50) 
	, printer_name varchar(255) not null
	, is_kitchen_printer int
	, is_receipt_printer int
	, is_in_use int
	, display_seq varchar(6)
);

create table if not exists tb_prod_post_printer (
	prod_pos_printer uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255 )not null
	, product_id uuid not null
	, pos_printer_id uuid not null
);

-- Meal Period
create table if not exists tb_meal_period (
	meal_period_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255 )not null
	, meal_period_desc varchar(255)
	, is_in_use int
	, display_seq varchar(6)
);

-- Food Menu
create table if not exists tb_food_menu (
	food_menu_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255 )not null
	, food_menu_desc varchar(255)
	, meal_period_id uuid
	, is_in_use int
	, display_seq varchar(6)
);

-- Food Menu Product
create table if not exists tb_food_menu_product (
	food_menu_product_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255 )not null
	, food_menu_id uuid
	, product_id uuid
);

create table if not exists tb_table_section (
	table_section_id uuid not null primary key,
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255 )not null
	, table_section_name varchar(255)
	, is_in_use integer
	, display_seq varchar(6)
);

create table if not exists tb_table (
	table_id uuid not null primary key,
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255 )not null
	, table_desc varchar(255)
	, table_section_id uuid
	, qr_code text
	, is_in_use integer
	, display_seq varchar(6)
);

-- customer membership
create table if not exists tb_guest (
	guest_id uuid not null
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255 )not null
	, first_name varchar(255) 
	, last_name varchar(255)
	, full_name varchar(255)
	, title varchar(50)
	, gender varchar(50)
	, phone_number varchar(50) not null 
	, email varchar(255)
	, dob date
	, addr_line_1 varchar(255)
	, addr_line_2 varchar(255)
	, city varchar(255)
	, state uuid
	, post_code varchar(50)
	, country uuid
	, guest_tag varchar(255)
	, total_spend numeric(15, 4)
	, total_cashback numeric(15, 4)
	, total_transaction integer
	, last_purchase_dt date
	
	, primary key (guest_id, phone_number)
);

-- Transcation
create table if not exists tb_order_trans (
	order_trans_id uuid not null primary key 
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255) not null
	, tr_dt timestamp 
	, tr_status varchar(50)
	, doc_no varchar(50)
	, remarks text
	, override_on timestamp
	, override_by varchar(255)
	, 
);

-- create table if not exists tb_order_item_line_trans (

-- );

-- User
create table if not exists tb_users (
	user_id uuid not null primary key,
	, created_on timestamp not null
	, created_by varchar(255) not null
	, modified_on timestamp not null
	, modified_by varchar(255 )not null
	, login_id varchar(255)
	, user_name varchar(255)
	, pwd varchar(255)
	, pwd_expire_on date
	, is_super_admin integer
	, is_manager integer
	, is_cashier integer
)

-- log in every click
create table if not exists tb_audit_log (
	audit_log_id bigserial not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, task text
	, remarks text
	, id1 uuid
	, id2 uuid
	, id3 uuid
	, app_id uuid
	, module_code varchar(255)
);

create table if not exists tb_country (
	country_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, country_name varchar(255) not null
	, country_code varchar(50) not null
	, is_in_use integer
	, display_seq varchar(6)
);

create table if not exists tb_state (
	state_id uuid not null primary key
	, created_on timestamp not null
	, created_by varchar(255) not null
	, state_name varchar(255) not null
	, is_in_use integer
	, display_seq varchar(6)
);

create table if not exists tb_last_id (
	subject_name text
	, last_id bigint
	, modified_on timestamp
	, store_id uuid
)