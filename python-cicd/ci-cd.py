#!/bin/bash
# ci-trivy-scan.sh

set -e

# Configuration
IMAGE_NAME="${1:-myapp:latest}"
SEVERITY_THRESHOLD="${2:-HIGH,CRITICAL}"
OUTPUT_FORMAT="${3:-json}"
FAIL_ON_VULNERABILITIES="${4:-true}"

# Create results directory
mkdir -p trivy-results

# Scan container image
echo "Scanning container image: $IMAGE_NAME"
trivy image --format "$OUTPUT_FORMAT" --output "trivy-results/image-scan.json" --severity "$SEVERITY_THRESHOLD" "$IMAGE_NAME"

# Scan IaC files
echo "Scanning Infrastructure as Code files"
trivy config \
      --format "$OUTPUT_FORMAT" \
               --output "trivy-results/iac-scan.json" \
                        --severity "$SEVERITY_THRESHOLD" \
    .

# Scan file system
echo "Scanning file system"
trivy fs \
      --format "$OUTPUT_FORMAT" \
               --output "trivy-results/fs-scan.json" \
                        --severity "$SEVERITY_THRESHOLD" \
    .

# Generate summary report
python3 trivy-reporter.py trivy-results/image-scan.json --output trivy-results/image-report.html
python3 trivy-reporter.py trivy-results/iac-scan.json --output trivy-results/iac-report.html
python3 trivy-reporter.py trivy-results/fs-scan.json --output trivy-results/fs-report.html

# Check for vulnerabilities and fail if configured
if [ "$FAIL_ON_VULNERABILITIES" = "true" ]; then
echo "Checking for vulnerabilities..."

# Count vulnerabilities
image_vulns=$(jq '[.Results[]?.Vulnerabilities[]? | select(.Severity == "HIGH" or .Severity == "CRITICAL")] | length' trivy-results/image-scan.json)
iac_vulns=$(jq '[.Results[]?.Misconfigurations[]? | select(.Severity == "HIGH" or .Severity == "CRITICAL")] | length' trivy-results/iac-scan.json)
fs_vulns=$(jq '[.Results[]?.Vulnerabilities[]? | select(.Severity == "HIGH" or .Severity == "CRITICAL")] | length' trivy-results/fs-scan.json)

total_vulns=$((image_vulns + iac_vulns + fs_vulns))

echo "Found $total_vulns high/critical vulnerabilities"

if [ "$total_vulns" -gt 0 ]; then
echo "❌ Security scan failed: Found $total_vulns high/critical vulnerabilities"
exit 1
else
echo "✅ Security scan passed: No high/critical vulnerabilities found"
fi
fi

echo "Trivy scan completed successfully"