# Obsidian Solutions

Remote IT and cyber security services for business:

- Remote server management and maintenance
- Network and VPN solutions
- Website support and maintenance
- Containerisation
- Custom solutions

[obsidiansolutions.co.uk](https://obsidiansolutions.co.uk)

## Toolchain

| Need | Repo | What It Does |
|------|------|-------------|
| Standards | [agent-standards-library](https://github.com/Obsidian-Solutions/agent-standards-library) | 72 briefs, STE linter, context severity ladder |
| Templates | [quarto-templates](https://github.com/Obsidian-Solutions/quarto-templates) | 90+ document templates, brand system, verification gates |
| CI/CD | [template-repository](https://github.com/Obsidian-Solutions/template-repository) | GitHub Actions, CodeQL, Trivy, Checkov, commit-format |
| Infrastructure | [infrastructure-as-code](https://github.com/Obsidian-Solutions/infrastructure-as-code) | 80+ Ansible roles, monitoring, security, PKI |
| Governance | [business-policy](https://github.com/Obsidian-Solutions/business-policy) | Risk, strategy, incident response, backup policy |
| Compliance | [estate-health](https://github.com/Obsidian-Solutions/estate-health) | Org-wide health monitoring, monthly reports |

## How Repos Connect

- Every new repo starts from **template-repository**
- Security scanning runs via **infrastructure-as-code** roles (Semgrep, Trivy, Checkov)
- Documents render through **quarto-templates** brand (PDF/A-4f, HTML, DOCX)
- Compliance monitored by **estate-health** (branches, licences, signatures)
- Governance in **business-policy** covers all repos (risk register, incident response)
- Standards in **agent-standards-library** inform all work (briefs index routes to relevant standards)

## Security

Report a vulnerability in any repository per the
[security policy](https://github.com/Obsidian-Solutions/.github/security).
