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
   shift;
   startTimer
   echo "$BREAKER1"
   echo "Deleting $NAME"
   echo "$BREAKER2"

   "$@";

   ELAPSED=$(timing)
   echo "$NAME handled in $ELAPSED"
      echo "$BREAKER2"
   echo "End of $NAME"
   echo $BREAKER1
   echo
}

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