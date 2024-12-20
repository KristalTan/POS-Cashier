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
const SERVICE = FILE.replace('.js', '');

function AppUser() {};

AppUser.prototype.userObject = function(o = {}) {
    const d = {
        current_uid: null,
        msg: null,
        user_id: null,
        login_id: null,
        user_name: null,
        email: null,
        pwd: null,
        user_group_id: null,
        is_active: null
    };

    return Object.assign(d, o);
};

AppUser.prototype.save = async function(req, res) {
    try {
        // Extract and validate request data
        const { code, axn, data } = req.body;
        p0.code = code;
        p0.axn = axn;
        p0.data = data;
        const preCode = p0.code;
        const o2 = data.map(item => this.userObject(item));

        if (!code || code !== SERVICE) {
            return res.status(400).send(libApi.response('Code is required', 'Failed'));
        };

        if (!axn) {
            return res.status(400).send(libApi.response('Action is required', 'Failed'));
        };

        if (!o2[0].login_id) {
            return res.status(400).send(libApi.response('Login ID is required', 'Failed'));
        };

        if (!o2[0].user_name) {
            return res.status(400).send(libApi.response('Username is required', 'Failed'));
        };

        if (!o2[0].email) {
            return res.status(400).send(libApi.response('Email is required', 'Failed'));
        };

        if (!o2[0].pwd) {
            return res.status(400).send(libApi.response('Password is required', 'Failed'));
        };

        if (!o2[0].user_group_id) {
            return res.status(400).send(libApi.response('User Group is required', 'Failed'));
        };

        // redefine the o2.pwd
        o2[0].pwd = libShared.hashText(o2[0].pwd);
        console.log(o2[0].pwd);

        const action = preCode.concat('::').concat(axn).toLowerCase().trim();
        // console.log("action: ", action);
        
        // Find the function by using action_code
        const validAxn = await pgSql.getAction(action);
        // console.log(validAxn);
                
        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        }

        // Use the shared library function to parse parameters
        const params = libApi.parseParams(validAxn, o2);
        // console.log("params: ", params);
            
        // Execute the function
        const result = await pgSql.executeStoreProc(validAxn.data[0].sql_stm, params)
             
        return res.send(libApi.response(result, 'Success'));
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    };
};

AppUser.prototype.list = async function(req, res) {

};

const user = new AppUser();

router.post('/s', user.save.bind(user));

module.exports = router;