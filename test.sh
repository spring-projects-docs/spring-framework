set -e

cat > po4a_generated.conf <<EOF
[po4a_langs] ko
[po4a_paths] po/templates.pot \$lang:po/\$lang/templates.po
EOF

# 2. AsciiDoc 파일 탐색 및 설정 추가 (폴더 구조 유지 로직)
# find로 모든 adoc을 찾아서, 설정 파일 포맷으로 변환해 append 합니다.
# 원본: doc/sub/guide.adoc
# 결과: [type: asciidoc] doc/sub/guide.adoc pot=po/doc/sub/guide.adoc.pot $lang:po/$lang/doc/sub/guide.adoc.po

find doc -name "*.adoc" | sort | while read f; do
    echo "[type: asciidoc] $f pot=po/$f.pot \$lang:po/\$lang/$f.po" >> po4a_generated.conf
done

# 3. 폴더 생성 (po4a가 못하는 것 보조)
# po 폴더 안에 원본 소스와 똑같은 폴더 트리 생성
find doc -type d | while read d; do
    mkdir -p "po/$d"
    mkdir -p "po/ko/$d"
done

# 4. 통합 툴 실행
echo "🔧 po4a 설정 파일 생성 완료. 번역 동기화를 시작합니다..."
po4a --no-translations --keep 0 po4a_generated.conf

# --no-translations: PO 파일만 업데이트 (번역 문서 생성 안 함)
# 번역 문서를 뽑고 싶으면 이 옵션을 빼면 됩니다.

