const path = require('path');
const fs = require('fs');
const express = require('express');
const router = express.Router();
const multer = require('multer');
const bodyParser = require('body-parser');

// Import Libraries
const { pgSql } = require('../../lib/lib-pgsql');
const libApi = require('../../lib/lib-api');
const libShared = require('../../lib/lib-shared');

const p0 = new libApi.apiCaller();

const FILE = path.basename(__filename)
const SERVICE = FILE.replace('app-', '').replace('.js', '');

function AppProdDailyAvail() {};

AppProdDailyAvail.prototype.availObj = function (o = {}) {
    const d = {
        current_uid: null,
        msg: null,
        start_dt: null,
        end_dt: null,
        product_id: null,
        qty: null,
        rid: null,
        axn: null,
        url: null,
        is_debug: null
    };

    const conversionMap = {
        current_uid: libShared.toString,
        start_dt: libShared.toDate,
        end_dt: libShared.toDate,
        rid: libShared.toInt,
        axn: libShared.toString,
        url: libShared.toString,
        is_debug: libShared.toInt
    };

    // Use the convertObjProp function to apply the conversions and merge with defaults
    return libShared.convertObjProp(o, d, conversionMap);
};

AppProdDailyAvail.prototype.initial = async function (req, res) {
    let validAxn;
    // Extract and validate request data
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const preCode = p0.code;
    const o2 = data.map(item => this.availObj(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    const action = preCode.concat('::').concat(axn).toLowerCase().trim();
        
    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action);
        // console.log(validAxn);
                
        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(500).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    };
    
    // Use the shared library function to parse parameters
    const params = libApi.parseParams(validAxn, o2);
    
    // Execute the function
    try {
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

AppProdDailyAvail.prototype.update = async function (req, res) {
    let validAxn;
    // Extract and validate request data
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const preCode = p0.code;
    const o2 = data.map(item => this.availObj(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    const action = preCode.concat('::').concat(axn).toLowerCase().trim();
    // console.log("action: ", action);
        
    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action);

        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    }
                
    try {
        await pgSql.runTransaction(async (t) => {
            for (const item of data) {
                // Ensure each item has required fields
                const availData = this.availObj(item);
                
                if (!availData.order_trans_id) {
                    return res.status(400).send(libApi.response('Order Transaction Number is required!', 'Failed'));
                };

                // Parse parameters for the current item
                const params = libApi.parseParams(validAxn, [lineData]);
                    
                // Create a promise for executing the stored procedure and add it to the array
                const result = await t.any(`CALL ${validAxn.data[0].sql_stm}($1, $2, $3, $4, $5, $6, $7, $8, $9, $10)`, params);
                   
                if (result[0].p_msg !== 'ok') {
                    throw new Error(result[0].p_msg);
                };
            };
        });  

        return res.send(libApi.response('ok', 'Success'));
    } catch (err) {
        console.error('Error executing stored procedure:', err);
        return res.status(500).send(libApi.response(err.message, 'Failed'));
    };
};

const avail = new AppProdDailyAvail();

router.post('/i', avail.initial.bind(avail));
router.post('/u', avail.update.bind(avail));

module.exports = router;