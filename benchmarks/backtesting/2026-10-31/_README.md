# Benchmark publication package

Article: ../../../articles/fastest-backtester-plain-r/index.qmd
Artifact landing page: index.qmd
Standalone report: report.html
Source/evidence download: data/source-and-evidence.zip

Both Quarto pages are enabled for production rendering. Deployment remains
separate: a push to main publishes through the existing GitHub Pages workflow.

## Publication scope

The November 1 article shares the measured SMA workloads from the October 31
snapshot. It does not claim a general framework ranking or complete-suite
acceptance. The source report and independent review retain their original
preliminary/internal-review status; enabling publication does not upgrade
that review's verdict into external or complete-suite certification.

The source/evidence comes from ledgr commit e29407b1. No sibling checkout is
needed or modified. Report navigation links were adapted to the local
methods/history sections; all 19 tables and the embedded plot are preserved.
The original byte-identical HTML is inside the ZIP. source.json records
source revisions, hashes, navigation changes and later hardware observation.

The ZIP supplies an inspection snapshot independently of the benchmark
commit's availability on GitHub. It does not contain installed third-party
libraries or the large raw native captures. Preserve these original assets;
later core measurements belong in a new dated package.

## Render and verify

Use Quarto 1.10.19 with R, knitr and rmarkdown installed:

    quarto render articles/fastest-backtester-plain-r/index.qmd
    quarto render

The article computes medians from the copied timing CSV, checking that all
four shapes and three workflows have five observations. Rendering does not
load ledgr, install dependencies or run benchmarks. Whole-site renders reuse
the committed _freeze results, including in CI without R installed.

Verify the article and benchmark landing page, report and downloads in the
production output. Check that each article feed contains this article and
that the showcase is absent from listings, search, sitemap and feeds. Inspect
desktop/mobile in light/dark themes, table scrolling and methodology disclosure.
Never deploy the preview profile, which deliberately exposes draft content.

Commit source, documented assets and refreshed article _freeze results;
exclude _site, .quarto and temporary verification tools. The repository README
documents the rest of the publishing workflow.

## Publication verification, 2026-11-01

Quarto 1.10.19 production rendering passed after explicitly executing the
article. An isolated source copy also rendered from _freeze with R deliberately
unavailable and without a sibling checkout. Checks passed for 308 local links
and assets, all four full-content feeds with one article each, and exclusion
of the draft showcase and seven removed placeholders from discovery surfaces.

All nine downloadable evidence hashes match source.json. The original report
inside the ZIP matches its recorded hash; all 19 tables and the embedded image
match the served report. The 12 displayed medians each have five observations
and match the refreshed frozen output. The ZIP contains 133 files including
the source license, with no sensitive filenames or common credential signatures
found in the publication check.

Browser checks at 1440x1050 and 390x844 passed in light/dark themes for the
article, archive and benchmark page. There was no page overflow or JavaScript
exception; table minima, category filters and methodology disclosure passed.
Screenshots and temporary audit tools are outside tracked source. No benchmark
runs, commits, pushes or deployments were performed for this publication change.
