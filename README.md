# Mule-ReturnedMail-API

Standalone MuleSoft 4 application for the **returned-mail / NCOA address-lookup**
capability, being lifted out of `Mule-Jhindexing-API`.

> ⚠️ **Boilerplate scaffold.** This repo currently contains the *high-level flow
> skeleton* only. Flow bodies, DWL transforms, and shared sub-flows are stubbed
> with `TODO: lift-and-shift` markers. Port the real implementation from
> `Mule-Jhindexing-API` before deploying anywhere.

## What this does

```
Azure Service Bus
  ├── returned-mail-subscribeFlow   — listens on returnedmail.sub
  │        └── IDP/CCH lookup → exclusion rules → publish to address-lookup-req
  ├── returned-mail-batcherFlow     — cron → drain address-lookup-req
  │        └── returned-mail-queue-listener → returned-mail-melissa (NCOA batch)
  │                 └── fan out to address-lookup-resp
  └── returned-mail-respFlow        — listens on address-lookup-resp
           └── AWD update → (Match) Alfresco clone + new AWD work item
```

## Project layout

| Path | Purpose |
|------|---------|
| `src/main/mule/global.xml` | Connector/global configs (trimmed to returned-mail deps) |
| `src/main/mule/returned-mail-flow.xml` | High-level flow skeleton (subscribe / batcher / resp) |
| `src/main/mule/sub-processes/shared-subflows.xml` | Stub shared helpers (token, AWD, tracking, Alfresco) |
| `src/main/mule/common-logger.xml` | Stub centralised failure/audit logger |
| `src/main/resources/config/common.yaml` | Env-independent properties |
| `src/main/resources/config/dev-local.yaml` | Local env properties (placeholders) |
| `src/main/resources/dwl/` | DWL transform stubs |

## Lift-and-shift checklist

- [ ] Port flow bodies in `returned-mail-flow.xml` (replace `TODO` markers)
- [ ] Port `token_generation`, `update-awd-workitemSub_Flow`, `address_lookup_tracking_table_Flow`, `alfresco-copy-update_Flow`, `awd-workItemv2_Flow`
- [ ] Port `process-common-logger-sub-flow` (ASB topic + audit DB)
- [ ] Port DWL: `rtnMailAWDupdate1-4.dwl`, `rtnMailMelissaReq.dwl`, `rtnMailPostQueue1.dwl`, `rtnMailNoMatch.dwl`
- [ ] Fill real values in `config/*.yaml`; add `test/uat/prod` env files
- [ ] Add DB schema scripts (address-lookup tracking table)
- [ ] Add MUnit coverage for each flow
- [ ] Wire deployment (Runtime Fabric) + connected-app credentials in `pom.xml`

## Build & test

```bash
# Build (skip tests)
mvn -U -DskipTests clean package

# MUnit tests
mvn test
```

- **Mule Runtime**: 4.6.6 | **Java**: 17 | **MUnit**: 3.7.1
- Local run needs `-Dmulenv=dev-local` plus secret JVM args (`-Dtoken.cs=...`, `-Ddb.pwd=...`)

## Conventions

Inherited from `Mule-Jhindexing-API`:

- Flows: `returned-mail-<operation>Flow` · Sub-flows: `<operation>_Flow`
- DWL files: `rtnMail<Operation>.dwl`
- Properties: `lowercase.dot.separated` · Variables: `camelCase`
- `correlationId` threads through all flows for distributed tracing
