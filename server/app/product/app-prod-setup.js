const path = require('path');
const fs = require('fs');
const express = require('express');
const router = express.Router();
const multer = require('multer');
const bodyParser = require('body-parser');
const currentWorkingDirectory = process.cwd();
const configPath = path.join(currentWorkingDirectory, "../config", "user-config.json");
const myConfig = JSON.parse(fs.readFileSync(configPath, 'utf8'));

// Ensure that the "user-file" folder exists
const uploadDir = path.join(currentWorkingDirectory, '..', myConfig.product_folder);

// Import Libraries
const { pgSql } = require('../../lib/lib-pgsql');
const libApi = require('../../lib/lib-api');
const libShared = require('../../lib/lib-shared');

const p0 = new libApi.apiCallerImg();

const FILE = path.basename(__filename)
const SERVICE = FILE.replace('app-', '').replace('.js', '');

// Create the directory if it doesn't exist
try {
    if (!fs.existsSync(uploadDir)) {
        console.log("Directory does not exist, creating...");

        // Create the directory recursively (including any parent directories if needed)
        fs.mkdirSync(uploadDir, { recursive: true });
        console.log("Directory created successfully");
    }
} catch (error) {
    // Log error if directory creation fails
    console.error("Error creating directory:", error);
}

// Set up storage engine for multer
const storage = multer.diskStorage({
    destination: function(req, file, cb) {
        cb(null, uploadDir); // Folder where the image will be saved
    },
    filename: function(req, file, cb) {
        cb(null, libShared.toNewGuid() + path.extname(file.originalname)); // Unique filename
    }
});

// Initialize upload variable with multer configuration
const upload = multer({
    storage: storage,
    limits: { fileSize: 2 * 1024 * 1024 }, // Limit file size to 2MB
    fileFilter: function(req, file, cb) {
        const fileTypes = libShared.imgFormat; // Assume this is an array of valid extensions and/or MIME types
        const extname = path.extname(file.originalname).toLowerCase();
        const mimetype = file.mimetype;
        console.log(extname, mimetype);
        
        // Check if the extension is in the array
        const isValidExt = fileTypes.some(type => extname === type || mimetype === type);
        console.log(isValidExt);
        
        if (isValidExt) {
            return cb(null, true);
        } else {
            cb('Only Accept Image Files!!');
        }
    }
}).fields([
    { name: 'product_img_path', maxCount: 1 }, // Field for image
    { name: 'data', maxCount: 1 }           // Field for JSON data
]);

function AppProdSetup() {};

AppProdSetup.prototype.prodObject = function (o = {}) {
    const d = {
        current_uid: null,
        msg: null,
        product_id: null,
        product_desc: null,
        product_code: null,
        category_id: null,
        product_tag: null,
        product_img_path: null,
        inventory_type_id: null,
        sku_code: null,
        supplier_id: null,
        pricing_type_id: null, 
        cost: null,
        sell_price: null,
        tax_code1: null, 
        amt_include_tax1: null,
        tax_code2: null,
        amt_include_tax2: null,
        calc_tax2_after_tax1: null,
        is_in_use: null,
        display_seq: null,
        is_enable_kitchen_printer: null,
        is_allow_modifier: null,
        is_enable_track_stock: null,
        is_enable_daily_avail: null,
        is_popular_item: null,
        meal_period: null,
        pos_printer: null,
        rid: null,
        axn: null,
        url: null,
        is_debug: null
    };

    const conversionMap = {
        current_uid: libShared.toString,
        product_id: libShared.toUUID,
        product_desc: libShared.toString,
        product_code: libShared.toString,
        category_id: libShared.toUUID,
        product_tag: libShared.toString,
        product_img_path: libShared.toString,
        inventory_type_id: libShared.toUUID,
        sku_code: libShared.toString,
        supplier_id: libShared.toUUID,
        pricing_type_id: libShared.toUUID, 
        cost: libShared.toFloat,
        sell_price: libShared.toFloat,
        tax_code1: libShared.toString, 
        amt_include_tax1: libShared.toInt,
        tax_code2: libShared.toString,
        amt_include_tax2: libShared.toInt,
        calc_tax2_after_tax1: libShared.toInt,
        is_in_use: libShared.toInt,
        display_seq: libShared.toString,
        is_enable_kitchen_printer: libShared.toInt,
        is_allow_modifier: libShared.toInt,
        is_enable_track_stock: libShared.toInt,
        is_enable_daily_avail: libShared.toInt,
        is_popular_item: libShared.toInt,
        meal_period: libShared.toString,
        pos_printer: libShared.toString,
        rid: libShared.toInt,
        axn: libShared.toString,
        url: libShared.toString,
        is_debug: libShared.toInt
    };

    // Use the convertObjProp function to apply the conversions and merge with defaults
    return libShared.convertObjProp(o, d, conversionMap);
};

