# Module 1: Introduction to CVE (Common Vulnerabilities and Exposures)

## Learning Objectives
By the end of this module, students will be able to:
- Understand what CVE is and its importance in cybersecurity
- Navigate CVE databases effectively
- Identify different types of vulnerabilities
- Use AI tools for vulnerability research

## 1.1 What is CVE?

The Common Vulnerabilities and Exposures (CVE) system provides a reference method for publicly known information-security vulnerabilities and exposures. CVE identifiers are assigned by CVE Numbering Authorities (CNAs) to vulnerabilities that meet specific criteria.

### Key Concepts:
- **CVE ID**: Unique identifier (e.g., CVE-2023-12345)
- **CVSS Score**: Common Vulnerability Scoring System rating
- **CWE**: Common Weakness Enumeration classification
- **EPSS**: Exploit Prediction Scoring System

## 1.2 AI-Powered Vulnerability Analysis

Modern cybersecurity leverages AI for:
- Automated vulnerability detection
- Threat intelligence gathering  
- Risk assessment and prioritization
- Remediation recommendations

### Hands-On Exercise: Using GitHub Copilot for CVE Research

```bash
# Use GitHub Copilot to suggest commands for CVE research
gh copilot suggest "search for recent high-severity CVEs in web applications"

# Example AI-generated command:
curl -s "https://services.nvd.nist.gov/rest/json/cves/1.0?resultsPerPage=10&cvssV3Severity=HIGH" | jq '.result.CVE_Items[] | .cve.CVE_data_meta.ID'
```

## 1.3 Interactive Lab Environment

### Setting up your AI-powered research environment:

1. **GitHub Codespaces Setup**:
   - Pre-configured with all security tools
   - GitHub Copilot integration
   - Gemini CLI for advanced queries

2. **Browser Optimization**:
   - **Safari**: Enhanced privacy features for secure research
   - **Chrome**: DevTools for analyzing web vulnerabilities
   - **Edge**: Integrated security features and Microsoft Defender

## 1.4 Assessment

### AI-Assisted Quiz
Use the following prompt with your AI assistant:

```
"Create a quiz about CVE fundamentals including:
1. CVE ID format and structure
2. CVSS scoring basics
3. Major vulnerability types
4. Best practices for vulnerability research"
```

### Practical Assignment
1. Research 3 recent CVEs using AI tools
2. Create a summary report with:
   - CVE details and CVSS scores
   - Impact analysis
   - Recommended mitigations
   - AI tool usage documentation

## Resources
- [CVE Program Official Site](https://cve.mitre.org/)
- [National Vulnerability Database](https://nvd.nist.gov/)
- [GitHub Security Advisories](https://github.com/advisories)
- [CVE Search API Documentation](https://cve.circl.lu/api/)

## Next Module
Continue to [Module 2: Vulnerability Assessment Techniques](./02-vulnerability-assessment.md)