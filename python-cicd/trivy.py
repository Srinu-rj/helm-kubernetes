#!/usr/bin/env python3

import json
import sys
from datetime import datetime
import argparse

def parse_trivy_results(file_path):
    """Parse Trivy JSON results"""
    with open(file_path, 'r') as f:
        data = json.load(f)

    vulnerabilities = []
    if 'Results' in data:
        for result in data['Results']:
            if 'Vulnerabilities' in result:
                vulnerabilities.extend(result['Vulnerabilities'])

    return vulnerabilities

def generate_summary(vulnerabilities):
    """Generate vulnerability summary"""
    severity_counts = {'CRITICAL': 0, 'HIGH': 0, 'MEDIUM': 0, 'LOW': 0}

    for vuln in vulnerabilities:
        severity = vuln.get('Severity', 'UNKNOWN')
        if severity in severity_counts:
            severity_counts[severity] += 1

    return severity_counts

def generate_html_report(vulnerabilities, output_file):
    """Generate HTML report"""
    summary = generate_summary(vulnerabilities)

    html_content = f"""
    <!DOCTYPE html>
    <html>
    <head>
        <title>Trivy Security Report</title>
        <style>
            body {{ font-family: Arial, sans-serif; margin: 20px; }}
            .summary {{ background: #f5f5f5; padding: 15px; border-radius: 5px; }}
            .critical {{ color: #d32f2f; }}
            .high {{ color: #f57c00; }}
            .medium {{ color: #fbc02d; }}
            .low {{ color: #388e3c; }}
            table {{ border-collapse: collapse; width: 100%; margin-top: 20px; }}
            th, td {{ border: 1px solid #ddd; padding: 8px; text-align: left; }}
            th {{ background-color: #f2f2f2; }}
        </style>
    </head>
    <body>
        <h1>Trivy Security Report</h1>
        <p>Generated on: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}</p>
        
        <div class="summary">
            <h2>Summary</h2>
            <p><span class="critical">Critical: {summary['CRITICAL']}</span></p>
            <p><span class="high">High: {summary['HIGH']}</span></p>
            <p><span class="medium">Medium: {summary['MEDIUM']}</span></p>
            <p><span class="low">Low: {summary['LOW']}</span></p>
        </div>
        
        <h2>Detailed Vulnerabilities</h2>
        <table>
            <tr>
                <th>CVE ID</th>
                <th>Severity</th>
                <th>Package</th>
                <th>Installed Version</th>
                <th>Fixed Version</th>
                <th>Description</th>
            </tr>
    """

    for vuln in vulnerabilities:
        html_content += f"""
            <tr>
                <td>{vuln.get('VulnerabilityID', 'N/A')}</td>
                <td class="{vuln.get('Severity', '').lower()}">{vuln.get('Severity', 'N/A')}</td>
                <td>{vuln.get('PkgName', 'N/A')}</td>
                <td>{vuln.get('InstalledVersion', 'N/A')}</td>
                <td>{vuln.get('FixedVersion', 'N/A')}</td>
                <td>{vuln.get('Description', 'N/A')[:100]}...</td>
            </tr>
        """

    html_content += """
        </table>
    </body>
    </html>
    """

    with open(output_file, 'w') as f:
        f.write(html_content)

def main():
    parser = argparse.ArgumentParser(description='Generate Trivy security reports')
    parser.add_argument('input_file', help='Trivy JSON results file')
    parser.add_argument('--output', '-o', default='trivy-report.html',
                        help='Output HTML file')

    args = parser.parse_args()

    try:
        vulnerabilities = parse_trivy_results(args.input_file)
        generate_html_report(vulnerabilities, args.output)
        print(f"Report generated: {args.output}")

        summary = generate_summary(vulnerabilities)
        print(f"Summary: {summary}")

    except Exception as e:
        print(f"Error: {e}")
        sys.exit(1)

if __name__ == '__main__':
    main()