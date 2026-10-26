# Source of the market-data example

ledgr-demo-bars.csv is a 60-row extract of the local ledgr repository's bundled
synthetic ledgr_demo_bars dataset. source.json records the source revision,
dataset hash, selection, generator, and export hash.

Only DEMO_01's first 60 timestamp-ordered observations are exported. The article
uses the last 30 for static comparisons and the same 60 for the interactive
chart. Numeric fields use 17 significant digits and were checked to round-trip
exactly; ts_utc is exported as ISO 8601 UTC and parsed back to POSIXct UTC.

To refresh from a ledgr checkout, load data/ledgr_demo_bars.rda into a fresh R
environment, select those rows, format the timestamps as %Y-%m-%dT%H:%M:%SZ, and
format numeric fields with sprintf("%.17g", values). Write comma-separated
values with only the first two columns quoted. Update source.json and rerender
the article explicitly to refresh _freeze.

The publishing site reads this extract directly. It does not need an installed
ledgr package, a sibling checkout, a database, or a data-provider connection.
Do not substitute adjusted prices or carry missing observations forward.