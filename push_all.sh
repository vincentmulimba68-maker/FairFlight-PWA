#!/bin/bash
# push_all.sh - automatically add, commit, and push to GitHub
# Supports optional custom message and appends timestamp automatically

# Get current date and time
NOW=$(date +"%Y-%m-%d %H:%M:%S")

# Determine commit message
if [ -z "$1" ]; then
    COMMIT_MSG="Automatic update: $NOW"
else
    COMMIT_MSG="$1 (updated: $NOW)"
fi

# Add all changes
git add .

# Commit with message
git commit -m "$COMMIT_MSG"

# Push to main branch
git push origin main

echo "✅ Changes pushed to GitHub with message: '$COMMIT_MSG'"
