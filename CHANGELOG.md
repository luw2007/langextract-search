# Changelog

本文件记录项目的所有重要变更。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

## [0.1.0] - 2026-02-27

### Added

- 智谱 AI 搜索集成（zai-sdk）
- DuckDuckGo 备用搜索支持
- 多模型结构化提取（豆包 ARK、智谱 GLM）
- 完整搜索工作流：搜索 → 提取 → 保存
- 支持火山引擎 ARK Coding Plan 和标准按量付费两种模式
- 命令行参数支持（--verbose、--save-json、--ddg-max-results）
- 自动保存搜索结果、提取信息和工作流摘要

### 文件结构

- `scripts/search.py` - 主搜索脚本
- `scripts/langextract_wrap.py` - 多模型 Provider 封装

---

<!-- 版本链接 -->
[Unreleased]: https://github.com/user/langextract-search/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/user/langextract-search/releases/tag/v0.1.0
