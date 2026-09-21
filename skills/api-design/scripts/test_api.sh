#!/usr/bin/env bash
# Test API endpoints with various methods
# Usage: test_api.sh <url> [options]
# Options:
#   -X METHOD   HTTP method (GET, POST, PUT, PATCH, DELETE)
#   -d DATA     Request body (JSON string)
#   -H HEADER   Extra header (can be repeated)
#   -f FILE     File to send as body
#   -v          Verbose mode
#   -t SECS     Timeout (default: 10)
#   -c          Color output
set -euo pipefail

URL=""
METHOD="GET"
BODY=""
FILE=""
HEADERS=()
VERBOSE=false
TIMEOUT=10
COLOR=false

while [[ $# -gt 0 ]]; do
    case "$1" in
        -X) METHOD="$2"; shift 2 ;;
        -d) BODY="$2"; shift 2 ;;
        -H) HEADERS+=("$2"); shift 2 ;;
        -f) FILE="$2"; shift 2 ;;
        -v) VERBOSE=true; shift ;;
        -t) TIMEOUT="$2"; shift 2 ;;
        -c) COLOR=true; shift ;;
        -*) echo "Unknown option: $1" >&2; exit 1 ;;
        *)  URL="$1"; shift ;;
    esac
done

if [[ -z "$URL" ]]; then
    echo "Usage: $0 <url> [-X METHOD] [-d '{\"key\":\"val\"}'] [-H 'Header: value'] [-f file] [-v] [-t secs]"
    echo ""
    echo "Examples:"
    echo "  $0 https://httpbin.org/get"
    echo "  $0 https://httpbin.org/post -X POST -d '{\"name\":\"test\"}'"
    echo "  $0 https://api.example.com/data -H 'Authorization: Bearer xxx'"
    exit 1
fi

echo "=== API Test ==="
echo "URL:    $URL"
echo "Method: $METHOD"
echo "Time:   $(date '+%Y-%m-%d %H:%M:%S')"
echo ""

CURL_ARGS=(-s -X "$METHOD" --max-time "$TIMEOUT")
CURL_ARGS+=(-w "\n---HTTP_CODE:%{http_code}---\nTIME_TOTAL:%{time_total}\nTIME_CONNECT:%{time_connect}\nTIME_STARTTRANSFER:%{time_starttransfer}\nSIZE:%{size_download}\n")

# Add headers
CURL_ARGS+=(-H "Content-Type: application/json")
CURL_ARGS+=(-H "Accept: application/json")
for h in "${HEADERS[@]}"; do
    CURL_ARGS+=(-H "$h")
done

# Add body
if [[ -n "$FILE" ]]; then
    CURL_ARGS+=(-d @"$FILE")
elif [[ -n "$BODY" ]]; then
    CURL_ARGS+=(-d "$BODY")
fi

if [[ "$VERBOSE" == true ]]; then
    CURL_ARGS+=(-v)
fi

RESPONSE=$(curl "${CURL_ARGS[@]}" "$URL" 2>&1)
EXIT_CODE=$?

# Extract metadata
HTTP_CODE=$(echo "$RESPONSE" | grep -o 'HTTP_CODE:[0-9]*' | cut -d: -f2 || echo "000")
TIME_TOTAL=$(echo "$RESPONSE" | grep -o 'TIME_TOTAL:[0-9.]*' | cut -d: -f2 || echo "?")
TIME_CONNECT=$(echo "$RESPONSE" | grep -o 'TIME_CONNECT:[0-9.]*' | cut -d: -f2 || echo "?")
TIME_TTFB=$(echo "$RESPONSE" | grep -o 'TIME_STARTTRANSFER:[0-9.]*' | cut -d: -f2 || echo "?")
SIZE=$(echo "$RESPONSE" | grep -o 'SIZE:[0-9.]*' | cut -d: -f2 || echo "?")

# Clean body (remove metadata lines)
BODY_RESP=$(echo "$RESPONSE" | sed '/^---HTTP_CODE/d; /^TIME_TOTAL/d; /^TIME_CONNECT/d; /^TIME_STARTTRANSFER/d; /^SIZE:/d; /^</d' 2>/dev/null)

# Status coloring
if [[ "$COLOR" == true ]]; then
    if [[ "$HTTP_CODE" -ge 200 && "$HTTP_CODE" -lt 300 ]]; then
        COLOR_CODE="\033[32m"  # green
    elif [[ "$HTTP_CODE" -ge 300 && "$HTTP_CODE" -lt 400 ]]; then
        COLOR_CODE="\033[33m"  # yellow
    elif [[ "$HTTP_CODE" -ge 400 ]]; then
        COLOR_CODE="\033[31m"  # red
    else
        COLOR_CODE="\033[0m"
    fi
    RESET="\033[0m"
else
    COLOR_CODE=""
    RESET=""
fi

echo -e "Status: ${COLOR_CODE}${HTTP_CODE:-???}${RESET}"
echo "Total:  ${TIME_TOTAL}s"
echo "Connect: ${TIME_CONNECT}s"
echo "TTFB:   ${TIME_TTFB}s"
echo "Size:   ${SIZE} bytes"
echo ""

# Pretty-print JSON response
if [[ -n "$BODY_RESP" ]]; then
    echo "--- Response Body ---"
    echo "$BODY_RESP" | python3 -m json.tool 2>/dev/null || echo "$BODY_RESP"
fi

exit "${EXIT_CODE:-1}"
