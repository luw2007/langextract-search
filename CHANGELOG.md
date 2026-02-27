# Changelog

本文件记录项目的所有重要变更。

格式基于 [Keep a Changelog](https://keepachangelog.com/zh-CN/1.0.0/)，
版本号遵循 [语义化版本](https://semver.org/lang/zh-CN/)。

## [Unreleased]

## [0.1.4] - 2026-02-27

### Added

- 搜索参数配置文档（references/search-params.md）
- 工作流详细说明文档（references/workflow-details.md）
- 智谱搜索高级配置：搜索引擎、结果数、时间过滤、内容长度、域名过滤
- DuckDuckGo 高级配置：地区、安全搜索、时间过滤、后端、代理、超时

### Changed

- 重构 README.md：完整的功能说明、目录结构、配置详解
- 更新 SKILL.md：简化内容，聚焦快速开始
- 增强 conf.json.example：添加详细配置注释
- 优化搜索函数：从配置读取参数，verbose 模式显示完整配置

## [0.1.3] - 2026-02-27

### Changed

- 重构配置管理：移除硬编码配置，强制从 conf.json 读取
- 简化路径获取函数，改为模块级常量
- 修复 README.md 中的本地绝对路径为相对路径

## [0.1.2] - 2026-02-27

### Added

- 火山引擎联网问答搜索支持（volcengine_search）
- `--volcengine` 和 `--volcengine-only` 命令行参数

### Changed

- 优化搜索结果合并逻辑

## [0.1.1] - 2026-02-27

### Added

- 智谱 AI 搜索集成（zai-sdk web_search API）
- 多搜索源支持：智谱 + DuckDuckGo 组合搜索
- 内容长度截断配置（extraction.max_content_length）

### Changed

- 改进 API Key 解析逻辑，支持环境变量引用

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

[Unreleased]: https://github.com/luw2007/langextract-search/compare/v0.1.4...HEAD
[0.1.4]: https://github.com/luw2007/langextract-search/compare/v0.1.3...v0.1.4
[0.1.3]: https://github.com/luw2007/langextract-search/compare/v0.1.2...v0.1.3
[0.1.2]: https://github.com/luw2007/langextract-search/compare/v0.1.1...v0.1.2
[0.1.1]: https://github.com/luw2007/langextract-search/compare/v0.1.0...v0.1.1
[0.1.0]: https://github.com/luw2007/langextract-search/releases/tag/v0.1.0
