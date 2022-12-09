import json
import urllib.parse
import boto3

print('Loading function')

s3 = boto3.client('s3')


def lambda_handler(event, context):
    #print("Received event: " + json.dumps(event, indent=2))

    # Get the object from the event and show its content type
    bucket = event['Records'][0]['s3']['bucket']['name']
    key = urllib.parse.unquote_plus(event['Records'][0]['s3']['object']['key'], encoding='utf-8')
    
    glue = boto3.client('glue')
    gluejobname = "tyropower-dataload-job"
    try:
        response = s3.get_object(Bucket=bucket, Key=key)
        print("key : "+key)
        print("CONTENT TYPE: " + response['ContentType'])
        
        runId = glue.start_job_run(JobName=gluejobname,Arguments ={'--key':key})
        status = glue.get_job_run(JobName=gluejobname, RunId=runId['JobRunId'])
        print("Job Status : ", status['JobRun']['JobRunState'])
    except Exception as e:
        print(e)
        print('Error getting object {} from bucket {}. Make sure they exist and your bucket is in the same region as this function.'.format(key, bucket))
        raise e
