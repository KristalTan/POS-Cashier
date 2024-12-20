const exceljs = require('exceljs');
const fs = require('fs');
const path = require('path');
const currentWorkingDirectory = process.cwd();

const tempDir = path.join(currentWorkingDirectory, '..', 'temp');

// Create the directory if it doesn't exist
try {
    if (!fs.existsSync(tempDir)) {
        //console.log("Directory does not exist, creating...");

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

function libRpt() {};

libRpt.interface = function() {
    this.workBook = null,
    this.workSheet = null
};

// Default value
libRpt.rptContentObj = function() {
    this.excel_field = null,
    this.db_field = null,
    this.excel_field_name = null,
    this.data_type = null,
    this.agg_func = null,

    // Style
    // font
    this.font_name = 'Segoe UI',
    this.font_size = '11',
    this.font_color = '	#ff000000', // ARGB code (black), can refer: https://www.myfixguide.com/color-converter/
    this.is_bold = 0,
    this.is_italic = 0,
    this.underline = 0,

    this.width = null,
    this.height = null,

    // Alignment
    this.hor_align = null,
    this.ver_align = null,
    this.wrapText = null,
    
    // Border Style: 
    // thin
    // dotted
    // dashDot
    // hair
    // dashDotDot
    // slantDashDot
    // mediumDashed
    // mediumDashDotDot
    // mediumDashDot
    // medium
    // double
    // thick
    this.border_top = null,
    this.border_bottom = null,
    this.border_left = null,
    this.border_right = null,
    this.bg_color = null
}

libRpt.newWorkbook = function(excel, file_name, bookInfo) {
    // construct a streaming XLSX workbook writer with styles and shared strings
    const filePath = path.join(tempDir, file_name)
    const options = {
        filename: filePath,
        useStyles: true,
        useSharedStrings: true
    };

    excel.workBooks = new exceljs.stream.xlsx.WorkbookWriter(options);

    // console.log('Excel Workbook in newWorkbook: ', excel.workBook);

    if (bookInfo) {
        excel.workBooks.subject = bookInfo.subject
        excel.workBooks.company = bookInfo.company
        excel.workBooks.creator = bookInfo.creator
    }
    
    return excel.workBooks;
};

libRpt.saveWorkbook = function (excel) {
    return new Promise((resolve, reject) => {
        // console.log('Excel Workbook in saveWorkbook: ', excel.workBook);
       excel.workBooks.commit()
        .then(() => {
            resolve();  // Resolve when the file is written
        })
        .catch((err) => {
            reject(err);  // Reject if there is an error
            console.error('Error writing the streamed file:', err);
        });
    });
};

libRpt.getWorksheetCount = function(excel) {    
    return excel.workBooks._worksheets.length;  // Get the length of the worksheets array
};

libRpt.newWorkSheet = function (excel, sheet) {
    if (!sheet) {
        sheet = 'Worksheet ' + (libRpt.getWorksheetCount(excel) + 1);
    };

    excel.workSheet = excel.workBooks.addWorksheet(sheet);

    // Set the page size to A4 and other settings
    excel.workSheet.pageSetup = {
        paperSize: 9, // A4 paper size (9 corresponds to A4 in Excel)
        orientation: 'portrait', // Optional: Set orientation to landscape if needed
        fitToPage: true, // This will automatically scale the content to fit the page
        fitToWidth: 1, // Fit the content to one page width
        fitToHeight: 1 // Fit the content to one page height
    };

    return excel.workSheet;
};

libRpt.setFooter = function () {

};

// libRpt.setReportHeader = function (excel, rptContentObj, addBlankLine) {
//     if (!excel.workSheet) {
//         throw new Error('Worksheet not initialized. Call newWorkSheet() first.');
//     }

//     headerConfig.forEach(header => {
//         const cell = excel.workSheet.getCell(header.excel_field);
//         cell.value = header.title_value;
//         cell.style = header.style || {};

//         if (header.merge) {
//             excel.workSheet.mergeCells(header.merge);
//         }
//     });

//     if (addBlankLine) {
//         excel.workSheet.addRow([]);
//     };
// };

libRpt.setColumnTitle = function () {

};

libRpt.setColumn = function () {

};

libRpt.setHeader = function (excel, headerConfig, addBlankLine) {
    if (!excel.workSheet) {
        throw new Error('Worksheet not initialized. Call newWorksheet() first.');
    }
    console.log(headerConfig);
    
    headerConfig.forEach(header => {
        // console.log("Header: ", header);
        // console.log(header.excel_field);
        
        
        const cell = excel.workSheet.getCell(header.excel_field);
        // console.log(cell);
        
        cell.value = header.excel_field_name;

        // Apply styles dynamically from rptContentObj
        cell.font = {
            name: header.font_name,
            size: header.font_size,
            color: { argb: header.font_color },
            bold: header.is_bold,
            italic: header.is_italic,
            underline: header.underline,
        };

        cell.alignment = {
            horizontal: header.hor_align,
            vertical: header.ver_align,
            mergeText: header.mergeText
        };

        if (header.bg_color) {
            cell.fill = {
                type: 'pattern',
                pattern: 'solid',
                fgColor: { argb: header.bg_color },
            };
        }

        // Apply border styles
        cell.border = {
            top: header.border_top ? { style: 'thin' } : undefined,
            bottom: header.border_bottom ? { style: 'thin' } : undefined,
            left: header.border_left ? { style: 'thin' } : undefined,
            right: header.border_right ? { style: 'thin' } : undefined,
        };

        const column = excel.workSheet.getColumn(cell.col); // Get the column object
        if (header.width) {
            column.width = header.width; // Set the width if defined
        }
    });

    if (addBlankLine) {
        excel.workSheet.addRow([]);
    }
};

libRpt.writeDataRows = function (excel, headerConfig, dataConfig, startRow = 2) {
    if (!excel.workSheet) {
        throw new Error('Worksheet not initialized. Call newWorksheet() first.');
    }

    let currentRow = startRow;

    dataConfig.forEach((dataRow) => {
        const row = excel.workSheet.getRow(currentRow);

        headerConfig.forEach((header, colIndex) => {
            if (header.db_field && dataRow[header.db_field] !== undefined) {
                const cell = row.getCell(colIndex + 1); // Columns are 1-indexed in ExcelJS
                cell.value = dataRow[header.db_field];

                // Apply cell styles from header configuration
                cell.font = {
                    name: header.font_name,
                    size: header.font_size,
                    color: { argb: header.font_color },
                    bold: header.is_bold,
                    italic: header.is_italic,
                    underline: header.underline,
                };

                if (header.bg_color) {
                    cell.fill = {
                        type: 'pattern',
                        pattern: 'solid',
                        fgColor: { argb: header.bg_color },
                    };
                }
            }
        });

        currentRow++; // Move to the next row
    });
};

module.exports = libRpt;