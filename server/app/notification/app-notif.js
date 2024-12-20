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
const SERVICE = FILE.replace('.js', '');

function AppNotif() {};

AppNotif.prototype.notifObj = function(o = {}) {
    const d = {
        current_uid: null,
        msg: null,
        notif_id: null,
        action_id: null,
        sent_to: null,
        cc_to: null,
        bcc_to: null,
        subject: null,
        body: null,
        is_in_use: null,
        rid: null,
        axn: null,
        url: null,
        is_debug: null
    };

    const conversionMap = {
        current_uid: libShared.toString,
        notif_id: libShared.toUUID,
        action_id: libShared.toUUID,
        sent_to: libShared.toText,
        cc_to: libShared.toText,
        bcc_to: libShared.toText,
        subject: libShared.toText,
        body: libShared.toText,
        is_in_use: libShared.toInt,
        rid: libShared.toInt,
        axn: libShared.toString,
        url: libShared.toString,
        is_debug: libShared.toInt
    };

    // Use the convertObjProp function to apply the conversions and merge with defaults
    return libShared.convertObjProp(o, d, conversionMap);
};

AppNotif.prototype.save = async function(req, res) {

};

AppNotif.prototype.list = 

module.exports = router;