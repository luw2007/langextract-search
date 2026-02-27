# langextract-search

本项目将「搜索」与「结构化提取」串起来，默认流程为：

1. 搜索：智谱网络搜索（可选） + DuckDuckGo（可选） + 火山联网问答（可选）
2. 提取：将搜索内容拼接后，调用 `langextract` 配置的模型做结构化提取
3. 落盘：把搜索结果、提取结果与摘要写入 `output/`

入口脚本： [search.py](langextract-search/scripts/search.py)  
核心配置： `conf.json`（可参考 [conf.json.example](langextract-search/conf.json.example)）

## 快速开始

在 `scripts/` 目录执行：

```bash
python search.py "Claude Code" --verbose
```

## 配置说明（conf.json）

整体结构（按需开启/关闭）：

- `langextract`：结构化提取模型配置（本仓库重点）
- `zhipu_search`：智谱网络搜索（zai-sdk web_search）
- `duckduckgo_search`：DuckDuckGo 搜索（ddgs）
- `volcengine_search`：火山联网问答（可选）

### langextract：切换不同 Provider

`langextract` 的请求方式是 OpenAI Chat Completions 风格：向 `${baseUrl}/chat/completions` 发起请求。

目前已验证可用的 `provider`：

| provider | 说明 | model 示例 | baseUrl 示例 |
|---|---|---|---|
| `volcengine_coding` | 火山方舟 Coding（豆包/兼容 OpenAI SDK） | `doubao-seed-2-0-code` | `https://ark.cn-beijing.volces.com/api/coding/v3` |
| `zhipu_coding` | 智谱 Chat Completions | `glm-4-flash` | `https://open.bigmodel.cn/api/paas/v4` |

说明：

- `provider` 主要用于选择默认的 API Key 来源（见下文 apiKey 规则）。
- `model`/`baseUrl` 决定实际调用哪个厂商/哪个模型。

### apiKey：支持「env key」与「字符串 key」

所有包含 `apiKey` 的配置项都支持以下两种写法：

1. **直接写真实 Key**：`"apiKey": "sk-xxxx"`
2. **写环境变量名（env key）**：`"apiKey": "VOLCENGINE_API_KEY"`

解析规则：

- 如果 `apiKey` 是一个字符串，且同名环境变量存在，则会使用环境变量的值
- 如果找不到同名环境变量，则把该字符串当作“真实 key”直接使用
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

### zhipu_search：启用与限流注意

`zhipu_search.enabled=false` 时会跳过智谱搜索，仅使用其它搜索源。

注意：智谱搜索返回的内容可能很长，随后再调用智谱 `chat/completions` 时可能触发 429（TPM/频控）。项目在提取阶段做了内容长度截断（默认 15000 字符）来降低触发概率。

## 已支持的 Provider（代码层）

除 `search.py` 的 `provider` 配置外，本仓库还包含 langextract 的多模型封装（供扩展使用）：

- [langextract_wrap.py](langextract-search/scripts/langextract_wrap.py)
  - 智谱类：`^glm` / `^zhipu`
  - 火山/豆包/Kimi：`^doubao` / `^volcengine` / `^kimi`

