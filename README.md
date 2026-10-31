# 🚀 Enterprise CI/CD Pipelines: Azure DevOps & GitHub Actions

[![Azure DevOps](https://img.shields.io/badge/Azure%20DevOps-0078D7?style=for-the-badge&logo=azure-devops&logoColor=white)](https://dev.azure.com/)
[![GitHub Actions](https://img.shields.io/badge/github%20actions-%232671E8.svg?style=for-the-badge&logo=githubactions&logoColor=white)](https://github.com/features/actions)
[![YAML](https://img.shields.io/badge/yaml-%23ffffff.svg?style=for-the-badge&logo=yaml&logoColor=151515)](https://yaml.org/)
[![Terraform](https://img.shields.io/badge/terraform-%235835CC.svg?style=for-the-badge&logo=terraform&logoColor=white)](https://www.terraform.io/)
[![Checkov](https://img.shields.io/badge/Checkov-IaC%20Security-blue?style=for-the-badge)](https://www.checkov.io/)
[![Bandit](https://img.shields.io/badge/Bandit-SAST-green?style=for-the-badge)](https://bandit.readthedocs.io/)

A production-grade collection of **Azure DevOps Multi-Stage YAML Pipelines** and **GitHub Actions Workflows** engineered for enterprise telecom and cloud solutions.

Designed and implemented by **Osama Khalil** (Senior DevOps Engineer), demonstrating Git branch policies, PR review gates, SAST security scans (Bandit/Checkov), automated testing, artifacts packaging, multi-environment deployments (`Dev` -> `Stage` -> `Prod`), and automated rollbacks.

---

## 🔄 End-to-End Delivery Architecture

```mermaid
sequenceDiagram
    autonumber
    actor Dev as Developer
    participant Git as Git Repo (Feature Branch)
    participant PR as Pull Request & Branch Policies
    participant CI as Azure DevOps / Actions CI
    participant Security as SAST & IaC Scanners
    participant Artifacts as Package Drop / Storage
    participant Gate as Approval Check
    participant Azure as Azure Environment (VM / DB)

    Dev->>Git: git push feature/nms-telemetry-engine
    Git->>PR: Open Pull Request to main
    PR->>CI: Trigger Automated CI Validation
    CI->>Security: Execute Flake8, Bandit SAST & Checkov
    Security-->>CI: Security Gate Passed (0 High/Critical)
    CI->>CI: Run Pytest Suite with Cobertura Coverage
    CI-->>PR: Report Status Checks: PASSED
    Dev->>PR: Peer Review Approval & Branch Merge
    PR->>Artifacts: Build & Publish Release Tarball (.tar.gz)
    Artifacts->>Gate: Trigger CD Pipeline to Production
    Gate-->>Azure: Manual Approval by Lead DevOps Engineer
    Azure->>Azure: Deploy to RHEL Linux VM & Run Smoke Tests
```

---

## 📂 Repository Layout

```
.
├── azure-pipelines/
│   ├── azure-pipelines-app-ci.yml       # Multi-stage CI: Lint, SAST, Test, Package
│   ├── azure-pipelines-app-cd.yml       # Multi-stage CD: Dev -> Prod VM rollout
│   ├── azure-pipelines-terraform.yml    # IaC Pipeline: TFLint, Checkov, Plan & Apply
│   └── templates/
│       ├── steps-python-test.yml        # Reusable Pytest & coverage step template
│       └── steps-security-scan.yml      # Security scanning step template
├── .github/
│   └── workflows/
│       ├── ci.yml                       # GitHub Actions: Python 3.10-3.12 matrix CI
│       └── terraform-checks.yml         # GitHub Actions: Checkov IaC security audit
├── scripts/
│   ├── smoke_test.sh                    # Automated HTTP status & latency prober
│   └── rollback.sh                      # Zero-downtime automated rollback handler
└── README.md
```

---

## 🛡️ Security & Compliance Controls

| Tool | Scope | Purpose | Enforcement Gate |
|---|---|---|---|
| **Bandit** | Python AST | Static Application Security Testing (SAST) | Blocks PR on High severity |
| **Flake8** | Source Code | PEP8 styling, complexity analysis, syntax validation | Fails on syntax or formatting bugs |
| **Checkov** | Terraform IaC | CIS Azure Benchmark & SOC2 policy compliance | Validates encryption, NSGs, private endpoints |
| **Pytest-Cov** | Test Execution | Code coverage threshold enforcement | Requires minimum 80% branch coverage |

---

## ⚙️ Branch Policy Specifications

To ensure maximum uptime and zero regressions in production:
1. **Require Minimum 1 Reviewer:** Direct pushes to `main` and `develop` branches are strictly blocked.
2. **Require Build Validation:** Pipelines must complete green (`Lint_And_Security_Scan` and `Unit_And_Integration_Tests`).
3. **Check for Linked Work Items:** Enforced via Azure DevOps Boards or Jira issue keys in commit messages.
4. **Enforce Fast-Forward or Squash Merge:** Keeps the commit history clean and auditable.

---

## 👨‍💻 Author

**Osama Khalil**
- **Role:** DevOps Engineer | Microsoft Azure | Terraform | CI/CD | Linux
- **GitHub:** [@khalilosam](https://github.com/khalilosam)
- **LinkedIn:** [linkedin.com/in/osamakhalil](https://linkedin.com)
