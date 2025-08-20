#!/bin/bash

# Daily GitHub Issues Sync Script
# This script can be run daily to keep issues synchronized

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "🔄 Starting daily GitHub issues sync..."
echo "⏰ $(date)"

# Run the fetch script
bash "$SCRIPT_DIR/fetch-issues.sh"

if [ $? -eq 0 ]; then
    echo "✅ Daily sync completed successfully!"
else
    echo "❌ Daily sync failed!"
    exit 1
fi

echo "📊 Sync completed at $(date)" 