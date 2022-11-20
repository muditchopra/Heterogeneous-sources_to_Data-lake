import boto3
import base64
import sys
from botocore.exceptions import ClientError

def ec2_client(region):
  ec2 = boto3.client('ec2', region_name=region)
  return ec2

def s3_client(region):
  s3 = boto3.client('s3', region_name=region)
  return s3

# Create keypair and store in s3 for ssh of ec2 instance
def create_key_pair():
  bucketname = sys.argv[1]
  region = sys.argv[2]
  ec2 = ec2_client(region)
  keyname = "tyropower-management-key"
  try:
    response = ec2.create_key_pair(
      KeyName=keyname
    )
    print("Created key:{}".format(keyname))
    upload_to_s3(response['KeyMaterial'],keyname, bucketname, region)
  except ClientError as e:
    if e.response['Error']['Code'] == 'InvalidKeyPair.Duplicate':
      print('Key pair "{}" exists'.format(keyname))
    else:
      raise ClientError
  return

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

def upload_to_s3( key_material, keyname, bucketname,region):
  s3 = s3_client(region)
  bucket = s3.create_bucket(Bucket=bucketname, CreateBucketConfiguration={
    'LocationConstraint': region
  })
  encrypt_bucket(region,bucketname,s3)
  s3.put_object(
    ACL='private',
    Body=base64.b64encode(key_material.encode("utf-8")),
    Bucket = bucketname,
    Key='keys/'+keyname
  )
  print("Uploaded key: '{}' to s3 bucket: {}".format(keyname, bucketname))
  return

if __name__ == '__main__':
  create_key_pair()