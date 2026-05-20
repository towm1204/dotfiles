#!/bin/bash
# PostToolUse hook: run tsc --noEmit after editing .ts/.tsx files in portal/pallas
file=$(python3 -c "import json,sys; d=json.load(sys.stdin); print(d.get('tool_input',{}).get('file_path',''))" 2>/dev/null)

[[ "$file" == *.ts || "$file" == *.tsx ]] || exit 0

if [[ "$file" == */packages/portal/* ]]; then
  pkg="/Users/tow-cfp/cash-flow-portal-react/packages/portal"
elif [[ "$file" == */packages/pallas/* ]]; then
  pkg="/Users/tow-cfp/cash-flow-portal-react/packages/pallas"
else
  exit 0
fi

output=$(cd "$pkg" && npx tsc --noEmit 2>&1)
rc=$?

[ $rc -eq 0 ] && exit 0

echo "$output" | tail -30
exit 1
