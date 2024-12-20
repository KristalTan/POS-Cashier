const path = require('path');
const fs = require('fs');
const express = require('express');
const router = express.Router();
const bodyParser = require('body-parser');

// Import Libraries
const { pgSql } = require('../lib/lib-pgsql');
const libApi = require('../lib/lib-api');
const libShared = require('../lib/lib-shared');
const libMail = require('../lib/lib-mail-service')

const p0 = new libApi.apiCaller();

const FILE = path.basename(__filename);
const SERVICE = FILE.replace('app-', '').replace('.js', '');

function AppMailService() {};

AppMailService.prototype.testMail = async function(req, res) {
    let oAuth = {};

    const { data } = req.body;
    p0.data = data;

    try {
        const result = await pgSql.executeFunction('fn_get_mail_setting', [null]);

        oAuth.oAuthService = result.data[0].smtp_service;
        oAuth.oAuthMailbox = result.data[0].smtp_mailbox;
        oAuth.oAuthClient = result.data[0].smtp_client;
        oAuth.oAuthClientSecret = result.data[0].smtp_client_secret;
        oAuth.oAuthToken = result.data[0].smtp_token;
    } catch (err) {
        return res.status(500).send(libApi.response(err, 'Failed'));;
    }
    
    const message = new libMail.msgObject();
    message.from = new libMail.msgAddrObject(oAuth.oAuthMailbox);
    message.to = new libMail.msgAddrObject(data[0].sent_to);
    message.subject = 'Test Email'
    message.bodyHtml = `
        <!DOCTYPE html>
        <html lang="en">
        <head>
            <meta charset="UTF-8">
            <meta name="viewport" content="width=device-width, initial-scale=1.0">
            <title>Test Email</title>
            <style>
                body {
                    margin: 0;
                    padding: 0;
                    font-family: Arial, sans-serif;
                    background-color: #f4f4f4;
                }
                table {
                    width: 100%;
                    border-spacing: 0;
                }
                td {
                    padding: 0;
                }
                img {
                    border: 0;
                    display: block;
                }

                .email-container {
                    max-width: 600px;
                    margin: 0 auto;
                    background-color: #ffffff;
                    border-radius: 8px;
                    overflow: hidden;
                }

                .email-header {
                    background-color: #007bff;
                    padding: 20px;
                    text-align: center;
                }
                .email-header img {
                    width: 150px;
                }

                .email-body {
                    padding: 20px;
                }
                .email-body h1 {
                    font-size: 24px;
                    color: #333333;
                }
                .email-body p {
                    font-size: 16px;
                    color: #555555;
                    line-height: 1.6;
                }
                .cta-button {
                    background-color: #28a745;
                    color: #ffffff;
                    padding: 12px 20px;
                    font-size: 16px;
                    text-decoration: none;
                    border-radius: 4px;
                    display: inline-block;
                    margin-top: 20px;
                    text-align: center;
                }
                .cta-button:hover {
                    background-color: #218838;
                }

                .email-footer {
                    background-color: #f8f9fa;
                    text-align: center;
                    padding: 20px;
                    font-size: 14px;
                    color: #888888;
                }

                @media only screen and (max-width: 600px) {
                    .email-container {
                        width: 100% !important;
                    }
                    .email-header img {
                        width: 120px;
                    }
                }
            </style>
        </head>
        <body>
            <table role="presentation" class="email-container">
                <!-- Header -->
                <tr>
                    <td class="email-header">
                        <img src="http://localhost:38998/sl/Logo.png" alt="Logo">
                    </td>
                </tr>
                
                <!-- Main Body -->
                <tr>
                    <td class="email-body">
                        <h1>Hello, Test User!</h1>
                        <p>This is a test email for testing purpose, kindly ignore it.</p>
                        <p>We hope you enjoy using our system and have a smooth experience.</p>
                        <p>If you have any questions, feel free to contact our support team.</p>
                    </td>
                </tr>
                
                <!-- Footer -->
                <tr>
                    <td class="email-footer">
                        <p>&copy; 2024 Your Company Name. All rights reserved.</p>
                        <p>If you no longer wish to receive emails, you can unsubscribe anytime.</p>
                    </td>
                </tr>
            </table>
        </body>
        </html>
    `;
    
    const mailClient = await libMail.MailClient(oAuth); 
    const mailResult = await mailClient.sendMail(message);  
        
    if (mailResult.status === 'Success') {
        return res.status(200).send(libApi.response('Email sent successfully!!', 'Success'));
    } else {
        return res.status(500).send(libApi.response(mailResult.response, 'Failed'));
    };
};

AppMailService.prototype.sendMail = async function(mail_id) {
    let oAuth = {}, result, mail = {};

    try {
        result = await pgSql.executeFunction('fn_get_mail_setting', [null]);
        
        oAuth.oAuthService = result.data[0].smtp_service;
        oAuth.oAuthMailbox = result.data[0].smtp_mailbox;
        oAuth.oAuthClient = result.data[0].smtp_client;
        oAuth.oAuthClientSecret = result.data[0].smtp_client_secret;
        oAuth.oAuthToken = result.data[0].smtp_token;        
    } catch (err) {
        console.error('Error fetching mail settings:', err);
        return { status: 'Failed', message: result };
    };

    try {
        result = await pgSql.getTable('tb_mail', `${pgSql.SQL_WHERE} mail_id = '${mail_id}'`, ['mail_id', 'send_to', 'cc_to', 'bcc_to', 'subject', 'email_body'])
        console.log(result);
        
        mail.send_to = result[0].send_to;
        mail.cc_to = result[0].cc_to;
        mail.bcc_to = result[0].bcc_to;
        mail.subject = result[0].subject;
        mail.email_body = result[0].email_body;
    } catch (err) {
        console.error('Error fetching mail settings:', err);
        return { status: 'Failed', message: result };
    };
    
    const ccTo = mail.cc_to ? (Array.isArray(mail.cc_to) ? mail.cc_to : [mail.cc_to]) : [];
    const bccTo = mail.bcc_to ? (Array.isArray(mail.bcc_to) ? mail.bcc_to : [mail.bcc_to]) : [];

    const message = new libMail.msgObject();
    message.from = new libMail.msgAddrObject(oAuth.oAuthMailbox);
    message.to = new libMail.msgAddrObject(mail.send_to);
    message.cc = ccTo;
    message.bcc = bccTo;
    message.subject = mail.subject;
    message.bodyHtml = mail.email_body;
    
    const mailClient = await libMail.MailClient(oAuth); 
    const mailResult = await mailClient.sendMail(message);  

    if (mailResult.status === 'Success') {
        return { status: 'Success', message: 'Email sent successfully!!' };
    } else {
        return { status: 'Failed', message: mailResult.response };
    };
};

const mail = new AppMailService();

router.post('/tm', mail.testMail.bind(mail));

module.exports = router;