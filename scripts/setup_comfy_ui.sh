#!/usr/bin/env bash
set -euo pipefail

BASE_DIR="/opt/comfy-ui-data"
COMFYUI_DIR="/opt/ComfyUI"

# Setup base directory and copy models
mkdir -p "$BASE_DIR"
cp -r "$COMFYUI_DIR/models" "$BASE_DIR/models"

# Clone essential extensions if not already present
declare -A repos=(
  ["ComfyUI_essentials"]="https://github.com/cubiq/ComfyUI_essentials"
  ["ComfyUI-AMDGPUMonitor"]="https://github.com/kyuz0/ComfyUI-AMDGPUMonitor"
  ["ComfyUI-Manager"]="https://github.com/Comfy-Org/ComfyUI-Manager"
  # Additional useful repos
  ["ComfyUI-WanVideoWrapper"]="https://github.com/kijai/ComfyUI-WanVideoWrapper.git"
  ["ComfyUI-VideoHelperSuite"]="https://github.com/Kosinkadink/ComfyUI-VideoHelperSuite.git"
  ["rgthree-comfy"]="https://github.com/rgthree/rgthree-comfy.git"
  ["ComfyUI-KJNodes"]="https://github.com/kijai/ComfyUI-KJNodes.git"
  ["ComfyUI-AnimateDiff-Evolved"]="https://github.com/Kosinkadink/ComfyUI-AnimateDiff-Evolved"
  ["ComfyUI-Advanced-ControlNet"]="https://github.com/Kosinkadink/ComfyUI-Advanced-ControlNet"
  ["ComfyUI-SeedVR2_VideoUpscaler"]="https://github.com/numz/ComfyUI-SeedVR2_VideoUpscaler"
  ["ComfyUI_Comfyroll_CustomNodes"]="https://github.com/Suzie1/ComfyUI_Comfyroll_CustomNodes"
  ["ComfyUI-LTXVideo"]="https://github.com/Lightricks/ComfyUI-LTXVideo"
  ["ComfyUI-GGUF-FantasyTalking"]="https://github.com/kael558/ComfyUI-GGUF-FantasyTalking"
  ["comfyui-vrgamedevgirl"]="https://github.com/vrgamegirl19/comfyui-vrgamedevgirl"
  ["RES4LYF"]="https://github.com/ClownsharkBatwing/RES4LYF"
  ["ComfyUI-Crystools"]="https://github.com/crystian/ComfyUI-Crystools"
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

pip install flash-attn --no-build-isolation
pip install blend_modes insightface
