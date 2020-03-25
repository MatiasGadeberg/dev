import boto3

session = boto3.Session(profile_name='trainingAccount')

client = session.client('s3')
s3 = session.resource('s3')
source_bucket = 'hmgd-test-bucket'
source_prefix = 'testfolder/'
bucket = 'hmgd-wildrydes-data'

paginator = client.get_paginator('list_objects_v2')
page_iterator = paginator.paginate(Bucket=source_bucket,Prefix=source_prefix)

for key in {x['Key'] for page in page_iterator for x in page['Contents']}:
    if not key.endswith('/'):
        s3.meta.client.copy({'Bucket':source_bucket, 'Key':key}, bucket, key)
# page_iterator = paginator.paginate(Bucket=source_bucket, Prefix=source_prefix)
#s3.meta.client.copy(copy_source, 'hmgd-wildrydes-data', 'test/')