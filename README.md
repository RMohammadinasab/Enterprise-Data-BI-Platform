# Enterprise Data & BI Platform

SQL Server data warehouse and BI platform for a fictional multi-region manufacturer/distributor. **AdventureWorks2022** is the operational source dataset for this portfolio implementation.

The repository is organized by version. Each version folder is self-contained: it holds its own documentation, SQL objects, and load scripts, so the state of the project at that version can be read and rebuilt on its own.

## Versions

| Version | Folder | Content |
|---------|--------|---------|
| Version 1 | [`Version1/`](Version1/) | Staging copies of eight selected source tables, a star-schema warehouse (7 dimensions, 4 facts), an audit load table, 6 semantic BI views, and the T-SQL full load that populated the warehouse. |

## Where to start

Open [`Version1/README.md`](Version1/README.md) for the full description of that version, then:

| To read about | Go to |
|---------------|-------|
| Business scenario and the questions the version answers | [`Version1/docs/business-requirements.md`](Version1/docs/business-requirements.md) |
| Layers and data flow | [`Version1/docs/architecture.md`](Version1/docs/architecture.md) |
| Tables, grains, keys, and view logic | [`Version1/docs/data-model.md`](Version1/docs/data-model.md) |
| Staging, warehouse, semantic, and validation SQL | [`Version1/sql/`](Version1/sql/) |
| Load implementation | [`Version1/etl/`](Version1/etl/) |
| BI / reporting notes | [`Version1/powerbi/`](Version1/powerbi/) |

## Repository structure

```text
Enterprise-Data-BI-Platform/
├── README.md              ← this file: project overview and version index
├── .gitignore
└── Version1/
    ├── README.md          ← Version 1 overview
    ├── docs/              ← architecture, data model, business requirements
    ├── sql/               ← staging, warehouse (dimensions/facts/audit), semantic, validation
    ├── etl/               ← full-load script and load documentation
    └── powerbi/           ← semantic-layer / reporting notes
```

## Technology

- Microsoft SQL Server (built and verified on a SQL Server 2022 instance)
- T-SQL (DDL, views, load scripts)
- AdventureWorks2022 sample database
- Power BI as the intended reporting tool against the semantic views

No cloud services, SSIS packages, or Power BI report files are included in this repository.
