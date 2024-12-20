const nodemailer = require('nodemailer');
const { google } = require('googleapis');
const path = require('path');
const fs = require('fs');

const { pgSql } = require('./lib-pgsql');

const OAuth2 = google.auth.OAuth2;

/**
 * Address object for handling email addresses.
 */
function msgAddrObject(emailAddr) {
    this.name = null;
    this.email = null;

    this.toString = function () {
        return this.name ? `${this.name} <${this.email}>` : this.email;
    };

    if (typeof emailAddr === 'string') {
        let pos = emailAddr.indexOf('<');
        this.name = pos > 0 ? emailAddr.substring(0, pos).trim() : null;
        this.email = pos > 0 ? emailAddr.substring(pos + 1, emailAddr.indexOf('>')).trim() : emailAddr;
    };
}

/**
 * Message object for holding email data.
 */
function msgObject() {
    this.from = null;
    this.to = null;
    this.cc = null;
    this.bcc = null;
    this.subject = null;
    this.bodyHtml = null;
    this.attachments = [];

    this.attachFile = function (filePath) {
        this.attachments.push({
            filename: path.basename(filePath),
            path: filePath
        });
    };
}

/**
 * Mail client for sending emails.
 */
async function MailClient(oAuth) {
    const oAuth2Client = new OAuth2(
        oAuth.oAuthClient,
        oAuth.oAuthClientSecret,
        'https://developers.google.com/oauthplayground',
    );

    oAuth2Client.setCredentials({
        refresh_token: oAuth.oAuthToken,
    });

    const accessToken = await new Promise((resolve, reject) => {
        oAuth2Client.getAccessToken((err, token) => {
            if (err) {
                reject(err);
            }
            resolve(token);
        });
    });

    const transporter = nodemailer.createTransport({
        service: oAuth.oAuthService,
        auth: {
            type: 'OAuth2',
            user: oAuth.oAuthMailbox,
            clientId: oAuth.oAuthClient,
            clientSecret: oAuth.oAuthClientSecret,
            refreshToken: oAuth.oAuthToken,
            accessToken: accessToken
        }
    });

    return {
        sendMail: async function (msg) {
            try {
                const mailOptions = {
                    from: msg.from.toString(),
                    to: Array.isArray(msg.to) ? msg.to.map(r => r.toString()).join(',') : msg.to,
                    cc: msg.cc ? (Array.isArray(msg.cc) ? msg.cc.map(r => r.toString()).join(',') : msg.cc) : [],
                    bcc: msg.bcc ? (Array.isArray(msg.bcc) ? msg.bcc.map(r => r.toString()).join(',') : msg.bcc) : [],
                    subject: msg.subject,
                    html: msg.bodyHtml,
                    attachments: msg.attachments
                };
                await transporter.sendMail(mailOptions);
                return {
                    status: 'Success'
                };
            } catch (err) {
                console.error('Failed to send email:', err);
                return { 
                    status: 'Failed', 
                    error: err.message, 
                    code: err.code, 
                    response: err.response 
                };
            };
        }
    };
};

async function sendEmail(o) {
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
        result = await pgSql.getTable('tb_mail', `${pgSql.SQL_WHERE} mail_id = '${o.mail_id}'`, ['mail_id', 'send_to', 'cc_to', 'bcc_to', 'subject', 'email_body'])
        // console.log(result);
        
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

    const message = new msgObject();
    message.from = new msgAddrObject(oAuth.oAuthMailbox);
    message.to = new msgAddrObject(mail.send_to);
    message.cc = ccTo;
    message.bcc = bccTo;
    message.subject = mail.subject;
    message.bodyHtml = mail.email_body;
    
    const mailClient = await MailClient(oAuth); 
    const mailResult = await mailClient.sendMail(message);  

    if (mailResult.status === 'Success') {
        try {
            result = await pgSql.executeStoreProc('pr_mark_email_sent', [o.current_uid, o.msg, o.mail_id]);
        } catch (err) {
            console.log(err);
        };  

        return { status: 'Success', message: 'Email sent successfully!!' };
    } else {
        return { status: 'Failed', message: mailResult.response };
    };
};

module.exports = {
    msgAddrObject,
    msgObject,
    MailClient,
    sendEmail
};

