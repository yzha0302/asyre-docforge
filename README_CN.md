<div align="center">

# Asyre DocForge

> *AI Agent 用 Markdown 思考，但现实世界只认 PDF 和 Word。*

![License](https://img.shields.io/badge/License-MIT-blue)
![Shell](https://img.shields.io/badge/Shell-Bash-green)
![Presets](https://img.shields.io/badge/%E9%A2%84%E8%AE%BE-21-brightgreen)
![CJK](https://img.shields.io/badge/%E4%B8%AD%E6%96%87-Native-orange)

**[English](README.md)** · **[中文](#为什么做这个)**

</div>

---

## 为什么做这个

每个 AI Agent — Claude、GPT、Copilot — 输出的都是 Markdown。但客户要的是 APA 论文、商业提案、法律合同、医疗报告。

通常的路径是：Agent 写好 Markdown → 人工打开 Word → 花 30 分钟调格式 → 导出 PDF。每次都这样。

或者更糟：在 prompt 里花 500 个 token 告诉 AI「用 12pt Times New Roman，双倍行距，1 英寸边距，页眉左对齐放标题缩写……」。结果 AI 还经常格式不对。

**DocForge 把这个环节消灭了。**

21 个内置预设，覆盖学术论文、商务文档、法律文书、医疗报告、政府公文等。每个预设把格式规范（字体、字号、行距、边距、页眉页脚）全部编码好了。一条命令搞定。

```bash
docforge -p apa paper.md           # APA 第七版论文
docforge -p contract terms.md      # 带条款编号的法律合同
docforge -p proposal plan.md       # 带保密标记的商业提案
```

Agent 只管写内容，格式的事交给预设。**零格式化 token。**

## 解决了什么问题

| 没有 DocForge | 有 DocForge |
|--------------|-------------|
| Agent 写 Markdown → 人工调格式 → 导出 | Agent 写 Markdown → `docforge -p preset` → 完成 |
| 每次 prompt 花 500+ token 描述格式 | 0 个格式化 token |
| 每种文档类型格式不同，手动处理 | 一个工具，21 个预设 |
| PDF 导出中文变方块 | 中文开箱即用 |
| 装 LaTeX 模板是噩梦 | `git clone` + `./install.sh` |

<div align="center">

### 同一份 Markdown，三种不同输出

<img src="assets/apa.png" width="30%" /> <img src="assets/proposal.png" width="30%" /> <img src="assets/eisvogel.png" width="30%" />

*APA 学术论文 · 商业提案 · Eisvogel 封面页*

</div>

## 预设一览

```bash
docforge --list-presets
```

### 学术论文

| 预设 | 格式 | 字体 | 字号 | 行距 | 适用领域 |
|------|------|------|------|------|---------|
| `apa` | APA 第七版 | Times New Roman | 12pt | 双倍 | 心理学、社会科学 |
| `harvard` | Harvard | Times New Roman | 12pt | 1.5 倍 | 英澳高校 |
| `mla` | MLA 第九版 | Times New Roman | 12pt | 双倍 | 人文、文学 |
| `chicago` | Chicago | Times New Roman | 12pt | 双倍 | 历史、艺术 |
| `ieee` | IEEE | Times New Roman | 10pt | 单倍 | 工程、计算机 |
| `vancouver` | Vancouver | Times New Roman | 12pt | 双倍 | 医学、生物 |

### 行业文档

| 预设 | 类型 | 字体 | 特点 |
|------|------|------|------|
| `proposal` | 商业提案 / 项目报告 | Arial 12pt | 1.5 倍行距，底部保密标记 |
| `meeting` | 会议纪要 | Arial 11pt | 紧凑简洁 |
| `memo` | 备忘录 | Arial 11pt | 极简，适合单页 |
| `tech-doc` | 技术文档 / API 文档 | Arial 11pt | 带页眉标记 |
| `release-notes` | 发布说明 | Arial 11pt | 单倍行距 |
| `contract` | 合同 / NDA | TNR 12pt | 条款编号，页码 X/Y |
| `legal-brief` | 法律摘要 | TNR 12pt | 双倍行距，首行缩进 |
| `finance` | 财务 / 审计报告 | Arial 10pt | 紧凑，带页眉 |
| `invoice` | 发票 | Arial 10pt | 单倍行距 |
| `medical` | 医疗报告 | Arial 11pt | 底部保密警告 |
| `government` | 政策文件 / 招标 | Arial 12pt | 层级编号（1.1.1） |
| `brand` | 品牌指南 | Arial 11pt | 大标题 |
| `marketing` | 营销方案 | Arial 11pt | 标准商务 |
| `syllabus` | 教学大纲 | TNR 11pt | 学术标准 |
| `lesson-plan` | 教案 | Arial 11pt | 紧凑实用 |

### 字体和通用预设

| 预设 | 说明 |
|------|------|
| `kaiti` | 楷体（文鼎楷体）— 传统文雅 |
| `songti` | 宋体 — 正式、书籍 |
| `heiti` | 黑体 — 现代简洁 |
| `pingfang` | 苹方（默认）— 屏幕优化 |
| `hiragino` | 冬青黑体 — 日式简约 |
| `essay` | 论文/作文（宋体 12pt，宽边距） |
| `report` | 通用报告（苹方 11pt） |
| `book` | 书籍排版（宋体 11pt，宽边距） |
| `slides` | 大字演示（14pt，窄边距） |
| `compact` | 省纸紧凑（9pt，窄边距） |
| `code` | 代码文档（10pt，暗色高亮） |

## 使用方法

```bash
docforge [选项] <input.md> [output.pdf|docx]
```

### 基本用法

```bash
docforge -p apa paper.md              # → paper.pdf
docforge -p apa --word paper.md       # → paper.docx
docforge -p apa paper.md paper.docx   # → paper.docx（自动识别扩展名）
```

### Eisvogel 模式 — 专业封面页

```bash
docforge --eisvogel \
  --title "Q4 财务报告" \
  --author "财务团队" \
  --titlepage \
  --titlepage-color "06386e" \
  report.md
```

### 预设 + Eisvogel 组合

```bash
docforge -p apa --eisvogel --title "研究论文" --titlepage paper.md
```

### 自定义字体和排版

```bash
docforge -f "Songti SC" -s 12pt --margin 3cm --toc document.md
```

### 所有参数

| 参数 | 默认值 | 说明 |
|------|--------|------|
| `-p, --preset` | — | 预设名称 |
| `-w, --word` | — | 强制 Word 输出 |
| `-f, --font` | PingFang SC | 正文字体 |
| `-m, --mono` | Heiti SC | 代码字体 |
| `-s, --fontsize` | 11pt | 字号 |
| `--margin` | 2.5cm | 页边距 |
| `--theme` | tango | 代码高亮主题 |
| `-t, --toc` | — | 生成目录 |
| `--numbersections` | — | 章节编号 |
| `--eisvogel` | — | Eisvogel 模板 |
| `--title` | — | 文档标题 |
| `--author` | — | 作者 |
| `--date` | 今天 | 日期 |
| `--titlepage` | — | 封面页 |
| `--titlepage-color` | — | 封面背景色（十六进制） |
| `--logo` | — | 封面 Logo 图片 |
| `--list-presets` | — | 显示所有预设 |
| `--list-fonts` | — | 显示可用中文字体 |

代码高亮主题：`tango` · `pygments` · `kate` · `monochrome` · `espresso` · `zenburn` · `haddock` · `breezedark`

## 应用场景

### 1. AI Agent 写研究报告，一键交付

Agent 调研完一个课题，产出 Markdown 草稿。不需要让 Agent 处理排版（浪费 token 且不稳定），直接交给 DocForge：

```bash
# Agent 输出 paper.md
docforge -p apa --toc paper.md
# → 符合 APA 规范的论文，带目录
```

### 2. 自动化客户周报

数据管道每周生成指标，脚本包装成 Markdown，DocForge 转成带封面的 PDF：

```bash
python3 generate_report.py > /tmp/weekly.md
docforge -p proposal --eisvogel \
  --title "每周运营报告" \
  --author "数据团队" \
  --titlepage \
  /tmp/weekly.md /tmp/weekly.pdf
```

### 3. 法律文档生成

Agent 从模板起草合同条款，DocForge 自动应用法律格式 — 编号条款、Times New Roman、页码 X/Y：

```bash
docforge -p contract draft.md contract.pdf
```

### 4. 一份内容，两种格式

客户要 PDF 审阅，也要 Word 方便修改：

```bash
docforge -p proposal report.md report.pdf
docforge -p proposal report.md report.docx
```

### 5. 学术论文投稿

用 Markdown 写论文，按目标期刊/会议要求导出：

```bash
docforge -p ieee --numbersections paper.md    # 计算机会议
docforge -p apa paper.md                       # 心理学期刊
docforge -p chicago paper.md                   # 历史课作业
```

### 6. 医疗/临床文档

Agent 生成临床摘要，DocForge 自动加上保密标记：

```bash
docforge -p medical summary.md
# 页脚自动添加: "Confidential — Medical Record"
```

### 7. 教学材料

教师用 Markdown 备课，一键生成标准教案或大纲：

```bash
docforge -p syllabus --toc course.md
docforge -p lesson-plan lesson.md
```

## 与 Asyre 技能生态的配合

DocForge 定位是 Agent 流水线的**最后一公里**。它和其他 [Asyre](https://github.com/yzha0302) 技能的关系：

| 上游技能 | 它做什么 | → DocForge 做什么 |
|---------|---------|-------------------|
| **writing-engine** | 从一个观点出发写长文 | `→ docforge -p essay` 排版成正式文章 |
| **paper-reader** | 拆解学术论文的核心思想 | `→ docforge -p apa` 输出带格式的阅读笔记 |
| **asyre-search** | 跨 21+ 平台社媒数据分析 | `→ docforge -p report` 生成客户交付报告 |
| **summarize** | 总结 URL、播客、视频 | `→ docforge -p memo` 生成团队简报 |
| **slide-deck** | 生成演示幻灯片 | DocForge 输出配套的文字报告 |
| **format-markdown** | 美化原始 Markdown | `→ docforge -p <any>` 最终输出 |
| **html-to-pdf** | HTML 转 PDF（WeasyPrint） | DocForge 走 LaTeX 路线，排版更精确 |
| **nano-pdf** | 自然语言编辑已有 PDF | DocForge 从 Markdown 生成新 PDF |
| **ship-to-github** | 发布项目到 GitHub | 发布 DocForge 本身 |

### 完整流水线示例：调研 → 报告 → 交付

```bash
# 1. paper-reader 读论文，输出 analysis.md
# 2. writing-engine 展开写分析，输出 report.md
# 3. DocForge 格式化交付

docforge -p proposal --eisvogel \
  --title "AI 教育行业竞品分析" \
  --author "调研团队" \
  --titlepage \
  report.md report.pdf

# 4. 发给客户
```

## 安装

```bash
git clone https://github.com/yzha0302/asyre-docforge.git
cd asyre-docforge
chmod +x docforge.sh install.sh
./install.sh    # 创建符号链接到 /usr/local/bin/docforge
```

### 依赖

**macOS:**
```bash
brew install pandoc
brew install --cask mactex   # 或用 TinyTeX 更轻量
```

**Ubuntu/Debian:**
```bash
sudo apt install pandoc texlive-xetex texlive-lang-chinese
```

### Eisvogel 模板（可选）

```bash
curl -fsSL -o /tmp/eisvogel.tar.gz \
  https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v3.4.0/Eisvogel.tar.gz
tar xzf /tmp/eisvogel.tar.gz -C /tmp
mkdir -p ~/.local/share/pandoc/templates
cp /tmp/Eisvogel-3.4.0/eisvogel.latex ~/.local/share/pandoc/templates/
```

## 给 Agent 开发者

DocForge 是你流水线末端的一行调用：

```python
import subprocess

# Agent 生成 markdown
markdown = agent.run("写一份项目提案...")
with open("/tmp/output.md", "w") as f:
    f.write(markdown)

# 一行命令，格式化完成
subprocess.run(["docforge", "-p", "proposal", "/tmp/output.md", "/tmp/output.pdf"])
```

Agent 不需要知道任何排版知识。不花额外 token。不会格式不一致。预设搞定一切。

## 原理

```
Markdown → Pandoc → LaTeX（XeLaTeX + CJK）→ PDF
Markdown → Pandoc → reference.docx 样式   → Word
```

每个预设是一个 LaTeX 头文件（`header.tex`），定义了：字体（英文 + 中文）、字号、行距、边距、页眉页脚、标题样式、段落缩进。

Word 输出使用 `reference.docx` 参考模板，预配置了对应的段落样式。

## License

MIT

---

<div align="center">

**让 Agent 专注写作，让 DocForge 处理排版。**

![Asyre DocForge](https://img.shields.io/badge/Asyre-DocForge-black?style=for-the-badge)

</div>
