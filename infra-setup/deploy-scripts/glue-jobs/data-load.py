import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame

args = getResolvedOptions(sys.argv, ["key"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
# job.init(args["JOB_NAME"], args)

sourceDyf = glueContext.create_dynamic_frame_from_options(
    connection_type="s3",
    format="csv",
    connection_options={
        "paths": [f"s3://{args['key']}"]
    },
    format_options={
        "withHeader": True,
        "separator": ","
    })

tablename = args['key'].split("/")[-1]

S3bucket_node3 = glueContext.getSink(
    path="s3://prod-tyropower-datalake-us-east-1/silver/flatfiles/csv/",
    connection_type="s3",
    updateBehavior="UPDATE_IN_DATABASE",
    partitionKeys=[],
    enableUpdateCatalog=True,
    transformation_ctx="S3bucket_node3",
)

S3bucket_node3.setCatalogInfo(
    catalogDatabase="tyropower-prod-Catalog-db", catalogTableName=f"${tablename}"
)
S3bucket_node3.setFormat("glueparquet")
S3bucket_node3.writeFrame(sourceDyf)

job.commit()