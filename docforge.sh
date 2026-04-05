#!/bin/bash
# md2pdf - Markdown 转 PDF / Word，支持中文，内置学术论文格式
# Usage: md2pdf [选项] input.md [output.pdf|docx]

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
TEMPLATE="$SCRIPT_DIR/template/cjk.tex"
ACADEMIC_DIR="$SCRIPT_DIR/template/academic"
INDUSTRY_DIR="$SCRIPT_DIR/template/industry"

# 颜色输出
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
CYAN='\033[0;36m'
NC='\033[0m'

# ============================================================
# 预设系统
# ============================================================
get_preset() {
    case "$1" in
        # 字体预设
        kaiti)    echo "AR PL KaitiM GB|Heiti SC|11pt|2.5cm|tango" ;;
        songti)   echo "Songti SC|Heiti SC|11pt|2.5cm|tango" ;;
        heiti)    echo "Heiti SC|Heiti SC|11pt|2.5cm|tango" ;;
        pingfang) echo "PingFang SC|Heiti SC|11pt|2.5cm|tango" ;;
        hiragino) echo "Hiragino Sans GB|Heiti SC|11pt|2.5cm|tango" ;;
        # 场景预设
        essay)    echo "Songti SC|Heiti SC|12pt|3cm|tango" ;;
        report)   echo "PingFang SC|Heiti SC|11pt|2.5cm|tango" ;;
        book)     echo "Songti SC|Heiti SC|11pt|3cm|tango" ;;
        slides)   echo "PingFang SC|Heiti SC|14pt|1.5cm|tango" ;;
        compact)  echo "PingFang SC|Heiti SC|9pt|1.5cm|kate" ;;
        code)     echo "PingFang SC|Heiti SC|10pt|2cm|breezedark" ;;
        # 学术论文预设
        apa)       echo "Times New Roman|Heiti SC|12pt|2.54cm|tango" ;;
        harvard)   echo "Times New Roman|Heiti SC|12pt|2.54cm|tango" ;;
        mla)       echo "Times New Roman|Heiti SC|12pt|2.54cm|tango" ;;
        chicago)   echo "Times New Roman|Heiti SC|12pt|2.54cm|tango" ;;
        ieee)      echo "Times New Roman|Heiti SC|10pt|1.59cm|tango" ;;
        vancouver) echo "Times New Roman|Heiti SC|12pt|2.54cm|tango" ;;
        # 行业文档预设
        proposal)      echo "Arial|Heiti SC|12pt|2.54cm|tango" ;;
        meeting)       echo "Arial|Heiti SC|11pt|2.54cm|tango" ;;
        memo)          echo "Arial|Heiti SC|11pt|2.54cm|tango" ;;
        tech-doc)      echo "Arial|Heiti SC|11pt|2.54cm|tango" ;;
        release-notes) echo "Arial|Heiti SC|11pt|2.54cm|tango" ;;
        contract)      echo "Times New Roman|Heiti SC|12pt|2.54cm|tango" ;;
        legal-brief)   echo "Times New Roman|Heiti SC|12pt|2.54cm|tango" ;;
        finance)       echo "Arial|Heiti SC|10pt|2cm|tango" ;;
        invoice)       echo "Arial|Heiti SC|10pt|2.54cm|tango" ;;
        medical)       echo "Arial|Heiti SC|11pt|2.54cm|tango" ;;
        government)    echo "Arial|Heiti SC|12pt|2.54cm|tango" ;;
        brand)         echo "Arial|Heiti SC|11pt|2cm|tango" ;;
        marketing)     echo "Arial|Heiti SC|11pt|2.54cm|tango" ;;
        syllabus)      echo "Times New Roman|Heiti SC|11pt|2.54cm|tango" ;;
        lesson-plan)   echo "Arial|Heiti SC|11pt|2cm|tango" ;;
        *)        return 1 ;;
    esac
}

