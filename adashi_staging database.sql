-- Check if the database exists and create it if not
IF DB_ID('adashi_staging') IS NULL
BEGIN
    CREATE DATABASE adashi_staging;
END
GO

-- Switch to the new database
USE adashi_staging;
GO

-- The following MySQL-specific session settings are either not required
-- or handled differently in SQL Server, so they are omitted or noted:

-- CHARACTER SET & COLLATION equivalents in SQL Server:
-- To set collation in SQL Server:
-- You can do this during CREATE DATABASE like:
-- CREATE DATABASE adashi_staging COLLATE Latin1_General_100_CI_AI_SC_UTF8;
-- (This mimics utf8mb4_0900_ai_ci somewhat closely.)

-- SQL Server doesn't support:
-- - /*! versioned comments */
-- - `SET @VAR = @@...` session variable pattern from MySQL
-- - `SET TIME_ZONE` (handled differently with AT TIME ZONE)
-- - NO_AUTO_VALUE_ON_ZERO (not applicable in SQL Server)
-- - SQL_NOTES (not supported)

-- Foreign key and unique checks are always enforced or managed per constraint.

-- So the rest of the setup commands are skipped or managed differently in SQL Server.

IF OBJECT_ID('dbo.plans_plan', 'U') IS NOT NULL
    DROP TABLE dbo.plans_plan;
GO


-- Create plans_currency table (referenced by plans_plan.currency_id)
IF OBJECT_ID('dbo.plans_currency', 'U') IS NOT NULL
    DROP TABLE dbo.plans_currency;
GO

CREATE TABLE dbo.plans_currency (
    id INT PRIMARY KEY,
    currency_code VARCHAR(10) NOT NULL,
    currency_name VARCHAR(50) NOT NULL
);
GO


-- Create users_tier table (referenced by users_customuser.tier_id)
IF OBJECT_ID('dbo.users_tier', 'U') IS NOT NULL
    DROP TABLE dbo.users_tier;
GO

CREATE TABLE dbo.users_tier (
    id INT PRIMARY KEY,
    tier_name VARCHAR(50) NOT NULL
);
GO


-- Create withdrawals_withdrawalintent table (referenced by withdrawals_withdrawal.withdrawal_intent_id)
IF OBJECT_ID('dbo.withdrawals_withdrawalintent', 'U') IS NOT NULL
    DROP TABLE dbo.withdrawals_withdrawalintent;
GO

CREATE TABLE dbo.withdrawals_withdrawalintent (
    id INT IDENTITY(1,1) PRIMARY KEY,
    intent_description VARCHAR(255) NOT NULL
);
GO



IF OBJECT_ID('dbo.plans_plan', 'U') IS NOT NULL
    DROP TABLE dbo.plans_plan;
GO

CREATE TABLE dbo.plans_plan (
    id CHAR(32) NOT NULL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    description VARCHAR(255) NOT NULL,
    amount INT NOT NULL,
    start_date DATE NULL,
    last_charge_date DATE NULL,
    next_charge_date DATE NULL,
    created_on DATETIME NOT NULL,
    frequency_id INT NOT NULL,
    owner_id CHAR(32) NOT NULL,
    status_id INT NOT NULL,
    interest_rate FLOAT NOT NULL,
    withdrawal_date DATE NULL,
    default_plan BIT NOT NULL,
    plan_type_id INT NOT NULL,
    goal FLOAT NOT NULL,
    locked BIT NOT NULL,
    next_returns_date DATE NOT NULL,
    last_returns_date DATE NOT NULL,
    cowry_amount INT NOT NULL,
    debit_card CHAR(32) NULL,
    is_archived BIT NOT NULL,
    is_deleted BIT NOT NULL,
    is_goal_achieved BIT NOT NULL,
    is_a_goal BIT NOT NULL,
    is_interest_free BIT NOT NULL,
    plan_group_id CHAR(32) NULL,
    is_deleted_from_group BIT NOT NULL,
    is_a_fund BIT NOT NULL,
    purchased_fund_id CHAR(32) NULL,
    is_a_wallet BIT NOT NULL,
    currency_is_dollars BIT NOT NULL,
    is_auto_rollover BIT NOT NULL,
    is_vendor_plan BIT NOT NULL,
    plan_source VARCHAR(100) NOT NULL,
    is_donation_plan BIT NOT NULL,
    donation_description NVARCHAR(MAX) NOT NULL,
    donation_expiry_date DATE NULL,
    donation_link VARCHAR(255) NULL,
    link_code VARCHAR(255) NULL,
    charge_payment_fee BIT NOT NULL,
    donation_is_approved BIT NOT NULL,
    is_emergency_plan BIT NOT NULL,
    is_personal_challenge BIT NOT NULL,
    currency_id INT NOT NULL,
    is_a_usd_index BIT NOT NULL,
    usd_index_id CHAR(32) NULL,
    open_savings_plan BIT NOT NULL,
    new_cycle BIT NOT NULL,
    recurrence NVARCHAR(MAX) NULL,
    is_bloom_note BIT NOT NULL,
    is_managed_portfolio BIT NOT NULL,
    portfolio_holdings_id CHAR(32) NULL,
    is_fixed_investment BIT NOT NULL,
    is_regular_savings BIT NOT NULL,
    preset_id INT NULL
);

