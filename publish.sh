#!/bin/bash
# ══════════════════════════════════════════════════════════════
# MARKET BIAS WEEKLY — Weekly Report Publisher
# Run: ./publish.sh [report-file] [date] [summary] [bias-score]
#
# Example:
#   ./publish.sh ~/ta-dashboard/spy_weekly.html 2026-04-13 \
#     "Testing 50 DMA after bounce continuation" "-8"
#
# Or run with no arguments for interactive mode.
# ══════════════════════════════════════════════════════════════

set -e

SITE_DIR="$(cd "$(dirname "$0")" && pwd)"
REPORTS_DIR="$SITE_DIR/reports"

# ── Collect inputs ──────────────────────────────────────────
if [ -n "$1" ]; then
    REPORT_FILE="$1"
    REPORT_DATE="${2:-$(date +%Y-%m-%d)}"
    SUMMARY="${3:-Weekly technical analysis brief}"
    BIAS_SCORE="${4:-0}"
else
    echo ""
    echo "  ╔══════════════════════════════════════╗"
    echo "  ║   MARKET BIAS WEEKLY — Weekly Report Publisher   ║"
    echo "  ╚══════════════════════════════════════╝"
    echo ""
    
    # Find the most recent report file
    LATEST_FILE=$(ls -t ~/ta-dashboard/spy_weekly*.html 2>/dev/null | head -1)
    if [ -n "$LATEST_FILE" ]; then
        echo "  Found: $LATEST_FILE"
        read -p "  Use this file? [Y/n]: " USE_LATEST
        if [ "$USE_LATEST" = "n" ] || [ "$USE_LATEST" = "N" ]; then
            read -p "  Enter report file path: " REPORT_FILE
        else
            REPORT_FILE="$LATEST_FILE"
        fi
    else
        read -p "  Enter report file path: " REPORT_FILE
    fi
    
    read -p "  Report date (YYYY-MM-DD) [$(date +%Y-%m-%d)]: " REPORT_DATE
    REPORT_DATE="${REPORT_DATE:-$(date +%Y-%m-%d)}"
    
    read -p "  One-line summary: " SUMMARY
    SUMMARY="${SUMMARY:-Weekly technical analysis brief}"
    
    read -p "  Bias score (e.g., -18, +25): " BIAS_SCORE
    BIAS_SCORE="${BIAS_SCORE:-0}"
fi

# ── Validate ────────────────────────────────────────────────
if [ ! -f "$REPORT_FILE" ]; then
    echo "  ERROR: File not found: $REPORT_FILE"
    exit 1
fi

# ── Parse date for display ──────────────────────────────────
MONTH_DAY=$(date -d "$REPORT_DATE" +"%b %-d" 2>/dev/null || date -j -f "%Y-%m-%d" "$REPORT_DATE" +"%b %-d" 2>/dev/null || echo "$REPORT_DATE")

# Determine the week range (Mon-Fri)
WEEK_START="$MONTH_DAY"
WEEK_END_DATE=$(date -d "$REPORT_DATE + 4 days" +"%b %-d" 2>/dev/null || echo "")
YEAR=$(date -d "$REPORT_DATE" +"%Y" 2>/dev/null || echo "2026")

# Determine bias color
if [ "$BIAS_SCORE" -lt -30 ] 2>/dev/null; then
    BIAS_BG="var(--red-d)"
    BIAS_COLOR="var(--red-b)"
elif [ "$BIAS_SCORE" -gt 30 ] 2>/dev/null; then
    BIAS_BG="var(--green-d)"
    BIAS_COLOR="var(--green-b)"
else
    BIAS_BG="var(--gold-d)"
    BIAS_COLOR="var(--gold-l)"
fi

echo ""
echo "  Publishing:"
echo "  ├── File:    $REPORT_FILE"
echo "  ├── Date:    $REPORT_DATE"
echo "  ├── Summary: $SUMMARY"
echo "  └── Bias:    $BIAS_SCORE"
echo ""

# ── Copy report files ───────────────────────────────────────
echo "  [1/4] Copying report..."
cp "$REPORT_FILE" "$REPORTS_DIR/$REPORT_DATE.html"
cp "$REPORT_FILE" "$REPORTS_DIR/latest.html"

# ── Update index.html archive ──────────────────────────────
echo "  [2/4] Updating archive..."

# Build the new archive card HTML
NEW_CARD="  <a href=\"/reports/$REPORT_DATE.html\" class=\"archive-card\">
    <div class=\"archive-date\">$MONTH_DAY</div>
    <div class=\"archive-info\">
      <div class=\"archive-title\">SPY Weekly Brief — $MONTH_DAY, $YEAR</div>
      <div class=\"archive-desc\">$SUMMARY</div>
    </div>
    <div class=\"archive-bias\" style=\"background:$BIAS_BG;color:$BIAS_COLOR\">$BIAS_SCORE</div>
  </a>"

# Insert after the archive-list opening div
# Find the line with "archive-list" and insert after it
sed -i "/<div class=\"archive-list\">/a\\
\\
$NEW_CARD" "$SITE_DIR/index.html"

# ── Update latest banner ───────────────────────────────────
echo "  [3/4] Updating latest banner..."

# Update the latest report link title (simplified — updates the date in the banner)
sed -i "s|Published Sunday, [A-Za-z]* [0-9]*, [0-9]*|Published Sunday, $(date -d "$REPORT_DATE - 1 day" +"%B %-d, %Y" 2>/dev/null || echo "$REPORT_DATE")|" "$SITE_DIR/index.html"

# ── Git push ────────────────────────────────────────────────
echo "  [4/4] Deploying to Netlify via GitHub..."
cd "$SITE_DIR"
git add .
git commit -m "Weekly brief: $REPORT_DATE — $SUMMARY"
git push

echo ""
echo "  ╔══════════════════════════════════════════════════╗"
echo "  ║  Published successfully!                         ║"
echo "  ║                                                  ║"
echo "  ║  Report: /reports/$REPORT_DATE.html    ║"
echo "  ║  Latest: /reports/latest.html                    ║"
echo "  ║                                                  ║"
echo "  ║  Netlify will deploy in ~30 seconds.             ║"
echo "  ╚══════════════════════════════════════════════════╝"
echo ""
echo "  Share on X:"
echo "  https://marketbiasweekly.netlify.app/reports/$REPORT_DATE.html"
echo ""
