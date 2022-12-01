-- TYPE OF LOANS
SELECT DISTINCT loantype FROM "tyropower-prod-catalog-db"."loan_data"

-- TYPE OF INSURANCE
SELECT DISTINCT policytype FROM "tyropower-prod-catalog-db"."insurance_data"

-- HOME LOAN
SELECT customerid,gender,mobile,email FROM "tyropower-prod-catalog-db"."customer_data" c
        WHERE c.customerid IN (select cardcustomerid from "tyropower-prod-catalog-db"."loan_data" where loantype!='home loan')
        c.seniorcitizen='N' AND c.curraccountbalance>=120000 AND c.home_ownership='Rent' AND c.annualincome>=8 
        AND ;

select customerid,mobile,email from "tyropower-prod-catalog-db"."customer_data" c 
                where c.customerid IN (select cardcustomerid from "tyropower-prod-catalog-db"."creditcard" where creditscore>=795 and annualspent>=250000)
                and c.seniorcitizen='N' and c.curraccountbalance>=120000 and c.home_ownership='Rent' and c.annualincome>=8;

-- INCREASE CREDIT CARD LIMIT
select customerid,mobile,email from "tyropower-prod-catalog-db"."customer_data" c 
                where c.customerid IN (select cardcustomerid from "tyropower-prod-catalog-db"."creditcard" where creditscore>=795 and annualspent>=250000);

-- EDUCATION LOAN
SELECT customerid,mobile,email FROM "tyropower-prod-catalog-db"."customer_data" c
        WHERE c.customerid IN (select cardcustomerid from "tyropower-prod-catalog-db"."loan_data" where loantype!='education loan')
        AND age IN (20,27) AND occupation='student';

SELECT customerid,mobile,email FROM "tyropower-prod-catalog-db"."customer_data"
        WHERE age IN (45,60) 

-- BIKE LOAN
SELECT customerid,mobile,email FROM "tyropower-prod-catalog-db"."customer_data"
        WHERE home_ownership!='Rent' AND annualincome >= 7 AND curraccountbalance>= 75000 AND age IN (25,45)

-- CAR LOAN
SELECT customerid,mobile,email FROM "tyropower-prod-catalog-db"."customer_data"
        WHERE home_ownership!='Rent' AND annualincome>=12 AND curraccountbalance>=600000 AND age IN (25,55)

