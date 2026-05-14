---
name: summarize-commit-changes
description: Summarize current repository changes before a git commit. Use when the user asks to commit, prepare a commit, review changes before committing, generate a pre-commit summary, or explicitly requests a summary of staged/current updates with core change points and capability impacts.
---

# Summarize Commit Changes

## Overview

Use this skill before creating a commit to give the user a concise, decision-ready summary of what changed and what capabilities are affected. Prefer staged changes as the commit source of truth; if nothing is staged, summarize the current unstaged worktree changes and clearly say that the summary is based on unstaged changes.

## Workflow

1. Inspect repository state with `git status --short`.
2. If staged changes exist, inspect staged content with `git diff --cached --stat` and targeted `git diff --cached -- <path>` reads.
3. If no staged changes exist, inspect unstaged content with `git diff --stat` and targeted `git diff -- <path>` reads.
4. Include untracked files by reading their paths directly when they are relevant to the requested commit.
5. Summarize behavior and capability impact, not just filenames.
6. Output the summary before running `git commit`. If the user already asked to commit, provide this summary first, then continue with the commit only when the current interaction rules allow it.

## Output Format

Write the response in Chinese by default unless the user asks for another language.

Use exactly these two primary sections:

```markdown
**核心改动点**
一句话概括本次更新最重要的变化和目的。

**所有的能力改动点**
- 能力/模块：<用户能感知到的功能、页面、流程、服务或基础能力>
  改动：<具体做了什么>
  影响面：<影响哪些用户路径、数据、接口、页面、测试、兼容性或风险>
```

Keep the core change sentence to one sentence. The capability list can be detailed, but keep each item focused on one capability or module.

## Summary Rules

- Group low-level file edits into user-facing capabilities when possible.
- Mention new, changed, and removed capabilities separately when they affect different user paths.
- Call out database, API, configuration, dependency, permission, migration, or build-setting changes as their own capability items when present.
- If the change is mostly refactoring, describe the preserved behavior and the affected internal surface.
- If tests or verification changed, include them as a capability item only when they materially affect confidence or coverage.
- If the diff is too large to inspect completely, say which files or areas were sampled and identify the remaining uncertainty.

## Commit Message Hint

When useful, add a short optional `建议 commit message` line after the two required sections. Do not let the commit message replace the required summary.
