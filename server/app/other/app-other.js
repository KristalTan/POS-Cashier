const path = require('path');
const express = require('express');
const router = express.Router();

// Import Libraries
const { pgSql } = require('../../lib/lib-pgsql');
const libApi = require('../../lib/lib-api');
const libShared = require('../../lib/lib-shared');
const { sendEmail } = require('../../lib/lib-mail-service');

const p0 = new libApi.apiCaller();

const FILE = path.basename(__filename);
const SERVICE = FILE.replace('app-', '').replace('.js', '');

function AppOther() {};

AppOther.prototype.othObj = function (o = {}) {
    const d = {
        current_uid: null,
        is_in_use: null,
        rid: null,
        axn: null,
        url: null,
        is_debug: null
    };

    const conversionMap ={
        current_uid: libShared.toString,
        is_in_use: libShared.toInt,
        rid: libShared.toInt,
        axn: libShared.toString,
        url: libShared.toString,
        is_debug: libShared.toInt
    };
    
    // Use the convertObjProp function to apply the conversions and merge with defaults
    return libShared.convertObjProp(o, d, conversionMap);
};

AppOther.prototype.countryList = async function (req, res) {
    let validAxn;
    
    // Extract and validate request data
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const o2 = data.map(item => this.othObj(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    const action = p0.code.concat('::').concat(axn).toLowerCase().trim();
    // console.log("action: ", action);

    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action);
        // console.log(validAxn);
                
        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };

    // Use the shared library function to parse parameters
    const params = libApi.parseParams(validAxn, o2);

    try {
        // Execute the function
        const result = await pgSql.executeFunction(validAxn.data[0].sql_stm, params);

        return res.status(200).send(libApi.response(result, 'Success'));
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };
};

AppOther.prototype.stateList = async function (req, res) {
    let validAxn;
    
    // Extract and validate request data
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const o2 = data.map(item => this.othObj(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    const action = p0.code.concat('::').concat(axn).toLowerCase().trim();
    // console.log("action: ", action);

    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action);
        // console.log(validAxn);
                
        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };

    // Use the shared library function to parse parameters
    const params = libApi.parseParams(validAxn, o2);

    try {
        // Execute the function
        const result = await pgSql.executeFunction(validAxn.data[0].sql_stm, params);

        return res.status(200).send(libApi.response(result, 'Success'));
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };
};

AppOther.prototype.pricingTypeList = async function (req, res) {
    let validAxn;
    
    // Extract and validate request data
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const o2 = data.map(item => this.othObj(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    const action = p0.code.concat('::').concat(axn).toLowerCase().trim();
    // console.log("action: ", action);

    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action);
        // console.log(validAxn);
                
        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };

    // Use the shared library function to parse parameters
    const params = libApi.parseParams(validAxn, o2);

    try {
        // Execute the function
        const result = await pgSql.executeFunction(validAxn.data[0].sql_stm, params);

        return res.status(200).send(libApi.response(result, 'Success'));
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };
};

AppOther.prototype.inventoryTypeList = async function (req, res) {
    let validAxn;
    
    // Extract and validate request data
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const o2 = data.map(item => this.othObj(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    const action = p0.code.concat('::').concat(axn).toLowerCase().trim();
    // console.log("action: ", action);

    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action);
        // console.log(validAxn);
                
        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };

    // Use the shared library function to parse parameters
    const params = libApi.parseParams(validAxn, o2);

    try {
        // Execute the function
        const result = await pgSql.executeFunction(validAxn.data[0].sql_stm, params);

        return res.status(200).send(libApi.response(result, 'Success'));
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };
};

AppOther.prototype.auditLogList = async function (req, res) {
    let validAxn;
    
    // Extract and validate request data
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const o2 = data.map(item => this.othObj(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    const action = p0.code.concat('::').concat(axn).toLowerCase().trim();
    // console.log("action: ", action);

    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action);
        // console.log(validAxn);
                
        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };

    // Use the shared library function to parse parameters
    const params = libApi.parseParams(validAxn, o2);

    try {
        // Execute the function
        const result = await pgSql.executeFunction(validAxn.data[0].sql_stm, params);

        return res.status(200).send(libApi.response(result, 'Success'));
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };
};

AppOther.prototype.actionList = async function (req, res) {
    let validAxn;
    
    // Extract and validate request data
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const o2 = data.map(item => this.othObj(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    const action = p0.code.concat('::').concat(axn).toLowerCase().trim();
    // console.log("action: ", action);

    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action);
        // console.log(validAxn);
                
        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };

    // Use the shared library function to parse parameters
    const params = libApi.parseParams(validAxn, o2);

    try {
        // Execute the function
        const result = await pgSql.executeFunction(validAxn.data[0].sql_stm, params);

        return res.status(200).send(libApi.response(result, 'Success'));
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };
};

const other = new AppOther();

router.post('/cl', other.countryList.bind(other));
router.post('/sl', other.stateList.bind(other));
router.post('/ptl', other.pricingTypeList.bind(other));
router.post('/il', other.inventoryTypeList.bind(other));
router.post('/all', other.auditLogList.bind(other));
router.post('/al', other.actionList.bind(other));


module.exports = router;