-- TYPE OF LOANS
SELECT DISTINCT loantype FROM "tyropower-prod-catalog-db"."customer_data"

-- TYPE OF INSURANCE
SELECT DISTINCT policytype FROM "tyropower-prod-catalog-db"."customer_data"

-- HOME LOAN
SELECT customerid,gender,mobile,email FROM "tyropower-prod-catalog-db"."customer_data"
        WHERE seniorcitizen='N' AND curraccountbalance>=120000 AND home_ownership='Rent' AND annualincome>=8 
        AND loantype!='home loan';

-- INCREASE CREDIT CARD LIMIT
SELECT customerid,mobile,email FROM "tyropower-prod-catalog-db"."customer_data"
        WHERE creditscore>=795 AND annualspent>=250000;

-- EDUCATION LOAN
SELECT customerid,mobile,email FROM "tyropower-prod-catalog-db"."customer_data"
        WHERE age IN (20,27) AND occupation='student' AND loantype!='education loan'

SELECT customerid,mobile,email FROM "tyropower-prod-catalog-db"."customer_data"
        WHERE age IN (45,60) 

-- BIKE LOAN
SELECT customerid,mobile,email FROM "tyropower-prod-catalog-db"."customer_data"
        WHERE home_ownership!='Rent' AND annualincome >= 7 AND curraccountbalance>= 75000 AND age IN (25,45)

-- CAR LOAN
SELECT customerid,mobile,email FROM "tyropower-prod-catalog-db"."customer_data"
        WHERE home_ownership!='Rent' AND annualincome>=12 AND curraccountbalance>=600000 AND age IN (25,55)

