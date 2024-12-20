const path = require('path');
const fs = require('fs');
const express = require('express');
const router = express.Router();
const bodyParser = require('body-parser');

// Import Libraries
const { pgSql } = require('../../lib/lib-pgsql');
const libApi = require('../../lib/lib-api');
const libShared = require('../../lib/lib-shared');

const p0 = new libApi.apiCaller();

const FILE = path.basename(__filename);
const SERVICE = FILE.replace('app-', '').replace('.js', '');

function AppSettingGeneral() {};

AppSettingGeneral.prototype.settingObject = function (o = {}) {
    const d = {
        current_uid: null,
        msg: null,
        setting_title: null,
        setting_value: null,
        rid: null,
        axn: null,
        url: null,
        is_debug: null
    };

    // Make sure the data type same as store procedure need
    const conversionMap = {
        current_uid: libShared.toString,
        setting_title: libShared.toString,
        setting_value: libShared.toString,       
        rid: libShared.toInt,                   
        axn: libShared.toString,                
        url: libShared.toString,                
        is_debug: libShared.toInt
    };

    // Use the convertObjProp function to apply the conversions and merge with defaults
    return libShared.convertObjProp(o, d, conversionMap);
};

AppSettingGeneral.prototype.save = async function(req, res) {
    let validAxn;
    
    // Extract and validate request data
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const preCode = p0.code;

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required or invalid!', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required!', 'Failed'));
    };

    // Ensure 'data' is an array and has at least one item
    if (!Array.isArray(data) || data.length === 0) {
        return res.status(400).send(libApi.response('Data is required and should not be empty!', 'Failed'));
    };

    const action = preCode.concat('::').concat(axn).toLowerCase().trim();
        
    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action);  

        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };
    
    try {
        // Put the process inside a transaction
        await pgSql.runTransaction(async (t) => {
            // Execute the stored procedure for each item in the data array
            for (const item of data) {
                // Ensure each item has required fields
                const settingData = this.settingObject(item);
                
                if (!settingData.setting_title) {
                    return res.status(400).send(libApi.response('Title is required for each data item!', 'Failed'));
                };

                if (!settingData.setting_value) {
                    return res.status(400).send(libApi.response('Value is required for each data item!', 'Failed'));
                };

                // Parse parameters for the current item
                const params = libApi.parseParams(validAxn, [settingData]);
                
                // Create a promise for executing the stored procedure and add it to the array
                const result = await t.any('CALL pr_general_setting_save($1, $2, $3, $4, $5, $6, $7, $8)', params);
                
                if (result[0].p_msg !== 'ok') {
                    throw new Error(result[0].p_msg);
                };
            };
        });        
        
        return res.send(libApi.response('ok', 'Success'));
    } catch (err) {
        console.error('Error executing stored procedure:', err);
        res.status(500).send(libApi.response(err.message, 'Failed'));
    };
};


AppSettingGeneral.prototype.list = async function(req, res) {
    let validAxn, params;

    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const preCode = p0.code;
    const o2 = data.map(item => this.settingObject(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required!!', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required!!', 'Failed'));
    };

    const action = preCode.concat('::').concat(axn).toLowerCase().trim();
    // console.log("action: ", action);
        
    try {
        // Find the function by using action_code
        validAxn = await pgSql.getAction(action);
        // console.log(validAxn);
                
        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    };

    try {
        // Use the shared library function to parse parameters
        params = libApi.parseParams(validAxn, o2);

        // Execute the function
        const result = await pgSql.executeFunction(validAxn.data[0].sql_stm, params);

        return res.send(libApi.response(result, 'Success'));
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    }; 
};

const setting = new AppSettingGeneral();

router.post('/s', setting.save.bind(setting));
router.post('/l', setting.list.bind(setting));

module.exports = router;