AppProdSetup.prototype.save = async function (req, res) {
    try {
        const { code, axn, data, product_img_path } = req.body;
        p0.code = code;
        p0.axn = axn;
        p0.data = data;
        p0.img = product_img_path;
        const preCode = p0.code;

        let parsedData = data;
        if (typeof data === 'string') {
            parsedData = JSON.parse(data);
        };
        
        // Check parsedData is an array
        if (!Array.isArray(parsedData)) {
            return res.status(400).send(libApi.response('Data should be an array!', 'Failed'));
        };

        const o2 = parsedData.map(item => this.prodObject(item));   

        // Access the uploaded file
        const uploadedFile = req.files['product_img_path'] ? req.files['product_img_path'][0] : null;
        
        // Check if the file was uploaded
        if (!uploadedFile) {
            return res.status(400).send(libApi.response('No file uploaded!', 'Failed'));
        };

        let oldLogoImgPath = null;
        if (o2[0].product_id) {
            // Extract the old `product_img_path` from the database
            try {
                oldLogoImgPath = await pgSql.getTable('tb_product', `${pgSql.SQL_WHERE} product_id = '${o2[0].product_id}'`, ['product_img_path']);
            } catch (err) {
                console.error('Error fetching old product_img_path:', err);
                return res.status(500).send(libApi.response('Error fetching old product img path', 'Failed'));
            }
        };
        console.log(oldLogoImgPath);

        // Process the logo image path deletion if there was a previous image
        if (oldLogoImgPath && oldLogoImgPath[0].product_img_path) {
            const oldImagePath = path.join(uploadDir, oldLogoImgPath[0].product_img_path);
            if (fs.existsSync(oldImagePath)) {
                fs.unlinkSync(oldImagePath); // Delete the old image
            }
        };
        
        if (!code || code !== SERVICE) {
            return res.status(400).send(libApi.response('Code is required!!', 'Failed'));
        };

        if (!axn) {
            return res.status(400).send(libApi.response('Action is required!!', 'Failed'));
        };

        if (!o2[0].product_desc) {
            return res.status(400).send(libApi.response('Product Description is required!!', 'Failed'));
        };

        if (o2[0].display_seq != null) {
            if (o2[0].display_seq.length > 6) {
                return res.status(400).send(libApi.response('Display sequence must be 6 digits or less!!', 'Failed'));
            } else {
                o2[0].display_seq = libShared.padFillLeft(o2[0].display_seq, 6, '0');
            };
        };

        // Now update `logo_img_path` in the params array with the new uploaded file path
        o2[0].product_img_path = `${uploadedFile.filename}`;
        o2[0].url = req.baseUrl;

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
        console.log("params: ", params);
            
        // Execute the function
        const result = await pgSql.executeStoreProc(validAxn.data[0].sql_stm, params);
             
        // Check if the result was successful
        if (result[0].p_msg !== 'ok') {
            if (uploadedFile) {
                const uploadedImagePath = path.join(uploadDir, uploadedFile.filename);
                if (fs.existsSync(uploadedImagePath)) {
                    fs.unlinkSync(uploadedImagePath); // Delete the uploaded image
                }
            }

            return res.status(500).send(libApi.response(result, 'Failed'));
        } else {            
            return res.status(200).send(libApi.response(result, 'Success'));
        };
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    };
};

