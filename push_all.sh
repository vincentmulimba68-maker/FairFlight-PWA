#!/bin/bash
# push_all.sh - automatically add, commit, and 
# push to GitHub Adds date/time to commit 
# message automatically Get current date and 
# time
NOW=$(date +"%Y-%m-%d %H:%M:%S")
# Add all changes
git add .
# Commit with automatic message
git commit -m "Automatic update: $NOW"
# Push to main branch
git push origin main
echo "✅ Changes pushed to GitHub with timestamp: $NOW"
