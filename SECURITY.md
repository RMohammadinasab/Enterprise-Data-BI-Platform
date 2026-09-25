# Security Policy

## About this repository

This is a **portfolio and documentation repository**. It contains T-SQL scripts and Markdown only. There is no deployed service, no application runtime, and no hosted API in this project.

## Supported versions

Security-relevant corrections apply to the **version folders present in the default branch** of this repository. Today that is `Version1/`. Older or removed version folders, if any appear later, are best-effort only.

| Scope | Supported |
| --- | --- |
| Current version folder(s) on the default branch | Yes |
| Historical / removed version folders | Best effort |

## Reporting a vulnerability

Please **do not** report security concerns through public GitHub issues.

Use **GitHub private vulnerability reporting** for this repository: open a **draft security advisory** (Repository **Security** tab → **Advisories**, or **Report a vulnerability** when that feature is enabled). Include:

- A description of the issue
- Steps to reproduce
- Potential impact
- Suggested remediation, if available

Do not attach database backups, credentials, or other secrets to public comments.

## Data handling

- All data used by these scripts comes from the public Microsoft **AdventureWorks2022** sample database. It is sample/fictional operational data, not production records of a real organization.
- This repository does not contain real personal data.
- Connections documented here use **Windows authentication** (`sqlcmd -S … -E`). There are no passwords, tokens, or credentialed connection strings stored in the repository.

## Secrets and local files

Never commit:

- Passwords, API keys, tokens, or connection strings that include credentials
- Database backups or SQL Server files (`.bak`, `.mdf`, `.ldf`, and similar)
- Local configuration that is specific to your machine

Keep those artifacts on your workstation only. `.gitignore` already excludes common backup and secrets patterns.
