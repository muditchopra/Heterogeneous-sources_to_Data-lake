--  Database: tyropower
-- ------------------------------------------------------

-- create table
DROP TABLE IF EXISTS `customer_details`;
CREATE TABLE `customer_details` (
  `CustomerID` bigint(20) NOT NULL,
  `Gender` varchar(255) DEFAULT NULL,
  `Age` int(11) DEFAULT NULL,
  `Married` varchar(255) DEFAULT NULL,
  `SeniorCitizen` varchar(255) DEFAULT NULL,
  `Mobile` int(11) DEFAULT NULL,
  `Email` varchar(255) DEFAULT NULL,
  `CurrAccountBalance` bigint(20) NOT NULL,
  `Home_Ownership` varchar(20) DEFAULT NULL,
  `Occupation` varchar(20) DEFAULT NULL,
  `AnnualIncome` float DEFAULT NULL,
  `Loan` varchar(20) DEFAULT NULL,
  `Insurance` varchar(1) DEFAULT NULL,
  PRIMARY KEY (`CustomerID`)
);

DROP TABLE IF EXISTS `credit_card`;
CREATE TABLE `credit_card` (
  `CardID` varchar(20) NOT NULL,
  `CardCustomerID` bigint(20) DEFAULT NULL,
  `CreditScore` int(11) DEFAULT NULL,
  `Annual_Income` float DEFAULT NULL,
  `YearofCreditHistory` float DEFAULT NULL,
  `CreditLimit` int DEFAULT NULL,
  `LastPendingAmt` float DEFAULT NULL, 
  `AnnualSpent` int(11) DEFAULT NULL
);

-- Insert into table

INSERT INTO customer_details (CustomerID, Gender, Age, Married, SeniorCitizen,
                             Mobile, Email, CurrAccountBalance, Home_Ownership, Occupation, AnnualIncome,Loan,Insurance) VALUES
(611301,'male',36,'married','N',9876543210,'abcxyz@gmail.com',38532,'Own Home','job',6,'N','N'),
(611302,'male',30,'single','N',9876543210,'abcxyz@gmail.com',156940,'Own Home','business',8,'N','N'),
(611303,'female',42,'divorced','N',9876543210,'abcxyz@gmail.com',281599,'Rent','job',16,'N','N'),
(611304,'female',29,'married','N',9876543210,'abcxyz@gmail.com',233206,'Own Home','business',10,'Y','Y'),
(611305,'male',28,'single','N',9876543210,'abcxyz@gmail.com',679573,'Rent','job',5,'N','N'),
(611306,'female',27,'single','N',9876543210,'abcxyz@gmail.com',128402,'Own Home','business',8,'N','N'),
(611307,'male',32,'married','N',9876543210,'abcxyz@gmail.com',167903,'Rent','job',9,'N','N'),
(611308,'female',34,'married','N',9876543210,'abcxyz@gmail.com',384522,'Own Home','business',10,'N','Y'),
(611309,'female',29,'married','N',9876543210,'abcxyz@gmail.com',431490,'Own Home','job',11,'Y','N'),
(611310,'male',31,'married','N',9876543210,'abcxyz@gmail.com',151088,'Own Home','business',7,'N','Y'),
(611311,'male',54,'married','N',9876543210,'abcxyz@gmail.com',212800,'Home Mortgage','job',6,'N','N'),
(611312,'male',63,'married','Y',9876543210,'abcxyz@gmail.com',65474,'Rent','job',8,'N','N'),
(611313,'female',24,'single','N',9876543210,'abcxyz@gmail.com',137332,'Own Home','student',0,'Y','N'),
(611314,'female',23,'single','N',9876543210,'abcxyz@gmail.com',281599,'Home Mortgage','student',0,'N','Y'),
(611315,'female',45,'married','N',9876543210,'abcxyz@gmail.com',729695,'Own Home','job',9,'N','N'),
(611316,'female',49,'married','N',9876543210,'abcxyz@gmail.com',164350,'Rent','business',7,'N','N'),
(611317,'male',64,'divorced','Y',9876543210,'abcxyz@gmail.com',347396,'Own Home','job',5,'Y','N'),
(611318,'female',64,'married','Y',9876543210,'abcxyz@gmail.com',330581,'Own Home','job',8,'N','N'),
(611319,'male',57,'married','N',9876543210,'abcxyz@gmail.com',121467,'Home Mortgage','business',11,'Y','N'),
(611320,'male',59,'divorced','N',9876543210,'abcxyz@gmail.com',125020,'Own Home','job',12,'N','Y'),
(611321,'female',25,'single','N',9876543210,'abcxyz@gmail.com',174344,'Rent','student',0,'N','N'),
(611322,'female',37,'single','N',9876543210,'abcxyz@gmail.com',85633,'Own Home','job',9,'Y','N'),
(611323,'male',29,'single','N',9876543210,'abcxyz@gmail.com',827051,'Rent','business',10,'N','N'),
(611324,'male',28,'single','N',9876543210,'abcxyz@gmail.com',684950,'Rent','business',7,'N','N'),
(611325,'male',46,'divorced','N',9876543210,'abcxyz@gmail.com',164008,'Home Mortgage','business',5,'N','Y'),
(611326,'female',28,'married','N',9876543210,'abcxyz@gmail.com',16511,'Home Mortgage','business',6,'N','N'),
(611327,'female',66,'married','Y',9876543210,'abcxyz@gmail.com',81358,'Own Home','job',15,'Y','N'),
(611328,'male',29,'single','N',9876543210,'abcxyz@gmail.com',130264,'Own Home','job',5,'N','Y'),
(611329,'female',31,'married','N',9876543210,'abcxyz@gmail.com',126179,'Own Home','business',5,'Y','N'),
(611330,'male',35,'married','N',9876543210,'abcxyz@gmail.com',165186,'Rent','business',6,'Y','N'),
(611331,'female',43,'single','N',9876543210,'abcxyz@gmail.com',110884,'Own Home','job',7,'N','Y'),
(611332,'male',48,'married','N',9876543210,'abcxyz@gmail.com',38532,'Own Home','business',7,'N','N')
;

INSERT INTO credit_card (CardID,CardCustomerID,CreditScore,Annual_Income,YearofCreditHistory,CreditLimit,LastPendingAmt,AnnualSpent)VALUES
('395a76dd',611303,815,17,5.8,125000,38532,425000),
('5ef6d424',611331,790,7.5,9,300000,101445,129045),
('6bdae209',611329,801,5,6.2,500000,245325,305235),
('67a35b69',611326,724,6,7.1,400000,122455,185445),
('cef6a8aa',611318,797,9,8.8,500000,128402,298578),
('4aec62aa',611322,744,9.5,4,100000,37800,85695),
('23bb03ea',611309,732,13,5,150000,25455,72389),
('55cedc7a',611301,733,8,3,80000,18965,56425),
('16f4e4a9',611310,683,7,2.2,50000,81358,125950),
('b171374b',611315,680,11,3.5,125000,1596,15905),
('401b284d',611325,696,8.5,4.9,150000,16511,32879),
('54459ce0',611308,703,11,3.6,100000,65474,145236),
('6866ead5',611306,803,8,12,600000,318953,388421)
;