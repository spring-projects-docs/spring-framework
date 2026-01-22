git log --oneline 9df19dedaf3c4f31382573c379cd0283599980ab..spring/main -- framework-docs
git fetch spring
md tmp\patches
git format-patch 9df19dedaf3c4f31382573c379cd0283599980ab..spring/main  -o tmp/patches -- framework-docs
echo " git am tmp/patches/*.patch"