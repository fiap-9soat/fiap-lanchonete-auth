const AWS = require('aws-sdk');
const cognito = new AWS.CognitoIdentityServiceProvider();

exports.handler = async (event) => {
    const {email} = JSON.parse(event.body);

    const params = {
        ClientId: process.env.CLIENT_ID,
        Username: email,
    };

    try {
        const response = await cognito.forgotPassword(params).promise();
        return {
            statusCode: 200,
            body: JSON.stringify(response),
        };
    } catch (error) {
        return {
            statusCode: 400,
            body: JSON.stringify({error: error.message}),
        };
    }
};
