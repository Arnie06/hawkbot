# SQL Styling Rules Summary

**Version:** 1.0  
**Last Updated:** May 5, 2026  
**Total Rules:** 39

---

## Table of Contents
- [Naming Conventions](#naming-conventions)
- [Casing Conventions](#casing-conventions)
- [Formatting](#formatting)
- [Query Structure](#query-structure)
- [dbt Specifics](#dbt-specifics)
- [Jinja Styling](#jinja-styling)
- [YAML Styling](#yaml-styling)
- [Severity Levels](#severity-levels)

---

## Naming Conventions

Rules for naming database objects and fields.

### NC001: Primary Key Naming Pattern ⛔ ERROR
**Rule:** The primary key of a model should be named `<object>_id`  
**Example:** `account_id`  
**Rationale:** Makes it easier to know what id is being referenced in downstream joined models

### NC002: No Abbreviations in Field Names ⛔ ERROR
**Rule:** Do not use abbreviations when naming fields. Emphasize readability over brevity  
**Example:** Use `customer` not `cust`, `orders` not `o`  
**Rationale:** Improves code readability and maintainability

### NC003: Avoid Reserved Words ⚠️ WARNING
**Rule:** Avoid reserved words as column names  
**Rationale:** Prevents syntax errors and confusion

### NC004: Boolean Field Prefix ⛔ ERROR
**Rule:** Booleans should be prefixed with `is_` or `has_`  
**Example:** `is_active`, `has_permission`  
**Rationale:** Makes boolean fields immediately identifiable

### NC005: Timestamp Naming Pattern ⛔ ERROR
**Rule:** Timestamp columns should be named `<event>_at`  
**Example:** `created_at`, `updated_at`, `created_at_pt` (with timezone suffix)  
**Rationale:** Consistent timestamp naming across the codebase

### NC006: Date Naming Pattern ⛔ ERROR
**Rule:** Dates should be named `<event>_date`  
**Example:** `created_date`, `modified_date`  
**Rationale:** Distinguishes dates from timestamps

---

## Casing Conventions

Rules for letter casing in SQL code.

### CC001: Snake Case for Identifiers ⛔ ERROR
**Rule:** Table, CTE, and column names should be written in `snake_case`  
**Example:** `customer_orders`, `total_amount`  
**Rationale:** Ensures consistency in identifier naming

### CC002: Lowercase Original Columns When Aliasing ⛔ ERROR
**Rule:** When aliasing columns to snakecase, leave the original column as lowercase  
**Rationale:** Maintains consistency in column references

### CC003: Lowercase Field Names ⛔ ERROR
**Rule:** Field/column names should be lowercase  
**Rationale:** Consistent with snake_case convention

### CC004: Uppercase SQL Keywords ⛔ ERROR
**Rule:** Keywords like SELECT, FROM, AS, WHERE, QUALIFY should be uppercase  
**Example:** `SELECT`, `FROM`, `WHERE`, `INNER JOIN`  
**Rationale:** Distinguishes SQL keywords from identifiers for readability

---

## Formatting

Rules for code formatting and structure.

### FMT001: Use Trailing Commas ⛔ ERROR
**Rule:** Commas should appear after each item, not before  
**Rationale:** Easier to add/remove lines and clearer git diffs

### FMT002: Four-Space Indentation ⛔ ERROR
**Rule:** Indents should be four spaces  
**Rationale:** Consistent code structure and readability

### FMT003: Explicit AS Keyword ⛔ ERROR
**Rule:** The AS keyword should be used explicitly when aliasing a field or table  
**Example:** `SELECT column AS alias FROM table AS t`  
**Rationale:** Makes aliasing explicit and improves readability

### FMT004: Grouped Fields Before Aggregates ⚠️ WARNING
**Rule:** Grouped fields should be stated before aggregates and window functions in the select list  
**Rationale:** Logical ordering that matches GROUP BY clause

---

## Query Structure

Rules for SQL query structure and optimization.

### QS001: Early Aggregation ⚠️ WARNING
**Rule:** Aggregations should be executed as early as possible (on the smallest data set possible) before joining to another table  
**Rationale:** Improves query performance by reducing data volume

### QS002: GROUP BY ALL Preferred ⚠️ WARNING
**Rule:** Utilizing GROUP BY ALL is preferred. Ordering and grouping by a number (e.g. group by 1, 2) is preferred over listing the column names explicitly  
**Rationale:** Reduces maintenance burden and improves readability

### QS003: Prefer UNION ALL ⚠️ WARNING
**Rule:** Prefer UNION ALL to UNION unless you explicitly want to remove duplicates  
**Rationale:** Better performance as it skips deduplication

### QS004: Qualify Column Names in Joins ⛔ ERROR
**Rule:** When joining tables, always qualify column names with the table name or alias  
**Example:** `t1.column_name`, `t2.column_name`  
**Rationale:** Prevents ambiguity and improves readability

### QS005: Explicit Join Types ⛔ ERROR
**Rule:** Be explicit about your join type (i.e. write INNER JOIN instead of JOIN)  
**Rationale:** Makes join intention clear

### QS006: No Right Joins ⛔ ERROR
**Rule:** Do not use right joins ever. Do not use full outer joins unless absolutely necessary  
**Rationale:** Right joins are confusing; left joins are more intuitive

### QS007: No Redundant Column Aliasing ⚠️ WARNING
**Rule:** Do not re-alias a column if the name is unchanged  
**Example:** Avoid: `source AS source`  
**Rationale:** Reduces unnecessary code verbosity

### QS008: No CTE Re-aliasing ⚠️ WARNING
**Rule:** Do not re-alias CTE names  
**Rationale:** Maintains clarity and reduces redundancy

### QS009: No Short Table Aliases ⛔ ERROR
**Rule:** Do not use short table aliases like `select * from orders as o` -- always prefer longer, explicit table aliases or no aliases at all  
**Example:** Good: `select * from orders` or `select * from orders AS customer_orders`  
**Rationale:** Improves code readability and clarity

---

## dbt Specifics

Rules specific to dbt models and conventions.

### DBT001: Use source() Function for Sources ⛔ ERROR
**Rule:** All references to dbt sources should use the `{{ source() }}` dbt function  
**Example:** `{{ source('ticketmaster', 'evnt') }}`  
**Rationale:** Enables dbt lineage tracking and validation

### DBT002: Use ref() Function for Models ⛔ ERROR
**Rule:** All references to other dbt models, seed, or snapshots should use the `{{ ref() }}` dbt function. Hard coding table or view names is not allowed  
**Example:** `{{ ref('stg_customers') }}`  
**Rationale:** Enables dbt dependency resolution and lineage

### DBT003: ID Columns First in Staging ⚠️ WARNING
**Rule:** id columns should be ordered first in staging models  
**Rationale:** Consistent column ordering for primary keys

### DBT004: Source CTE Naming ⛔ ERROR
**Rule:** The source CTE in a staging model should be named after the source model  
**Example:** If source is `{{ source('ticketmaster', 'evnt') }}`, CTE should be `WITH evnt_source AS`  
**Rationale:** Clear indication of CTE source

### DBT005: Standard Column Aliasing ⛔ ERROR
**Rule:** Alias these columns where appropriate:
- `adduser` as `created_by`
- `adddatetime` as `created_at`

**Rationale:** Standardizes common column names across models

### DBT006: Exclude Rescued Data ⛔ ERROR
**Rule:** Don't include these columns in stg models: `_rescued_data`  
**Rationale:** Removes unnecessary metadata columns

### DBT007: ETL Metadata Columns Last ⛔ ERROR
**Rule:** Alias and order these columns as the last selections in a staging model:
- `landingcreatedate` AS `landing_created_at`
- `etlfilename` AS `etl_file_name`
- `CURRENT_TIMESTAMP()` AS `etl_created_at`
- `CURRENT_TIMESTAMP()` AS `etl_updated_at`

**Rationale:** Consistent metadata column positioning

### DBT008: Fivetran Columns Ordering ⛔ ERROR
**Rule:** If the loader of a source is Fivetran, order and alias these columns last:
- `_fivetran_synced` AS `synced_at`
- `_fivetran_start` AS `effective_date_started_at`
- `_fivetran_end` AS `effective_date_ended_at`
- `_fivetran_active` AS `is_active`

**Rationale:** Standardizes Fivetran metadata handling

### DBT009: Fivetran Deleted Column Handling ⛔ ERROR
**Rule:** If the loader is Fivetran and `_fivetran_deleted` column is present:
- Ensure `_fivetran_deleted` is not in the final select (e.g. `SELECT * EXCEPT (_fivetran_deleted)`)
- `WHERE NOT _fivetran_deleted` is a filter for the final select

**Rationale:** Excludes soft-deleted records from staging models

### DBT010: Incremental Model Configuration ⛔ ERROR
**Rule:** If the dbt model is an incremental model, ensure that `etl_created_at` is included in the `merge_exclude_columns` configuration  
**Rationale:** Prevents overwriting creation timestamp on updates

---

## Jinja Styling

Rules for Jinja template formatting.

### JNJ001: Spaces Inside Jinja Delimiters ⛔ ERROR
**Rule:** When using Jinja delimiters, use spaces on the inside of your delimiter  
**Example:** Good: `{{ this }}`, Bad: `{{this}}`  
**Rationale:** Improves readability of Jinja expressions

---

## YAML Styling

Rules for YAML file formatting.

### YML001: Two-Space Indentation ⛔ ERROR
**Rule:** Indents should be two spaces  
**Rationale:** YAML standard formatting convention

### YML002: Indent List Items ⛔ ERROR
**Rule:** List items should be indented  
**Rationale:** Proper YAML structure

### YML003: Separate Dictionary List Items ⚠️ WARNING
**Rule:** Use a new line to separate list items that are dictionaries where appropriate  
**Rationale:** Improves readability of complex YAML structures

---

## Severity Levels

### ⛔ ERROR
**Must be fixed before merge**  
These rules are critical for code quality, consistency, and maintainability. Pull requests violating ERROR-level rules should be blocked until resolved.

### ⚠️ WARNING
**Should be fixed but may be merged with justification**  
These rules improve code quality and performance but may be bypassed with proper justification and team review.

---

## Rule Categories Summary

| Category | Rule Count | Description |
|----------|-----------|-------------|
| **Naming Conventions** | 6 | Rules for naming database objects and fields |
| **Casing Conventions** | 4 | Rules for letter casing in SQL code |
| **Formatting** | 4 | Rules for code formatting and structure |
| **Query Structure** | 9 | Rules for SQL query structure and optimization |
| **dbt Specifics** | 10 | Rules specific to dbt models and conventions |
| **Jinja Styling** | 1 | Rules for Jinja template formatting |
| **YAML Styling** | 3 | Rules for YAML file formatting |
| **TOTAL** | **39** | |

---

## Implementation Notes for PR Review System

### Automated Checks
The following rules can be automatically validated by a linting system:
- All casing conventions (CC001-CC004)
- Formatting rules (FMT001-FMT003)
- Keyword usage (CC004, FMT003, QS005)
- dbt function usage (DBT001, DBT002)
- Jinja delimiter spacing (JNJ001)
- YAML indentation (YML001, YML002)

### Pattern-Based Detection
These rules can be detected using regex or AST parsing:
- Naming patterns (NC001, NC004, NC005, NC006)
- Abbreviation detection (NC002) - requires dictionary
- Reserved word usage (NC003) - requires keyword list
- Join qualification (QS004)
- Table alias length (QS009)

### Context-Aware Validation
These rules require understanding the query context:
- Field ordering (FMT004, DBT003, DBT007, DBT008)
- Aggregation placement (QS001)
- GROUP BY preferences (QS002)
- Staging model column rules (DBT005-DBT010)

### Manual Review Required
Some rules require human judgment:
- Abbreviation appropriateness (NC002)
- Full outer join necessity (QS006)
- Dictionary list separation (YML003)

---

*This document was automatically generated from the SQL styling guide for use in automated code review systems.*
