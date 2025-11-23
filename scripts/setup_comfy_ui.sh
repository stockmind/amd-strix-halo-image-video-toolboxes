#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/data/comfy-ui"
COMFYUI_DIR="/opt/ComfyUI"

# Setup base directory and copy models
mkdir -p "$BASE_DIR"
cp -r "$COMFYUI_DIR/models" "$BASE_DIR/models"

# Clone essential extensions if not already present
declare -A repos=(
  ["ComfyUI_essentials"]="https://github.com/cubiq/ComfyUI_essentials"
  ["ComfyUI-AMDGPUMonitor"]="https://github.com/kyuz0/ComfyUI-AMDGPUMonitor"
  ["ComfyUI-Manager"]="https://github.com/Comfy-Org/ComfyUI-Manager"
)

for name in "${!repos[@]}"; do
  target_dir="$BASE_DIR/custom_nodes/$name"
  if [ ! -d "$target_dir" ]; then
    git clone "${repos[$name]}" "$target_dir"
  fi
done

# Install requirements in each custom_nodes subdirectory
for dir in "$BASE_DIR/custom_nodes"/*/ ; do
  if [ -f "${dir}requirements.txt" ]; then
    pip install -r "${dir}requirements.txt"
  fi
done
