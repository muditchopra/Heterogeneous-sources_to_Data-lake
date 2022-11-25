import boto3
import sys
from botocore.exceptions import ClientError
import glob
import os

def s3_client(region):
  s3 = boto3.client('s3', region_name=region)
  return s3

def encrypt_bucket(region, bucketname, s3_client):
  kms_client = boto3.client('kms', region_name=region)
  result = kms_client.describe_key(KeyId='alias/core/s3')
  s3_kms_arn= result['KeyMetadata']['Arn']
  response = s3_client.put_bucket_encryption(
    Bucket=bucketname,
    ServerSideEncryptionConfiguration={
      'Rules': [
        {
          'ApplyServerSideEncryptionByDefault': {
            'SSEAlgorithm': 'aws:kms',
            'KMSMasterKeyID': s3_kms_arn
          }
        }
      ]
    }
  )
  return

def uplode_s3_bucket(bucketname,region):
    s3 = s3_client(region)
    csv_files = glob.glob('data/*')
    folder_name = 'bronze/data'
    for filename in csv_files:
        key = '%s/%s'% (folder_name, os.path.basename(filename))
        print("Putting %s as %s" % (filename,key))
        s3.upload_file(filename, Bucket=bucketname, Key=key)
    return

def create_s3_bucket():
    bucketname = sys.argv[1]
    region = sys.argv[2]
    s3 = s3_client(region)
    try:
      bucket = s3.create_bucket(Bucket=bucketname, CreateBucketConfiguration={
          'LocationConstraint': region
      })
      encrypt_bucket(region,bucketname,s3)
      uplode_s3_bucket(bucketname,region)
    except ClientError as e:
      if e.response['Error']['Code'] == 'BucketAlreadyOwnedByYou':
        print('Bucket "{}" already exists'.format(bucketname))
      else:
        raise ClientError
    return


if __name__ == '__main__':
    create_s3_bucket()