-- Indexes
CREATE NONCLUSTERED INDEX idx_frequency_id ON dbo.plans_plan(frequency_id);
CREATE NONCLUSTERED INDEX idx_owner_id ON dbo.plans_plan(owner_id);
CREATE NONCLUSTERED INDEX idx_status_id ON dbo.plans_plan(status_id);
CREATE NONCLUSTERED INDEX idx_plan_type_id ON dbo.plans_plan(plan_type_id);
CREATE NONCLUSTERED INDEX idx_plan_group_id ON dbo.plans_plan(plan_group_id);
CREATE NONCLUSTERED INDEX idx_purchased_fund_id ON dbo.plans_plan(purchased_fund_id);
CREATE NONCLUSTERED INDEX idx_usd_index_id ON dbo.plans_plan(usd_index_id);
CREATE NONCLUSTERED INDEX idx_currency_id ON dbo.plans_plan(currency_id);
CREATE NONCLUSTERED INDEX idx_portfolio_holdings_id ON dbo.plans_plan(portfolio_holdings_id);
CREATE NONCLUSTERED INDEX idx_preset_id ON dbo.plans_plan(preset_id);

-- Foreign keys
ALTER TABLE dbo.plans_plan
ADD CONSTRAINT FK_plans_plan_currency_id
    FOREIGN KEY (currency_id)
    REFERENCES dbo.plans_currency(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;

ALTER TABLE dbo.plans_plan
ADD CONSTRAINT FK_plans_plan_portfolio_holdings_id
    FOREIGN KEY (portfolio_holdings_id)
    REFERENCES dbo.managed_portfolio_portfolioholdings(id);

ALTER TABLE dbo.plans_plan
ADD CONSTRAINT FK_plans_plan_preset_id
    FOREIGN KEY (preset_id)
    REFERENCES dbo.plans_planpreset(id);

ALTER TABLE dbo.plans_plan
ADD CONSTRAINT FK_plans_plan_usd_index_id
    FOREIGN KEY (usd_index_id)
    REFERENCES dbo.funds_usdindex(id)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION;
	GO

IF OBJECT_ID('dbo.savings_savingsaccount', 'U') IS NOT NULL
    DROP TABLE dbo.savings_savingsaccount;
GO

CREATE TABLE dbo.savings_savingsaccount (
    id INT IDENTITY(1,1) PRIMARY KEY,
    savings_id CHAR(32) NULL,
    maturity_start_date DATETIME NOT NULL,
    maturity_end_date DATETIME NOT NULL,
    amount FLOAT NOT NULL,
    confirmed_amount FLOAT NOT NULL,
    deduction_amount FLOAT NOT NULL,
    new_balance FLOAT NOT NULL,
    transaction_date DATETIME NOT NULL,
    transaction_reference VARCHAR(200) NOT NULL,
    transaction_status VARCHAR(200) NOT NULL,
    verification_call_amount VARCHAR(200) NOT NULL,
    verification_call_message VARCHAR(100) NOT NULL,
    verification_call_code VARCHAR(50) NOT NULL,
    verification_transaction_date DATETIME NULL,
    book_returns FLOAT NOT NULL,
    available_returns FLOAT NOT NULL,
    returns_on_hold FLOAT NOT NULL,
    last_returns_date DATE NOT NULL,
    next_returns_date DATE NOT NULL,
    created_on DATETIME NOT NULL,
    card_billed_id CHAR(32) NULL,
    channel_id INT NOT NULL,
    charging_method_id INT NOT NULL,
    owner_id CHAR(32) NOT NULL,
    plan_id CHAR(32) NOT NULL,
    transaction_type_id INT NOT NULL,
    verification_status_id INT NOT NULL,
    gateway_response_message VARCHAR(100) NULL,
    fee_in_kobo FLOAT NOT NULL,
    donor_id CHAR(32) NULL,
    is_anonymous BIT NOT NULL,
    description VARCHAR(255) NOT NULL,
    payment_gateway VARCHAR(200) NULL,
    source_bank_account VARCHAR(100) NULL,
    currency VARCHAR(3) NULL,
    fee_in_cents FLOAT NOT NULL
);
GO

CREATE NONCLUSTERED INDEX IX_card_billed_id ON dbo.savings_savingsaccount(card_billed_id);
CREATE NONCLUSTERED INDEX IX_channel_id ON dbo.savings_savingsaccount(channel_id);
CREATE NONCLUSTERED INDEX IX_charging_method_id ON dbo.savings_savingsaccount(charging_method_id);
CREATE NONCLUSTERED INDEX IX_owner_id ON dbo.savings_savingsaccount(owner_id);
CREATE NONCLUSTERED INDEX IX_plan_id ON dbo.savings_savingsaccount(plan_id);
CREATE NONCLUSTERED INDEX IX_transaction_type_id ON dbo.savings_savingsaccount(transaction_type_id);
CREATE NONCLUSTERED INDEX IX_verification_status_id ON dbo.savings_savingsaccount(verification_status_id);
CREATE NONCLUSTERED INDEX IX_donor_id ON dbo.savings_savingsaccount(donor_id);
CREATE NONCLUSTERED INDEX IX_description ON dbo.savings_savingsaccount(description);
GO

IF OBJECT_ID('dbo.users_customuser', 'U') IS NOT NULL
    DROP TABLE dbo.users_customuser;
	GO

CREATE TABLE dbo.users_customuser (
    [id] CHAR(32) NOT NULL PRIMARY KEY,
    [password] VARCHAR(128) NOT NULL,
    [last_login] DATETIME NULL,
    [is_superuser] BIT NOT NULL,
    [email] VARCHAR(60) NOT NULL UNIQUE,
    [name] VARCHAR(100) NULL,
    [first_name] VARCHAR(100) NULL,
    [last_name] VARCHAR(100) NULL,
    [phone_number] VARCHAR(128) NULL,
    [date_of_birth] DATE NULL,
    [is_staff] BIT NOT NULL,
    [is_active] BIT NOT NULL,
    [date_joined] DATETIME NOT NULL,
    [is_admin] BIT NOT NULL,
    [username] VARCHAR(25) NULL,
    [created_on] DATETIME NOT NULL,
    [gender_id] INT NULL,
    [invite_code] VARCHAR(100) NULL,
    [avatar_firebase_reference] VARCHAR(255) NULL,
    [avatar_local_uri] VARCHAR(255) NULL,
    [avatar_url] VARCHAR(255) NULL,
    [risk_apetite] INT NOT NULL,
    [current_latitude] VARCHAR(100) NULL,
    [current_longitude] VARCHAR(100) NULL,
    [postal_address] VARCHAR(255) NULL,
    [pin] VARCHAR(128) NULL,
    [ambassador_profile_id] CHAR(32) NULL UNIQUE,
    [is_ambassador] BIT NOT NULL,
    [account_source] VARCHAR(100) NOT NULL,
    [is_vendor_account] BIT NOT NULL,
    [is_business_account] BIT NOT NULL,
    [is_account_deleted] BIT NOT NULL,
    [vendor_code] VARCHAR(100) NOT NULL,
    [is_halal_account] BIT NOT NULL,
    [address_city] VARCHAR(100) NULL,
    [address_country] VARCHAR(40) NULL,
    [address_state] VARCHAR(40) NULL,
    [address_street] VARCHAR(255) NULL,
    [monthly_expense] FLOAT NOT NULL,
    [monthly_salary] FLOAT NOT NULL,
    [is_account_disabled] BIT NOT NULL,
    [authy_id] VARCHAR(128) NULL,
    [fraud_score] INT NOT NULL,
    [account_campaign] VARCHAR(150) NULL,
    [account_medium] VARCHAR(100) NULL,
    [last_password_change] DATETIME2(6) NULL,
    [last_pin_change] DATETIME2(6) NULL,
    [is_private] BIT NOT NULL,
    [disabled_at] DATETIME2(6) NULL,
    [is_disabled_by_owner] BIT NOT NULL,
    [is_account_deleted_by_owner] BIT NOT NULL,
    [proposed_deletion_date] DATETIME2(6) NULL,
    [reason_for_deletion] VARCHAR(255) NULL,
    [enabled_at] DATETIME2(6) NULL,
    [signup_device] VARCHAR(100) NULL,
    [proposed_enablement_date] DATETIME2(6) NULL,
    [tier_id] INT NULL,
    
    CONSTRAINT FK_users_customuser_tier_id FOREIGN KEY (tier_id) 
        REFERENCES dbo.users_tier(id)
);
GO

-- Optional indexes
CREATE INDEX IX_users_customuser_gender_id ON dbo.users_customuser(gender_id);
CREATE INDEX IX_users_customuser_tier_id ON dbo.users_customuser(tier_id);
GO





-- Drop table if it exists
IF OBJECT_ID('dbo.withdrawals_withdrawal', 'U') IS NOT NULL
    DROP TABLE dbo.withdrawals_withdrawal;
GO

-- Create table
CREATE TABLE dbo.withdrawals_withdrawal (
    id INT IDENTITY(1,1) PRIMARY KEY,
    amount FLOAT NOT NULL,
    amount_withdrawn FLOAT NOT NULL,
    transaction_reference VARCHAR(50) NOT NULL,
    transaction_date DATETIME NOT NULL,
    new_balance FLOAT NOT NULL,
    bank_id INT NULL,
    owner_id CHAR(32) NOT NULL,
    plan_id CHAR(32) NOT NULL,
    transaction_channel_id INT NOT NULL,
    transaction_status_id INT NOT NULL,
    transaction_type_id INT NOT NULL,
    fee_in_kobo FLOAT NOT NULL,
    description VARCHAR(255) NOT NULL,
    gateway VARCHAR(255) NULL,
    gateway_response VARCHAR(255) NULL,
    session_id VARCHAR(50) NULL,
    currency VARCHAR(3) NOT NULL,
    fee_in_cents FLOAT NOT NULL,
    payment_id VARCHAR(50) NULL,
    created_on DATETIME2(6) NOT NULL,
    updated_on DATETIME2(6) NOT NULL,
    withdrawal_intent_id INT NULL
);
GO

-- Create foreign key constraint (assuming referenced table exists)
ALTER TABLE dbo.withdrawals_withdrawal
ADD CONSTRAINT FK_withdrawal_intent
FOREIGN KEY (withdrawal_intent_id) REFERENCES dbo.withdrawals_withdrawalintent(id);
GO

-- Create indexes
CREATE INDEX IX_withdrawal_bank_id ON dbo.withdrawals_withdrawal(bank_id);
CREATE INDEX IX_withdrawal_owner_id ON dbo.withdrawals_withdrawal(owner_id);
CREATE INDEX IX_withdrawal_plan_id ON dbo.withdrawals_withdrawal(plan_id);
CREATE INDEX IX_withdrawal_channel_id ON dbo.withdrawals_withdrawal(transaction_channel_id);
CREATE INDEX IX_withdrawal_status_id ON dbo.withdrawals_withdrawal(transaction_status_id);
CREATE INDEX IX_withdrawal_type_id ON dbo.withdrawals_withdrawal(transaction_type_id);
CREATE INDEX IX_withdrawal_intent_id ON dbo.withdrawals_withdrawal(withdrawal_intent_id);
GO
