# AGENTS.md

This file defines coding standards and conventions for this repository. All PRs will be reviewed against these guidelines.

---

## Naming Fields and Tables

- The primary key of a model should be named `<object>_id` (e.g., `account_id`). This makes it easier to know what `id` is being referenced in downstream joined models.
- Do not use abbreviations when naming fields. Emphasize readability over brevity (e.g., use `customer` not `cust`, `orders` not `o`).
- Avoid reserved words as column names.
- Boolean columns should be prefixed with `is_` or `has_`.
- Timestamp columns should be named `<event>_at` (e.g., `created_at`). If a non-default timezone is used, indicate it with a suffix (e.g., `created_at_pt`).
- Date columns should be named `<event>_date` (e.g., `created_date`).

---

## Styling SQL

- Table, CTE, and column names should be written in `snake_case`.
- When aliasing columns to snake_case, leave the original column reference as lowercase.
- Use trailing commas.
- Indents should be four (4) spaces.
- Field/column names should be lowercase.
- Keywords (`SELECT`, `FROM`, `AS`, `WHERE`, `QUALIFY`, etc.) should be UPPERCASE.
- The `AS` keyword must be used explicitly when aliasing a field or table.
- In the SELECT list, grouped fields should appear before aggregates and window functions.
- Aggregations should be executed as early as possible (on the smallest dataset) before joining to other tables.
- Prefer `GROUP BY ALL`. When ordering or grouping by position, use numbers (e.g., `GROUP BY 1, 2`) over listing column names explicitly.
- Prefer `UNION ALL` over `UNION` unless duplicate removal is explicitly required.
- When joining tables, always qualify column names with the table name or alias.
- Always be explicit about join type (e.g., write `INNER JOIN` instead of `JOIN`).
- Never use `RIGHT JOIN`. Avoid `FULL OUTER JOIN` unless absolutely necessary.
- Do not re-alias a column if the name is unchanged (e.g., do not write `source AS source`).
- Do not re-alias CTE names.
- Do not use short table aliases (e.g., `orders AS o`). Prefer full, explicit aliases or no alias at all (e.g., `FROM orders` is preferred over `FROM orders AS o`).

---

## dbt Model Specifics

- All references to dbt sources must use the `{{ source() }}` dbt function.
- All references to other dbt models, seeds, or snapshots must use the `{{ ref() }}` dbt function. Hard-coding table or view names is not allowed.
- `id` columns should be ordered first in staging models.
- The source CTE in a staging model should be named after the source model. For example, if the source is `{{ source('ticketmaster', 'evnt') }}`, the import CTE should be named `evnt_source`:
  ```sql
  WITH evnt_source AS (
      SELECT * FROM {{ source('ticketmaster', 'evnt') }}
  )
  ```
- Alias the following columns where present:
  - `adduser` → `created_by`
  - `adddatetime` → `created_at`
- Exclude the following columns from staging models:
  - `_rescued_data`
- The following columns must be aliased and placed as the **last selections** in a staging model:
  ```sql
  landingcreatedate AS landing_created_at,
  etlfilename AS etl_file_name,
  CURRENT_TIMESTAMP() AS etl_created_at,
  CURRENT_TIMESTAMP() AS etl_updated_at
  ```
- If the source loader is **Fivetran**, order and alias these columns last in the staging model:
  ```sql
  _fivetran_synced AS synced_at,
  _fivetran_start AS effective_date_started_at,
  _fivetran_end AS effective_date_ended_at,
  _fivetran_active AS is_active
  ```
- If the source loader is **Fivetran** and the `_fivetran_deleted` column is present:
  - Exclude `_fivetran_deleted` from the final SELECT (e.g., `SELECT * EXCEPT (_fivetran_deleted)`).
  - Apply `WHERE NOT _fivetran_deleted` as a filter in the final SELECT of the model.
- For incremental models, ensure `etl_created_at` is included in the `merge_exclude_columns` configuration.

---

## Styling Jinja

- Always use spaces on the inside of Jinja delimiters:
  - ✅ `{{ this }}`
  - ❌ `{{this}}`

---

## Styling YAML

- Indents should be two (2) spaces.
- List items should be indented.
- Use a new line to separate list items that are dictionaries where appropriate.
