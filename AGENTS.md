# AGENTS.md - Guidelines for AI Contributors

Guidelines for AI (and human) contributors to **adrianwedd/home-assistant-obsidian**

This repository hosts a **pure-wrapper Home Assistant add-on** that embeds the
official `ghcr.io/sytone/obsidian-remote` container via Ingress.

---

## Commit message convention

All commits must follow the format:

```
ADDON-XXX: short imperative summary
```

Where XXX is a three-digit task number. This is enforced by the git hook in `scripts/check_commit_msg.sh`.

---

## Pull-request checklist

- [ ] Commit message follows `ADDON-XXX:` format
- [ ] `pre-commit run --all-files` passes (markdown-lint, shell-check, etc.)
- [ ] `ha dev addon lint` returns **0 errors / 0 warnings**
- [ ] Updated docs if user-visible behaviour changed

---

## Branching & naming

| Purpose | Branch prefix | Example |
|---------|---------------|---------|
| Feature / task implementation | `feat/ADDON-XXX-` | `feat/ADDON-004-config-yaml` |
| Docs-only | `docs/ADDON-XXX-` | `docs/ADDON-009-readme` |
| CI / infra | `ci/` | `ci/github-actions-cache` |

PRs must target `main`.

---

## Linting & CI

| Tool | Trigger | Notes |
|------|---------|-------|
| **Addon-linter** (`frenck/action-addon-linter`) | Every push / PR | Validates `config.yaml`, icons, translations. |
| **Release workflow** | Git tag `v*.*.*` | Bumps `version` in `config.yaml`, publishes GitHub Release. |
| **Renovate** | Nightly | Opens PR when new upstream container tag appears. |

Never merge failing CI—but propose diagnostic improvements when failure patterns emerge.

---

## File-specific rules

| File | Rule |
|------|------|
| `obsidian/config.yaml` | Keep `image:` untagged; `version` is bumped by the release workflow. |
| `obsidian/run.sh` | Keep shebang `#!/usr/bin/with-contenv bashio`. |
| `README.md` & `DOCS.md` | Must stay in sync; update both. |
| `obsidian/translations/en.yaml` | Always valid YAML; keys match `config.yaml` options. |

---

## Testing

Testing should cover multiple architectures:

* **Dev-container (amd64)** – Mandatory
* **Raspberry Pi 4 (aarch64)** – Mandatory
* **x86-64 VM** – Mandatory
* **Pi 3 / armv7** – Optional but desirable

Record pass/fail and resource metrics in `/TESTS.md`.

---

## Sensitive actions

| Action | Allowed by | Procedure |
|--------|-----------|-----------|
| Bumping `version` | Release workflow only | Workflow keeps `image:` untagged; never bump manually. |
| Enabling `full_access` | Explicit approval only | Must include detailed security rationale in PR. |

---

## Style guide (documentation)

* Use sentence-case headings (`## Accessing Obsidian`)
* Wrap commands / paths in back-ticks.
* Keep line length ≤ 120 chars.
* Prefer ISO dates (`YYYY-MM-DD`)
