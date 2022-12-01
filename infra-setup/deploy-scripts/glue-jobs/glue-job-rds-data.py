
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.dynamicframe import DynamicFrame

# args = getResolvedOptions(sys.argv, ["JOB_NAME"])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
# job.init(args["JOB_NAME"], args)

CustomerDetails = glueContext.create_dynamic_frame.from_catalog(
             database="tyropower-prod-Catalog-db",
             table_name="tyropower_customer_details")

CreditCard = glueContext.create_dynamic_frame.from_catalog(
             database="tyropower-prod-Catalog-db",
             table_name="tyropower_credit_card")

LoanDetails = glueContext.create_dynamic_frame.from_catalog(
             database="tyropower-prod-Catalog-db",
             table_name="loan_details_csv")

Insurance = glueContext.create_dynamic_frame.from_catalog(
             database="tyropower-prod-Catalog-db",
             table_name="insurance_csv")

print("Rename columns in loan table")
LoanDetails = LoanDetails.apply_mapping(
                                    [("term","String","loanterm","String"),
                                     ("type","String","loantype","String")]
)
LoanDetails.printSchema()

S3bucket_node3 = glueContext.getSink(
    path="s3://prod-tyropower-datalake-us-east-1/silver/customer-details/customer",
    connection_type="s3",
    updateBehavior="UPDATE_IN_DATABASE",
    partitionKeys=[],
    enableUpdateCatalog=True,
    transformation_ctx="S3bucket_node3",
)

S3bucket_node3.setCatalogInfo(
    catalogDatabase="tyropower-prod-Catalog-db", catalogTableName="customer_data"
)
S3bucket_node3.setFormat("glueparquet")
S3bucket_node3.writeFrame(CustomerDetails)

S3bucket_node3 = glueContext.getSink(
    path="s3://prod-tyropower-datalake-us-east-1/silver/customer-details/creditcard",
    connection_type="s3",
    updateBehavior="UPDATE_IN_DATABASE",
    partitionKeys=[],
    enableUpdateCatalog=True,
    transformation_ctx="S3bucket_node3",
)

S3bucket_node3.setCatalogInfo(
    catalogDatabase="tyropower-prod-Catalog-db", catalogTableName="creditcard"
)
S3bucket_node3.setFormat("glueparquet")
S3bucket_node3.writeFrame(CreditCard)

S3bucket_node3 = glueContext.getSink(
    path="s3://prod-tyropower-datalake-us-east-1/silver/customer-details/loan",
    connection_type="s3",
    updateBehavior="UPDATE_IN_DATABASE",
    partitionKeys=[],
    enableUpdateCatalog=True,
    transformation_ctx="S3bucket_node3",
)

S3bucket_node3.setCatalogInfo(
    catalogDatabase="tyropower-prod-Catalog-db", catalogTableName="loan_data"
)
S3bucket_node3.setFormat("glueparquet")
S3bucket_node3.writeFrame(LoanDetails)

S3bucket_node3 = glueContext.getSink(
    path="s3://prod-tyropower-datalake-us-east-1/silver/customer-details/insurance",
    connection_type="s3",
    updateBehavior="UPDATE_IN_DATABASE",
    partitionKeys=[],
    enableUpdateCatalog=True,
    transformation_ctx="S3bucket_node3",
)

S3bucket_node3.setCatalogInfo(
    catalogDatabase="tyropower-prod-Catalog-db", catalogTableName="insurance_data"
)
S3bucket_node3.setFormat("glueparquet")
S3bucket_node3.writeFrame(Insurance)




print("Drop cloumns from credit card and loan")
CreditCard = CreditCard.drop_fields(['annual_income'])
LoanDetails = LoanDetails.drop_fields(['annual_income','credit_score','homeownership'])
CreditCard.printSchema()

# print("convert string to int (Y&N)->(1&0)")
# CustomerDetails['SeniorCitizen'] = CustomerDetails['SeniorCitizen'].map(f= lambda t: 1 if t=='Y' else 0)
# CustomerDetails['Loan'] = CustomerDetails['Loan'].map(f= lambda t: 1 if t=='Y' else 0)
# CustomerDetails['Insurance'] = CustomerDetails['Insurance'].map(f= lambda t: 1 if t=='Y' else 0)
CustomerDetails.printSchema()
print("joinning the dynamic data frames")
Customer_Data = Join.apply(Insurance,
                                    Join.apply(LoanDetails,
                                    Join.apply(CreditCard,CustomerDetails,'cardcustomerid','customerid'),
                                'loancustomerid','customerid'),
                                'customer_id','customerid').drop_fields(['cardcustomerid','loancustomerid','customer_id'])

Customer_Data.printSchema()
print("write the data to s3")
# glueContext.write_dynamic_frame.from_options(
#        frame = Customer_Data,
#        connection_type = "s3",
#        connection_options = {"path": "s3://prod-tyropower-datalake-us-east-1/silver/customer-details/customer"},
#        format = "parquet")

# sink to s3 and glue catalog 
S3bucket_node3 = glueContext.getSink(
    path="s3://prod-tyropower-datalake-us-east-1/silver/customer-details",
    connection_type="s3",
    updateBehavior="UPDATE_IN_DATABASE",
    partitionKeys=[],
    enableUpdateCatalog=True,
    transformation_ctx="S3bucket_node3",
)

S3bucket_node3.setCatalogInfo(
    catalogDatabase="tyropower-prod-Catalog-db", catalogTableName="final_join_data"
)
S3bucket_node3.setFormat("glueparquet")
S3bucket_node3.writeFrame(Customer_Data)

job.commit()