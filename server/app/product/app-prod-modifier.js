const path = require('path');
const fs = require('fs');
const express = require('express');
const router = express.Router();
const bodyParser = require('body-parser');

// Import Libraries
const { pgSql } = require('../../lib/lib-pgsql');
const libApi = require('../../lib/lib-api');
const libShared = require('../../lib/lib-shared');

const p0 = new libApi.apiCallerImg();

const FILE = path.basename(__filename)
const SERVICE = FILE.replace('app-', '').replace('.js', '');

function AppProdModifier() {};

AppProdModifier.prototype.prodModifierObject = function(o = {}) {
    const d = {
        current_uid: null,
        msg: null,
        modifier_group_id: null,
        modifier_group_name: null,
        is_single_modifier_choice: null,
        is_multiple_modifier_choice: null,
        is_in_use: null,
        display_seq: null,
        modifier_option_id: null,
        modifier_option_name: null,
        addon_amt: null,
        is_default: null,
        link_item: null,
        rid: null,
        axn: null,
        url: null,
        is_debug: null
    };

    // Make sure the data type same as store procedure need
    const conversionMap = {
        current_uid: libShared.toString,
        modifier_group_id_id: libShared.toUUID,          
        modifier_group_name: libShared.toString,
        is_single_modifier_choice: libShared.toInt,
        is_multiple_modifier_choice: libShared.toInt,
        is_in_use: libShared.toInt,
        display_seq: libShared.toString, 
        modifier_option_id: libShared.toUUID,
        modifier_option_name: libShared.toString,
        addon_amt: libShared.toFloat,
        is_default:libShared.toInt,
        link_item: libShared.toText,
        rid: libShared.toInt,                   
        axn: libShared.toString,                
        url: libShared.toString,                
        is_debug: libShared.toInt
    };

    // Use the convertObjProp function to apply the conversions and merge with defaults
    return libShared.convertObjProp(o, d, conversionMap);
};

// Step 1: Save the modifier group
AppProdModifier.prototype.modifierGroupSave = async function(req, res) {
    try {
        const { code, axn, data } = req.body;
        p0.code = code;
        p0.axn = axn;
        p0.data = data;
        const preCode = p0.code;
        const o2 = data.map(item => this.prodModifierObject(item));

        if (!code || code !== SERVICE) {
            return res.status(400).send(libApi.response('Code is required!!', 'Failed'));
        };

        if (!axn) {
            return res.status(400).send(libApi.response('Action is required!!', 'Failed'));
        };

        if (!o2[0].modifier_group_name) {
            return res.status(400).send(libApi.response('Modifier Group Name is required!!', 'Failed'));
        };

        if (
            (o2[0].is_single_modifier_choice === null || o2[0].is_single_modifier_choice === 0) && 
            (o2[0].is_multiple_modifier_choice === null && o2[0].is_multiple_modifier_choice === 0) 
        ) {           
            return res.status(400).send(libApi.response('Please select either a single choice or multiple choices for the modifier!!', 'Failed'));
        };

        if (o2[0].display_seq != null) {
            if (o2[0].display_seq.length > 6) {
                return res.status(400).send(libApi.response('Display sequence must be 6 digits or less!!', 'Failed'));
            } else {
                o2[0].display_seq = libShared.padFillLeft(o2[0].display_seq, 6, '0');
            };
        };

        const action = preCode.concat('::').concat(axn).toLowerCase().trim();

        const validAxn = await pgSql.getAction(action);

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

AppProdModifier.prototype.modifierGroupList = async function(req, res) {
    try {
        const { code, axn, data } = req.body;
        p0.code = code;
        p0.axn = axn;
        p0.data = data;
        const preCode = p0.code;
        const o2 = data.map(item => this.prodModifierObject(item));

        if (!code || code !== SERVICE) {
            return res.status(400).send(libApi.response('Code is required!!', 'Failed'));
        };

        if (!axn) {
            return res.status(400).send(libApi.response('Action is required!!', 'Failed'));
        };

        const action = preCode.concat('::').concat(axn).toLowerCase().trim();

        const validAxn = await pgSql.getAction(action);

        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };

        // Use the shared library function to parse parameters
        const params = libApi.parseParams(validAxn, o2);

        // Execute the function
        const result = await pgSql.executeFunction(validAxn.data[0].sql_stm, params);

        return res.status(200).send(libApi.response(result, 'Success'));
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    };
};

// Step 2: Save the Modifier Group Option
AppProdModifier.prototype.modifierOptSave = async function(req, res) {
    try {
        const { code, axn, data } = req.body;
        p0.code = code;
        p0.axn = axn;
        p0.data = data;
        const preCode = p0.code;
        const o2 = data.map(item => this.prodModifierObject(item));

        if (!code || code !== SERVICE) {
            return res.status(400).send(libApi.response('Code is required!!', 'Failed'));
        };

        if (!axn) {
            return res.status(400).send(libApi.response('Action is required!!', 'Failed'));
        };

        const action = preCode.concat('::').concat(axn).toLowerCase().trim();

        const validAxn = await pgSql.getAction(action);

        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };

        // Put the process inside a transaction
        const result = await pgSql.runTransaction(async (t) => {
            // Prepare an array to hold individual promises
            const promises = [];

            // Execute the stored procedure for each item in the data array
            for (const item of data) {
                // Ensure each item has required fields
                const optionData = this.prodModifierObject(item);
                
                if (!optionData.modifier_option_name) {
                    return res.status(400).send(libApi.response('Modifier Option Name is required!', 'Failed'));
                };

                if (!optionData.modifier_group_id) {
                    return res.status(400).send(libApi.response('Modifier Group is required!', 'Failed'));
                };

                // Parse parameters for the current item
                const params = libApi.parseParams(validAxn, [optionData]);
                
                // Create a promise for executing the stored procedure and add it to the array
                const promise = t.any('CALL pr_product_modifier_item_save($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11)', params)
                    .then((result) => { 
                        if (result[0].p_msg !== 'ok') {
                            return { data: result[0].p_msg, message: "Failed" };
                        } else {
                            return { data: result[0].p_msg, message: "Success" };
                        }
                    })
                    .catch((error) => { 
                        console.error('Error occurred in stored procedure execution:', error.message, { item, params });
                        // Log the full error object to capture stack trace and other details
                        console.error(error);
                        return { data: error, message: "Failed" }
                    });
                
                promises.push(promise);
            };

            // Use Promise.all to execute all promises concurrently
            const results = await Promise.all(promises);

            // Check each result for errors after all promises have resolved
            for (const result3 of results) {
                if (result3.message !== 'Success') {
                    return res.status(400).send(libApi.response(result3.data, 'Failed'));
                };
            };

            // If everything is successful, return the results
            return results;
        });        

        return res.send(libApi.response('ok', 'Success'));
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    };
};

