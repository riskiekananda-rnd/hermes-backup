#!/usr/bin/env bash
# Basic page fetcher with curl
# Usage: fetch_page.sh <url> [options]
# Options:
#   -o FILE    Save output to file
#   -h         Show headers
#   -j         Parse as JSON and pretty-print
#   -s         Silent mode (no status info)
#   -t SECS    Timeout in seconds (default: 15)
#   -r         Follow redirects
#   -A AGENT   Custom User-Agent
set -euo pipefail

URL=""
OUTPUT=""
SHOW_HEADERS=false
JSON_PRETTY=false
SILENT=false
TIMEOUT=15
FOLLOW_REDIRECTS=false
USER_AGENT="Mozilla/5.0 (Android 14; Mobile; rv:128.0) Gecko/20120101 Firefox/128.0"

while [[ $# -gt 0 ]]; do
    case "$1" in
        -o) OUTPUT="$2"; shift 2 ;;
        -h) SHOW_HEADERS=true; shift ;;
        -j) JSON_PRETTY=true; shift ;;
        -s) SILENT=true; shift ;;
        -t) TIMEOUT="$2"; shift 2 ;;
        -r) FOLLOW_REDIRECTS=true; shift ;;
        -A) USER_AGENT="$2"; shift 2 ;;
        -*) echo "Unknown option: $1" >&2; exit 1 ;;
        *)  URL="$1"; shift ;;
    esac
done

if [[ -z "$URL" ]]; then
    echo "Usage: $0 <url> [-o file] [-h] [-j] [-s] [-t secs] [-r] [-A agent]"
    exit 1
fi

CURL_ARGS=(-s -L --max-time "$TIMEOUT" -H "User-Agent: $USER_AGENT")
[[ "$FOLLOW_REDIRECTS" == true ]] && CURL_ARGS+=(-L)
[[ "$SHOW_HEADERS" == true ]] && CURL_ARGS+=(-D -)

# Determine accept header for JSON
if [[ "$JSON_PRETTY" == true ]]; then
    CURL_ARGS+=(-H "Accept: application/json")
fi

if [[ -n "$OUTPUT" ]]; then
    curl "${CURL_ARGS[@]}" -o "$OUTPUT" "$URL"
    STATUS=$?
    if [[ "$STATUS" -eq 0 && "$SILENT" == false ]]; then
        echo "Saved to $OUTPUT ($(du -h "$OUTPUT" | cut -f1))"
    fi
    exit $STATUS
fi

RESPONSE=$(curl "${CURL_ARGS[@]}" -w "\n%{http_code}" "$URL")
HTTP_CODE=$(echo "$RESPONSE" | tail -1)
BODY=$(echo "$RESPONSE" | sed '$d')

if [[ "$SILENT" == false ]]; then
    echo "URL:    $URL"
    echo "Status: $HTTP_CODE"
    echo "---"
fi

if [[ "$JSON_PRETTY" == true ]]; then
    echo "$BODY" | python3 -m json.tool 2>/dev/null || echo "$BODY"
else
    echo "$BODY"
fi
