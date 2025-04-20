-- Cr�er la base de donn�es
-- Cr�er la base de donn�es du Data Warehouse
CREATE DATABASE BankLoanDW;
GO

-- Utiliser la base de donn�es
USE BankLoanDW;
GO


-- Staging_Loan
CREATE TABLE Staging_Loan (
    LoanID VARCHAR(50),
    Grade VARCHAR(5),
    SubGrade VARCHAR(5),
    Purpose VARCHAR(50),
    Term VARCHAR(20),
    ApplicationType VARCHAR(20),
    LoanStatus VARCHAR(50),
    VerificationStatus VARCHAR(20)
);
EXEC sp_help 'Staging_Loan';
SELECT * FROM Staging_Loan;
TRUNCATE TABLE Staging_Loan;
-- Staging_Borrower
CREATE TABLE Staging_Borrower (
    MemberID VARCHAR(50),
    EmploymentLength VARCHAR(20),
    EmploymentTitle VARCHAR(100),
    HomeOwnership VARCHAR(20)
);
USE BankLoanDW;
EXEC sp_help 'Staging_FactLoan';
SELECT * FROM Staging_FactLoan;
TRUNCATE TABLE Staging_Borrower;
-- Staging_Date
CREATE TABLE Staging_Date (
    FullDate VARCHAR(20)
);
ALTER TABLE dbo.FactLoan
ALTER COLUMN Installment DECIMAL(18,4) NULL;

-- Staging_Location
CREATE TABLE Staging_Location (
    StateCode VARCHAR(5)
);

-- Staging_FactLoan
CREATE TABLE Staging_FactLoan (
    LoanID VARCHAR(50),
    MemberID VARCHAR(50),
    IssueDate VARCHAR(20),
    LastPaymentDate VARCHAR(20),
    NextPaymentDate VARCHAR(20),
    LastCreditPullDate VARCHAR(20),
    AddressState VARCHAR(5),
    LoanAmount DECIMAL(10,2),
    TotalPayment DECIMAL(10,2),
    Installment DECIMAL(10,2),
    InterestRate DECIMAL(5,4),
    DTI DECIMAL(6,4),
    AnnualIncome DECIMAL(10,2),
    TotalAcc INT
);

SELECT * FROM Staging_Borrower;

-- DimLoan
CREATE TABLE DimLoan (
    LoanID VARCHAR(50)  PRIMARY KEY,
    Grade CHAR(1),
    SubGrade CHAR(2),
    Purpose VARCHAR(50),
    Term VARCHAR(20),
    ApplicationType VARCHAR(20),
    LoanStatus VARCHAR(50),
    VerificationStatus VARCHAR(15)
);

-- DimBorrower
CREATE TABLE DimBorrower (
    MemberID VARCHAR(50) PRIMARY KEY,
    EmploymentLength VARCHAR(10),
    EmploymentTitle VARCHAR(100),
    HomeOwnership VARCHAR(10)
);
SELECT * FROM Staging_FactLoan;


ALTER TABLE dbo.Staging_FactLoan
DROP CONSTRAINT FK_Staging_FactLoan_DimDate;

CREATE TABLE DimDate (
    DateKey INT PRIMARY KEY,  -- Removed IDENTITY(1,1)
    FullDate DATE,
    Year INT,
    Quarter VARCHAR(2) COLLATE FRENCH_CI_AS,
    Month INT,
    MonthName VARCHAR(15) COLLATE FRENCH_CI_AS,
    Day INT,
    DayName VARCHAR(15) COLLATE FRENCH_CI_AS,
    WeekNumber INT,
    IsWeekend BIT
);

-- DimLocation
CREATE TABLE DimLocation (
    StateCode CHAR(2) PRIMARY KEY,
    StateName VARCHAR(50),
    Region VARCHAR(50)
);

SELECT * FROM DimLocation;

SELECT StateCode, COUNT(*)
FROM dbo.DimLocation
GROUP BY StateCode
HAVING COUNT(*) > 1;
DELETE FROM  dbo.DimLocation;
SELECT * FROM DimLocation;