AppProdModifier.prototype.modifierOptList = async function(req, res) {
    try {
        const { code, axn, data } = req.body;
        p0.code = code;
        p0.axn = axn;
        p0.data = data;
        const preCode = p0.code;
        const o2 = data.map(item => this.prodModifierObject(item));

        if (!code || code !== SERVICE) {
            return res.status(400).send(libApi.response('Code is required!!', 'Failed'));
        };

        if (!axn) {
            return res.status(400).send(libApi.response('Action is required!!', 'Failed'));
        };

        const action = preCode.concat('::').concat(axn).toLowerCase().trim();

        const validAxn = await pgSql.getAction(action);

        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };

        // Use the shared library function to parse parameters
        const params = libApi.parseParams(validAxn, o2);

        // Execute the function
        const result = await pgSql.executeFunction(validAxn.data[0].sql_stm, params);

        return res.status(200).send(libApi.response(result, 'Success'));
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    };
};

// Step 3: Link the Modifier Group with product
AppProdModifier.prototype.linkProduct = async function(req, res) {
    try {
        const { code, axn, data } = req.body;
        p0.code = code;
        p0.axn = axn;
        p0.data = data;
        const preCode = p0.code;
        const o2 = data.map(item => this.prodModifierObject(item));

        if (!code || code !== SERVICE) {
            return res.status(400).send(libApi.response('Code is required!!', 'Failed'));
        };

        if (!axn) {
            return res.status(400).send(libApi.response('Action is required!!', 'Failed'));
        };

        if (!o2[0].modifier_group_id) {
            return res.status(400).send(libApi.response('Modifier Group is required!!', 'Failed'));
        };

        const action = preCode.concat('::').concat(axn).toLowerCase().trim();

        const validAxn = await pgSql.getAction(action);

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

AppProdModifier.prototype.linkProductList = async function(req, res) {
    try {
        const { code, axn, data } = req.body;
        p0.code = code;
        p0.axn = axn;
        p0.data = data;
        const preCode = p0.code;
        const o2 = data.map(item => this.prodModifierObject(item));

        if (!code || code !== SERVICE) {
            return res.status(400).send(libApi.response('Code is required!!', 'Failed'));
        };

        if (!axn) {
            return res.status(400).send(libApi.response('Action is required!!', 'Failed'));
        };

        const action = preCode.concat('::').concat(axn).toLowerCase().trim();

        const validAxn = await pgSql.getAction(action);

        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };

        // Use the shared library function to parse parameters
        const params = libApi.parseParams(validAxn, o2);

        // Execute the function
        const result = await pgSql.executeFunction(validAxn.data[0].sql_stm, params);

        return res.status(200).send(libApi.response(result, 'Success'));
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    };
};

const prodModf = new AppProdModifier();

router.post('/mgs', prodModf.modifierGroupSave.bind(prodModf));
router.post('/mgl', prodModf.modifierGroupList.bind(prodModf));
router.post('/mos', prodModf.modifierOptSave.bind(prodModf));
router.post('/mol', prodModf.modifierOptList.bind(prodModf));
router.post('/mlps', prodModf.linkProduct.bind(prodModf));
router.post('/mlpl', prodModf.linkProductList.bind(prodModf));

module.exports = router;