# Obsidian Solutions: security posture statement

**Status:** self-declared. **Date:** 16 August 2026.
**Scope:** public software published by the Obsidian Solutions GitHub organisation.
**Basis:** NIST SSDF (SP 800-218) practices, mapped to the UK Software Security Code of Practice.

Obsidian Solutions is a UK sole-trader business. It holds no government
endorsement and no cyber-security certification. This statement records
what the organisation actually does, so that clients and auditors can
verify it against the published repositories and workflows. Every claim
below is observable in the organisation's public GitHub activity.

## PO - Secure software development

| Practice | Position | Evidence |
|---|---|---|
| Define security requirements | Adopted | NCSC secure-development standard cited in the CodeQL workflow |
| Implement threat modelling | Partial | Security gates are designed into the pipeline, but no formal threat-model document is published |
| Track and remediate findings | Adopted | Dependabot alerts, CodeQL findings, and Trivy scan results are triaged through GitHub |
| Use secure coding practices | Adopted | Markdownlint, prettier, eslint, jshint, pre-commit hooks, commit-format enforcement |

## PS - Protect all forms of code

| Practice | Position | Evidence |
|---|---|---|
| Secure the build environment | Adopted | GitHub Actions restricted to verified creators, SHA pinning required, protected `release` environment with human release review |
| Protect code repositories | Adopted | Signed commits required, linear history, no force push, no deletion, admins enforced, least-privilege default (read) |
| Control build changes | Adopted | Branch protection, required pull requests, commit-format workflow on every repo |
| Verify integrity of provenance | Adopted | `attest-build-provenance` signs release assets |

## PW - Produce well-secured software

| Practice | Position | Evidence |
|---|---|---|
| Verify code before release | Adopted | CodeQL SAST, Checkov IaC scanning, Trivy container scanning, render-and-validate gates with veraPDF |
| Verify third-party components | Adopted | SPDX SBOM regenerated per release (`tools/make-sbom.py`), sha256 digests on all release assets |
| Reuse code securely | Adopted | Dependabot version updates with grouped PRs, actions pinned by SHA |
| Inspect output artifacts | Adopted | Release assets carry SBOM and digests, published via draft-then-review |

## RV - Respond to vulnerability reports

| Practice | Position | Evidence |
|---|---|---|
| Identify and respond to reports | Adopted | SECURITY.md: private reporting to security@obsidiansolutions.co.uk, severity-based targets (Critical 1-day acknowledge / 7-day fix, down to Low 5/90) |
| Analyse and remediate | Adopted | Only the latest release is supported; fixes flow through the protected-branch PR process |
| Communicate | Adopted | Responsible disclosure with reporter credit; private vulnerability reporting enabled |

## Known gaps (notable, not exhaustive)

| Gap | Implication |
|---|---|
| No penetration testing evidence | External pen testing (at least every 12 months) is not yet performed. Absent from Def Stan 05-138 Level 1+ expectations |
| No formal threat-model document | SSDF PO.3 not fully met; CodeQL workflow comment is the current artefact |
| Single maintainer | Bus factor of 1; no external code review on any repo |
| No certification | No Cyber Essentials, ISO 27001, or other certification held. This statement is self-declared |

## How to verify this statement

Clone the public repositories and inspect: the reusable workflows in
`.github/workflow-templates`, the release assets of `quarto-templates`
(the SPDX SBOM and sha256 digests), and the branch protection on `main`
in every public repo. The GitHub API will confirm the settings. Nothing
in this statement requires trusting our word.

## Changes

This statement is reviewed when the organisation's practices change, and
at least annually. Change history is in git.