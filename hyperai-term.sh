#!/bin/bash
MODEL="example/example"  # Change this to the exact name of the model API identifier in LM Studio
API_URL="http://localhost:1234/v1/chat/completions" # Don't change ANYTHING ELSE (unless you're a dev and know what you're doing)

echo "💻 HyperAI Terminal Chat — type 'exit' to quit."
history='[]'

while true; do
  read -p "You: " input
  [[ "$input" == "exit" ]] && break

  history=$(jq -n \
    --argjson h "$history" \
    --arg role "user" \
    --arg content "$input" \
    '$h + [{"role":$role,"content":$content}]')

  response=$(curl -s "$API_URL" \
    -H "Content-Type: application/json" \
    -d "{
      \"model\": \"$MODEL\",
      \"messages\": $history
    }")

  reply=$(echo "$response" | jq -r '.choices[0].message.content')

  echo -e "\033[36mHyperAI:\033[0m $reply"

  history=$(jq -n \
    --argjson h "$history" \
    --arg role "assistant" \
    --arg content "$reply" \
    '$h + [{"role":$role,"content":$content}]')
done

#MIT License - © 2025 Sunita Vishwakarma & Shivansh Gupta

