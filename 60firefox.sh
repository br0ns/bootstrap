#!/bin/bash
source "$(dirname "$0")/bs.sh"

INFO Installing \`userContent.css\`

for d in .mozilla/firefox/*/chrome ; do
    cat > $d/userContent.css <<EOF
input, textarea {
  color: black !important;
  background-color: white !important;
}
EOF
done
