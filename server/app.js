const express = require('express');
const app = express();
const cors = require('cors');
const path = require("path");
const fs = require("fs");
const currentWorkingDirectory = process.cwd();
const configPath = path.join(currentWorkingDirectory, '../config', 'user-config.json')
const myConfig = JSON.parse(fs.readFileSync(configPath, 'utf8'));

const prodCat = require('./app/product/app-prod-category');
const modifier = require('./app/product/app-prod-modifier')
const store = require('./app/settings/app-setting-store');
const receiptTemp = require('./app/settings/app-setting-receipt-temp');
const tax = require('./app/settings/app-setting-tax');
const prod = require('./app/product/app-prod-setup');
const meal = require('./app/settings/app-setting-meal-period');
const pymt = require('./app/settings/app-setting-pymt-mode');
const table = require('./app/settings/app-setting-table');
const tableSec = require('./app/settings/app-setting-table-sec');
const customer = require('./app/app-customer');
// const supplier = require('./app/app-supplier');
const generalSet = require('./app/settings/app-setting-general');
const cashier = require('./app/cashiering/app-cashiering-shift');
const usergrp = require('./app/user/app-user-group');
const user = require('./app/user/app-users');
const rpt = require('./app/report/app-report');
const mail = require('./app/app-mail-service');
const other = require('./app/other/app-other')

// Order process
const order = require('./app/order/app-order-trans');

app.use(cors());
app.use(express.json());

// Serve static files from the 'product-file' directory
app.use('/il', express.static(path.join(__dirname, '..', 'product-file')));
app.use('/sl', express.static(path.join(__dirname, '..', 'user-file')));

app.use('/prodCat', prodCat);
app.use('/mod', modifier);
app.use('/store', store);
app.use('/receiptTemp', receiptTemp);
app.use('/tax', tax);
app.use('/prod', prod);
app.use('/mp', meal);
app.use('/pm', pymt);
app.use('/ts', tableSec);
app.use('/t', table);
app.use('/cus', customer);
// app.use('/spl', supplier);
app.use('/gs', generalSet);
app.use('/ug', usergrp);
app.use('/u', user);
app.use('/rpt', rpt);
app.use('/m', mail);
app.use('/oth', other);

app.use('/ord', order);
app.use('/csh', cashier);

app.listen(myConfig.PORT, () => {
    console.log(`Server running on PORT: ${myConfig.PORT}`);
});