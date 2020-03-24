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

s3StaticWebStackName="s3-for-static-hosting"
#Get bucket name from creation stack
bucketName=$(aws cloudformation describe-stacks --stack-name "$s3StaticWebStackName" --query 'Stacks[0].Outputs[?OutputKey==`BucketName`].OutputValue' --output text --region "$AwsRegion" --profile "$AwsProfile")

#Delete all files in bucket for deletion
aws s3 rm s3://$bucketName --recursive --region "$AwsRegion" --profile "$AwsProfile"

#Delete s3 bucket stack
deleteStack "s3-static-hosting" aws cloudformation delete-stack \
    --stack-name $s3StaticWebStackName \
    --region "$AwsRegion" \
    --profile "$AwsProfile"