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

function AppDayEndClosing() {};

AppDayEndClosing.prototype.settingObject = function(o = {}) {
    const d = {

    };

    return Object.assign(d, o);
};

// Day-end closing manual close

// Day-end closing auto close setup

// Day-end closing auto close

module.exports = router;