CREATE TABLE StateReference (
    StateCode CHAR(2) PRIMARY KEY,
    StateName VARCHAR(50),
    Region VARCHAR(50)
);

INSERT INTO StateReference (StateCode, StateName, Region) VALUES
('GA', 'Georgia', 'Southeast'),
('CA', 'California', 'West'),
('TX', 'Texas', 'Southwest'),
('IL', 'Illinois', 'Midwest'),
('PA', 'Pennsylvania', 'Northeast'),
('FL', 'Florida', 'Southeast'),
('MI', 'Michigan', 'Midwest'),
('RI', 'Rhode Island', 'Northeast'),
('NY', 'New York', 'Northeast'),
('MD', 'Maryland', 'Northeast'),
('WI', 'Wisconsin', 'Midwest'),
('NV', 'Nevada', 'West'),
('UT', 'Utah', 'West'),
('WA', 'Washington', 'West'),
('NH', 'New Hampshire', 'Northeast'),
('HI', 'Hawaii', 'West'),
('MA', 'Massachusetts', 'Northeast'),
('OK', 'Oklahoma', 'Southwest'),
('NJ', 'New Jersey', 'Northeast'),
('OH', 'Ohio', 'Midwest'),
('AZ', 'Arizona', 'Southwest'),
('CT', 'Connecticut', 'Northeast'),
('MN', 'Minnesota', 'Midwest'),
('CO', 'Colorado', 'West'),
('TN', 'Tennessee', 'Southeast'),
('VA', 'Virginia', 'Southeast'),
('MO', 'Missouri', 'Midwest'),
('DE', 'Delaware', 'Northeast'),
('NM', 'New Mexico', 'Southwest'),
('LA', 'Louisiana', 'Southeast'),
('AR', 'Arkansas', 'Southeast'),
('KY', 'Kentucky', 'Southeast'),
('NC', 'North Carolina', 'Southeast'),
('SC', 'South Carolina', 'Southeast'),
('WV', 'West Virginia', 'Southeast'),
('KS', 'Kansas', 'Midwest'),
('WY', 'Wyoming', 'West'),
('OR', 'Oregon', 'West'),
('AL', 'Alabama', 'Southeast'),
('VT', 'Vermont', 'Northeast'),
('MS', 'Mississippi', 'Southeast'),
('DC', 'District of Columbia', 'Northeast'),
('MT', 'Montana', 'West'),
('SD', 'South Dakota', 'Midwest'),
('AK', 'Alaska', 'West'),
('IN', 'Indiana', 'Midwest'),
('ME', 'Maine', 'Northeast'),
('ID', 'Idaho', 'West'),
('NE', 'Nebraska', 'Midwest'),
('IA', 'Iowa', 'Midwest');

DROP TABLE DimLoan;
DROP TABLE DimBorrower;

