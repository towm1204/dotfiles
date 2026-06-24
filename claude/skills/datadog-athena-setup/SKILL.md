---
name: datadog-athena-setup
description: Sets up or repairs the datadog.logs Athena table that points at the Datadog S3 log archive. Use when the user says the Athena table is missing, queries against datadog.logs are failing, or they want to ensure the table is ready to query. Trigger on /datadog-athena-setup and proactively whenever a query against datadog.logs returns an entity-not-found error.
---

# Datadog Logs Athena Table Setup

The `datadog.logs` table is a permanent external table that points at the Datadog S3 log archive. It covers all logs from Nov 2023 onward and auto-includes new data via partition projection — no manual refresh ever needed. This skill ensures the table exists with the correct schema.

## AWS config

- **Profile**: default (`cashflowportal-production`)
- **Region**: `us-east-1`
- **S3 archive**: `s3://datadog-archived-logs-1/datadog/logs/`
- **Query results**: `s3://cashflowportalbucket-prod/athena-results/`

## Steps

### 1. Check if the table exists

```bash
QUERY_ID=$(aws athena start-query-execution \
  --query-string "DESCRIBE datadog.logs" \
  --result-configuration "OutputLocation=s3://cashflowportalbucket-prod/athena-results/" \
  --region us-east-1 \
  --query "QueryExecutionId" --output text 2>&1)

until aws athena get-query-execution --query-execution-id "$QUERY_ID" \
  --query "QueryExecution.Status.State" --output text 2>&1 \
  | grep -qE "SUCCEEDED|FAILED|CANCELLED"; do sleep 2; done

STATE=$(aws athena get-query-execution --query-execution-id "$QUERY_ID" \
  --query "QueryExecution.Status.State" --output text)
```

If `STATE` is `SUCCEEDED`, the table exists — confirm to the user and stop. If `FAILED`, proceed to recreate it.

### 2. Ensure the database exists

```bash
QUERY_ID=$(aws athena start-query-execution \
  --query-string "CREATE DATABASE IF NOT EXISTS datadog" \
  --result-configuration "OutputLocation=s3://cashflowportalbucket-prod/athena-results/" \
  --region us-east-1 \
  --query "QueryExecutionId" --output text)

until aws athena get-query-execution --query-execution-id "$QUERY_ID" \
  --query "QueryExecution.Status.State" --output text | grep -qE "SUCCEEDED|FAILED"; do sleep 2; done
```

### 3. Create the table

```bash
QUERY_ID=$(aws athena start-query-execution \
  --query-string "CREATE EXTERNAL TABLE IF NOT EXISTS datadog.logs (
  \`date\` STRING, service STRING, host STRING, source STRING, message STRING, status STRING, tags ARRAY<STRING>,
  attributes STRUCT<
    environment:STRING, user_id:STRING, request_id:STRING, url:STRING, origin_site:STRING, email_address:STRING,
    request:STRUCT<operationName:STRING>,
    payload:STRUCT<email_address:STRING,investor_name:STRING,investment_id:STRING,template_id:STRING,offering_slug:STRING>,
    http:STRUCT<request_id:STRING,method:STRING,status_code:INT,url:STRING,url_details:STRUCT<path:STRING>>,
    syslog:STRUCT<appname:STRING,procid:STRING>,
    network:STRUCT<client:STRUCT<ip:STRING>>,
    duration:DOUBLE
  >
)
PARTITIONED BY (dt STRING, hour STRING)
ROW FORMAT SERDE 'org.openx.data.jsonserde.JsonSerDe'
WITH SERDEPROPERTIES ('ignore.malformed.json'='TRUE','use.null.for.invalid.data'='TRUE')
STORED AS INPUTFORMAT 'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT 'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat'
LOCATION 's3://datadog-archived-logs-1/datadog/logs/'
TBLPROPERTIES (
  'projection.enabled'='true',
  'projection.dt.type'='date','projection.dt.format'='yyyyMMdd','projection.dt.range'='20231130,NOW','projection.dt.interval'='1','projection.dt.interval.unit'='DAYS',
  'projection.hour.type'='integer','projection.hour.range'='0,23','projection.hour.digits'='2',
  'storage.location.template'='s3://datadog-archived-logs-1/datadog/logs/dt=\${dt}/hour=\${hour}'
)" \
  --result-configuration "OutputLocation=s3://cashflowportalbucket-prod/athena-results/" \
  --region us-east-1 \
  --query "QueryExecutionId" --output text)

until aws athena get-query-execution --query-execution-id "$QUERY_ID" \
  --query "QueryExecution.Status.State" --output text | grep -qE "SUCCEEDED|FAILED"; do sleep 2; done

aws athena get-query-execution --query-execution-id "$QUERY_ID" --query "QueryExecution.Status" 2>&1
```

### 4. Confirm to the user

On success:

> `datadog.logs` is ready. Covers Nov 2023 → today, auto-updates as new logs land in S3. Query it in Athena — no refresh needed.

On failure, show the error message and diagnose (common causes: Glue IAM permissions, S3 access).

## Key schema fields for reference

| Field | Type | Notes |
|---|---|---|
| `attributes.user_id` | STRING | user UUID; `"anonymous"` on unauthenticated requests |
| `attributes.request_id` | STRING | app-level request ID |
| `attributes.request.operationName` | STRING | GraphQL operation name |
| `attributes.payload.email_address` | STRING | email in request body (auth/login requests) |
| `attributes.http.request_id` | STRING | router-level request ID |
| `attributes.http.url_details.path` | STRING | e.g. `/v1/accounts/auth` |
| `attributes.network.client.ip` | STRING | client IP |
| `dt` | STRING | partition key, format `YYYYMMDD` |
| `hour` | STRING | partition key, format `HH` (zero-padded) |

Partition filter `dt >= 'YYYYMMDD'` is the main cost control lever — always include it in queries.
