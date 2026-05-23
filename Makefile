SKILLS_DIR := $(CURDIR)/skills
CLAUDE_SKILLS := $(HOME)/.claude/skills
CODEX_SKILLS := $(HOME)/.codex/skills

SKILLS := $(notdir $(wildcard $(SKILLS_DIR)/*))

.PHONY: link unlink status clean

link:
	@for skill in $(SKILLS); do \
		for target in $(CLAUDE_SKILLS) $(CODEX_SKILLS); do \
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
		for target in $(CLAUDE_SKILLS) $(CODEX_SKILLS); do \
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
		for target in $(CLAUDE_SKILLS) $(CODEX_SKILLS); do \
			if [ -L "$$target/$$skill" ]; then \
				echo "  ✓ $$target/$$skill -> $$(readlink $$target/$$skill)"; \
			elif [ -e "$$target/$$skill" ]; then \
				echo "  ✗ $$target/$$skill (exists, not a symlink)"; \
			else \
				echo "  - $$target/$$skill (not installed)"; \
			fi; \
		done; \
	done

clean: unlink
