const path = require('path');
const express = require('express');
const router = express.Router();
const bodyParser = require('body-parser');

// Import Libraries
const { pgSql } = require('../../lib/lib-pgsql');
const libApi = require('../../lib/lib-api');
const libShared = require('../../lib/lib-shared');

const p0 = new libApi.apiCaller();

const FILE = path.basename(__filename)
const SERVICE = FILE.replace('app-', '').replace('.js', '');

function AppSettingStore() {};

AppSettingStore.prototype.storeObject = function(o = {}) {
    const d = {
        current_uid: null,
        msg: null,
        store_id: null,
        store_code: null,
        store_name: null,
        addr_line_1: null,
        addr_line_2: null,
        city: null,
        state: null,
        post_code: null,
        country: null,
        phone_number: null,
        email: null,
        website: null,
        gst_id: null,
        sst_id: null,
        business_registration_num: null,
        receipt_temp_id: null,
        curr_code: null,
        rid: null,
        axn: null,
        url: null,
        is_debug: null
    };

    // Make sure the data type same as store procedure need
    const conversionMap = {
        current_uid: libShared.toString,
        store_id: libShared.toUUID,         
        store_code: libShared.toString,     
        store_name: libShared.toString,      
        addr_line_1: libShared.toString,
        addr_line_2: libShared.toString,
        city: libShared.toString,
        state: libShared.toUUID,
        post_code: libShared.toString,
        country: libShared.toUUID,
        phone_number: libShared.toString,
        email: libShared.toString,
        website: libShared.toString,
        gst_id: libShared.toString,
        sst_id: libShared.toString,
        business_registration_num: libShared.toString,
        receipt_temp_id: libShared.toUUID,
        curr_code: libShared.toString,
        rid: libShared.toInt,                   
        axn: libShared.toString,                
        url: libShared.toString,                
        is_debug: libShared.toInt
    };

    // Use the convertObjProp function to apply the conversions and merge with defaults
    return libShared.convertObjProp(o, d, conversionMap);
}

AppSettingStore.prototype.save = async function(req, res) {
    try {
        // Extract and validate request data
        const { code, axn, data } = req.body;
        p0.code = code;
        p0.axn = axn;
        p0.data = data;
        const preCode = p0.code;
        const o2 = data.map(item => this.storeObject(item));

        // Validate the request data
        if (!code || code !== SERVICE) {
            return res.status(400).send(libApi.response('Code is required!!', 'Failed'));
        };

        if (!axn) {
            return res.status(400).send(libApi.response('Action is required!!', 'Failed'));
        };

        if (!o2[0].store_code) {
            return res.status(400).send(libApi.response('Store Code is required!!', 'Failed'));
        };

        if (!o2[0].store_name) {
            return res.status(400).send(libApi.response('Store Name is required!!', 'Failed'));
        };

        if (!o2[0].receipt_temp_id) {
            return res.status(400).send(libApi.response('Receipt Template is required!!', 'Failed'));
        };

        if (!o2[0].curr_code) {
            return res.status(400).send(libApi.response('Currency Code is required!!', 'Failed'));
        };

        o2[0].url = req.url;

        const action = preCode.concat('::').concat(axn).toLowerCase().trim();
        // console.log("action: ", action);
        
        // Find the function by using action_code
        const validAxn = await pgSql.getAction(action);
        // console.log(validAxn);
                
        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };

        // Use the shared library function to parse parameters
        const params = libApi.parseParams(validAxn, o2);
            
        // Execute the function
        const result = await pgSql.executeStoreProc(validAxn.data[0].sql_stm, params);
             
        if (result[0].p_msg !== 'ok') {
            return res.status(500).send(libApi.response(result, 'Failed'));
        } else {
            return res.status(200).send(libApi.response(result, 'Success'));
        };
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    };
};

AppSettingStore.prototype.list = async function (req, res) {
    try {
        // Extract and validate request data
        const { code, axn, data } = req.body;
        p0.code = code;
        p0.axn = axn;
        p0.data = data;
        const preCode = p0.code;
        const o2 = data.map(item => this.storeObject(item));

        // Validate the request data
        if (!code || code !== SERVICE) {
            return res.status(400).send(libApi.response('Code is required!!', 'Failed'));
        };

        if (!axn) {
            return res.status(400).send(libApi.response('Action is required!!', 'Failed'));
        };

        const action = preCode.concat('::').concat(axn).toLowerCase().trim();
        // console.log("action: ", action);
        
        // Find the function by using action_code
        const validAxn = await pgSql.getAction(action);
        // console.log(validAxn);
                
        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };

        // Use the shared library function to parse parameters
        const params = libApi.parseParams(validAxn, o2);
            
        // Execute the function
        const result = await pgSql.executeFunction(validAxn.data[0].sql_stm, params);
             
        return res.send(libApi.response(result, 'Success'));
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    };
};

AppSettingStore.prototype.delete = async function (req, res) {
    try {
        // Extract and validate request data
        const { code, axn, data } = req.body;
        p0.code = code;
        p0.axn = axn;
        p0.data = data;
        const preCode = p0.code;
        const o2 = data.map(item => this.storeObject(item));

        // Validate the request data
        if (!code || code !== SERVICE) {
            return res.status(400).send(libApi.response('Code is required!!', 'Failed'));
        };

        if (!axn) {
            return res.status(400).send(libApi.response('Action is required!!', 'Failed'));
        };

        if (!o2[0].store_id) {
            return res.status(400).send(libApi.response('Invalid Store!!', 'Failed'));
        };

        const action = preCode.concat('::').concat(axn).toLowerCase().trim();
        // console.log("action: ", action);
        
        // Find the function by using action_code
        const validAxn = await pgSql.getAction(action);
        // console.log(validAxn);
                
        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };

        // Use the shared library function to parse parameters
        const params = libApi.parseParams(validAxn, o2);
            
        // Execute the function
        const result = await pgSql.executeStoreProc(validAxn.data[0].sql_stm, params);
             
        return res.send(libApi.response(result, 'Success'));
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    };
};

// Create an instance
const store = new AppSettingStore();

// Define route handler
router.post('/l', store.list.bind(store));
router.post('/s', store.save.bind(store));
// router.post('/d', store.delete.bind(store));

module.exports = router;