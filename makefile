# 1. 설정: 원본 폴더와 번역 폴더 지정
SRC_DIR = /mnt/c/Users/etrees/Desktop/private/spring-framework/framework-docs
PO_DIR = /mnt/c/Users/etrees/Desktop/private/spring-framework/translated/po
LANG_CODE = ko

# 2. 모든 .adoc 파일 찾기 (재귀적 탐색)
SRCS := $(shell find $(SRC_DIR) -name '*.adoc')

# 3. 대상 PO 파일 경로 계산 (doc/a/b.adoc -> po/ko/a/b.adoc.po)
POS := $(patsubst $(SRC_DIR)/%.adoc,$(PO_DIR)/$(LANG_CODE)/%.adoc.po,$(SRCS))

# 4. 번역된 결과물(adoc) 경로 계산
TRANSLATED_DOCS := $(patsubst $(SRC_DIR)/%.adoc,$(SRC_DIR)/$(LANG_CODE)/%.adoc,$(SRCS))

.PHONY: all update-po translate clean

all: update-po translate

# [핵심 1] PO 파일 업데이트 (폴더 자동 생성 포함)
# 원본(.adoc)이 변경되면 해당 .po 파일만 딱 집어서 업데이트합니다.
update-po: $(POS)

$(PO_DIR)/$(LANG_CODE)/%.adoc.po: $(SRC_DIR)/%.adoc
	@mkdir -p $(dir $@)
	@echo "Updating PO: $@"
	@po4a-updatepo -f asciidoc -M utf-8 -m $< -p $@

# [핵심 2] 번역문 생성 (po -> adoc)
# 번역률 80% 이상일 때만 문서를 생성하도록 설정 (-k 80)
translate: $(TRANSLATED_DOCS)

$(SRC_DIR)/$(LANG_CODE)/%.adoc: $(PO_DIR)/$(LANG_CODE)/%.adoc.po $(SRC_DIR)/%.adoc
	@mkdir -p $(dir $@)
	@echo "Generating Translated Doc: $@"
	@po4a-translate -f asciidoc -M utf-8 -m $(word 2,$^) -p $< -l $@ -k 80

clean:
	rm -rf $(PO_DIR) $(SRC_DIR)/$(LANG_CODE)

