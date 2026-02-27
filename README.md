# langextract-search

集成智谱搜索 + DuckDuckGo 搜索 + 火山引擎联网问答 + 多模型结构化提取的完整工作流。

## 功能特性

- 🔍 **智谱 AI 搜索**: 使用智谱 zai-sdk 进行网络搜索
- 🌐 **DuckDuckGo 搜索**: 备用搜索引擎（支持多后端：Bing/Google/Brave 等）
- 🌋 **火山引擎联网问答**: 火山引擎 Agent API 联网搜索（可选）
- 📝 **多模型提取**: 支持 OpenAI 兼容协议（豆包、智谱、OpenAI 等）
- 🔄 **完整工作流**: 搜索 → 提取 → 保存，一键完成
- ⚙️ **灵活配置**: 支持时间过滤、地区设置、代理等高级参数

## 目录结构

```
langextract-search/
├── langextract-search/        # 核心代码目录
│   ├── scripts/
│   │   ├── search.py          # 主搜索脚本
│   │   └── langextract_wrap.py # 多模型 Provider 封装
│   ├── references/
│   │   ├── search-params.md   # 搜索参数配置详解
│   │   └── workflow-details.md # 工作流详细说明
│   ├── conf.json.example      # 配置文件示例
│   └── SKILL.md               # Skill 文档
├── output/                    # 输出目录（运行时生成）
├── CHANGELOG.md
├── LICENSE
├── Makefile
└── README.md
```

## 快速开始

### 1. 安装依赖

```bash
pip install requests ddgs zai langextract openai
```

### 2. 配置

复制配置文件示例并填入 API Key：

```bash
cp langextract-search/conf.json.example langextract-search/conf.json
```

配置说明见下方「配置详解」部分。

### 3. 运行

```bash
cd langextract-search/scripts
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

### 启用火山引擎联网问答

```bash
python search.py "搜索关键词" --volcengine
```

### 仅使用火山引擎搜索

```bash
python search.py "搜索关键词" --volcengine-only
```

### 所有选项

```bash
python search.py --help
```

## 配置详解（conf.json）

整体结构（按需开启/关闭）：

- `langextract`：结构化提取模型配置
- `zhipu_search`：智谱网络搜索（zai-sdk web_search）
- `duckduckgo_search`：DuckDuckGo 搜索（ddgs）
- `volcengine_search`：火山引擎联网问答（可选）
- `extraction`：提取配置（内容长度限制等）

### langextract：切换不同 Provider

`langextract` 使用 OpenAI Chat Completions 风格 API：向 `${baseUrl}/chat/completions` 发起请求。

已验证可用的 `provider`：

| provider            | 说明                                    | model 示例             | baseUrl 示例                                      |
| ------------------- | --------------------------------------- | ---------------------- | ------------------------------------------------- |
| `volcengine_coding` | 火山方舟 Coding（豆包/兼容 OpenAI SDK） | `doubao-seed-2-0-code` | `https://ark.cn-beijing.volces.com/api/coding/v3` |
| `volcengine`        | 火山方舟标准版                          | `doubao-pro-32k`       | `https://ark.cn-beijing.volces.com/api/v3`        |
| `zhipu`             | 智谱 Chat Completions                   | `glm-4-flash`          | `https://open.bigmodel.cn/api/paas/v4`            |
| `openai`            | OpenAI 官方 API                         | `gpt-4o-mini`          | `https://api.openai.com/v1`                       |

### apiKey：支持「env key」与「字符串 key」

所有包含 `apiKey` 的配置项都支持以下写法：

1. **直接写真实 Key**：`"apiKey": "sk-xxxx"`
2. **写环境变量名（env key）**：`"apiKey": "VOLCENGINE_API_KEY"`

解析规则：

- 如果 `apiKey` 是一个字符串，且同名环境变量存在，则使用环境变量的值
- 如果找不到同名环境变量，则把该字符串当作"真实 key"直接使用
- 也支持 `"$VAR"` / `"${VAR}"` 形式引用环境变量

示例：

```json
{
  "langextract": {
    "provider": "volcengine_coding",
    "model": "doubao-seed-2-0-code",
    "baseUrl": "https://ark.cn-beijing.volces.com/api/coding/v3",
    "apiKey": "VOLCENGINE_API_KEY"
  }
}
```

### 搜索配置

| 搜索引擎     | 默认结果数 | 时间过滤 | 其他            |
| ------------ | ---------- | -------- | --------------- |
| 智谱搜索     | 15 条      | 不限     | search_pro 引擎 |
| DuckDuckGo   | 20 条      | 不限     | 自动选择后端    |
| 火山引擎联网 | -          | -        | 需配置 botId    |

自定义配置请参阅：

- [search-params.md](langextract-search/references/search-params.md) - 搜索参数配置详解
- [workflow-details.md](langextract-search/references/workflow-details.md) - 工作流详细说明

## 输出文件

运行后在 `output/` 目录生成：

| 文件名                                        | 说明                          |
| --------------------------------------------- | ----------------------------- |
| `zhipu_search_result_YYYYMMDD_HHMMSS.md`      | 智谱 AI 搜索结果              |
| `duckduckgo_search_result_YYYYMMDD_HHMMSS.md` | DuckDuckGo 搜索结果           |
| `volcengine_search_result_YYYYMMDD_HHMMSS.md` | 火山引擎搜索结果              |
| `extracted_info_YYYYMMDD_HHMMSS.md`           | 提取的结构化信息              |
| `workflow_summary_YYYYMMDD_HHMMSS.md`         | 工作流摘要                    |
| `full_results_YYYYMMDD_HHMMSS.json`           | 完整 JSON（需 `--save-json`） |

## 许可证

本项目采用 **Apache-2.0 License**

| 依赖库                                               | 许可证     | 说明                            |
| ---------------------------------------------------- | ---------- | ------------------------------- |
| [langextract](https://github.com/google/langextract) | Apache-2.0 | Google LLM 结构化提取库（可选） |
| [ddgs](https://github.com/deedy5/ddgs)               | MIT        | DuckDuckGo 元搜索库             |
| [zai](https://pypi.org/project/zai/)                 | MIT        | 智谱 AI 官方 Python SDK         |
| [requests](https://github.com/psf/requests)          | Apache-2.0 | HTTP 请求库                     |
| [openai](https://github.com/openai/openai-python)    | MIT        | OpenAI Python SDK               |
