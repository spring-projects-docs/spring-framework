SCRIPT_DIR=$(cd "$(dirname "$0")" && pwd)
make all
cd "$SCRIPT_DIR/translated/ko"
npm install
npx antora antora-playbook.yml --stacktrace
