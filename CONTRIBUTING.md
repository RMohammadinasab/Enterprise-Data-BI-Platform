# Contributing to Enterprise Data & BI Platform

Thank you for your interest in contributing.

This repository is a Data Engineer / BI portfolio of **T-SQL scripts and Markdown documentation**. It is not an application: there is no build system, package manager, test suite, or CI pipeline to run. Changes are reviewed by comparing scripts and docs, then rebuilding locally against SQL Server.

## Getting started

1. Fork the repository and clone it locally.
2. Install a **SQL Server** instance you can reach with Windows authentication.
3. Restore the Microsoft **AdventureWorks2022** sample database on that instance. Warehouse load and rebuild scripts assume it already exists.
4. Open the version folder you intend to change (today that is `Version1/`). Each version folder is self-contained.

Connect with Windows authentication. Example (adjust the instance name if yours is not `.\SQL2022`):

```powershell
sqlcmd -S .\SQL2022 -E
```

Do not add passwords, tokens, or credentialed connection strings to any file.

## Repository layout

The root README is an index. **Each version lives in its own top-level folder** (for example `Version1/`). A version folder’s contents describe **that version only**. Do not mix objects or documentation from one version into another.

Typical contents of a version folder:

| Path | Contents |
| --- | --- |
| `docs/` | Architecture, data model, and business requirements for that version |
| `sql/staging/` | Staging database and `stg` table DDL |
| `sql/warehouse/` | Warehouse database, schemas, dimensions, facts, audit |
| `sql/semantic/` | Semantic-layer view definitions |
| `sql/validation/` | Read-only sample queries against semantic views |
| `sql/00_build_all.sql` | Orchestrates warehouse, load, and semantic objects via `:r` includes |
| `etl/` | Full-load script and load notes |
| `powerbi/` | Notes on using the semantic layer (no report file in this repository) |

## Development guidelines

- Keep changes focused and avoid unrelated refactors.
- Match existing T-SQL and Markdown conventions (object names, schemas `stg` / `dw` / `semantic` / `audit`, file naming).
- **SQL scripts map one-to-one to database objects.** Edit the script that defines the object you are changing (for example `sql/warehouse/facts/FactSales.sql` for `dw.FactSales`, or `sql/semantic/vw_ProductProfitability.sql` for `semantic.vw_ProductProfitability`). Keep the file name aligned with the object it creates.
- **Documentation under that version’s `docs/` must stay factually consistent with the scripts.** If you change a table, grain, key, view, or load step, update the matching notes in `docs/` (and the version README when the overview would otherwise be wrong).
- Do not commit secrets, connection strings with credentials, database backups, or machine-specific files (see below).

## Changing SQL objects

1. Identify the version folder (`Version1/` unless you are adding a new version).
2. Edit the matching script under that version’s `sql/` (or `etl/` for the load procedure).
3. If `sql/00_build_all.sql` should include a new warehouse, load, or semantic file, add a `:r` line using a path relative to the version folder, consistent with the existing includes.
4. Staging is **not** included in `00_build_all.sql`. Staging changes belong under `sql/staging/` and are applied separately (`00_create_staging_database.sql`, then the `stg_*.sql` scripts).
5. Update `docs/` so descriptions still match the scripts.

## How to verify locally

`sql/00_build_all.sql` rebuilds **EnterpriseData_DW**: warehouse DDL, `etl/04_etl_load.sql`, and the semantic views. It expects **AdventureWorks2022** on the instance. It does not create or load `EnterpriseData_Staging`.

`:r` include paths are relative to the **version folder**. Run from `Version1/` (not from `sql/` and not from the repository root):

```powershell
cd Version1
sqlcmd -S .\SQL2022 -E -i sql\00_build_all.sql
```

Use `-S` with your instance name if it is not `.\SQL2022`. `-E` is Windows authentication.

Then run the read-only sanity queries in `sql/validation/sample_kpi_queries.sql`. That script issues `USE EnterpriseData_DW` and `SELECT` statements against the six `semantic` views (sample product profitability, territory trend, actual vs target, churn-risk, inventory status, and operational-risk result sets). It does not modify data.

```powershell
sqlcmd -S .\SQL2022 -E -i sql\validation\sample_kpi_queries.sql
```

(Still from the `Version1/` folder, or pass an equivalent path to `-i`.) Confirm the batches complete and the result shapes match what you expect for your change.

If you changed staging only, apply the staging scripts under `sql/staging/` instead of relying on `00_build_all.sql`.

## Pull request checklist

- [ ] Change is scoped to the intended version folder
- [ ] SQL scripts still match the database objects they represent
- [ ] `docs/` (and the version README if needed) updated when objects or load behavior changed
- [ ] Rebuild via that version’s `sql/00_build_all.sql` from the version folder, when warehouse, load, or semantic scripts changed
- [ ] Read-only queries in `sql/validation/sample_kpi_queries.sql` still run after a warehouse rebuild
- [ ] No secrets, credentials, backups, or machine-specific files added

## Commit messages and pull requests

- Use a short subject that states **why** the change exists (for example, correcting a view definition or aligning docs with a script), not only which file was touched.
- Keep the pull request focused: one concern per PR when practical.
- Fill in `.github/PULL_REQUEST_TEMPLATE.md`. Link related issues when they exist.
- Describe what you ran locally (`00_build_all.sql` and/or the validation queries) rather than claiming a CI job that this repository does not provide.

## Files that must never be committed

- Passwords, tokens, API keys, or connection strings that contain secrets
- Database backups and data files: `.bak`, `.mdf`, `.ldf` (and similar)
- Machine-specific paths, local dumps, or editor/user settings (see `.gitignore`)

AdventureWorks2022 itself is not part of this repository; restore it on your instance from Microsoft’s sample.

## Reporting issues

Use the GitHub issue templates for bugs and feature requests. Include the version folder, the affected script or document, SQL Server version, expected vs actual object definition or query result, and reproduction steps.

## Questions

Start with [README.md](README.md) and [Version1/README.md](Version1/README.md) for the current version’s objects and rebuild steps.
