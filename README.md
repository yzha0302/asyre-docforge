<div align="center">

# Asyre DocForge

> *"Write in Markdown. Ship in any format."*

![License](https://img.shields.io/badge/License-MIT-blue)
![Shell](https://img.shields.io/badge/Shell-Bash-green)
![Presets](https://img.shields.io/badge/Presets-21-brightgreen)
![CJK](https://img.shields.io/badge/CJK-First%20Class-orange)

<br>

**Still hand-formatting Word documents for every client?**

**Wasting hours tweaking LaTeX margins for each paper format?**

**Can't get Chinese to render in your PDFs?**

<br>

### One command. 21 presets. PDF & Word. CJK out of the box.

<br>

[**Quick Start**](#quick-start) · [**Presets**](#presets) · [**Usage**](#usage) · [**Install**](#install)

</div>

<br>

---

## What It Does

Asyre DocForge converts Markdown files to beautifully formatted **PDF** and **Word** documents with a single command. It ships with **21 built-in presets** covering academic papers, business documents, legal contracts, and more — all with first-class Chinese/CJK support.

```
Markdown → Pandoc → LaTeX/XeLaTeX → PDF
Markdown → Pandoc → reference.docx → Word
```

## Presets

| Category | Presets | Details |
|----------|---------|---------|
| **Fonts** | `kaiti` `songti` `heiti` `pingfang` `hiragino` | 5 Chinese font presets |
| **General** | `essay` `report` `book` `slides` `compact` `code` | 6 scenario presets |
| **Academic** | `apa` `harvard` `mla` `chicago` `ieee` `vancouver` | 6 paper formats |
| **Business** | `proposal` `meeting` `memo` | Reports, minutes, memos |
| **Tech** | `tech-doc` `release-notes` | API docs, changelogs |
| **Legal** | `contract` `legal-brief` | Contracts, NDAs, briefs |
| **Finance** | `finance` `invoice` | Financial reports, invoices |
| **Medical** | `medical` | Clinical reports |
| **Government** | `government` | Policy docs, tenders |
| **Marketing** | `brand` `marketing` | Brand guides, plans |
| **Education** | `syllabus` `lesson-plan` | Syllabi, lesson plans |

## Quick Start

```bash
# Default PDF (PingFang SC, 11pt)
docforge README.md

# APA format paper
docforge -p apa paper.md

# Business proposal as Word
docforge -p proposal --word report.md

# Contract PDF with Eisvogel cover page
docforge -p contract --eisvogel --title "Service Agreement" --titlepage contract.md
```

## Usage

```bash
docforge [options] <input.md> [output.pdf|docx]
```

### Output Format

| Flag | Description |
|------|-------------|
| *(default)* | PDF output |
| `-w, --word` | Word (.docx) output |
| `file.docx` | Auto-detect from extension |

### Presets & Fonts

| Flag | Description |
|------|-------------|
| `-p, --preset <name>` | Use a preset (see `--list-presets`) |
| `--list-presets` | Show all 21 presets |
| `--list-fonts` | List available CJK fonts on your system |

### Formatting

| Flag | Default | Description |
|------|---------|-------------|
| `-f, --font` | PingFang SC | Body font |
| `-m, --mono` | Heiti SC | Code font |
| `-s, --fontsize` | 11pt | Font size |
| `--margin` | 2.5cm | Page margins |
| `--theme` | tango | Code highlight theme |
| `-t, --toc` | — | Generate table of contents |
| `--numbersections` | — | Number sections |

### Eisvogel Mode

Professional layouts with cover pages, headers/footers.

| Flag | Description |
|------|-------------|
| `--eisvogel` | Enable Eisvogel template |
| `--title` | Document title |
| `--author` | Author name |
| `--date` | Date (default: today) |
| `--titlepage` | Generate cover page |
| `--titlepage-color` | Cover background (hex) |
| `--logo` | Cover logo image path |

### Code Highlight Themes

`tango` · `pygments` · `kate` · `monochrome` · `espresso` · `zenburn` · `haddock` · `breezedark`

## Examples

```bash
# Chinese calligraphy font
docforge -p kaiti document.md

# IEEE paper with TOC
docforge -p ieee --toc --numbersections paper.md

# MLA paper as Word
docforge -p mla paper.md paper.docx

# Eisvogel with blue cover
docforge -p report --eisvogel \
  --title "Q4 Report" \
  --author "Team" \
  --titlepage \
  --titlepage-color "06386e" \
  report.md

# Custom: Songti 12pt, wide margins
docforge -f "Songti SC" -s 12pt --margin 3cm document.md
```

## Install

### Dependencies

**macOS:**

```bash
brew install pandoc
brew install --cask mactex   # or use TinyTeX for lighter install
```

**Ubuntu/Debian:**

```bash
sudo apt install pandoc texlive-xetex texlive-lang-chinese
```

### Install DocForge

```bash
git clone https://github.com/yzha0302/asyre-docforge.git
cd asyre-docforge
chmod +x docforge.sh install.sh
./install.sh
```

### Eisvogel Template (Optional)

```bash
curl -fsSL -o /tmp/eisvogel.tar.gz \
  https://github.com/Wandmalfarbe/pandoc-latex-template/releases/download/v3.4.0/Eisvogel.tar.gz
tar xzf /tmp/eisvogel.tar.gz -C /tmp
mkdir -p ~/.local/share/pandoc/templates
cp /tmp/Eisvogel-3.4.0/eisvogel.latex ~/.local/share/pandoc/templates/
```

## How It Works

```
         ┌─────────────┐
         │  Markdown    │
         └──────┬───────┘
                │
         ┌──────▼───────┐
         │   Pandoc      │
         └──┬────────┬───┘
            │        │
     ┌──────▼──┐  ┌──▼──────┐
     │ XeLaTeX │  │ ref.docx│
     │ + CJK   │  │ styles  │
     └────┬────┘  └────┬────┘
          │            │
     ┌────▼────┐  ┌────▼────┐
     │  PDF    │  │  Word   │
     └─────────┘  └─────────┘
```

Each preset includes:
- **LaTeX header** (`header.tex`) — font, spacing, margins, headers/footers for PDF
- **Reference doc** (`reference.docx`) — styled Word template (academic presets)

## License

MIT

---

<div align="center">

**Stop formatting. Start writing.**

![Asyre DocForge](https://img.shields.io/badge/Asyre-DocForge-black?style=for-the-badge)

Powered by [**Asyre**](https://github.com/yzha0302)

</div>
