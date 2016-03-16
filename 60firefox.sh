#!/bin/bash
source "$(dirname "$0")/bs.sh"

INFO Installing \`userContent.css\`

shopt -s nullglob

for d in .mozilla/firefox/*/chrome ; do
    cat > $d/userContent.css <<EOF
input, textarea, select {
  color: black !important;
  background-color: white !important;
}
EOF
done
