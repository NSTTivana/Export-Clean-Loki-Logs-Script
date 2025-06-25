# Export & Clean Loki Logs Script

## 📝 Script: `export_clean_loki_logs.sh`

This Bash script is used to:
- Query logs from [Grafana Loki](https://grafana.com/oss/loki/) using `logcli`
- Sanitize log entries by removing sensitive fields (e.g., `request_body`)
- Convert `.jsonl` logs into a readable **JSON array format**

---

## 🧰 Requirements

Make sure the following tools are installed on your system:

### ✅ For macOS (ARM64 / Intel) 


```bash
brew install jq 
brew install logcli #STOP SUPORTING ON Homebrew
``` 

If `logcli` is not available in Homebrew:
```bash
wget https://github.com/grafana/loki/releases/download/v3.0.0/logcli-darwin-arm64.zip
unzip logcli-darwin-arm64.zip
chmod +x logcli
sudo mv logcli /usr/local/bin/
```

### ✅ For Linux (Ubuntu/Debian)
```bash
sudo apt update
sudo apt install -y jq
```

Install `logcli`:
```bash
wget https://github.com/grafana/loki/releases/download/v3.0.0/logcli-linux-amd64.zip
unzip logcli-linux-amd64.zip
chmod +x logcli
sudo mv logcli /usr/local/bin/
```

---

## ⚙️ How to Use

1. Edit the top variables in the script:

```bash
LOKI_ADDR="http://<your-loki-ip>:3100"
APP_LABEL='app=" "'
SEARCH_TERM=" <ip or domain>"
FROM="2025-06-11T00:00:00+07:00"
TO="2025-06-12T00:00:00+07:00"
LIMIT=800000
```

2. Grant execute permission:
```bash
chmod +x export_clean_loki_logs.sh
```

3. Run the script:
```bash
./export_clean_loki_logs.sh
```

---

## 📂 Output Files

| File | Description |
|------|-------------|
| `domain_log_YYYYMMDD.jsonl` | Raw log data exported from Loki |
| `domain_log_YYYYMMDD_json.json` | Cleaned JSON array with `request_body` removed |

---

## 🧪 Example

```bash
./export_clean_loki_logs.sh
```

Will generate:
- `domain_log_20250611.jsonl` — raw `.jsonl`
- `domain_log_20250612_json.json` — cleaned JSON array

---

## 🔐 Security Note

This script use jq for trim and removes `request_body` fields to prevent storing any sensitive information such as tokens, passwords, or client secrets in log archives.

---
