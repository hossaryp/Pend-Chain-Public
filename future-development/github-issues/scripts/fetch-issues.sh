#!/bin/bash

# GitHub Issues Fetcher for Pend Beta Repository
# This script fetches all issues from the GitHub repository and organizes them

REPO="hossaryp/beta"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BASE_DIR="$(dirname "$SCRIPT_DIR")"
RAW_DATA_DIR="$BASE_DIR/raw-data"

echo "🔍 Fetching GitHub Issues for $REPO..."

# Check if GitHub CLI is installed and authenticated
if ! command -v gh &> /dev/null; then
    echo "❌ GitHub CLI is not installed. Please install with: brew install gh"
    exit 1
fi

# Check authentication
if ! gh auth status &> /dev/null; then
    echo "🔐 GitHub CLI is not authenticated. Please run: gh auth login"
    exit 1
fi

# Create timestamp for this fetch
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

echo "📥 Fetching all issues..."

# Fetch all issues
gh issue list --repo "$REPO" --state all --limit 1000 \
    --json number,title,body,state,labels,assignees,milestone,createdAt,updatedAt,url,author \
    > "$RAW_DATA_DIR/all-issues-$TIMESTAMP.json"

if [ $? -eq 0 ]; then
    echo "✅ All issues saved to: all-issues-$TIMESTAMP.json"
    # Create symlink to latest
    ln -sf "all-issues-$TIMESTAMP.json" "$RAW_DATA_DIR/all-issues-latest.json"
else
    echo "❌ Failed to fetch all issues"
    exit 1
fi

# Fetch open issues specifically
echo "📥 Fetching open issues..."
gh issue list --repo "$REPO" --state open --limit 1000 \
    --json number,title,body,state,labels,assignees,milestone,createdAt,updatedAt,url,author \
    > "$RAW_DATA_DIR/open-issues-$TIMESTAMP.json"

if [ $? -eq 0 ]; then
    echo "✅ Open issues saved to: open-issues-$TIMESTAMP.json"
    ln -sf "open-issues-$TIMESTAMP.json" "$RAW_DATA_DIR/open-issues-latest.json"
fi

# Fetch closed issues
echo "📥 Fetching closed issues..."
gh issue list --repo "$REPO" --state closed --limit 1000 \
    --json number,title,body,state,labels,assignees,milestone,createdAt,updatedAt,url,author \
    > "$RAW_DATA_DIR/closed-issues-$TIMESTAMP.json"

if [ $? -eq 0 ]; then
    echo "✅ Closed issues saved to: closed-issues-$TIMESTAMP.json"
    ln -sf "closed-issues-$TIMESTAMP.json" "$RAW_DATA_DIR/closed-issues-latest.json"
fi

# Count issues
TOTAL_ISSUES=$(jq length "$RAW_DATA_DIR/all-issues-latest.json" 2>/dev/null || echo "0")
OPEN_ISSUES=$(jq length "$RAW_DATA_DIR/open-issues-latest.json" 2>/dev/null || echo "0")
CLOSED_ISSUES=$(jq length "$RAW_DATA_DIR/closed-issues-latest.json" 2>/dev/null || echo "0")

echo ""
echo "📊 Issue Summary:"
echo "   Total: $TOTAL_ISSUES"
echo "   Open: $OPEN_ISSUES"
echo "   Closed: $CLOSED_ISSUES"

# Run the parser if it exists
if [ -f "$SCRIPT_DIR/parse-issues.js" ]; then
    echo ""
    echo "🔄 Running issue parser..."
    cd "$SCRIPT_DIR"
    node parse-issues.js
else
    echo ""
    echo "ℹ️  To organize issues by category, run: node scripts/parse-issues.js"
fi

echo ""
echo "✅ GitHub issues fetch completed!"
echo "📁 Raw data saved in: $RAW_DATA_DIR"
echo "🔗 Latest files:"
echo "   - all-issues-latest.json"
echo "   - open-issues-latest.json" 
echo "   - closed-issues-latest.json" 