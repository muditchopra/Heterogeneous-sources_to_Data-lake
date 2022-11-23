
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

CreditCard = CreditCard.drop_fields(['Annual_Income'])
LoanDetails = LoanDetails.drop_fields(['Annual_Income','Credit_Score','HomeOwnership'])





CustomerDetails['SeniorCitizen'] = CustomerDetails['SeniorCitizen'].map(f= lambda t: 1 if t=='Y' else 0)
CustomerDetails['Loan'] = CustomerDetails['Loan'].map(f= lambda t: 1 if t=='Y' else 0)
CustomerDetails['Insurance'] = CustomerDetails['Insurance'].map(f= lambda t: 1 if t=='Y' else 0)

Customer_Data = Join.apply(Insurance,
                                    Join.apply(Loan,
                                    Join.apply(credit_card,customer_details,'CardCustomerID','CustomerID'),
                                'LoanCustomerID','CustomerID'),
                                'Customer_ID','CustomerID').drop_fields(['CardCustomerID','LoanCustomerID','Customer_ID'])

s_history = Customer_Data.toDF().repartition(1)
s_history.write.parquet('s3://prod-tyropower-datalake-ap-south-1/silver/data')