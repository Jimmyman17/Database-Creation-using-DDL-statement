adashi_staging Database Setup - README

🏦 Adashi Staging Database – SQL Server

This repository provides the full SQL Server schema for the `adashi_staging` database. It includes tables, indexes, foreign key constraints, and stored procedures used to support key features such as plans, savings, users, and withdrawals.

---

🗂️ Database Overview

**Database Name**: `adashi_staging`
**Engine**: Microsoft SQL Server
**Purpose**: Staging environment for managing user financial activities including savings plans, transactions, and withdrawals.

---

📐 Database Initialization

```sql
IF DB_ID('adashi_staging') IS NULL
CREATE DATABASE adashi_staging;
```

---

📊 Table Structure

🔹 `plans_plan`
Stores user savings plan details.

- **Fields**: `id`, `name`, `amount`, `start_date`, `interest_rate`, `status_id`, `plan_type_id`, `owner_id`, etc.
- **Indexes**: `frequency_id`, `owner_id`, `status_id`, `plan_type_id`, `currency_id`
- **Foreign Keys**:
- `currency_id → plans_currency(id)`
- `portfolio_holdings_id → managed_portfolio_portfolioholdings(id)`
- `preset_id → plans_planpreset(id)`
- `usd_index_id → funds_usdindex(id)`

---

🔹 `plans_currency`
Reference table for supported currencies (e.g., NGN, USD).

---

🔹 `savings_savingsaccount`
Logs deposits and savings activities by users.

- **Fields**: `amount`, `created_on`, `owner_id`, `plan_id`, etc.
- **Indexes**: `plan_id`, `owner_id`, `charging_method_id`, `savings_type_id`, etc.

---

🔹 `users_customuser`
Contains user profile and authentication metadata.

- **Fields**: `email`, `first_name`, `last_name`, `gender_id`, `tier_id`, etc.
- **Indexes**: `gender_id`, `tier_id`
- **Foreign Key**: `tier_id → users_tier(id)`

---

🔹 `users_tier`
User tier classification (e.g., Basic, Premium).

---

🔹 `withdrawals_withdrawal`
Represents withdrawal requests initiated by users.

- **Fields**: `amount`, `is_processed`, `plan_id`, `owner_id`, etc.
- **Indexes**: `plan_id`, `owner_id`, `withdrawal_intent_id`, etc.
- **Foreign Key**: `withdrawal_intent_id → withdrawals_withdrawalintent(id)`

---

🔹 `withdrawals_withdrawalintent`
Defines reasons behind each withdrawal.

---

⚙️ Indexing Strategy

All major foreign keys and frequently queried columns are indexed to optimize SELECT and JOIN operations. Indexing focuses on:

- Relationship columns (`*_id`)
- Query filters (`is_deleted`, `is_archived`)
- Date fields (`created_on`, `next_charge_date`)

---

📜 Stored Procedures

`dbo.GetUserActivePlans`

Returns a list of active (non-deleted, non-archived) plans belonging to a specified user.

```sql
EXEC dbo.GetUserActivePlans @OwnerId = 'ABC123DEF4567890ABC123DEF4567890';
```

**Parameters**:
- `@OwnerId` – `CHAR(32)` – Unique identifier for the user

---

🚀 Prerequisites

- Microsoft SQL Server 2019 or newer
- SQL Server Management Studio (SSMS)
- Access to create databases, tables, procedures, and constraints

---

🛡️ Notes

- UUID-like fields use `CHAR(32)`
- `NO ACTION` constraints preserve referential integrity
- Ensure referenced tables (e.g., `managed_portfolio_portfolioholdings`, `funds_usdindex`) exist or are stubbed for staging purposes

---

🧑‍💼 Author

**Nwadim Chukwuma Nestor**
Electronic and Computer Engineer | Data Analyst
_Microsoft SQL Server • Data Modeling • ETL & Warehousing_

---
