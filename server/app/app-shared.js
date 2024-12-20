function appShared() {};

Object.defineProperty(appShared, 'TB_CATEGORY', { get: function() { return 'tb_category'; } });
Object.defineProperty(appShared, 'TB_MODIFIER', { get: function() { return 'tb_modifier_group'; } });
Object.defineProperty(appShared, 'TB_PRICE_TAG', { get: function() { return 'tb_priceing_tag'; } });
Object.defineProperty(appShared, 'TB_PRODUCT', { get: function() { return 'tb_product'; } });
Object.defineProperty(appShared, 'TB_RECEIPT_TEMP', { get: function() { return 'tb_receipt_temp'; } });

module.exports = appShared;