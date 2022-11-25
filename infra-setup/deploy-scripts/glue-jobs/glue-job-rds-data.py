
import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job

glueContext = GlueContext(SparkContext.getOrCreate())

CustomerDetails = glueContext.create_dynamic_frame.from_catalog(
             database="tyropower-prod-Catalog-db",
             table_name="customer_details")

CreditCard = glueContext.create_dynamic_frame.from_catalog(
             database="tyropower-prod-Catalog-db",
             table_name="credit_card")

LoanDetails = glueContext.create_dynamic_frame.from_catalog(
             database="tyropower-prod-Catalog-db",
             table_name="loan_details")

Insurance = glueContext.create_dynamic_frame.from_catalog(
             database="tyropower-prod-Catalog-db",
             table_name="Insurance")

print("Drop cloumns from credit card and loan")
CreditCard = CreditCard.drop_fields(['Annual_Income'])
LoanDetails = LoanDetails.drop_fields(['Annual_Income','Credit_Score','HomeOwnership'])
CreditCard.printSchema()

print("Rename columns in loan table")
LoanDetails = LoanDetails.apply_mapping(
                                    [("Term","String","LoanTerm","String"),
                                     ("Type","String","LoanType","String")]
)
LoanDetails.printSchema()
print("convert string to int (Y&N)->(1&0)")
CustomerDetails['SeniorCitizen'] = CustomerDetails['SeniorCitizen'].map(f= lambda t: 1 if t=='Y' else 0)
CustomerDetails['Loan'] = CustomerDetails['Loan'].map(f= lambda t: 1 if t=='Y' else 0)
CustomerDetails['Insurance'] = CustomerDetails['Insurance'].map(f= lambda t: 1 if t=='Y' else 0)
CustomerDetails.printSchema()
print("joinning the dynamic data frames")
Customer_Data = Join.apply(Insurance,
                                    Join.apply(Loan,
                                    Join.apply(credit_card,customer_details,'CardCustomerID','CustomerID'),
                                'LoanCustomerID','CustomerID'),
                                'Customer_ID','CustomerID').drop_fields(['CardCustomerID','LoanCustomerID','Customer_ID'])

Customer_Data.printSchema()
print("write the data to s3")
glueContext.write_dynamic_frame.from_options(
       frame = Customer_Data,
       connection_type = "s3",
       connection_options = {"path": "s3://prod-tyropower-datalake-ap-south-1/silver/customer-details"},
       format = "parquet")