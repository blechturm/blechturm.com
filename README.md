# blechturm.com

Source for Max Thomasberger's Quarto technical publishing site.

## Prerequisites

Install [Quarto CLI](https://quarto.org/docs/get-started/) (tested with
1.10.19, also pinned in CI) and Git. Quarto's installer includes Pandoc;
no Node/npm installation is needed. RStudio can use an installed Quarto CLI.

The initial site needs only Quarto to render. To execute R articles, install
[R](https://cran.r-project.org/) and then:

~~~r
install.packages(c("knitr", "rmarkdown"))
~~~

Install any additional article packages in your local R environment.

## Write and render

From the repository root:

~~~bash
quarto preview
quarto render
~~~

Preview watches for edits and shows drafts. A full render writes the public
site to _site/; drafts are blank and omitted from listings, search, sitemap,
and feeds. _site/ and .quarto/ are ignored by Git.

Create `articles/<slug>/index.qmd`, using an existing draft as a starting
point. Give it a title, an author, a real publication date (date: YYYY-MM-DD),
categories (use R, ledgr, and quant-finance consistently), and optionally
a description. Keep draft: true until publication. URLs are
`https://blechturm.com/articles/<slug>/`.

R chunks use the usual fenced {r} syntax. Quarto handles syntax highlighting,
copy buttons, figures, tables, and cross-references. Set author and toc in each article's front matter; use toc: false for a short
article. Index pages keep a plain title without article metadata.
Add real entries to references.bib and cite them with [@key].
The bibliography is deliberately empty initially.

### Frozen computation

The `execute: freeze: auto` setting reuses computations during a whole-site
render unless the article source changes. To execute or refresh one article:

~~~bash
quarto render articles/<slug>/index.qmd
quarto render
~~~

Commit the article and its generated `_freeze/` results, including figures.
The freeze directory is intentional source-controlled computational evidence;
rendered HTML is not committed. CI renders static HTML from the frozen results
without installing R or article packages. Quarto regenerates its bundled clipboard and listing libraries; frozen R
widget dependencies under _freeze/site_libs/ must be committed with the results.
Always render computational articles
locally before pushing, and commit the updated freeze results with source edits.

Freeze does not track changed data, packages, shared scripts, or random state.
Keep input provenance and package versions with each computational article,
set an explicit seed where needed, and explicitly rerun affected articles when
those inputs change. Do not commit credentials or private data into source or
frozen output.

## Deployment

Pushes to main and manual runs of .github/workflows/publish.yml render with
Quarto 1.10.19, upload _site/ as a Pages artifact, and deploy it using GitHub's
Pages actions and OIDC. No deploy token, gh-pages branch, committed HTML,
database, CMS, or JavaScript build system is required.

In **Settings → Pages**, set **Source: GitHub Actions**. Set **Custom domain**
to blechturm.com. The website.site-url setting uses the HTTPS apex as the site base URL; the
root CNAME is also copied into the output. With Actions, GitHub's custom-domain
setting is authoritative; a CNAME file alone does not configure the domain.

## Custom domain and DNS

Configure the Pages custom domain first, then create these records at the
registrar/DNS provider (TTL: provider default, or 3600 seconds):

| Type | Name | Value |
| --- | --- | --- |
| A | @ | 185.199.108.153 |
| A | @ | 185.199.109.153 |
| A | @ | 185.199.110.153 |
| A | @ | 185.199.111.153 |
| CNAME | www | blechturm.github.io |

Optional IPv6 records:

| Type | Name | Value |
| --- | --- | --- |
| AAAA | @ | 2606:50c0:8000::153 |
| AAAA | @ | 2606:50c0:8001::153 |
| AAAA | @ | 2606:50c0:8002::153 |
| AAAA | @ | 2606:50c0:8003::153 |

Replace conflicting web-hosting records for @/www; preserve unrelated mail
and verification records. Do not include a repository path in the www
CNAME. With both names configured and the apex selected in Pages, GitHub
redirects www.blechturm.com to blechturm.com.

After DNS propagation and GitHub certificate issuance, enable **Enforce HTTPS**
in Pages settings. Consider verifying the domain in GitHub account settings;
GitHub supplies the exact account-specific TXT record. No registrar changes
are made by this repository or workflow.

See GitHub's [custom domain documentation](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site/managing-a-custom-domain-for-your-github-pages-site)
for the authoritative DNS and HTTPS instructions.

## RSS and syndication

The full-content article feed is
https://blechturm.com/articles/index.xml. Add that URL to an RSS reader.
Published pages appear automatically. Drafts are excluded.

Category feeds use ordinary Quarto filtered listings, with no custom generator:

- R: https://blechturm.com/articles/r.xml
- ledgr: https://blechturm.com/articles/ledgr.xml
- quant-finance: https://blechturm.com/articles/quant-finance.xml

For R-Bloggers, submit the full-content R-only feed (articles/r.xml) through
its [submission process](https://www.r-bloggers.com/add-your-blog/) after
publishing suitable R articles. Tag R-related posts with the exact category R.
R-Bloggers requires an R-only, full-content feed; acceptance is external to
this site.

Quarto references: [listings and feeds](https://quarto.org/docs/websites/website-listings.html),
[drafts](https://quarto.org/docs/websites/website-drafts.html),
[freeze](https://quarto.org/docs/projects/code-execution.html).

## Publishing showcase

The public design demonstration at articles/quarto-showcase/index.qmd uses
lorem ipsum prose and synthetic data. Share its live URL:
https://blechturm.com/articles/quarto-showcase/.
It uses only the showcase category, keeping it out of the R syndication feed.
Preview it at
http://localhost:4200/articles/quarto-showcase/ using the explicit draft-preview profile:

~~~bash
quarto preview --profile preview --render all
~~~

The preview profile makes drafts visible locally; the default production
render keeps them hidden.

To execute this demonstration, install ggplot2, DT, and plotly in addition to knitr
and rmarkdown. Ordinary whole-site renders reuse the committed frozen results.
The article has its own bibliography, generated from R's actual citation
metadata; the shared references.bib remains empty.

## Publication plotting style

Source R/plot-theme.R from an article's setup chunk. It provides
blechturm_palette(), theme_blechturm(), scale_colour_blechturm(),
scale_fill_blechturm(), and layout_blechturm(), each with light/dark modes.

The optional plotly_blechturm() wrapper adapts up to four scatter/line traces
to the page theme in the browser. Use line styles or symbols as well as color.
The showcase also demonstrates pre-rendered light/dark ggplot2 variants.
Theme changes never rerun R in the browser.

The showcase opts into a Tufte-inspired article layout with margin references
and an in-article contents list. Navigation and listing pages retain their
existing layout. Explicitly rerender articles after changing shared R helpers:
freeze does not track those helper files automatically.

Navigation pages share the site grid and keep category filters in the archive.
Author and contents metadata belongs to individual articles. The small
navigation include keeps Articles active on its category and article pages.

The Articles archive uses includes/_articles.ejs.md with Quarto's native
category filtering. The filter buttons select topics in place; categories
beside article dates are plain metadata. Title-block category badges are
disabled, and RSS remains available in the navigation and footer. Category feed
pages remain available at their existing URLs. The preview contains the three
planned drafts and four entries labeled "Layout mock". All seven retain
draft: true and are excluded by the default production render and feeds.
Preview-profile feeds may include drafts; do not deploy that profile.

Typography sizes and colors live in styles.css. Code wraps visually without
changing the text copied by Quarto's native Copy button. On narrow screens
the line-number gutter is hidden. The showcase uses code-annotations: below
so explanations also work with touch. Plotly shows only zoom, pan, and reset,
with separate toolbar space above and the legend below.