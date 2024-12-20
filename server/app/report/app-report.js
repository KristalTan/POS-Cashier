const path = require('path');
const fs = require('fs');
const express = require('express');
const router = express.Router();
const bodyParser = require('body-parser');
const currentWorkingDirectory = process.cwd();

const tempDir = path.join(currentWorkingDirectory, '..', 'temp');

// Create the directory if it doesn't exist
try {
    if (!fs.existsSync(tempDir)) {
        console.log("Directory does not exist, creating...");

        // Create the directory recursively (including any parent directories if needed)
        fs.mkdirSync(tempDir, { recursive: true });
        console.log("Directory created successfully");
    } else {
        console.log("Directory already exists.");
    }
} catch (error) {
    // Log error if directory creation fails
    console.error("Error creating directory:", error);
};

// Import Libraries
const { pgSql } = require('../../lib/lib-pgsql');
const libApi = require('../../lib/lib-api');
const libShared = require('../../lib/lib-shared');
const libRpt = require('../../lib/lib-rpt');

const p0 = new libApi.apiCaller();

const FILE = path.basename(__filename);
const SERVICE = FILE.replace('.js', '');

function AppReport() {};

AppReport.prototype.rptObject = function (o = {}) {
    const d = {
        current_uid: null,
        start_dt: null,
        end_dt: null,
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

AppReport.prototype.dailyAvailabilityRpt = async function (req, res) {
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const preCode = p0.code;
    const o2 = data.map(item => this.rptObject(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    // Ensure 'data' is an array and has at least one item
    if (!Array.isArray(data) || data.length === 0) {
        return res.status(400).send(libApi.response('Data is required and should not be empty!', 'Failed'));
    };

    const action = preCode.concat('::').concat(axn).toLowerCase().trim();
    
    let validAxn;
    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action); 

        // Check if action is valid
        if (validAxn.rowCount <= 0) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };

    // If validAxn is undefined or not valid, don't proceed
    if (!validAxn || !validAxn.data || validAxn.data.length === 0) {
        return res.status(400).send(libApi.response('Invalid action or no data found', 'Failed'));
    };

    // Proceed with parsing parameters and executing the stored procedure
    const params = libApi.parseParams(validAxn, o2);

    try {
        const result = await pgSql.executeFunction(validAxn.data[0].sql_stm, params);
        
        if (o2[0].axn === 'excel') {
            // Generate the Excel file from the result
            const excel = new libRpt.interface();  // Create a new Excel workbook
            const fileName = `Product_Availability_Report-${libShared.toNewGuid()}.xlsx`
            const sheet = 'Product Availability'
            const addBlankLine = true;
        
            const bookInfo = {
                subject: 'Sales Report',
                company: 'ABC Corporation',
                creator: 'John Doe'
            };

            libRpt.newWorkbook(excel, fileName, bookInfo);
            libRpt.newWorkSheet(excel, sheet);

            // Define the columns (headers)
            const headerConfig = [  
                { 
                    excel_field: 'E1', 
                    excel_field_name: 'Product Availability Report', 
                    font_size: 16,
                    font_color: "FF0070BC",
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'
                },
                { 
                    excel_field: 'D3', 
                    excel_field_name: 'Store Code:', 
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'
                },
                { 
                    excel_field: 'E3', 
                    excel_field_name: 'ABC Store',  // Need Update
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'
                },
                { 
                    excel_field: 'D4', 
                    excel_field_name: 'Period:', 
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'
                },
                { 
                    excel_field: 'E4', 
                    excel_field_name: '05 Dec - 11 Dec 2024',
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'
                },
                { 
                    excel_field: 'D5', 
                    excel_field_name: 'Printed On:', 
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'
                },
                { 
                    excel_field: 'E5', 
                    excel_field_name: '05/12/2024 15:22:37 PM', 
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle' 
                },
                { 
                    excel_field: 'D6', 
                    excel_field_name: 'Printed By: ', 
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'  
                },
                { 
                    excel_field: 'E6', 
                    excel_field_name: 'leehao.chin@theeverlygroup.com', 
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'   
                }
            ].map((config) => {            
                return Object.assign(new libRpt.rptContentObj(), config); // Map configs to rptContentObj
            });

            libRpt.setHeader(excel, headerConfig, addBlankLine);

            const titleConfig = [
                { excel_field: 'A8', excel_field_name: 'Category Description', db_field: 'category_desc', width: 20 },
                { excel_field: 'B8', excel_field_name: 'Product Description', db_field: 'product_desc', width: 20 },
                { excel_field: 'C8', excel_field_name: 'Date', db_field: 'dt', width: 15 },
                { excel_field: 'D8', excel_field_name: 'Quantity', db_field: 'qty', width: 20 },
                { excel_field: 'E8', excel_field_name: 'Sold', db_field: 'sold', width: 30 },
            ].map((config) => {
                return Object.assign(new libRpt.rptContentObj(), config)
            });

            libRpt.setHeader(excel, titleConfig);
            libRpt.writeDataRows(excel, titleConfig, result.data, 9);      

            // Write the Excel file to the response stream
            await libRpt.saveWorkbook(excel);

            // Send file out
            res.sendFile(path.join(tempDir, fileName));
        } else {
            res.status(200).send(libApi.response(result, 'Success'));
        };
        
    } catch (err) {
        console.error('Error executing stored procedure:', err);
        res.status(500).send(libApi.response('Error executing stored procedure', 'Failed'));
    };
};

AppReport.prototype.invoiceListingSumm = async function (req, res) {
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const preCode = p0.code;
    const o2 = data.map(item => this.rptObject(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    // Ensure 'data' is an array and has at least one item
    if (!Array.isArray(data) || data.length === 0) {
        return res.status(400).send(libApi.response('Data is required and should not be empty!', 'Failed'));
    };

    const action = preCode.concat('::').concat(axn).toLowerCase().trim();
    
    let validAxn;
    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action); 

        // Check if action is valid
        if (validAxn.rowCount <= 0) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };

    // If validAxn is undefined or not valid, don't proceed
    if (!validAxn || !validAxn.data || validAxn.data.length === 0) {
        return res.status(400).send(libApi.response('Invalid action or no data found', 'Failed'));
    };

    // Proceed with parsing parameters and executing the stored procedure
    const params = libApi.parseParams(validAxn, o2);
};

AppReport.prototype.item86 = async function (req, res) {
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const preCode = p0.code;
    const o2 = data.map(item => this.rptObject(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    // Ensure 'data' is an array and has at least one item
    if (!Array.isArray(data) || data.length === 0) {
        return res.status(400).send(libApi.response('Data is required and should not be empty!', 'Failed'));
    };

    const action = preCode.concat('::').concat(axn).toLowerCase().trim();
    
    let validAxn;
    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action); 

        // Check if action is valid
        if (validAxn.rowCount <= 0) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };

    // If validAxn is undefined or not valid, don't proceed
    if (!validAxn || !validAxn.data || validAxn.data.length === 0) {
        return res.status(400).send(libApi.response('Invalid action or no data found', 'Failed'));
    };

    // Proceed with parsing parameters and executing the stored procedure
    const params = libApi.parseParams(validAxn, o2);

    try {
        const result = await pgSql.executeFunction(validAxn.data[0].sql_stm, params);

        if (o2[0].axn === 'excel') {
            // Generate the Excel file from the result
            const excel = new libRpt.interface();  // Create a new Excel workbook
            const fileName = `Item86_Report-${libShared.toNewGuid()}.xlsx`
            const sheet = 'Item 86'
            const addBlankLine = true;
        
            const bookInfo = {
                subject: 'Item 86',
                company: '',
                creator: 'John Doe'
            };

            libRpt.newWorkbook(excel, fileName, bookInfo);
            libRpt.newWorkSheet(excel, sheet);

            // Define the columns (headers)
            const headerConfig = [  
                { 
                    excel_field: 'E1', 
                    excel_field_name: 'Item 86 Report', 
                    font_size: 16,
                    font_color: "FF0070BC",
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'
                },
                { 
                    excel_field: 'D3', 
                    excel_field_name: 'Store Code:', 
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'
                },
                { 
                    excel_field: 'E3', 
                    excel_field_name: 'ABC Store',  // Need Update
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'
                },
                { 
                    excel_field: 'D4', 
                    excel_field_name: 'Period:', 
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'
                },
                { 
                    excel_field: 'E4', 
                    excel_field_name: '05 Dec - 11 Dec 2024',
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'
                },
                { 
                    excel_field: 'D5', 
                    excel_field_name: 'Printed On:', 
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'
                },
                { 
                    excel_field: 'E5', 
                    excel_field_name: '05/12/2024 15:22:37 PM', 
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle' 
                },
                { 
                    excel_field: 'D6', 
                    excel_field_name: 'Printed By: ', 
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'  
                },
                { 
                    excel_field: 'E6', 
                    excel_field_name: 'leehao.chin@theeverlygroup.com', 
                    font_size: 12,
                    is_bold: true,
                    hor_align: 'right',
                    ver_align: 'middle'   
                }
                ].map((config) => {            
                    return Object.assign(new libRpt.rptContentObj(), config); // Map configs to rptContentObj
                });

                libRpt.setHeader(excel, headerConfig, addBlankLine);

                const titleConfig = [
                    { excel_field: 'A8', excel_field_name: 'Category Description', db_field: 'category_desc', width: 20 },
                    { excel_field: 'B8', excel_field_name: 'Product Description', db_field: 'product_desc', width: 20 },
                    { excel_field: 'C8', excel_field_name: 'Date', db_field: 'dt', width: 15 },
                    { excel_field: 'D8', excel_field_name: 'Quantity', db_field: 'qty', width: 20 },
                    { excel_field: 'E8', excel_field_name: 'Sold', db_field: 'sold', width: 30 },
                ].map((config) => {
                    return Object.assign(new libRpt.rptContentObj(), config)
                });

                libRpt.setHeader(excel, titleConfig);
                libRpt.writeDataRows(excel, titleConfig, result.data, 9);      

                // Write the Excel file to the response stream
                await libRpt.saveWorkbook(excel);

                // Send file out
                res.sendFile(path.join(tempDir, fileName));
            } else {
                res.status(200).send(libApi.response(result, 'Success'));
            };

    } catch (err) {
        console.error('Error executing stored procedure:', err);
        res.status(500).send(libApi.response('Error executing stored procedure', 'Failed'));
    };
};

AppReport.prototype.cashieringRpt = async function (req, res) {
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const preCode = p0.code;
    const o2 = data.map(item => this.rptObject(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    // Ensure 'data' is an array and has at least one item
    if (!Array.isArray(data) || data.length === 0) {
        return res.status(400).send(libApi.response('Data is required and should not be empty!', 'Failed'));
    };

    const action = preCode.concat('::').concat(axn).toLowerCase().trim();
    
    let validAxn;
    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action); 

        // Check if action is valid
        if (validAxn.rowCount <= 0) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };

    // If validAxn is undefined or not valid, don't proceed
    if (!validAxn || !validAxn.data || validAxn.data.length === 0) {
        return res.status(400).send(libApi.response('Invalid action or no data found', 'Failed'));
    };

    // Proceed with parsing parameters and executing the stored procedure
    const params = libApi.parseParams(validAxn, o2);
};

AppReport.prototype.itemVoidRpt = async function (req, res) {
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const preCode = p0.code;
    const o2 = data.map(item => this.rptObject(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    // Ensure 'data' is an array and has at least one item
    if (!Array.isArray(data) || data.length === 0) {
        return res.status(400).send(libApi.response('Data is required and should not be empty!', 'Failed'));
    };

    const action = preCode.concat('::').concat(axn).toLowerCase().trim();
    
    let validAxn;
    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action); 

        // Check if action is valid
        if (validAxn.rowCount <= 0) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };

    // If validAxn is undefined or not valid, don't proceed
    if (!validAxn || !validAxn.data || validAxn.data.length === 0) {
        return res.status(400).send(libApi.response('Invalid action or no data found', 'Failed'));
    };

    // Proceed with parsing parameters and executing the stored procedure
    const params = libApi.parseParams(validAxn, o2);
};

AppReport.prototype.billVoidRpt = async function (req, res) {
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const preCode = p0.code;
    const o2 = data.map(item => this.rptObject(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    // Ensure 'data' is an array and has at least one item
    if (!Array.isArray(data) || data.length === 0) {
        return res.status(400).send(libApi.response('Data is required and should not be empty!', 'Failed'));
    };

    const action = preCode.concat('::').concat(axn).toLowerCase().trim();
    
    let validAxn;
    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action); 

        // Check if action is valid
        if (validAxn.rowCount <= 0) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };

    // If validAxn is undefined or not valid, don't proceed
    if (!validAxn || !validAxn.data || validAxn.data.length === 0) {
        return res.status(400).send(libApi.response('Invalid action or no data found', 'Failed'));
    };

    // Proceed with parsing parameters and executing the stored procedure
    const params = libApi.parseParams(validAxn, o2);
};

AppReport.prototype.serviceChargeRpt = async function (req, res) {
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const preCode = p0.code;
    const o2 = data.map(item => this.rptObject(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    // Ensure 'data' is an array and has at least one item
    if (!Array.isArray(data) || data.length === 0) {
        return res.status(400).send(libApi.response('Data is required and should not be empty!', 'Failed'));
    };

    const action = preCode.concat('::').concat(axn).toLowerCase().trim();
    
    let validAxn;
    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action); 

        // Check if action is valid
        if (validAxn.rowCount <= 0) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };

    // If validAxn is undefined or not valid, don't proceed
    if (!validAxn || !validAxn.data || validAxn.data.length === 0) {
        return res.status(400).send(libApi.response('Invalid action or no data found', 'Failed'));
    };

    // Proceed with parsing parameters and executing the stored procedure
    const params = libApi.parseParams(validAxn, o2);
};

AppReport.prototype.sstRpt = async function (req, res) {
    const { code, axn, data } = req.body;
    p0.code = code;
    p0.axn = axn;
    p0.data = data;
    const preCode = p0.code;
    const o2 = data.map(item => this.rptObject(item));

    if (!code || code !== SERVICE) {
        return res.status(400).send(libApi.response('Code is required', 'Failed'));
    };

    if (!axn) {
        return res.status(400).send(libApi.response('Action is required', 'Failed'));
    };

    // Ensure 'data' is an array and has at least one item
    if (!Array.isArray(data) || data.length === 0) {
        return res.status(400).send(libApi.response('Data is required and should not be empty!', 'Failed'));
    };

    const action = preCode.concat('::').concat(axn).toLowerCase().trim();
    
    let validAxn;
    // Find the function by using action_code
    try {
        validAxn = await pgSql.getAction(action); 

        // Check if action is valid
        if (validAxn.rowCount <= 0) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        };
    } catch (err) {
        console.log(err);
        return res.status(500).send(libApi.response(err.message || 'Failed to fetch action', 'Failed'));
    };

    // If validAxn is undefined or not valid, don't proceed
    if (!validAxn || !validAxn.data || validAxn.data.length === 0) {
        return res.status(400).send(libApi.response('Invalid action or no data found', 'Failed'));
    };

    // Proceed with parsing parameters and executing the stored procedure
    const params = libApi.parseParams(validAxn, o2);
};

const rpt = new AppReport();

router.post('/dar', rpt.dailyAvailabilityRpt.bind(rpt));

module.exports = router;