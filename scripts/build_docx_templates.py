#!/usr/bin/env python3
"""为每种学术格式生成 Word 参考模板"""

import os
from docx import Document
from docx.shared import Pt, Inches, Cm
from docx.enum.text import WD_ALIGN_PARAGRAPH, WD_LINE_SPACING

TEMPLATE_DIR = os.path.join(os.path.dirname(__file__), '..', 'template', 'academic')

# 格式规格定义
STYLES = {
    'apa': {
        'name': 'APA 7th Edition',
        'font': 'Times New Roman',
        'font_size': 12,
        'line_spacing': WD_LINE_SPACING.DOUBLE,
        'margin_top': Inches(1),
        'margin_bottom': Inches(1),
        'margin_left': Inches(1),
        'margin_right': Inches(1),
        'first_line_indent': Inches(0.5),
        'heading1_align': WD_ALIGN_PARAGRAPH.CENTER,
        'heading1_bold': True,
        'heading2_align': WD_ALIGN_PARAGRAPH.LEFT,
        'heading2_bold': True,
        'heading3_align': WD_ALIGN_PARAGRAPH.LEFT,
        'heading3_bold': True,
        'heading3_italic': True,
    },
    'harvard': {
        'name': 'Harvard',
        'font': 'Times New Roman',
        'font_size': 12,
        'line_spacing': WD_LINE_SPACING.ONE_POINT_FIVE,
        'margin_top': Inches(1),
        'margin_bottom': Inches(1),
        'margin_left': Inches(1),
        'margin_right': Inches(1),
        'first_line_indent': Inches(0.5),
        'heading1_align': WD_ALIGN_PARAGRAPH.LEFT,
        'heading1_bold': True,
        'heading2_align': WD_ALIGN_PARAGRAPH.LEFT,
        'heading2_bold': True,
        'heading2_italic': True,
        'heading3_align': WD_ALIGN_PARAGRAPH.LEFT,
        'heading3_bold': False,
        'heading3_italic': True,
    },
    'mla': {
        'name': 'MLA 9th Edition',
        'font': 'Times New Roman',
        'font_size': 12,
        'line_spacing': WD_LINE_SPACING.DOUBLE,
        'margin_top': Inches(1),
        'margin_bottom': Inches(1),
        'margin_left': Inches(1),
        'margin_right': Inches(1),
        'first_line_indent': Inches(0.5),
        'heading1_align': WD_ALIGN_PARAGRAPH.CENTER,
        'heading1_bold': True,
        'heading2_align': WD_ALIGN_PARAGRAPH.LEFT,
        'heading2_bold': True,
        'heading3_align': WD_ALIGN_PARAGRAPH.LEFT,
        'heading3_bold': False,
        'heading3_italic': True,
    },
    'chicago': {
        'name': 'Chicago (Notes-Bibliography)',
        'font': 'Times New Roman',
        'font_size': 12,
        'line_spacing': WD_LINE_SPACING.DOUBLE,
        'margin_top': Inches(1),
        'margin_bottom': Inches(1),
        'margin_left': Inches(1),
        'margin_right': Inches(1),
        'first_line_indent': Inches(0.5),
        'heading1_align': WD_ALIGN_PARAGRAPH.CENTER,
        'heading1_bold': True,
        'heading2_align': WD_ALIGN_PARAGRAPH.LEFT,
        'heading2_bold': True,
        'heading2_italic': True,
        'heading3_align': WD_ALIGN_PARAGRAPH.LEFT,
        'heading3_bold': False,
        'heading3_italic': True,
    },
    'ieee': {
        'name': 'IEEE',
        'font': 'Times New Roman',
        'font_size': 10,
        'line_spacing': WD_LINE_SPACING.SINGLE,
        'margin_top': Inches(0.75),
        'margin_bottom': Inches(1),
        'margin_left': Inches(0.625),
        'margin_right': Inches(0.625),
        'first_line_indent': Inches(0.25),
        'heading1_align': WD_ALIGN_PARAGRAPH.CENTER,
        'heading1_bold': True,
        'heading2_align': WD_ALIGN_PARAGRAPH.LEFT,
        'heading2_bold': False,
        'heading2_italic': True,
        'heading3_align': WD_ALIGN_PARAGRAPH.LEFT,
        'heading3_bold': False,
        'heading3_italic': True,
    },
    'vancouver': {
        'name': 'Vancouver',
        'font': 'Times New Roman',
        'font_size': 12,
        'line_spacing': WD_LINE_SPACING.DOUBLE,
        'margin_top': Inches(1),
        'margin_bottom': Inches(1),
        'margin_left': Inches(1),
        'margin_right': Inches(1),
        'first_line_indent': Inches(0.5),
        'heading1_align': WD_ALIGN_PARAGRAPH.LEFT,
        'heading1_bold': True,
        'heading2_align': WD_ALIGN_PARAGRAPH.LEFT,
        'heading2_bold': True,
        'heading2_italic': True,
        'heading3_align': WD_ALIGN_PARAGRAPH.LEFT,
        'heading3_bold': False,
        'heading3_italic': True,
    },
}


def apply_style(doc, spec):
    """Apply formatting spec to a docx reference template."""
    # 页面边距
    for section in doc.sections:
        section.top_margin = spec['margin_top']
        section.bottom_margin = spec['margin_bottom']
        section.left_margin = spec['margin_left']
        section.right_margin = spec['margin_right']

    # 正文样式
    style = doc.styles['Normal']
    font = style.font
    font.name = spec['font']
    font.size = Pt(spec['font_size'])
    pf = style.paragraph_format
    pf.line_spacing_rule = spec['line_spacing']
    pf.first_line_indent = spec.get('first_line_indent', Inches(0.5))
    pf.space_before = Pt(0)
    pf.space_after = Pt(0)

    # 标题样式
    for level, key_prefix in [(1, 'heading1'), (2, 'heading2'), (3, 'heading3')]:
        style_name = f'Heading {level}'
        if style_name in doc.styles:
            h_style = doc.styles[style_name]
            h_font = h_style.font
            h_font.name = spec['font']
            h_font.size = Pt(spec['font_size'])
            h_font.bold = spec.get(f'{key_prefix}_bold', False)
            h_font.italic = spec.get(f'{key_prefix}_italic', False)
            h_style.paragraph_format.alignment = spec.get(f'{key_prefix}_align', WD_ALIGN_PARAGRAPH.LEFT)
            h_style.paragraph_format.space_before = Pt(12)
            h_style.paragraph_format.space_after = Pt(6)


def main():
    for style_key, spec in STYLES.items():
        ref_path = os.path.join(TEMPLATE_DIR, style_key, 'reference.docx')
        doc = Document(ref_path)
        apply_style(doc, spec)
        doc.save(ref_path)
        print(f"  {spec['name']:40s} → {style_key}/reference.docx")

    print("Done!")


if __name__ == '__main__':
    main()
