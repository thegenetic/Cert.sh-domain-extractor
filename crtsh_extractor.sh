#!/bin/bash

# Function to display the banner
show_banner() {
    echo "========================================="
    echo "        CRT.SH DOMAIN EXTRACTOR TOOL     "
    echo "        by Dipesh Paul aka thegenetic    "
    echo "========================================="
}

# Function to display help message
show_help() {
    show_banner
    echo "Usage: $0 [-d domain/org_name] [-o output_file] [--expired] [-t threads]"
    echo ""
    echo "Options:"
    echo "  -d, --domain      Specify the domain or organization name."
    echo "  -o, --output      Specify the output file location. If not provided, output to stdout."
    echo "  --expired         Include this flag to exclude expired certificates."
    echo "  -t, --threads     Number of threads to use for concurrent processing (default is 1)."
    echo "  -h, --help        Show this help message."
    echo ""
    echo "- by Dipesh Paul aka thegenetic"
}

# Default values
domain=""
output_file=""
exclude_expired=false
threads=1

# Parse command line arguments
while [[ $# -gt 0 ]]; do
    case $1 in
        -d|--domain)
            domain="$2"
            shift 2
            ;;
        -o|--output)
            output_file="$2"
            shift 2
            ;;
        --expired)
            exclude_expired=true
            shift
            ;;
        -t|--threads)
            threads="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
done

# Check if domain is provided
if [[ -z "$domain" ]]; then
    echo "Error: Domain/organization name must be specified."
    show_help
    exit 1
fi

# Show the banner at the start
show_banner

# Build the query URL
url="https://crt.sh/?q=${domain}&group=none&output=json"
if $exclude_expired; then
    url="${url}&exclude=expired"
fi

# Function to process the JSON response and extract 'common name'
process_response() {
    local response="$1"
    echo "$response" | jq -r '.[].common_name' | sed 's/^*\.//' | sort -u | grep "\.${domain}$"
}

# Fetch and process the data
fetch_data() {
    local url="$1"
    response=$(curl -s "$url")
    process_response "$response"
}

export -f process_response
export -f fetch_data
export domain

# Use xargs to handle threading
result=$(echo "$url" | xargs -n 1 -P "$threads" bash -c 'fetch_data "$@"' _)

# If output file is specified, save the results to the file
if [[ -n "$output_file" ]]; then
    echo "$result" > "$output_file"
    echo "Results saved to $output_file"
else
    echo "$result"
fi

# Print completion message
echo "Processing completed."
