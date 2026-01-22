cp translated/po/ko/modules/ROOT/nav.adoc.po tmp/nav.adoc.po 

# B 브랜치
git checkout heads/v7.0.3 
#msgcat --use-first newFile oldFile -o targetFile
msgcat --use-first tmp/nav.adoc.po translated/po/ko/modules/ROOT/nav.adoc.po -o final.po
mv final.po translated/po/ko/modules/ROOT/nav.adoc.po
rm tmp/*.po
