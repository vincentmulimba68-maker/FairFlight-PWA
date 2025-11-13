#!/bin/bash
# push_all.sh - automatically add, commit, and 
# push to GitHub Check if commit message was 
# provided
if [ -z "$1" ]; then echo "Usage: ./push_all.sh 
  \"Your commit message\"" exit 1
fi
# Add all changes
git add .
# Commit with provided message
git commit -m "$1"
# Push to the main branch
git push origin main
echo "✅ Changes pushed to GitHub!"
