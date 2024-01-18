DIFF_OUTPUT=$(git diff --stat origin/dev)

DIFF_OUTPUT_WITHOUT_LAST_LINE=$(echo "$DIFF_OUTPUT" | head -n -1)

JSON_STRING="{"

while IFS= read -r line; do
    file=$(echo "$line" | sed -n 's/^[[:space:]]*\([^ ]\+\)[[:space:]]*|.*$/\1/p')
    value=$(echo "$line" | sed -n 's/.*|\s*\([0-9]\+\).*$/\1/p')

    JSON_STRING="$JSON_STRING \"$file\": $value,"

done <<< "$DIFF_OUTPUT_WITHOUT_LAST_LINE"

JSON_STRING="${JSON_STRING%,} }"

FILTERED_JSON=$(echo "$JSON_STRING" | jq 'with_entries(select(.key | test("-lock.json$|-lock.yaml$|yarn.lock$|-lockb$")))')

MODIFIED_LOCK_LINES_TOTAL=$(echo "$FILTERED_JSON" | jq '[.[]] | add')

echo $MODIFIED_LOCK_LINES_TOTAL
