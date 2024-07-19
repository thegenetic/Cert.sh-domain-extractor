# CRT.SH Domain Extractor Tool

**CRT.SH Domain Extractor Tool** is a shell script for extracting domain and subdomain names from the [crt.sh](https://crt.sh) certificate transparency logs. The script allows users to fetch certificates related to a specified domain and optionally filter out expired certificates. It also provides options for multi-threaded execution and saving results to an output file.

## Features

- Extract domains and subdomains from crt.sh
- Option to include or exclude expired certificates
- Support for multi-threaded execution
- Save results to a file or print to the console
- Clean and deduplicate the output

## Installation

1\. Clone the repository and make the file executable:
```bash\
git clone https://github.com/thegenetic/crtsh-domain-extractor.git && cd crtsh-domain-extractor && chmod +x crtsh_extractor.sh
```

## Usage

```bash\
./crtsh_extractor.sh [-d domain/org_name] [-o output_file] [--expired] [-t threads]
```

### Options

- `-d, --domain`\
  Specify the domain or organization name (e.g., `example.com`). This option is required.

- `-o, --output`\
  Specify the output file location. If not provided, results will be printed to the console.

- `--expired`\
  Include this flag to exclude expired certificates from the results.

- `-t, --threads`\
  Number of threads to use for concurrent processing (default is 1).

- `-h, --help`\
  Show the help message and exit.

### Examples

1\. **Basic Usage:**
```bash\
   ./crtsh_extractor.sh -d example.com
```

2\. **With Output File:**
```bash\
   ./crtsh_extractor.sh -d example.com -o output.txt
```

3\. **With Expired Flag:**
```bash\
   ./crtsh_extractor.sh -d example.com --expired
```

4\. **With Threads:**
```bash\
   ./crtsh_extractor.sh -d example.com -t 4
```

5\. **Help Option:**
```bash\
   ./crtsh_extractor.sh -h
```

## Author

- **Dipesh Paul aka thegenetic**

## Contributing

Feel free to open issues or submit pull requests for improvements or bug fixes.
