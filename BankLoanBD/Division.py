import pandas as pd

# Charger le fichier CSV original
df = pd.read_csv('financial_loan.csv')

# 1. dim_loan.csv
# Colonnes pour DimLoan : id, grade, sub_grade, purpose, term, application_type, loan_status, verification_status
dim_loan = df[['id', 'grade', 'sub_grade', 'purpose', 'term', 'application_type', 'loan_status', 'verification_status']].drop_duplicates()
dim_loan.to_csv('dim_loan.csv', index=False, header=['LoanID', 'Grade', 'SubGrade', 'Purpose', 'Term', 'ApplicationType', 'LoanStatus', 'VerificationStatus'])

# 2. dim_borrower.csv
# Colonnes pour DimBorrower : member_id, emp_length, emp_title, home_ownership
dim_borrower = df[['member_id', 'emp_length', 'emp_title', 'home_ownership']].drop_duplicates()
dim_borrower.to_csv('dim_borrower.csv', index=False, header=['MemberID', 'EmploymentLength', 'EmploymentTitle', 'HomeOwnership'])

# 3. dim_date.csv
# Colonnes pour DimDate : issue_date, last_payment_date, next_payment_date, last_credit_pull_date
dim_date = pd.concat([df['issue_date'], df['last_payment_date'], df['next_payment_date'], df['last_credit_pull_date']]).drop_duplicates().reset_index(drop=True)
dim_date_df = pd.DataFrame(dim_date, columns=['FullDate'])
dim_date_df.to_csv('dim_date.csv', index=False)

# 4. dim_location.csv
# Colonne pour DimLocation : address_state
dim_location = df[['address_state']].drop_duplicates()
dim_location.to_csv('dim_location.csv', index=False, header=['StateCode'])

# 5. staging_fact_loan.csv
# Colonnes pour Staging_FactLoan : id, member_id, issue_date, last_payment_date, next_payment_date, last_credit_pull_date,
# address_state, loan_amount, total_payment, installment, int_rate, dti, annual_income, total_acc
staging_fact_loan = df[[
    'id', 'member_id', 'issue_date', 'last_payment_date', 'next_payment_date', 'last_credit_pull_date',
    'address_state', 'loan_amount', 'total_payment', 'installment', 'int_rate', 'dti', 'annual_income', 'total_acc'
]]
staging_fact_loan.to_csv('staging_fact_loan.csv', index=False, header=[
    'LoanID', 'MemberID', 'IssueDate', 'LastPaymentDate', 'NextPaymentDate', 'LastCreditPullDate',
    'AddressState', 'LoanAmount', 'TotalPayment', 'Installment', 'InterestRate', 'DTI', 'AnnualIncome', 'TotalAcc'
])

print("Fichiers générés : dim_loan.csv, dim_borrower.csv, dim_date.csv, dim_location.csv, staging_fact_loan.csv")