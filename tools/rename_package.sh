#!/usr/bin/env bash
# Rename package folder from "Manufacturing-Defect-Prediction-App" to
# "manufacturing_defect_prediction_app", replace references, and commit.
# Usage: ./tools/rename_package.sh
set -euo pipefail

OLD_NAME="Manufacturing-Defect-Prediction-App"
NEW_NAME="manufacturing_defect_prediction_app"

# Determine candidate paths: repo root and src/
CANDIDATES=("$OLD_NAME" "src/$OLD_NAME")

FOUND_PATH=""
for p in "${CANDIDATES[@]}"; do
  if [ -d "$p" ]; then
    FOUND_PATH="$p"
    break
  fi
done

if [ -z "$FOUND_PATH" ]; then
  echo "ERROR: Could not find directory \"$OLD_NAME\" at repo root or under src/."
  echo "Please run this script from the repository root or adjust the path manually."
  exit 1
fi

NEW_PATH="$(dirname "$FOUND_PATH")/$NEW_NAME"

echo "Renaming: $FOUND_PATH -> $NEW_PATH"

# Ensure in a git repo
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  echo "ERROR: Not inside a git repository. Aborting."
  exit 1
fi

# Use git mv to preserve history
git mv "$FOUND_PATH" "$NEW_PATH"

# Find files that mention OLD_NAME and replace with NEW_NAME (portable perl)
echo "Searching and replacing occurrences in tracked files..."
files=$(git grep -Il "$OLD_NAME" || true)
if [ -n "$files" ]; then
  printf '%s\n' "$files" | xargs -r perl -pi -e "s/${OLD_NAME}/${NEW_NAME}/g"
fi

# Best-effort update to pyproject.toml packages.find include
if [ -f "pyproject.toml" ]; then
  # If there's an include line referencing the old name, update it
  if git grep -I --quiet "include.*${OLD_NAME}" pyproject.toml 2>/dev/null; then
    perl -pi -e "s/${OLD_NAME}/${NEW_NAME}/g" pyproject.toml
    echo "Updated pyproject.toml include lines."
  fi
fi

# Stage changes and commit
git add -A
git commit -m "Rename package: ${OLD_NAME} -> ${NEW_NAME} and update imports/references"

echo "Rename complete. Please run tests locally and push branch:"
echo "  git push origin HEAD"
echo "Then update any external references (CI, Dockerfiles, other repos)."
