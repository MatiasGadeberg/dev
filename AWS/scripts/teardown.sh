#!/bin/bash -e

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

function deleteStack {
   local NAME=$1
   local STACKNAME=$6
   shift;
   startTimer
   echo "$BREAKER1"
   echo "Deleting $NAME"
   echo "Stackname $STACKNAME"
   echo "$BREAKER2"

   "$@";
   
   aws cloudformation wait stack-delete-complete \
    --stack-name $STACKNAME \
    --region "$AwsRegion" \
    --profile "$AwsProfile" 

   ELAPSED=$(timing)
   echo "$NAME handled in $ELAPSED"
      echo "$BREAKER2"
   echo "End of $NAME"
   echo $BREAKER1
   echo
}

ApiStackName="API-creation"
#Delete backend stack
deleteStack "api" aws cloudformation delete-stack \
    --stack-name $ApiStackName \
    --region "$AwsRegion" \
    --profile "$AwsProfile" \
    
BackendStackName="wildrydes-serverless-backend"
#Delete backend stack
deleteStack "serverless-backend" aws cloudformation delete-stack \
    --stack-name $BackendStackName \
    --region "$AwsRegion" \
    --profile "$AwsProfile"

UserPoolStackName="wildrydes-user-pool"
#Delete Cognito stack
deleteStack "User-pool" aws cloudformation delete-stack \
    --stack-name $UserPoolStackName \
    --region "$AwsRegion" \
    --profile "$AwsProfile"

s3StaticWebStackName="s3-for-static-hosting"
#Delete s3 bucket stack
deleteStack "s3-static-hosting" aws cloudformation delete-stack \
    --stack-name $s3StaticWebStackName \
    --region "$AwsRegion" \
    --profile "$AwsProfile"