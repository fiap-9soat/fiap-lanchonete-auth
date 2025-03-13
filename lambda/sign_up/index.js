/*
Lambda for user creation (sign-in) using Cognito, but receiving parameters
directly.
This is necessary since we don't have a dedicated frontend client.
 */
const AWS = require('aws-sdk');
const cognito = new AWS.CognitoIdentityServiceProvider();

function validaCPF(cpf) {
    let Soma;
    let Resto;
    Soma = 0;
    if (cpf === "00000000000") return false;

    if (cpf.length !== 11){
        return false;
    }

    for (let i=1; i<=9; i++) Soma = Soma + parseInt(cpf.substring(i-1, i)) * (11 - i);
    Resto = (Soma * 10) % 11;

    if ((Resto == 10) || (Resto == 11))  Resto = 0;
    if (Resto != parseInt(cpf.substring(9, 10)) ) return false;

    Soma = 0;
    for (i = 1; i <= 10; i++) Soma = Soma + parseInt(cpf.substring(i-1, i)) * (12 - i);
    Resto = (Soma * 10) % 11;

    if ((Resto == 10) || (Resto == 11))  Resto = 0;
    if (Resto != parseInt(cpf.substring(10, 11) ) ) return false;
    return true;
}

exports.handler = async (event) => {
    const {email, cpf, password} = JSON.parse(event.body);

    if (!validaCPF(cpf)){
        throw new Error("CPF inválido. CPF deve ser somente números!")
    }

    const userCreateParams = {
        UserPoolId: process.env.USER_POOL_ID,
        Username: email,
        UserAttributes: [
            {Name: 'email', Value: email},
            {Name: 'custom:cpf', Value: cpf},
        ],
        MessageAction: 'SUPPRESS',
        TemporaryPassword: password,
    };

    const setPasswordParams = {
        Password: password,
        UserPoolId: process.env.USER_POOL_ID,
        Username: email,
        Permanent: true, // Set password as permanent
    };

    try {
        const signUpResponse = await cognito.adminCreateUser(userCreateParams).promise();

        // Set the password as permanent to avoid password reset
        await cognito.adminSetUserPassword(setPasswordParams).promise();

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