# 带专用模板的预设列表（学术 + 行业）
TEMPLATE_PRESETS="apa harvard mla chicago ieee vancouver proposal meeting memo tech-doc release-notes contract legal-brief finance invoice medical government brand marketing syllabus lesson-plan"

is_template_preset() {
    for tp in $TEMPLATE_PRESETS; do
        [ "$1" = "$tp" ] && return 0
    done
    return 1
}

get_template_dir() {
    local preset="$1"
    for ap in apa harvard mla chicago ieee vancouver; do
        [ "$preset" = "$ap" ] && echo "$ACADEMIC_DIR/$preset" && return
    done
    echo "$INDUSTRY_DIR/$preset"
}

apply_preset() {
    local preset_val
    preset_val=$(get_preset "$1") || {
        echo -e "${RED}未知预设: $1${NC}"
        echo "可用预设:"
        list_presets
        exit 1
    }
    IFS='|' read -r FONT MONO_FONT FONTSIZE MARGIN THEME <<< "$preset_val"
}

list_presets() {
    echo ""
    echo -e "${CYAN}字体预设:${NC}"
    echo "  kaiti       楷体 (文鼎楷体) — 传统、文雅"
    echo "  songti      宋体 — 正式、书籍"
    echo "  heiti       黑体 — 现代、简洁"
    echo "  pingfang    苹方 (默认) — 清晰、易读"
    echo "  hiragino    冬青黑体 — 日式简约"
    echo ""
    echo -e "${CYAN}场景预设:${NC}"
    echo "  essay       论文/作文 (宋体 12pt 宽边距)"
    echo "  report      报告 (苹方 11pt 标准)"
    echo "  book        书籍 (宋体 11pt 宽边距)"
    echo "  slides      演示 (苹方 14pt 窄边距)"
    echo "  compact     紧凑 (苹方 9pt 窄边距 省纸)"
    echo "  code        代码文档 (苹方 10pt 暗色高亮)"
    echo ""
    echo -e "${CYAN}学术论文预设:${NC}"
    echo "  apa            APA 7th — 社科、心理学 (TNR 12pt, 双倍行距)"
    echo "  harvard        Harvard — 英澳高校通用 (TNR 12pt, 1.5倍行距)"
    echo "  mla            MLA 9th — 人文、文学 (TNR 12pt, 双倍行距)"
    echo "  chicago        Chicago — 历史、艺术 (TNR 12pt, 双倍行距, 脚注)"
    echo "  ieee           IEEE — 工程、计算机 (TNR 10pt, 单倍行距)"
    echo "  vancouver      Vancouver — 医学、生物 (TNR 12pt, 双倍行距)"
    echo ""
    echo -e "${CYAN}商务文档:${NC}"
    echo "  proposal       商业提案/项目报告 (Arial 12pt, 1.5倍行距)"
    echo "  meeting        会议纪要 (Arial 11pt, 紧凑)"
    echo "  memo           备忘录 (Arial 11pt, 简洁)"
    echo ""
    echo -e "${CYAN}技术文档:${NC}"
    echo "  tech-doc       技术文档/API文档 (Arial 11pt, 带页眉)"
    echo "  release-notes  发布说明 (Arial 11pt, 单倍行距)"
    echo ""
    echo -e "${CYAN}法律文书:${NC}"
    echo "  contract       合同/NDA (TNR 12pt, 编号条款, 页码X/Y)"
    echo "  legal-brief    法律摘要 (TNR 12pt, 双倍行距, 首行缩进)"
    echo ""
    echo -e "${CYAN}财务:${NC}"
    echo "  finance        财务/审计报告 (Arial 10pt, 紧凑)"
    echo "  invoice        发票 (Arial 10pt, 单倍行距)"
    echo ""
    echo -e "${CYAN}医疗:${NC}"
    echo "  medical        医疗报告/临床方案 (Arial 11pt, 保密标记)"
    echo ""
    echo -e "${CYAN}政府/公共:${NC}"
    echo "  government     政策文件/招标文件 (Arial 12pt, 层级编号)"
    echo ""
    echo -e "${CYAN}营销:${NC}"
    echo "  brand          品牌指南 (Arial 11pt, 大标题)"
    echo "  marketing      营销方案 (Arial 11pt, 标准)"
    echo ""
    echo -e "${CYAN}教育:${NC}"
    echo "  syllabus       教学大纲 (TNR 11pt)"
    echo "  lesson-plan    教案 (Arial 11pt, 紧凑)"
}

