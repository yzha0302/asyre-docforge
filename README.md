<div align="center">

# Asyre DocForge

> *AI agents think in Markdown. The world runs on PDF and Word.*

![License](https://img.shields.io/badge/License-MIT-blue)
![Shell](https://img.shields.io/badge/Shell-Bash-green)
![Presets](https://img.shields.io/badge/Presets-21-brightgreen)
![CJK](https://img.shields.io/badge/CJK-Native-orange)

**[English](#why)** · **[中文](README_CN.md)**

</div>

---

## Why

Every AI agent outputs Markdown. Every client expects a formatted PDF or Word doc.

The gap between "agent wrote it" and "client can read it" is usually 30 minutes of manual formatting — picking the right font, adjusting margins, adding headers, exporting. Every. Single. Time.

DocForge closes that gap. 21 built-in presets covering academic, business, legal, medical, government, and more. Each preset encodes the exact formatting spec for its document type. One command, done.

```bash
docforge -p apa paper.md           # APA 7th edition paper
docforge -p contract terms.md      # Legal contract with clause numbering
docforge -p proposal plan.md       # Business proposal with confidentiality footer
```

No token-heavy prompts telling the AI to "use 12pt Times New Roman, double spacing, 1-inch margins, running head flush left..." The template already knows.

## What It Solves

| Without DocForge | With DocForge |
|------------------|---------------|
| Agent writes Markdown → human formats in Word → exports PDF | Agent writes Markdown → `docforge -p preset` → done |
| 500+ tokens describing formatting in every prompt | 0 formatting tokens — preset handles it |
| Different formatting for every document type | One tool, 21 presets |
| CJK characters break in PDF export | CJK works out of the box |
| Installing LaTeX templates is a nightmare | `git clone` + `./install.sh` |

<div align="center">

### One Markdown file. Three different outputs.

<img src="assets/apa.png" width="30%" /> <img src="assets/proposal.png" width="30%" /> <img src="assets/eisvogel.png" width="30%" />

*APA academic paper · Business proposal · Eisvogel cover page*

</div>

## Presets

```bash
docforge --list-presets
```

### Academic Papers

| Preset | Style | Font | Size | Spacing | Use Case |
|--------|-------|------|------|---------|----------|
| `apa` | APA 7th | Times New Roman | 12pt | Double | Psychology, social sciences |
| `harvard` | Harvard | Times New Roman | 12pt | 1.5x | UK/AU universities |
| `mla` | MLA 9th | Times New Roman | 12pt | Double | Humanities, literature |
| `chicago` | Chicago | Times New Roman | 12pt | Double | History, arts |
| `ieee` | IEEE | Times New Roman | 10pt | Single | Engineering, CS |
| `vancouver` | Vancouver | Times New Roman | 12pt | Double | Medicine, biomedical |

### Industry Documents

| Preset | Type | Font | Details |
|--------|------|------|---------|
| `proposal` | Business proposal / project report | Arial 12pt | 1.5x spacing, confidentiality footer |
| `meeting` | Meeting minutes | Arial 11pt | Compact, clean |
| `memo` | Company memo | Arial 11pt | Minimal, single-page friendly |
| `tech-doc` | Technical / API documentation | Arial 11pt | Page header, structured headings |
| `release-notes` | Release notes / changelog | Arial 11pt | Single spacing, tight layout |
| `contract` | Contracts / NDA | Times New Roman 12pt | Numbered clauses, page X/Y footer |
| `legal-brief` | Legal briefs | Times New Roman 12pt | Double spacing, first-line indent |
| `finance` | Financial / audit reports | Arial 10pt | Compact, header with label |
| `invoice` | Invoices | Arial 10pt | Single spacing, clean |
| `medical` | Medical / clinical reports | Arial 11pt | Confidentiality warning in footer |
| `government` | Policy / tender documents | Arial 12pt | Hierarchical numbering (1.1.1) |
| `brand` | Brand guidelines | Arial 11pt | Large headings |
| `marketing` | Marketing plans | Arial 11pt | Standard business |
| `syllabus` | Course syllabus | Times New Roman 11pt | Academic standard |
| `lesson-plan` | Lesson plans | Arial 11pt | Compact, practical |

### Font & General Presets

| Preset | Description |
|--------|-------------|
| `kaiti` | Chinese calligraphy (AR PL KaitiM GB) |
| `songti` | Song typeface — formal, books |
| `heiti` | Hei typeface — modern, clean |
| `pingfang` | PingFang SC (default) — screen-optimized |
| `hiragino` | Hiragino Sans GB — Japanese-influenced |
| `essay` | Essay/composition (Songti 12pt, wide margins) |
| `report` | General report (PingFang 11pt) |
| `book` | Book layout (Songti 11pt, wide margins) |
| `slides` | Large text for presentations (14pt, narrow margins) |
| `compact` | Space-saving (9pt, narrow margins) |
| `code` | Code-heavy docs (10pt, dark highlight theme) |

## Usage

```bash
docforge [options] <input.md> [output.pdf|docx]
```

### Output format

```bash
docforge -p apa paper.md              # → paper.pdf (default)
docforge -p apa --word paper.md       # → paper.docx
docforge -p apa paper.md paper.docx   # → paper.docx (auto-detect)
```

### Eisvogel mode — professional cover pages

```bash
docforge --eisvogel \
  --title "Q4 Financial Report" \
  --author "Finance Team" \
  --titlepage \
  --titlepage-color "06386e" \
  report.md
```

### Combine preset + Eisvogel

```bash
docforge -p apa --eisvogel --title "Research Paper" --titlepage paper.md
```

### All flags

| Flag | Default | Description |
|------|---------|-------------|
| `-p, --preset` | — | Preset name |
| `-w, --word` | — | Force Word output |
| `-f, --font` | PingFang SC | Body font |
| `-m, --mono` | Heiti SC | Code font |
| `-s, --fontsize` | 11pt | Font size |
| `--margin` | 2.5cm | Page margins |
| `--theme` | tango | Code highlight theme |
| `-t, --toc` | — | Table of contents |
| `--numbersections` | — | Number sections |
| `--eisvogel` | — | Eisvogel template |
| `--title` | — | Document title |
| `--author` | — | Author |
| `--date` | today | Date |
| `--titlepage` | — | Cover page |
| `--titlepage-color` | — | Cover background (hex) |
| `--titlepage-text-color` | FFFFFF | Cover text color |
| `--logo` | — | Cover logo image |
| `--list-presets` | — | Show all presets |
| `--list-fonts` | — | Show CJK fonts |

Code highlight themes: `tango` · `pygments` · `kate` · `monochrome` · `espresso` · `zenburn` · `haddock` · `breezedark`

## Scenarios

### 1. AI agent writes a research paper

Your agent researches a topic and produces a Markdown draft. Instead of asking the agent to also handle formatting (wasting tokens and getting inconsistent results), pipe the output through DocForge:

```bash
# Agent outputs paper.md
docforge -p apa --toc paper.md
# → Correctly formatted APA paper with table of contents
```

### 2. Automated client reporting

A data pipeline generates weekly metrics. A script wraps them in Markdown, DocForge converts to a branded PDF:

```bash
python3 generate_report.py > /tmp/weekly.md
docforge -p proposal --eisvogel \
  --title "Weekly Performance Report" \
  --author "Analytics Team" \
  --titlepage \
  /tmp/weekly.md /tmp/weekly.pdf
```

### 3. Legal document generation

An agent drafts contract terms from a template. DocForge applies proper legal formatting — numbered clauses, Times New Roman, page X/Y footer:

```bash
docforge -p contract draft.md contract.pdf
```

### 4. Multi-format delivery

Client wants both PDF for review and Word for editing:

```bash
docforge -p proposal report.md report.pdf
docforge -p proposal report.md report.docx
```

### 5. Academic paper submission

Student writes in Markdown, submits in the required format:

```bash
docforge -p ieee --numbersections paper.md    # For a CS conference
docforge -p apa paper.md                      # For a psychology journal
docforge -p chicago paper.md                  # For a history class
```

### 6. Medical / clinical documentation

Agent generates a clinical summary. DocForge adds the confidentiality footer automatically:

```bash
docforge -p medical summary.md
# Footer: "Confidential — Medical Record"
```

## Integration with Asyre Skills

DocForge is designed as the **last mile** in an agent pipeline. It pairs with other [Asyre](https://github.com/yzha0302) skills:

| Upstream Skill | What it does | → DocForge |
|----------------|-------------|------------|
| **writing-engine** | Writes long-form articles from a thesis | `→ docforge -p essay` |
| **paper-reader** | Extracts ideas from academic papers | `→ docforge -p apa` for annotated summary |
| **asyre-search** | Cross-platform social media data analysis | `→ docforge -p report` for client deliverable |
| **summarize** | Summarizes URLs, podcasts, videos | `→ docforge -p memo` for team briefing |
| **slide-deck** | Generates presentation slides | DocForge handles the written report companion |
| **format-markdown** | Beautifies raw Markdown | `→ docforge -p <any>` for final output |
| **ship-to-github** | Publishes projects to GitHub | Ships DocForge itself |

### Example pipeline: Research → Report → Deliver

```bash
# 1. Agent reads a paper
#    paper-reader → outputs analysis.md

# 2. DocForge formats it
docforge -p proposal --eisvogel \
  --title "Competitive Analysis: AI in Education" \
  --author "Research Team" \
  --titlepage \
  analysis.md analysis.pdf

# 3. Done — send to client
```

## Install

```bash
git clone https://github.com/yzha0302/asyre-docforge.git
cd asyre-docforge
chmod +x docforge.sh install.sh
./install.sh    # symlinks to /usr/local/bin/docforge
```

### Dependencies

**macOS:**
```bash
brew install pandoc
brew install --cask mactex   # or TinyTeX for lighter install
```

**Ubuntu/Debian:**
```bash
sudo apt install pandoc texlive-xetex texlive-lang-chinese
```

### Eisvogel template (optional)

```bash
curl -fsSL -o /tmp/eisvogel.tar.gz \
  https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v3.4.0/Eisvogel.tar.gz
tar xzf /tmp/eisvogel.tar.gz -C /tmp
mkdir -p ~/.local/share/pandoc/templates
cp /tmp/Eisvogel-3.4.0/eisvogel.latex ~/.local/share/pandoc/templates/
```

## For Agent Builders

DocForge is a single shell call at the end of your pipeline:

```python
import subprocess

# Your agent generates markdown
markdown = agent.run("Write a project proposal for ...")
with open("/tmp/output.md", "w") as f:
    f.write(markdown)

# One line — formatted PDF
subprocess.run(["docforge", "-p", "proposal", "/tmp/output.md", "/tmp/output.pdf"])
```

The agent doesn't need to know anything about formatting. No extra tokens. No inconsistent output. The preset handles everything.

## How It Works

```
Markdown → Pandoc → LaTeX (XeLaTeX + CJK) → PDF
Markdown → Pandoc → reference.docx styles  → Word
```

Each preset is a LaTeX header file (`header.tex`) that defines:
- Font family (English + CJK)
- Font size
- Line spacing
- Page margins
- Header/footer content
- Section heading styles
- Paragraph indentation

For Word output, academic presets include a `reference.docx` with pre-configured styles.

## License

MIT

---

<div align="center">

**Let agents write. Let DocForge format.**

![Asyre DocForge](https://img.shields.io/badge/Asyre-DocForge-black?style=for-the-badge)

</div>
