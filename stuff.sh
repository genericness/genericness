#!/bin/bash

# Script to create hundreds of commits with random emails and names

# Function to generate random string
random_string() {
    cat /dev/urandom | tr -dc 'a-z0-9' | fold -w ${1:-10} | head -n 1
}

# Function to generate random name
random_name() {
    local first=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 8 | head -n 1)
    local last=$(cat /dev/urandom | tr -dc 'a-z' | fold -w 10 | head -n 1)
    echo "${first} ${last}"
}

# Function to generate random email
random_email() {
    local user=$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 12 | head -n 1)
    local domains=("gmail.com" "yahoo.com" "hotmail.com" "outlook.com" "protonmail.com" "icloud.com" "mail.com" "aol.com" "zoho.com" "fastmail.com")
    local domain=${domains[$RANDOM % ${#domains[@]}]}
    echo "${user}@${domain}"
}

# Set git config to genericness
git config user.name "genericness"

# Number of commits to create
NUM_COMMITS=500

echo "Creating $NUM_COMMITS commits (genericness with random emails)..."

for i in $(seq 1 $NUM_COMMITS); do
    # Generate random email (same for author and committer)
    RANDOM_EMAIL=$(random_email)
    
    # Generate random commit message
    COMMIT_MSG=$(random_string 20)
    
    # Make a small change to TEST.md
    echo "# Commit $i - $(random_string 15)" >> TEST.md
    
    # Stage the change
    git add TEST.md
    
    # Create commit with genericness as both author and committer, but random email
    GIT_AUTHOR_NAME="genericness" \
    GIT_AUTHOR_EMAIL="$RANDOM_EMAIL" \
    GIT_COMMITTER_NAME="genericness" \
    GIT_COMMITTER_EMAIL="$RANDOM_EMAIL" \
    git commit -m "$COMMIT_MSG" --no-verify
    
    # Progress indicator
    if [ $((i % 50)) -eq 0 ]; then
        echo "Created $i commits..."
    fi
done

echo "Done! Created $NUM_COMMITS commits (author: genericness, random committers)."
echo "You can now push with: git push origin main (or your branch name)"
echo "To see the commit history: git log --oneline"
