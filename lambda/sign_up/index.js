/*
Lambda for user creation (sign-in) using Cognito, but receiving parameters
directly.
This is necessary since we don't have a dedicated frontend client.
 */
const AWS = require('aws-sdk');
const cognito = new AWS.CognitoIdentityServiceProvider();

exports.handler = async (event) => {
    const {email, cpf, password} = JSON.parse(event.body);

    // TODO: validar CPF!

    const params = {
        UserPoolId: process.env.USER_POOL_ID,
        Username: email,
        UserAttributes: [
            {Name: 'email', Value: email},
            {Name: 'custom:cpf', Value: cpf},
        ],
        MessageAction: 'SUPPRESS',
        TemporaryPassword: password,
    };

    try {
        const signUpResponse = await cognito.adminCreateUser(params).promise();
        return {
            statusCode: 200,
            body: JSON.stringify(signUpResponse),
        };
    } catch (error) {
        return {
            statusCode: 400,
            body: JSON.stringify({error: error.message}),
        };
    }
};
