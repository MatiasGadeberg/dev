const AWS = require('aws-sdk');

const DMSSecretId = "arn:aws:secretsmanager:eu-central-1:967597038905:secret:dev-dms-database-dms-pg-db-dSYru1"

function getCredentials(SecretId,timeout=9000){
    // Connectiong to scret manager and getting secrets
    const secretsmanager = new AWS.SecretsManager({httpOptions:{timeout:timeout,maxRetries:1}});
    var smParams = {
        SecretId: SecretId,
        VersionStage: "AWSCURRENT"
    };
    resp = secretsmanager.getSecretValue(smParams).promise();
    return(resp)
}

exports.handler = async function(event, context) {
    console.log("REQUEST RECEIVED:\n" + JSON.stringify(event));
    if (event.RequestType == 'Create'){
        // Initializing parameters
        
        data = await getCredentials(DMSSecretId,timeout=9000)
        console.log('data')
        response.send(event, context, response.SUCCESS, {});

    } else if (event.RequestType == 'Delete') {
        // Forcefully droping all connections
        var sql = "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname ="+"'"+process.env.PostgresDatabase+"'"+";";
        await resolveQuery(sql,'template1');
        // Dropping database
        var sql = 'DROP DATABASE ' + process.env.PostgresDatabase +';';
        await resolveQuery(sql,'template1');
        response.send(event, context, response.SUCCESS, {});

    } else if (event.RequestType == 'Update') {
        // Dose nothing in the case
        response.send(event, context, response.SUCCESS, {});
    } else {
        // Throwing error over none defined event
        response.send(event, context, response.FAILED, {});
    }; 

}

event = {
    "RequestType": "Create",
    "ServiceToken": "arn:aws:lambda:eu-central-1:967597038905:function:autoDB1d9-db-postcreation-lambd-PostCreationLambda-WFYX0TLVJUZK",
    "ResponseURL": "https://cloudformation-custom-resource-response-eucentral1.s3.eu-central-1.amazonaws.com/arn%3Aaws%3Acloudformation%3Aeu-central-1%3A967597038905%3Astack/autoDB1d9-db-postcreation-lambda/4ccf0120-9ff5-11ea-8547-06a619e5de86%7CDBupdate%7Ce1b907be-5235-4a2d-b48b-df5f0cc61bef?X-Amz-Algorithm=AWS4-HMAC-SHA256&X-Amz-Date=20200527T083921Z&X-Amz-SignedHeaders=host&X-Amz-Expires=7200&X-Amz-Credential=AKIAYYGVRKE7IDTA6BEO%2F20200527%2Feu-central-1%2Fs3%2Faws4_request&X-Amz-Signature=aa6798353e86e527b990800126ae711deca314f3256d84fc87576419ac7808a9",
    "StackId": "arn:aws:cloudformation:eu-central-1:967597038905:stack/autoDB1d9-db-postcreation-lambda/4ccf0120-9ff5-11ea-8547-06a619e5de86",
    "RequestId": "e1b907be-5235-4a2d-b48b-df5f0cc61bef",
    "LogicalResourceId": "DBupdate",
    "ResourceType": "Custom::Lambda",
    "ResourceProperties": {
        "ServiceToken": "arn:aws:lambda:eu-central-1:967597038905:function:autoDB1d9-db-postcreation-lambd-PostCreationLambda-WFYX0TLVJUZK"
    }
}

exports.handler(event, {});