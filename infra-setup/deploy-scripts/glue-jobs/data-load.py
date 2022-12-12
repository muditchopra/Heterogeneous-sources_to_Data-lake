
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

args = getResolvedOptions(sys.argv, ["JOB_NAME","key"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args["JOB_NAME"], args)

sourceDyf = glueContext.create_dynamic_frame.from_options(
    connection_type="s3",
    format="csv",
    connection_options={
        "paths": [f"s3://prod-tyropower-datalake-us-east-1/{args['key']}"]
        },
    format_options={
        "withHeader": True,
        "separator": ","
        }
)

tablename = args['key'].split("/")[-1].split(".")[0]

S3bucket_node3 = glueContext.getSink(
    path="s3://prod-tyropower-datalake-us-east-1/silver/flatfiles/",
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