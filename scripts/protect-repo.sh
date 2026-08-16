#!/usr/bin/env bash
# protect-repo.sh - apply Obsidian Solutions repo protection defaults.
#
# Usage: ./protect-repo.sh <repo-name> [default-branch]
#
# Applies, idempotently, to one repository:
#   1. Branch protection on the default branch (signed commits, linear
#      history, no force push, no deletion, enforced on admins)
#   2. Secret scanning + push protection + dependabot security updates
#   3. Private vulnerability reporting
#   4. Code scanning default setup (public repos only)
#   5. Dependabot version-update config if absent (opens a PR)
#
# Mapping: NCSC Secure Development P5/P6, UK Software Security Code
# 2.1/3.3, JSP 945 CM. See obsidian-solutions-github-config-actions.md.
#
# Requires: gh authenticated with repo scope, base64.
set -euo pipefail

OWNER="Obsidian-Solutions"
REPO="${1:?usage: protect-repo.sh <repo-name> [default-branch]}"
BRANCH="${2:-main}"
FULL="$OWNER/$REPO"

echo "==> $FULL"

# 1. Branch protection (classic, enforced on admins).
#    ponytail: classic protection chosen over rulesets because it supports
#    enforce_admins; per-repo rulesets default to admin bypass. Org rulesets
#    would replace this but need the GitHub Team plan.
gh api --method PUT "repos/$FULL/branches/$BRANCH/protection" --input - >/dev/null <<'JSON'
{"required_status_checks":{"strict":true,"contexts":[]},
 "required_pull_request_reviews":{"required_approving_review_count":0,
   "dismiss_stale_reviews":false,"require_code_owner_reviews":false},
 "enforce_admins":true,"required_linear_history":true,
 "allow_force_pushes":false,"allow_deletions":false,
 "required_conversation_resolution":false,"restrictions":null}
JSON
gh api --method POST "repos/$FULL/branches/$BRANCH/protection/required_signatures" --input - >/dev/null <<'JSON'
{}
JSON
echo "   branch protection: active"

# 2. Security and analysis.
gh api --method PATCH "repos/$FULL" --input - >/dev/null <<'JSON'
{"security_and_analysis":{"secret_scanning":{"status":"enabled"},
 "secret_scanning_push_protection":{"status":"enabled"},
 "dependabot_security_updates":{"status":"enabled"}}}
JSON
echo "   secret scanning + push protection + dependabot updates: enabled"

# 3. Private vulnerability reporting. Fails on private repos without GHAS.
if gh api --method PUT "repos/$FULL/private-vulnerability-reporting" >/dev/null 2>&1; then
  echo "   private vulnerability reporting: enabled"
else
  echo "   private vulnerability reporting: unavailable (private repo, needs GHAS)"
fi

# 4. Code scanning default setup. Public repos only; private needs GHAS.
PRIVATE=$(gh api "repos/$FULL" --jq '.private')
if [ "$PRIVATE" = "false" ]; then
  gh api --method PUT "repos/$FULL/code-scanning/default-setup" --input - >/dev/null 2>&1 \
    <<'JSON' && echo "   code scanning default setup: configured" || echo "   code scanning: skipped (already custom)"
{"state":"configured"}
JSON
else
  echo "   code scanning: skipped (private repo, needs GHAS)"
fi

# 5. Dependabot version-update config, if absent.
if ! gh api "repos/$FULL/contents/.github/dependabot.yml" >/dev/null 2>&1; then
  TMP=$(mktemp)
  cat > "$TMP" <<'YAML'
# Dependabot version updates: keep dependencies current.
version: 2
updates:
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "weekly"
    commit-message:
      prefix: "ci"
    groups:
      github-actions:
        patterns: ["*"]
YAML
  B64=$(base64 -w0 "$TMP")
  rm -f "$TMP"
  HEAD=$(gh api "repos/$FULL/commits/$BRANCH" --jq '.sha')
  gh api --method POST "repos/$FULL/git/refs" \
    -f ref="refs/heads/ci/dependabot-config" -f sha="$HEAD" >/dev/null 2>&1 || true
  gh api --method PUT "repos/$FULL/contents/.github/dependabot.yml" \
    -f message="ci: add dependabot config" -f content="$B64" \
    -f branch=ci/dependabot-config >/dev/null
  gh api --method POST "repos/$FULL/pulls" \
    -f title="ci: add dependabot config" -f head=ci/dependabot-config \
    -f base="$BRANCH" --jq '.html_url'
  echo "   dependabot.yml: added, merge the PR above"
else
  echo "   dependabot.yml: present"
fi

echo "==> done: $FULL"