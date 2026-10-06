#!/usr/bin/env bash

set -e

echo "=== Jennifer Brana Website Deploy ==="

# Make sure we're inside a git repository.
if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "Error: This script must be run from inside the website git repository."
    exit 1
fi

# Always operate from the repository root.
cd "$(git rev-parse --show-toplevel)"

# Make sure we're on main.
BRANCH=$(git branch --show-current)

if [ "$BRANCH" != "main" ]; then
    echo "Error: You are currently on '$BRANCH', not 'main'."
    exit 1
fi

# Ensure GitHub Pages treats this as a plain static site.
if [ ! -f ".nojekyll" ]; then
    echo "Creating .nojekyll..."
    touch .nojekyll
fi

echo
echo "Current changes:"
git status --short
echo

# Stage EVERYTHING in the repository:
#   - new files
#   - modified files
#   - deleted files
git add -A

# Stop if there is nothing to commit.
if git diff --cached --quiet; then
    echo "Nothing new to commit."
    exit 0
fi

echo
echo "Files that will be committed:"
git status --short
echo

# Optional commit message:
#   ./deploy.sh "Update research description"
COMMIT_MESSAGE="${1:-Update website}"

echo "Committing all changes..."
git commit -m "$COMMIT_MESSAGE"

echo
echo "Pushing main to GitHub..."
git push origin main

echo
echo "======================================"
echo "Website pushed successfully."
echo
echo "GitHub now contains all tracked/staged"
echo "changes from this repository."
echo
echo "GitHub Pages should automatically"
echo "redeploy from the main branch."
echo
echo "Site:"
echo "https://jenniferbrana.github.io/"
echo "======================================"
