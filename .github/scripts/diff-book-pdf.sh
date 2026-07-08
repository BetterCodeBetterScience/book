#!/bin/bash
#
# Generate a PDF diff comment and per-page montage assets for the book PR.
#
# Adapted from stamped-principles/stamped-paper's gh-pages-diff-pdf.sh; the
# main difference is that the base PDF is a local file (built in the same
# CI job) rather than fetched from a deployed URL.
#
# Usage: diff-book-pdf.sh <pr-pdf> <base-pdf> <preview-branch> \
#                        <repo> <server> <head-sha> <base-ref>
#
# Inputs:
#   pr-pdf          path to the PR-built book PDF
#   base-pdf        path to the base-branch-built book PDF (may be missing)
#   preview-branch  name of the per-PR preview branch (e.g. gh-pages-pr-42)
#   repo            GitHub repository (owner/name)
#   server          GitHub server URL (https://github.com)
#   head-sha        full SHA of the PR head commit
#   base-ref        name of the base branch (e.g. main) — used in comment text
#
# Outputs in the working directory:
#   pr-comment.md       markdown body for the PR comment
#   diff.pdf            visual diff PDF (only when differences exist)
#   diff-page-NN.png    per-page 3-panel montages for changed pages

set -euo pipefail

pr_pdf="$1"
base_pdf="$2"
preview_branch="$3"
repo="$4"
server="$5"
head_sha="$6"
base_ref="${7:-main}"

raw_base="https://raw.githubusercontent.com/${repo}/${preview_branch}"
view_url="${server}/${repo}/blob/${preview_branch}/book.pdf"
diff_view_url="${server}/${repo}/blob/${preview_branch}/diff.pdf"

{
    echo "<!-- pdf-preview -->"
    echo "### Book PDF"
    echo "Built from ${head_sha}."
    echo "**[View PDF](${view_url})** | **[Download](${raw_base}/book.pdf)**"
} > pr-comment.md

if [ ! -f "$base_pdf" ]; then
    echo "" >> pr-comment.md
    echo "*Base PDF (\`${base_ref}\`) was not available — diff skipped.*" >> pr-comment.md
    exit 0
fi

if diff-pdf --output-diff=diff.pdf --dpi=300 --channel-tolerance=0 -g \
     "$base_pdf" "$pr_pdf"; then
    echo "" >> pr-comment.md
    echo "No visual differences from \`${base_ref}\`." >> pr-comment.md
    exit 0
fi

# Differences exist — build per-page montages.
mkdir -p diff-pages
pdftoppm -png -r 150 diff.pdf    diff-pages/page
pdftoppm -png -r 150 "$base_pdf" diff-pages/base
pdftoppm -png -r 150 "$pr_pdf"   diff-pages/pr

mapfile -t diff_pngs < <(find diff-pages -name 'page-*.png' | sort -V)
mapfile -t base_pngs < <(find diff-pages -name 'base-*.png' | sort -V)
mapfile -t pr_pngs   < <(find diff-pages -name 'pr-*.png'   | sort -V)

base_count=${#base_pngs[@]}
pr_count=${#pr_pngs[@]}
diff_count=${#diff_pngs[@]}
max_count=$((base_count > pr_count ? base_count : pr_count))

changed=0
unchanged=0
added=0
removed=0
page_details=""

for ((i = 0; i < max_count; i++)); do
    page_num=$((i + 1))
    padded=$(printf '%02d' "$page_num")

    if [ "$i" -lt "$base_count" ] && [ "$i" -lt "$pr_count" ]; then
        if [ "$i" -lt "$diff_count" ]; then
            pixels=$(compare -metric AE -fuzz 2% \
                "${base_pngs[$i]}" "${pr_pngs[$i]}" /dev/null 2>&1 || true)

            if [ "$pixels" = "0" ] || ! [[ "$pixels" =~ ^[0-9]+$ ]]; then
                unchanged=$((unchanged + 1))
                page_details+="- Page ${page_num} — unchanged\n"
            else
                changed=$((changed + 1))
                compare -fuzz 2% -highlight-color '#FF000060' \
                    "${base_pngs[$i]}" "${pr_pngs[$i]}" \
                    -compose src "diff-pages/highlighted-${padded}.png" 2>/dev/null || true
                montage_args=(-tile 3x1 -geometry '+4+4')
                if ! montage \
                        -font DejaVu-Sans \
                        -label "${base_ref}" "${base_pngs[$i]}" \
                        -label "PR"          "${pr_pngs[$i]}" \
                        -label "changes"     "diff-pages/highlighted-${padded}.png" \
                        "${montage_args[@]}" "diff-page-${padded}.png" 2>/dev/null; then
                    montage +label \
                        "${base_pngs[$i]}" "${pr_pngs[$i]}" \
                        "diff-pages/highlighted-${padded}.png" \
                        "${montage_args[@]}" "diff-page-${padded}.png"
                fi
                diff_img_url="${raw_base}/diff-page-${padded}.png"
                page_details+="<details><summary>Page ${page_num} — changed</summary>\n\n"
                page_details+="![page ${page_num} diff](${diff_img_url})\n\n"
                page_details+="</details>\n"
            fi
        fi
    elif [ "$i" -lt "$pr_count" ]; then
        added=$((added + 1))
        page_details+="- Page ${page_num} — **new**\n"
    else
        removed=$((removed + 1))
        page_details+="- Page ${page_num} — **removed**\n"
    fi
done

parts=()
[ "$changed"   -gt 0 ] && parts+=("${changed} changed")
[ "$unchanged" -gt 0 ] && parts+=("${unchanged} unchanged")
[ "$added"     -gt 0 ] && parts+=("${added} added")
[ "$removed"   -gt 0 ] && parts+=("${removed} removed")
summary="${pr_count} pages total: $(IFS=', '; echo "${parts[*]}")"
[ "$base_count" -ne "$pr_count" ] && summary+=" (was ${base_count})"

{
    echo ""
    echo "#### Diff vs \`${base_ref}\`"
    echo "${summary}"
    echo "**[View full diff PDF](${diff_view_url})**"
    echo ""
    printf '%b' "$page_details"
} >> pr-comment.md

rm -rf diff-pages