# 检查依赖
check_deps() {
    if ! command -v pandoc &> /dev/null; then
        echo -e "${RED}缺少依赖: pandoc${NC}"
        echo "安装: brew install pandoc (macOS) / sudo apt install pandoc (Ubuntu)"
        exit 1
    fi
    # PDF 输出需要 xelatex
    if [ "$OUTPUT_FORMAT" = "pdf" ] && ! command -v xelatex &> /dev/null; then
        echo -e "${RED}缺少依赖: xelatex (PDF 输出需要)${NC}"
        echo "安装: brew install --cask mactex (macOS)"
        exit 1
    fi
}

# 使用说明
usage() {
    echo "用法: md2pdf [选项] <input.md> [output.pdf|output.docx]"
    echo ""
    echo "输出格式 (根据输出文件扩展名自动判断，或用 --word 指定):"
    echo "  .pdf                    PDF 输出 (默认)"
    echo "  .docx                   Word 输出"
    echo "  -w, --word              强制输出 Word 格式"
    echo ""
    echo "模式:"
    echo "  --lite                  轻量模式 (默认)"
    echo "  --eisvogel              Eisvogel 模式 (精美排版，支持封面页)"
    echo ""
    echo "预设:"
    echo "  -p, --preset <名称>     使用预设配置 (用 --list-presets 查看)"
    echo "  --list-presets          列出所有可用预设"
    echo ""
    echo "通用选项:"
    echo "  -f, --font <字体>       正文字体 (默认: PingFang SC)"
    echo "  -m, --mono <字体>       代码字体 (默认: Heiti SC)"
    echo "  -s, --fontsize <大小>   字号 (默认: 11pt)"
    echo "  --margin <边距>         页边距 (默认: 2.5cm)"
    echo "  --theme <主题>          代码高亮主题 (默认: tango)"
    echo "  -t, --toc               生成目录"
    echo "  --numbersections        章节自动编号"
    echo "  --list-fonts            列出系统可用的中文字体"
    echo "  -h, --help              显示帮助"
    echo ""
    echo "Eisvogel 选项:"
    echo "  --title <标题>          文档标题"
    echo "  --author <作者>         作者"
    echo "  --date <日期>           日期 (默认: 今天)"
    echo "  --titlepage             生成封面页"
    echo "  --titlepage-color <色>  封面背景色 (十六进制)"
    echo "  --titlepage-text-color <色>  封面文字色 (默认: FFFFFF)"
    echo "  --logo <路径>           封面 Logo 图片路径"
    echo ""
    echo "示例:"
    echo "  md2pdf README.md                                        # 默认 PDF"
    echo "  md2pdf -p kaiti README.md                               # 楷体"
    echo "  md2pdf -p apa paper.md                                  # APA 格式 PDF"
    echo "  md2pdf -p apa --word paper.md                           # APA 格式 Word"
    echo "  md2pdf -p mla paper.md paper.docx                       # MLA 格式 Word"
    echo "  md2pdf -p ieee --toc paper.md                           # IEEE 格式 + 目录"
    echo "  md2pdf -p chicago --eisvogel --titlepage paper.md       # Chicago + Eisvogel 封面"
    echo "  md2pdf -f 'Songti SC' -s 12pt README.md                # 自定义字体和字号"
}

# 默认参数
MODE="lite"
FONT="PingFang SC"
MONO_FONT="Heiti SC"
FONTSIZE="11pt"
MARGIN="2.5cm"
THEME="tango"
TOC=""
INPUT=""
OUTPUT=""
PRESET_APPLIED=""
FORCE_WORD=""
OUTPUT_FORMAT="pdf"

