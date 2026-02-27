# Makefile for langextract-search skill
# 用于发布到 ClawHub

SKILL_DIR := langextract-search
VERSION := $(shell cat VERSION)
SKILL_SLUG := langextract-search

.PHONY: help version publish dry-run check

help:
	@echo "Usage:"
	@echo "  make version    - 显示当前版本"
	@echo "  make check      - 检查发布前置条件"
	@echo "  make dry-run    - 预览发布信息（不实际发布）"
	@echo "  make publish    - 发布到 ClawHub"

version:
	@echo "当前版本: $(VERSION)"

check:
	@echo "检查发布前置条件..."
	@test -f VERSION || (echo "错误: VERSION 文件不存在" && exit 1)
	@test -d $(SKILL_DIR) || (echo "错误: $(SKILL_DIR) 目录不存在" && exit 1)
	@test -f $(SKILL_DIR)/SKILL.md || (echo "错误: SKILL.md 文件不存在" && exit 1)
	@command -v clawhub >/dev/null 2>&1 || (echo "错误: clawhub CLI 未安装" && exit 1)
	@clawhub whoami >/dev/null 2>&1 || (echo "错误: 未登录 ClawHub，请先执行 clawhub login" && exit 1)
	@echo "检查通过 ✓"

dry-run: check
	@echo "预览发布信息:"
	@echo "  Skill: $(SKILL_SLUG)"
	@echo "  Version: $(VERSION)"
	@echo "  Directory: $(SKILL_DIR)"
	@echo ""
	@echo "发布命令:"
	@echo "  clawhub publish $(SKILL_DIR) --slug $(SKILL_SLUG) --version $(VERSION)"

publish: check
	@echo "发布 $(SKILL_SLUG) v$(VERSION) 到 ClawHub..."
	clawhub publish $(SKILL_DIR) --slug $(SKILL_SLUG) --version $(VERSION)
	@echo "发布完成 ✓"
