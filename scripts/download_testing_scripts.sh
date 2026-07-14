#!/bin/bash


URLS=(
    "https://raw.githubusercontent.com/swapnil-lakra/deploy-sheild/refs/heads/main/scripts/check-environment.sh"
    "https://raw.githubusercontent.com/swapnil-lakra/deploy-sheild/refs/heads/main/scripts/deployment.sh"
    "https://raw.githubusercontent.com/swapnil-lakra/deploy-sheild/refs/heads/main/scripts/down-blue-env.sh"
    "https://raw.githubusercontent.com/swapnil-lakra/deploy-sheild/refs/heads/main/scripts/down-green-env.sh"
    "https://raw.githubusercontent.com/swapnil-lakra/deploy-sheild/refs/heads/main/scripts/healthcheck.sh"
)

echo "Checking if wget is installed or not..."

if ! command -v wget &> /dev/null; then
  echo "❌ 'wget' not found. Installing wget..."

  if [ -x "$(command -v apt-get)" ]; then
    sudo apt-get update && sudo apt-get install -y wget
  elif [ -x "$(command -v dnf)" ]; then
    sudo dnf install -y wget
  elif [ -x "$(command -v yum)" ]; then
    sudo yum install -y wget
  elif [ -x "$(command -v pacman)" ]; then
    sudo pacman -Sy --noconfirm wget
  else 
    echo "💥 Error: Your package manager not found. Please manually install wget."
    exit 1
  fi

  if [ -x "$(command -v wget)" ]; then
    echo "✅ 'wget' had installed successfully!"
  else
    echo "💥 Error: 'wget' installation failed."
    exit 1
  fi
else
  echo "✅ 'wget' is already installed. Moving ahead..."
fi

for URL in "${URLS[@]}"; do
    FILE_NAME=$(basename "$URL")
    FILE_PATH="$HOME/deploy-sheild/scripts/$FILE_NAME"
    FOLDER_PATH=$(dirname "$FILE_PATH")

    if [ ! -d "$FOLDER_PATH" ]; then
      echo "📁 Path do not exist. Creating directory structure: $FOLDER_PATH"
      mkdir -p "$FOLDER_PATH"
    else
      echo "✅ Folder path already exist."
    fi


    if [ ! -f "$FILE_PATH" ]; then
      echo "📥 File is missing! Downloading fresh file via wget..."
      # 🛠️ Fix: $"FILE_PATH" ka syntax thik kiya
      wget -q --show-progress -O "$FILE_PATH" "$URL"
     
      # 🛠️ Fix: '-x' ko '+x' kiya taaki execute permission mile
      if [[ "$FILE_NAME" == *.sh ]]; then chmod +x "$FILE_PATH"; fi
    else
      echo "📄 File is already downloaded. Matching the Content..."
     
      TEMP_FILE="/tmp/temp_$FILE_NAME"
      wget -q -O "$TEMP_FILE" "$URL"
    
      if cmp -s "$FILE_PATH" "$TEMP_FILE"; then
        echo "🤝 Content already MATCHED! No need to do anything."
        rm -f "$TEMP_FILE"
      else
        echo "⚠️ Content MISMATCHED! Deleting old file and new file is downloading..."
        rm -f "$FILE_PATH"
        mv "$TEMP_FILE" "$FILE_PATH"
        echo "🔄 File successfully updated with new content!"
    
        if [[ "$FILE_NAME" == *.sh ]]; then chmod +x "$FILE_PATH"; fi
      fi
    fi
done 