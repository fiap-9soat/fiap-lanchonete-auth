const AWS = require('aws-sdk');
const cognito = new AWS.CognitoIdentityServiceProvider();



exports.handler = async (event) => {
    const { refreshToken } = JSON.parse(event.body);

    if (!refreshToken) {
        return {
            statusCode: 400,
            body: JSON.stringify({ message: "Refresh token is required." }),
        };
    }

    const params = {
        UserPoolId: process.env.USER_POOL_ID,
        ClientId: process.env.CLIENT_ID,
        AuthFlow: "REFRESH_TOKEN_AUTH",
        AuthParameters: {
            REFRESH_TOKEN: refreshToken,
        },
    };

    try {
        const response = await cognito.adminInitiateAuth(params).promise();

        return {
            statusCode: 200,
            body: JSON.stringify({
                accessToken: response.AuthenticationResult.AccessToken,
                idToken: response.AuthenticationResult.IdToken,
                refreshToken: response.AuthenticationResult.RefreshToken || refreshToken, // Cognito only returns a new refresh token if it has changed
            }),
        };
    } catch (error) {
        console.error("Error refreshing tokens:", error);
        return {
            statusCode: 500,
            body: JSON.stringify({ message: "Failed to refresh tokens." }),
        };
    }
};
