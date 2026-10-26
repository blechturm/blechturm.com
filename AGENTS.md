# blechturm publishing notes

This repository is the Quarto source for https://blechturm.com.
Keep it a lightweight static publication. The sibling ledgr repository is
separate; do not modify it as part of site work.

## Article style reference

articles/quarto-showcase/index.qmd is the canonical style and authoring
reference for all articles on this site. Use its final presentation as the
template; adapt the content and include only the features an article needs.
Do not copy its placeholder prose, publication metadata, or synthetic results
into a real article.

- Preserve the graphite backgrounds, neutral text and headings, and blue
  interaction accents for links, selected navigation, filters, tabs, and focus.
  Typography, spacing, and colors are shared in styles.css.
- Use serif prose/headings and sans-serif navigation/metadata with the shared
  type scale. Avoid per-article CSS, new fonts, or independent palettes.
- Use the article-tufte body class. Long technical articles use numbered
  sections and an in-body, numbers-only table of contents. Margin notes and
  references follow the showcase where useful.
- Keep titles, descriptions, author, date, and categories accurate. Article
  categories are plain metadata in the archive; filtering belongs to the
  archive controls. Title-block category badges remain disabled.
- Use Quarto's native Copy button in the separate code toolbar. Code wraps
  visually, line numbers disappear on narrow screens, and annotations appear
  below the code. Preserve copied source and touch interaction.
- Reuse R/plot-theme.R for ggplot2 and Plotly figures. Plot colors derive from
  the ledgr logo's navy, blue, orange, and gray, with contrast adjustments for
  each theme. Use line styles, shapes, or hollow/filled bodies as well as color.
- Static figures should have readable light/dark variants where applicable.
  Use plotly_blechturm() for supported interactive traces. Keep room above
  charts for the zoom/pan/reset toolbar and below for legends; check mobile.
- R/market-plots.R and the showcase's market-data section demonstrate OHLC
  bars, filled/hollow candles, aligned volume, and interactive inspection.
  Preserve UTC timestamps, observation gaps, price basis, and data provenance.
  Blue means close >= open; orange means close < open.
- Label synthetic data and distinguish market inputs from strategy results.
  Do not invent research findings, citations, trades, or performance claims.
  Use descriptive figure alt text and the configured bibliography support.

## Authoring and verification

- Articles live at articles/<slug>/index.qmd. Start unfinished work with
  draft: true. The original planned stubs and layout mocks remain drafts.
- Read README.md for prerequisites and operations. Use quarto preview for
  writing; quarto preview --profile preview --render all also shows drafts.
  Never deploy the preview profile.
- Use quarto render for a production build. Explicitly rerender computational
  articles after changing shared R helpers, input data, or packages: freeze
  does not automatically track those inputs.
- Commit source, documented input assets, and required _freeze results.
  Do not commit _site, .quarto, local caches, or temporary verification tools.
  The site must render from its own checkout without a sibling ledgr checkout.
- Check production rendering, internal links/assets, RSS, and draft exclusion.
  For presentation changes, inspect light/dark desktop and mobile views;
  verify code copying/annotations and affected chart interactions.
- Primary navigation pages keep their stable layout and do not inherit an
  article's author block or table of contents. AGENTS.md is maintainer guidance,
  excluded from site rendering.
- Pushes to main deploy through the existing GitHub Pages workflow. Preserve
  the canonical HTTPS domain and CNAME. DNS changes require separate approval.
- Keep the publishing stack minimal: no CMS, database, server-side application,
  JavaScript framework, analytics, or unrelated npm tooling.