-- FactLoan
CREATE TABLE FactLoan (
    LoanID INT PRIMARY KEY,
    DimLoanKey VARCHAR(50) ,
    DimBorrowerKey VARCHAR(50) ,
    DateIssueKey INT,
    DateLastPaymentKey INT,
    DateNextPaymentKey INT,
    DateCreditPullKey INT,
    LocationKey CHAR(2) ,
    LoanAmount DECIMAL(10,2),
    TotalPayment DECIMAL(10,2),
    Installment DECIMAL(10,2),
    InterestRate DECIMAL(5,4),
    DTI DECIMAL(6,4),
    AnnualIncome DECIMAL(10,2),
    TotalAcc INT,
    FOREIGN KEY (DimLoanKey) REFERENCES DimLoan(LoanID),
    FOREIGN KEY (DimBorrowerKey) REFERENCES DimBorrower(MemberID),
    FOREIGN KEY (DateIssueKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (DateLastPaymentKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (DateNextPaymentKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (DateCreditPullKey) REFERENCES DimDate(DateKey),
    FOREIGN KEY (LocationKey) REFERENCES DimLocation(StateCode)
);

SET LANGUAGE French;

SELECT * FROM FactLoan;
-- Create a table for month names
CREATE TABLE dbo.MonthNames (
    MonthNumber INT PRIMARY KEY,
    MonthName VARCHAR(15) COLLATE FRENCH_CI_AS
);

-- Create a table for day names
CREATE TABLE dbo.DayNames (
    DayNumber INT PRIMARY KEY,
    DayName VARCHAR(15) COLLATE FRENCH_CI_AS
);

-- Populate month names in French
SET LANGUAGE French;
INSERT INTO dbo.MonthNames (MonthNumber, MonthName)
SELECT MONTH(DATEADD(MONTH, n-1, '2025-01-01')), DATENAME(MONTH, DATEADD(MONTH, n-1, '2025-01-01'))
FROM (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS n FROM master..spt_values WHERE type = 'P' AND number < 12) AS numbers(n);

-- Populate day names in French (0 = Monday, 1 = Tuesday, ..., 6 = Sunday)
INSERT INTO dbo.DayNames (DayNumber, DayName)
SELECT n, DATENAME(WEEKDAY, DATEADD(DAY, n, '2025-04-07'))  -- Start from a known Monday (2025-04-07)
FROM (SELECT ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) - 1 AS n FROM master..spt_values WHERE type = 'P' AND number < 7) AS numbers(n);




ALTER TABLE dbo.Staging_FactLoan
ALTER COLUMN Installment VARCHAR(50) NULL;

ALTER TABLE dbo.Staging_FactLoan
ALTER COLUMN DTI VARCHAR(50) NULL;

ALTER TABLE dbo.Staging_FactLoan
ALTER COLUMN InterestRate VARCHAR(50) NULL;

ALTER TABLE dbo.Staging_FactLoan
ALTER COLUMN AnnualIncome VARCHAR(50) NULL;


-- Installment to DECIMAL(18,4)
ALTER TABLE dbo.Staging_FactLoan
ADD Installment_Temp DECIMAL(18,4) NULL;

UPDATE dbo.Staging_FactLoan
SET Installment_Temp = TRY_CONVERT(DECIMAL(18,4), Installment);

ALTER TABLE dbo.Staging_FactLoan
DROP COLUMN Installment;

EXEC sp_rename 'dbo.Staging_FactLoan.Installment_Temp', 'Installment', 'COLUMN';

-- DTI to DECIMAL(5,4)
ALTER TABLE dbo.Staging_FactLoan
ADD DTI_Temp DECIMAL(5,4) NULL;

UPDATE dbo.Staging_FactLoan
SET DTI_Temp = TRY_CONVERT(DECIMAL(5,4), DTI);

ALTER TABLE dbo.Staging_FactLoan
DROP COLUMN DTI;

EXEC sp_rename 'dbo.Staging_FactLoan.DTI_Temp', 'DTI', 'COLUMN';

-- InterestRate to DECIMAL(5,4)
ALTER TABLE dbo.Staging_FactLoan
ADD InterestRate_Temp DECIMAL(5,4) NULL;

UPDATE dbo.Staging_FactLoan
SET InterestRate_Temp = TRY_CONVERT(DECIMAL(5,4), InterestRate);

ALTER TABLE dbo.Staging_FactLoan
DROP COLUMN InterestRate;

EXEC sp_rename 'dbo.Staging_FactLoan.InterestRate_Temp', 'InterestRate', 'COLUMN';

-- AnnualIncome to DECIMAL(18,2)
ALTER TABLE dbo.Staging_FactLoan
ADD AnnualIncome_Temp DECIMAL(18,2) NULL;

UPDATE dbo.Staging_FactLoan
SET AnnualIncome_Temp = TRY_CONVERT(DECIMAL(18,2), AnnualIncome);

ALTER TABLE dbo.Staging_FactLoan
DROP COLUMN AnnualIncome;

EXEC sp_rename 'dbo.Staging_FactLoan.AnnualIncome_Temp', 'AnnualIncome', 'COLUMN';