# Eisvogel 参数
TITLE=""
AUTHOR=""
DATE=$(date +%Y-%m-%d)
TITLEPAGE=""
TITLEPAGE_COLOR=""
TITLEPAGE_TEXT_COLOR=""
LOGO=""
NUMBERSECTIONS=""

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        --lite)        MODE="lite"; shift ;;
        --eisvogel)    MODE="eisvogel"; shift ;;
        -p|--preset)   apply_preset "$2"; PRESET_APPLIED="$2"; shift 2 ;;
        --list-presets) list_presets; exit 0 ;;
        --list-fonts)
            echo -e "${CYAN}系统可用的中文字体:${NC}"
            fc-list :lang=zh family 2>/dev/null | sort | while read -r line; do
                echo "  $line"
            done
            exit 0
            ;;
        -w|--word)     FORCE_WORD="true"; shift ;;
        -f|--font)     FONT="$2"; shift 2 ;;
        -m|--mono)     MONO_FONT="$2"; shift 2 ;;
        -s|--fontsize) FONTSIZE="$2"; shift 2 ;;
        --margin)      MARGIN="$2"; shift 2 ;;
        --theme)       THEME="$2"; shift 2 ;;
        -t|--toc)      TOC="--toc"; shift ;;
        --title)       TITLE="$2"; shift 2 ;;
        --author)      AUTHOR="$2"; shift 2 ;;
        --date)        DATE="$2"; shift 2 ;;
        --titlepage)   TITLEPAGE="true"; shift ;;
        --titlepage-color)      TITLEPAGE_COLOR="$2"; shift 2 ;;
        --titlepage-text-color) TITLEPAGE_TEXT_COLOR="$2"; shift 2 ;;
        --logo)        LOGO="$2"; shift 2 ;;
        --numbersections) NUMBERSECTIONS="--number-sections"; shift ;;
        -h|--help)     usage; exit 0 ;;
        -*)            echo -e "${RED}未知选项: $1${NC}"; usage; exit 1 ;;
        *)
            if [ -z "$INPUT" ]; then
                INPUT="$1"
            elif [ -z "$OUTPUT" ]; then
                OUTPUT="$1"
            fi
            shift
            ;;
    esac
done

# 检查输入
if [ -z "$INPUT" ]; then
    echo -e "${RED}错误: 请指定输入文件${NC}"
    echo ""
    usage
    exit 1
fi

if [ ! -f "$INPUT" ]; then
    echo -e "${RED}错误: 文件不存在: $INPUT${NC}"
    exit 1
fi

# 判断输出格式
if [ -n "$FORCE_WORD" ]; then
    OUTPUT_FORMAT="docx"
fi

if [ -z "$OUTPUT" ]; then
    if [ "$OUTPUT_FORMAT" = "docx" ]; then
        OUTPUT="${INPUT%.md}.docx"
    else
        OUTPUT="${INPUT%.md}.pdf"
    fi
else
    # 根据扩展名判断格式
    case "$OUTPUT" in
        *.docx) OUTPUT_FORMAT="docx" ;;
        *.pdf)  OUTPUT_FORMAT="pdf" ;;
    esac
fi

# 检查依赖
check_deps

# 显示配置信息
if [ -n "$PRESET_APPLIED" ]; then
    echo -e "预设: ${CYAN}$PRESET_APPLIED${NC} (字体: $FONT / 字号: $FONTSIZE / 边距: $MARGIN)"
fi

