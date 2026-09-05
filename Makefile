SKILLS_DIR := $(CURDIR)/skills
AGENTS_SKILLS := $(HOME)/.agents/skills
CLAUDE_SKILLS := $(HOME)/.claude/skills

SKILLS := $(notdir $(wildcard $(SKILLS_DIR)/*))

.PHONY: link unlink status validate clean

link:
	@for skill in $(SKILLS); do \
		for target in $(AGENTS_SKILLS) $(CLAUDE_SKILLS); do \
			if [ -L "$$target/$$skill" ]; then \
				echo "skip  $$target/$$skill (already linked)"; \
			elif [ -e "$$target/$$skill" ]; then \
				echo "WARN  $$target/$$skill exists and is not a symlink, skipping"; \
			else \
				mkdir -p "$$target"; \
				ln -s "$(SKILLS_DIR)/$$skill" "$$target/$$skill"; \
				echo "link  $$target/$$skill -> $(SKILLS_DIR)/$$skill"; \
			fi; \
		done; \
	done

unlink:
	@for skill in $(SKILLS); do \
		for target in $(AGENTS_SKILLS) $(CLAUDE_SKILLS); do \
			if [ -L "$$target/$$skill" ]; then \
				rm "$$target/$$skill"; \
				echo "rm    $$target/$$skill"; \
			fi; \
		done; \
	done

status:
	@echo "=== Skills ==="
	@for skill in $(SKILLS); do \
		echo ""; \
		echo "$$skill:"; \
		for target in $(AGENTS_SKILLS) $(CLAUDE_SKILLS); do \
			if [ -L "$$target/$$skill" ]; then \
				echo "  ✓ $$target/$$skill -> $$(readlink $$target/$$skill)"; \
			elif [ -e "$$target/$$skill" ]; then \
				echo "  ✗ $$target/$$skill (exists, not a symlink)"; \
			else \
				echo "  - $$target/$$skill (not installed)"; \
			fi; \
		done; \
	done

validate:
	@ruby scripts/validate_skills.rb
	@for script in $$(find skills -path '*/scripts/*.js' -o -path '*/scripts/*.mjs'); do \
		node --check "$$script"; \
	done

clean: unlink
