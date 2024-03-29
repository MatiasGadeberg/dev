#!/bin/bash -e

# shellcheck disable=SC2016 # warning about backticks in --query's not expanding

AwsProfile="trainingAccount"
AwsRegion="eu-central-1"

BREAKER1='######################################################################'
BREAKER2='########################'
function startTimer {
   SECONDS=0
}

function timing {
   local TIMESTRING="$((SECONDS / 3600))h $(((SECONDS / 60) % 60))m $((SECONDS % 60))s"
   echo "$TIMESTRING"
}

function runStack {
   local NAME=$1
   shift;
   startTimer
   echo "$BREAKER1"
   echo "Creating $NAME"
   echo "$BREAKER2"

   "$@";

   ELAPSED=$(timing)
   echo "$NAME handled in $ELAPSED"
      echo "$BREAKER2"
   echo "End of $NAME"
   echo $BREAKER1
   echo
}

s3StaticWebStackName="s3-for-static-hosting"
BucketName="wildrydes-hmgd-dev"
runStack "unicorn-s3-static-web" aws cloudformation deploy \
    --stack-name "$s3StaticWebStackName" \
    --template-file "../Cloudformation/unicorn-s3-static-web.yml" \
    --parameter-overrides \
      BucketName="$BucketName" \
    --region "$AwsRegion" \
    --profile "$AwsProfile" \
    --capabilities CAPABILITY_IAM

websiteUrl=$(aws cloudformation describe-stacks --stack-name "$s3StaticWebStackName" --query 'Stacks[0].Outputs[?OutputKey==`WebsiteURL`].OutputValue' --output text --region "$AwsRegion" --profile "$AwsProfile")

UserPoolStackName="wildrydes-user-pool"

runStack "unicorn-user-pool" aws cloudformation deploy \
    --stack-name "$UserPoolStackName" \
    --template-file "../Cloudformation/cognito-user-auth.yml" \
    --parameter-overrides \
      BucketName="$BucketName" \
    --region "$AwsRegion" \
    --profile "$AwsProfile" \
    --capabilities CAPABILITY_IAM

BackendStackName="wildrydes-serverless-backend"

runStack "unicorn-serverless-backend" aws cloudformation deploy \
    --stack-name "$BackendStackName" \
    --template-file "../Cloudformation/serverless-backend.yml" \
    --region "$AwsRegion" \
    --profile "$AwsProfile" \
    --capabilities CAPABILITY_NAMED_IAM

ApiStackName="wildrydes-api"

runStack "unicorn-api" aws cloudformation deploy \
    --stack-name "$ApiStackName" \
    --template-file "../Cloudformation/API.yml" \
    --parameter-overrides \
      BucketStack="$s3StaticWebStackName" \
      CognitoStack="$UserPoolStackName" \
      BackendStack="$BackendStackName" \
    --region "$AwsRegion" \
    --profile "$AwsProfile" \
    --capabilities CAPABILITY_IAM

echo "Opening website: $websiteUrl" 
start chrome $websiteUrl


