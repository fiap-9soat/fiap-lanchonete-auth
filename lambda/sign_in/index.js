/*
Lambda for user authentication (sign-in) using Cognito, but receiving parameters
directly.
This is necessary since we don't have a dedicated frontend client.
 */
const AWS = require('aws-sdk');
const cognito = new AWS.CognitoIdentityServiceProvider();

exports.handler = async (event) => {
    const {email, password} = JSON.parse(event.body);

    const params = {
        AuthFlow: 'ADMIN_NO_SRP_AUTH',
        UserPoolId: process.env.USER_POOL_ID,
        ClientId: process.env.CLIENT_ID,
        AuthParameters: {
            USERNAME: email,
            PASSWORD: password,
        },
    };

    try {
        const authResponse = await cognito.adminInitiateAuth(params).promise();
        return {
            statusCode: 200,
            body: JSON.stringify(authResponse),
        };
    } catch (error) {
        return {
            statusCode: 400,
            body: JSON.stringify({error: error.message}),
        };
    }
};