AppProdSetup.prototype.list = async function (req, res) {
    try {
        const { code, axn, data } = req.body;
        p0.code = code;
        p0.axn = axn;
        p0.data = data;
        const preCode = p0.code;
        const o2 = data.map(item => this.prodObject(item));

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
        const result = await pgSql.executeFunction(validAxn.data[0].sql_stm, params)
             
        return res.send(libApi.response(result, 'Success'));
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    };
};

AppProdSetup.prototype.delete = async function (req, res) {
    try {
        const { code, axn, data } = req.body;
        p0.code = code;
        p0.axn = axn;
        p0.data = data;
        const preCode = p0.code;
        const o2 = data.map(item => this.prodObject(item));
        
        if (!code || code !== SERVICE) {
            return res.status(400).send(libApi.response('Code is required!!', 'Failed'));
        };

        if (!axn) {
            return res.status(400).send(libApi.response('Action is required!!', 'Failed'));
        };

        if (!o2[0].product_id) {
            return res.status(400).send(libApi.response('Invalid Product!!', 'Failed'));
        };

        const oldLogoImgPath = await pgSql.getTable('tb_product', `${pgSql.SQL_WHERE} product_id = '${o2[0].product_id}'`, ['product_img_path']); 
        // console.log(oldLogoImgPath);
        
        if (oldLogoImgPath) {      

            // Get the full path of the old image
            const oldImagePath = path.join(__dirname, myConfig.product_folder, oldLogoImgPath[0].product_img_path.replace(`/${myConfig.product_folder}/`, '')); 
                 
            // Check if the old image exists, if so, delete it
            if (fs.existsSync(oldImagePath)) {
                fs.unlinkSync(oldImagePath); // Delete the old image
            };
        };

        const action = preCode.concat('::').concat(axn).toLowerCase().trim();
        // console.log("action: ", action);
        
        // Find the function by using action_code
        const validAxn = await pgSql.getAction(action);

        // Append Error if the action is not found
        if (validAxn.rowCount <= 1) {
            return res.status(400).send(libApi.response(validAxn.data[0]?.msg || 'Invalid Action', 'Failed'));
        }

        // Use the shared library function to parse parameters
        const params = libApi.parseParams(validAxn, o2);
            
        // Execute the function
        const result = await pgSql.executeStoreProc(validAxn.data[0].sql_stm, params)
             
        return res.send(libApi.response(result, 'Success'));
    } catch (err) {
        console.error(err);
        return res.status(500).send(libApi.response(err.message || err, 'Failed'));
    }
};

// AppProdSetup.prototype.imageList = async function(req, res) {
//     const imagesDir = path.join(__dirname, 'product-file');

//     fs.readdir(imagesDir, (err, files) => {
//         if (err) {
//             return res.status(500).json({ error: 'Unable to scan directory: ' + err });
//         }

//         // Filter out non-image files if necessary
//         const imageFiles = files.filter(file => /\.(jpg|jpeg|png|gif)$/.test(file));

//         // Map to create full image URLs
//         const images = imageFiles.map(file => ({
//             id: file, // or use an incrementing ID if you prefer
//             url: `http://localhost:38998/images/${file}`
//         }));

//         res.json(images);
//     });
// };

const prod = new AppProdSetup();

router.post('/s', upload, prod.save.bind(prod));
router.post('/l', prod.list.bind(prod));
router.post('/d', prod.delete.bind(prod));
// router.get('/il', prod.imageList.bind(prod));

module.exports = router;