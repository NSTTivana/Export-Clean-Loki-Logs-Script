#!/bin/bash

# ---------- CONFIG ----------
LOKI_ADDR="http://192.168.88.153:3100"
APP_LABEL='app="apisix"'
SEARCH_TERM="emt.otepc.go.th"
FROM="2025-03-20T00:00:00+07:00"
TO="2025-03-21T00:00:00+07:00"
LIMIT=800000

# ---------- FORMAT FILE NAMES ----------
FROM_DATE=$(echo "$FROM" | cut -d'T' -f1 | tr -d '-')
TO_DATE=$(echo "$TO" | cut -d'T' -f1 | tr -d '-')

RAW_FILE="emt.otepc.go.th_log_${FROM_DATE}.jsonl"
CLEAN_FILE="emt.otepc.go.th_log_${FROM_DATE}_to_${TO_DATE}_json.jsonl"

# ---------- 1. RUN logcli ----------
echo "📡 Fetching logs from $FROM to $TO..."
logcli --addr="$LOKI_ADDR" \
  query "{$APP_LABEL} |= \"$SEARCH_TERM\"" \
  --from="$FROM" \
  --to="$TO" \
  --limit="$LIMIT" \
  --output=jsonl > "$RAW_FILE"

if [[ $? -ne 0 ]]; then
  echo "❌ logcli query failed"
  exit 1
fi

echo "✅ Raw logs saved to $RAW_FILE"

# ---------- 2. CLEAN with jq into array ----------
echo "🧹 Cleaning logs and exporting as JSON array..."
jq -s '
  map(
    select(.line | try fromjson | type == "object")
    | .line |= (fromjson | del(.request_body))
    | .line
  )
' "$RAW_FILE" > "$CLEAN_FILE"

if [[ $? -ne 0 ]]; then
  echo "❌ jq transformation failed"
  exit 2
fi

echo "✅ Cleaned logs saved to $CLEAN_FILE"
