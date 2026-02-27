---
name: langextract-search
description: 集成智谱搜索、DuckDuckGo 搜索和多模型结构化提取的完整工作流。
---

# LangExtract Search Skill

集成智谱搜索 + DuckDuckGo 搜索 + 多模型结构化提取的完整工作流。

## 功能特性

- 🔍 **智谱 AI 搜索**: 使用智谱 zai-sdk 进行网络搜索
- 🌐 **DuckDuckGo 搜索**: 备用搜索引擎
- 📝 **多模型提取**: 支持 OpenAI 通用协议
- 🔄 **完整工作流**: 搜索 → 提取 → 保存，一键完成
- 📦 **开箱即用**: 最小依赖（requests、ddgs、zai）

## 前置条件

1. OpenClaw 配置文件（`~/.openclaw/openclaw.json`）
2. Python 3.8+
3. **ddgs**（DuckDuckGo 搜索库）
4. **requests**（HTTP 请求库）
5. 可选 配置 langextrace 处理模型

## 安装

### 1. 安装核心依赖

```bash
pip install requests ddgs langextract
```

#### 2 模型配置

参考 conf.json.example 配置模型

#### 首次使用交互选择

如果未在 `openclaw.json` 中配置 `baseUrl`，首次运行时会自动提示选择套餐类型，选择结果保存到项目 `conf.json` 文件中（该文件仅用于本地运行，需保持不提交/不发布）。

## 快速开始

### 运行搜索

```bash
cd ~/clawd/skills/langextract-search/scripts
python search.py "搜索关键词" --verbose
```

## 使用方法

### 基本用法

```bash
python search.py "搜索关键词"
```

### 验证输入输出（详细模式）

```bash
python search.py "搜索关键词" --verbose
```

### 保存完整 JSON

```bash
python search.py "搜索关键词" --save-json
```

### 自定义 DuckDuckGo 结果数量

```bash
python search.py "搜索关键词" --ddg-max-results 30
```

### 所有选项

```bash
python search.py --help
```

## 工作流说明

### 步骤 1: DuckDuckGo 搜索

**工具**: `ddgs` (Python 库)

**输入**:

- 搜索查询
- 最大结果数（默认 20）

**输出**:

- 搜索结果列表，每条包含：
  - title: 网页标题
  - href: 网页 URL
  - body: 网页摘要

### 步骤 2: LangExtract 结构化提取

**工具**: [langextract](https://github.com/google/langextract)（Google LLM 结构化提取库）

**后端模型**: 可配置，默认 `doubao-seed-2-0-code`（火山引擎 ARK）

**输入**:

- DuckDuckGo 原始搜索结果（不预处理）

**输出**:

- 结构化信息，包含：
  1. 主要内容摘要
  2. 关键点列表（3-5个）
  3. 相关事实或数据
  4. 来源或参考信息

## 输出文件

运行后会在输出目录生成：

1. `duckduckgo_search_result_YYYYMMDD_HHMMSS.md` - DuckDuckGo 搜索结果
2. `extracted_info_YYYYMMDD_HHMMSS.md` - 提取的结构化信息
3. `workflow_summary_YYYYMMDD_HHMMSS.md` - 工作流摘要
4. `full_results_YYYYMMDD_HHMMSS.json` - 完整 JSON 结果（使用 `--save-json`）

## 项目结构

```
langextract-search/
├── SKILL.md                       # 本文件
├── output/                        # 输出目录（忽略，不需要读取）
└── scripts/
    ├── search.py                  # 主脚本
    └── langextract_wrap.py        # 多模型 Provider 封装
```

> **注意**: `output/` 文件夹用于保存搜索结果，不需要在 skills 中显示或读取。

## 故障排除

### DuckDuckGo 搜索失败

- 确保已安装 `ddgs` 库：`pip install ddgs`
- 检查网络连接

### 提取失败

- 检查 API Key 是否有效
- 确认模型可访问
- 查看 `--verbose` 输出了解详细错误
- 确认 `~/.openclaw/openclaw.json` 配置正确

## 许可证

本项目采用 **Apache-2.0 License**

| 依赖库                                               | 许可证     | 说明                            |
| ---------------------------------------------------- | ---------- | ------------------------------- |
| [langextract](https://github.com/google/langextract) | Apache-2.0 | Google LLM 结构化提取库（可选） |
| [ddgs](https://github.com/deedy5/ddgs)               | MIT        | DuckDuckGo 元搜索库             |
| [zai-sdk](https://github.com/zai-org)                | MIT        | 智谱 AI 官方 Python SDK         |
| [requests](https://github.com/psf/requests)          | Apache-2.0 | HTTP 请求库                     |
