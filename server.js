const express = require('express');
const app = express();
const PORT = 3000;

// Main landing page
app.get('/', (req, res) => {
    res.send(`
        <html>
            <head><title>CloudDrive MVP</title></head>
            <body style="font-family: Arial, sans-serif; text-align: center; margin-top: 50px;">
                <h1>☁️ Welcome to CloudDrive MVP ............hello!</h1>
                <p>Infrastructure, CI/CD, and Auto Scaling are working flawlessly.</p>
            </body>
        </html>
    `);
});

// AWS Target Group Health Check Endpoint
app.get('/health', (req, res) => {
    res.status(200).send('OK');
});

app.listen(PORT, () => {
    console.log(`🚀 CloudDrive server running locally on port ${PORT}`);
});