# ============================================================
# Word (docx) 输出
# ============================================================
if [ "$OUTPUT_FORMAT" = "docx" ]; then
    PANDOC_ARGS=()

    # 模板预设：使用对应的 reference.docx
    if [ -n "$PRESET_APPLIED" ] && is_template_preset "$PRESET_APPLIED"; then
        REF_DOCX="$(get_template_dir "$PRESET_APPLIED")/reference.docx"
        if [ -f "$REF_DOCX" ]; then
            PANDOC_ARGS+=(--reference-doc="$REF_DOCX")
        fi
    fi

    [ -n "$TOC" ] && PANDOC_ARGS+=($TOC)
    [ -n "$NUMBERSECTIONS" ] && PANDOC_ARGS+=($NUMBERSECTIONS)

    echo -e "正在转换 (${YELLOW}Word${NC}): $INPUT → $OUTPUT"

    pandoc "$INPUT" -o "$OUTPUT" "${PANDOC_ARGS[@]}" 2>&1 | grep -v "WARNING" || true

    if [ -f "$OUTPUT" ]; then
        SIZE=$(du -h "$OUTPUT" | cut -f1)
        echo -e "${GREEN}完成: $OUTPUT ($SIZE)${NC}"
    else
        echo -e "${RED}转换失败${NC}"
        exit 1
    fi
    exit 0
fi

# ============================================================
# PDF 输出
# ============================================================

# 学术预设 PDF：使用对应的 LaTeX header
if [ -n "$PRESET_APPLIED" ] && is_template_preset "$PRESET_APPLIED"; then
    TEMPLATE_HEADER="$(get_template_dir "$PRESET_APPLIED")/header.tex"

    if [ ! -f "$TEMPLATE_HEADER" ]; then
        echo -e "${RED}错误: 模板不存在: $TEMPLATE_HEADER${NC}"
        exit 1
    fi

    # 如果同时用了 Eisvogel
    if [ "$MODE" = "eisvogel" ]; then
        EISVOGEL_PATH="$(pandoc -v | grep 'User data' | awk '{print $NF}')/templates/eisvogel.latex"
        if [ ! -f "$EISVOGEL_PATH" ]; then
            echo -e "${RED}错误: Eisvogel 模板未安装${NC}"
            exit 1
        fi

        echo -e "正在转换 (${YELLOW}$PRESET_APPLIED + Eisvogel${NC}): $INPUT → $OUTPUT"

        EXTRA_ARGS=()
        [ -n "$TITLE" ]  && EXTRA_ARGS+=(-V "title=$TITLE")
        [ -n "$AUTHOR" ] && EXTRA_ARGS+=(-V "author=$AUTHOR")
        [ -n "$DATE" ]   && EXTRA_ARGS+=(-V "date=$DATE")
        [ -n "$TITLEPAGE" ] && EXTRA_ARGS+=(-V "titlepage=true")
        [ -n "$TITLEPAGE_COLOR" ] && EXTRA_ARGS+=(-V "titlepage-color=$TITLEPAGE_COLOR")
        [ -n "$TITLEPAGE_TEXT_COLOR" ] && EXTRA_ARGS+=(-V "titlepage-text-color=$TITLEPAGE_TEXT_COLOR")
        [ -n "$LOGO" ] && EXTRA_ARGS+=(-V "logo=$LOGO")

        TMPFILE=$(mktemp /tmp/md2pdf-XXXXXXXX)
        trap "rm -f $TMPFILE" EXIT
        sed -e "s|{{FONT}}|$FONT|g" -e "s|{{MONO_FONT}}|$MONO_FONT|g" "$TEMPLATE_HEADER" > "$TMPFILE"

        pandoc "$INPUT" -o "$OUTPUT" \
            --template eisvogel \
            --pdf-engine=xelatex \
            -H "$TMPFILE" \
            -V CJKmainfont="$FONT" \
            -V CJKsansfont="$FONT" \
            -V CJKmonofont="$MONO_FONT" \
            -V geometry:margin="$MARGIN" \
            -V fontsize="$FONTSIZE" \
            --highlight-style="$THEME" \
            -V colorlinks=true \
            $TOC $NUMBERSECTIONS "${EXTRA_ARGS[@]}" \
            2>&1 | grep -v "WARNING" || true
    else
        echo -e "正在转换 (${YELLOW}$PRESET_APPLIED${NC}): $INPUT → $OUTPUT"

        TMPFILE=$(mktemp /tmp/md2pdf-XXXXXXXX)
        trap "rm -f $TMPFILE" EXIT
        sed -e "s|{{FONT}}|$FONT|g" -e "s|{{MONO_FONT}}|$MONO_FONT|g" "$TEMPLATE_HEADER" > "$TMPFILE"

        pandoc "$INPUT" -o "$OUTPUT" \
            --pdf-engine=xelatex \
            -H "$TMPFILE" \
            -V geometry:margin="$MARGIN" \
            -V fontsize="$FONTSIZE" \
            --highlight-style="$THEME" \
            -V colorlinks=true \
            $TOC $NUMBERSECTIONS \
            2>&1 | grep -v "WARNING" || true
    fi

