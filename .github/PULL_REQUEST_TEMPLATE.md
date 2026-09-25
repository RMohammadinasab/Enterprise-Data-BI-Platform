## Summary

Describe the purpose of this pull request.

## Type of change

- [ ] Bug fix (script or documentation incorrect)
- [ ] New or changed SQL object
- [ ] Documentation
- [ ] Other (describe):

## Version folder

Which version folder does this change apply to? (for example `Version1/`)

## Related issue

Fixes #<!-- issue number -->

## Changes made

- 
- 

## Testing performed

- [ ] Rebuilt with this version’s `sql/00_build_all.sql` from the version folder (when warehouse, load, or semantic scripts changed)
- [ ] Ran `sql/validation/sample_kpi_queries.sql` against `EnterpriseData_DW` (when a rebuild or semantic change is in scope)
- [ ] Staging scripts applied separately if only `sql/staging/` changed (`00_build_all.sql` does not include staging)

## Checklist

- [ ] Change is limited to the intended version folder
- [ ] SQL scripts still match the database objects they represent
- [ ] Documentation under that version’s `docs/` updated so it stays consistent with the scripts
- [ ] No secrets, credentials, connection strings with secrets, database backups (`.bak`, `.mdf`, `.ldf`), or machine-specific files added
