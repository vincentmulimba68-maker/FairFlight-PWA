#!/bin/bash

# === 1. Check if SSH key exists ===
KEY="$HOME/.ssh/id_ed25519"
if [ ! -f "$KEY" ]; then
    echo "SSH key not found. Creating one..."
    ssh-keygen -t ed25519 -C "vincentmulimba68@gmail.com" -f "$KEY" -N ""
    NEW_KEY=true
else
    echo "SSH key already exists."
    NEW_KEY=false
fi

# === 2. Start ssh-agent and add key ===
eval "$(ssh-agent -s)"
ssh-add "$KEY"

# === 3. If new key, print it for GitHub ===
if [ "$NEW_KEY" = true ]; then
    echo
    echo "Copy this public key and add it to GitHub:"
    cat "$KEY.pub"
    echo
    echo "After adding the key to GitHub, re-run this script to push the repo."
    exit 0
fi

# === 4. Test GitHub SSH connection ===
ssh -o BatchMode=yes -T git@github.com 2>/dev/null
if [ $? -ne 1 ] && [ $? -ne 255 ]; then
    echo "GitHub SSH key authentication failed!"
    echo "Make sure your public key is added to GitHub."
    exit 1
fi

# === 5. Set remote to SSH ===
git remote set-url origin git@github.com:vincentmulimba68-maker/FairFlight-PWA.git
echo "Remote set to SSH."

# === 6. Push the repo ===
git push -u origin main
if [ $? -eq 0 ]; then
    echo "✅ Repo pushed to GitHub successfully."
else
    echo "❌ Failed to push repo. Check if the repository exists and your access rights."
fi
