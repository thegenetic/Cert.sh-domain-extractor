#!/bin/bash

# CRT.SH Domain Extractor Tool
# by Dipesh Paul aka thegenetic

show_help() {
    echo "========================================="
    echo "        CRT.SH DOMAIN EXTRACTOR TOOL"
    echo "        by Dipesh Paul aka thegenetic"
    echo "========================================="
    echo ""
    echo "Usage: ./crtsh_extractor.sh -d domain/org_name -o output_file [--expired] [-t threads]"
    echo ""
    echo "Options:"
    echo "  -d, --domain    Specify the domain or organization name (e.g., example.com). This option is required."
    echo "  -o, --output    Specify the output file location. This option is required."
    echo "  --expired       Include this flag to exclude expired certificates from the results."
    echo "  -t, --threads   Number of threads to use for concurrent processing (default is 1)."
    echo "  -h, --help      Show the help message and exit."
    echo ""
}

# Default values
threads=1
expired=""

# Parse command-line arguments
while [[ "$#" -gt 0 ]]; do
    case $1 in
        -d|--domain) domain="$2"; shift ;;
        -o|--output) output_file="$2"; shift ;;
        --expired) expired="--exclude=expired" ;;
        -t|--threads) threads="$2"; shift ;;
        -h|--help) show_help; exit 0 ;;
        *) echo "Unknown parameter passed: $1"; show_help; exit 1 ;;
    esac
    shift
done

# Check for required parameters
if [[ -z "$domain" || -z "$output_file" ]]; then
    echo "Error: Domain and output file parameters are required."
    show_help
    exit 1
fi

# Display banner
echo "========================================="
echo "        CRT.SH DOMAIN EXTRACTOR TOOL"
echo "        by Dipesh Paul aka thegenetic"
echo "========================================="

# Create a temporary file for storing the fetched data
temp_file=$(mktemp)

# Fetch the data from crt.sh
url="https://crt.sh/?q=${domain}&group=none&output=json${expired}"
echo "Fetching data from: $url"
curl -s "$url" | jq -r '.[] | .common_name' | sort -u > "$temp_file"

# Process and filter domains
grep -Eo '^[^/]+(\.[^/]+)*$' "$temp_file" | awk -v domain="$domain" '
{
    gsub(/^\*\./, "", $0);
    if ($0 ~ domain) {
        print $0
    }
}' | sort -u > "$output_file"

# Remove temporary file
rm "$temp_file"

# Print results to console
echo "Domains extracted and saved to: $output_file"
cat "$output_file"
