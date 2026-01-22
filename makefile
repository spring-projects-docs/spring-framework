# -----------------------------
# 1. 설정: 원본 폴더와 번역 폴더 지정
# -----------------------------
SRC_DIR    := $(CURDIR)/origin/framework-docs
PO_DIR     := $(CURDIR)/translated/po
TARGET_DIR := $(CURDIR)/translated
LANG_CODE  := ko

# -----------------------------
# 2. 모든 .adoc 파일 찾기 (재귀적 탐색)
# -----------------------------
SRCS := $(shell find $(SRC_DIR) -name '*.adoc')

# -----------------------------
# 3. 대상 PO 파일 경로 계산 (doc/a/b.adoc -> po/ko/a/b.adoc.po)
# -----------------------------
POS := $(patsubst $(SRC_DIR)/%.adoc,$(PO_DIR)/$(LANG_CODE)/%.adoc.po,$(SRCS))

# -----------------------------
# 4. 번역된 결과물(adoc) 경로 계산 (doc/a/b.adoc -> translated/ko/a/b.adoc)
# -----------------------------
TRANSLATED_DOCS := $(patsubst $(SRC_DIR)/%.adoc,$(TARGET_DIR)/$(LANG_CODE)/%.adoc,$(SRCS))

# -----------------------------
# 5. PHONY 타겟
# -----------------------------
.PHONY: all update-po translate clean

all: update-po translate

# -----------------------------
# [핵심 1] PO 파일 업데이트
# -----------------------------
update-po: $(POS)

$(PO_DIR)/$(LANG_CODE)/%.adoc.po: $(SRC_DIR)/%.adoc
	@mkdir -p $(dir $@)
	@echo "Updating PO: $@"
	@po4a-updatepo -f asciidoc -M utf-8 -m $< -p $@

# -----------------------------
# [핵심 2] 번역문 생성 (po -> adoc)
# -----------------------------
translate: $(TRANSLATED_DOCS)

$(TARGET_DIR)/$(LANG_CODE)/%.adoc: $(PO_DIR)/$(LANG_CODE)/%.adoc.po $(SRC_DIR)/%.adoc
	@mkdir -p $(dir $@)
	@echo "Generating Translated Doc: $@"
	@po4a-translate -f asciidoc -M utf-8 -m $(word 2,$^) -p $< -l $@ -k 0


