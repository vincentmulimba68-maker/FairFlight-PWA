#!/bin/bash
# push_all.sh - smart push script for GitHub
# Skips empty commits, optional message, timestamp included

# Get current date and time
NOW=$(date +"%Y-%m-%d %H:%M:%S")

# Determine commit message
if [ -z "$1" ]; then
    COMMIT_MSG="Automatic update: $NOW"
else
    COMMIT_MSG="$1 (updated: $NOW)"
fi

# Stage all changes
git add .

# Check if there are any changes to commit
if git diff --cached --quiet; then
    echo "ℹ️ No changes to commit. Skipping."
    exit 0
fi

# Commit and push
git commit -m "$COMMIT_MSG"
git push origin main

echo "✅ Changes pushed to GitHub with message: '$COMMIT_MSG'"