# Eisvogel 模式（非学术）
elif [ "$MODE" = "eisvogel" ]; then
    EISVOGEL_PATH="$(pandoc -v | grep 'User data' | awk '{print $NF}')/templates/eisvogel.latex"
    if [ ! -f "$EISVOGEL_PATH" ]; then
        echo -e "${RED}错误: Eisvogel 模板未安装${NC}"
        echo "  下载: https://github.com/Wandmalfarbe/pandoc-latex-template/releases"
        exit 1
    fi

    echo -e "正在转换 (${YELLOW}Eisvogel${NC}): $INPUT → $OUTPUT"

    EXTRA_ARGS=()
    [ -n "$TITLE" ]  && EXTRA_ARGS+=(-V "title=$TITLE")
    [ -n "$AUTHOR" ] && EXTRA_ARGS+=(-V "author=$AUTHOR")
    [ -n "$DATE" ]   && EXTRA_ARGS+=(-V "date=$DATE")
    [ -n "$TITLEPAGE" ] && EXTRA_ARGS+=(-V "titlepage=true")
    [ -n "$TITLEPAGE_COLOR" ] && EXTRA_ARGS+=(-V "titlepage-color=$TITLEPAGE_COLOR")
    [ -n "$TITLEPAGE_TEXT_COLOR" ] && EXTRA_ARGS+=(-V "titlepage-text-color=$TITLEPAGE_TEXT_COLOR")
    [ -n "$LOGO" ] && EXTRA_ARGS+=(-V "logo=$LOGO")

    pandoc "$INPUT" -o "$OUTPUT" \
        --template eisvogel \
        --pdf-engine=xelatex \
        -V CJKmainfont="$FONT" \
        -V CJKsansfont="$FONT" \
        -V CJKmonofont="$MONO_FONT" \
        -V geometry:margin="$MARGIN" \
        -V fontsize="$FONTSIZE" \
        --highlight-style="$THEME" \
        -V colorlinks=true \
        -V table-use-row-colors=true \
        $TOC $NUMBERSECTIONS "${EXTRA_ARGS[@]}" \
        2>&1 | grep -v "WARNING" || true

# 轻量模式
else
    echo "正在转换 (轻量): $INPUT → $OUTPUT"

    TMPFILE=$(mktemp /tmp/md2pdf-XXXXXXXX)
    trap "rm -f $TMPFILE" EXIT

    sed -e "s|{{FONT}}|$FONT|g" \
        -e "s|{{MONO_FONT}}|$MONO_FONT|g" \
        "$TEMPLATE" > "$TMPFILE"

    pandoc "$INPUT" -o "$OUTPUT" \
        --pdf-engine=xelatex \
        -H "$TMPFILE" \
        -V geometry:margin="$MARGIN" \
        -V fontsize="$FONTSIZE" \
        --highlight-style="$THEME" \
        -V colorlinks=true \
        $TOC $NUMBERSECTIONS \
        2>&1 | grep -v "WARNING" || true
fi

if [ -f "$OUTPUT" ]; then
    SIZE=$(du -h "$OUTPUT" | cut -f1)
    echo -e "${GREEN}完成: $OUTPUT ($SIZE)${NC}"
else
    echo -e "${RED}转换失败${NC}"
    exit 1
fi
