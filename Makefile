SKILLS_DIR := $(CURDIR)/skills
AGENTS_SKILLS := $(HOME)/.agents/skills
CLAUDE_SKILLS := $(HOME)/.claude/skills
LEGACY_CODEX_SKILLS := $(HOME)/.codex/skills

.PHONY: link unlink status validate clean

link unlink status:
	@ruby scripts/manage_links.rb $@ "$(AGENTS_SKILLS)" "$(CLAUDE_SKILLS)" "$(LEGACY_CODEX_SKILLS)"

validate:
	@ruby scripts/validate_skills.rb
	@ruby scripts/manage_links_test.rb
	@set -e; for script in $$(find skills -type f \( -name '*.js' -o -name '*.mjs' \)); do \
		node --check "$$script"; \
	done
	@bash -n skills/write-technical-acceptance-report/scripts/collect-repo-evidence.sh

clean: unlink
