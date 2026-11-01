# Cut 3 workstream 4: frozen native contract

Accepted authority: tickets.yml cut 3, LDG-3139--3143; synthesis D1--D11.
Frozen before peer comparative outcomes. Source product 891c23c8 (installed
public ledgr, R/src identical to cut acceptance 8e3ec0d8). Fresh suite only;
no legacy/A0 executable adapter is sourced or copied. Frozen cut-2 witnesses stay intact.

## Common rule and inputs

Public ledgr_sim_bars(seed=20260530, start=2020-01-01, prefix=P), daily
weekdays at 21:00 UTC. Qualification 12 instruments x90 pulses; headline
500x1260. Raw OHLC/volume unchanged; cash USD10,000,000, initially flat,
zero fees/slippage/risk, desired quantity zero or one. Native SMA5 and SMA10
of closes. First usable pair seeds state without trading; enter only on a
subsequent usable transition from fast<=slow to fast>slow, exit on reverse.
Unknown scores keep holdings. Signal known at close; ledgr fills next input
bar open and marks that recording pulse's next-open position at its current
close (native dense behavior). Final-pulse orders have no next-bar fill.
This native alignment is compared explicitly, never restamped into parity.

OHLC/session keys are (ASCII instrument ID, exact UTC input pulse).
Peer calendar labels must map by an explicit date/time join, with equal
sets and unique keys; no positional zip. The custom Zipline weekday calendar
is a synthetic input calendar, not an exchange-calendar claim. No target lag,
adapter fill/funding/accounting or silent forced final liquidation.
Native outputs: signed fills with native execution UTC, decision UTC where
native evidence proves it, event order, ID, quantity, price, fee; per-pulse
equity/cash and asset holdings. Qualification additionally retains native
scores, usable masks and sparse entry/exit intent. Pure keyed projections
of native output are allowed; adapter accounting is not.

## Numeric contract (fixed before outcomes)

u=2^-53; gamma(k)=k*u/(1-k*u); k*u<1; scalar test abs(a-b)<=A+R*max(abs(a),abs(b)).
Keys, masks, decisions, quantities and sessions exact, fees exactly zero.
R=8*u throughout. Price A=8*u USD. SMA A=gamma(8*S+64)*max(1,max(abs(close)))
USD; S=input pulses. Cash/equity A=gamma(8*F+8*H+64)*(initial_cash + sum(abs(native
fill notionals)) + fees + held marks) USD; F=exact agreed fill count,H=max held IDs.
Native arithmetic/output precision must fit before claiming equivalence.
NA masks exact, nonfinite nonmissing values refuse. No widened bound,
percentage-of-capital tolerance, near-tie exclusion or different-trade tolerance.
First divergence order: scores/masks, intent, fills/sessions/order, holdings,
cash, equity. Same decisions only and same trades/balances are disjoint;
only fully matched economics AND lifecycle/output clocks yield ratios.

## Measurement

Five isolated processes per engine/shape; rotated then reversed engine order.
Cold launch/import/common input IO/native reusable preparation/first-use through
materialized fills,equity,cash,asset holdings. Warm new independent book,
experiment setup/run/materialization on unchanged prepared native data.
No reusable indicator/signal payload; validation tracing is outside timing,
with exact within-engine economic equality required. All first-use JIT is cold;
actual warmed process is reused. Installation/common simulation outside clocks.
Phase marker: import, input, preparation, cold, retained, warm, complete.
One descendant-tree sampler,250ms,working set/private bytes; retain baseline
and phase peaks. Sampled lower bounds; working-set sums include shared pages,
not unique physical memory. Observe descendant P-core affinity and threads.
High performance/P-core0xFFFF, single external math threads, idle host,
background CPU recorded; invalid host stops its window.20min/attempt,
240min dense lane total,no automatic retry; preserve failed/censored attempts,
mark remaining repetitions explicitly. No optimization round.

## Public native workflow sources and pins

- PMwR1.3-0: https://search.r-project.org/CRAN/refmans/PMwR/html/btest.html
  OHLC list,lag1,trade.at.open,Portfolio,Time,Globals,journal/native histories.
- quantstrat1114e4a1a8a3b68d2fb7a62b52d743cbc5e4b39f:
  https://github.com/braverock/quantstrat/blob/1114e4a1a8a3b68d2fb7a62b52d743cbc5e4b39f/README.md
  strategy/add.indicator/add.signal/add.rule/applyStrategy; ruleSignal prefer Open.
- backtrader1.9.78.123: https://www.backtrader.com/docu/order-creation-execution/order-creation-execution/
  native SMA,Strategy.next,market order,broker/notify_order.
- bt1.4.1: https://pmorissette.github.io/bt/docs/source/overview.html
  Algo/Strategy/Backtest,Security.transact for quantity sizing,native current-close execution.
- zipline-reloaded3.2.1: https://zipline.ml4trading.io/bundles.html and
  https://zipline.ml4trading.io/api-reference.html ; native bundle,history/order_target,
  native daily execution observed before limitation classification.
- PyBroker2.0.2: https://www.pybroker.com/en/latest/reference/pybroker.strategy.html
  and https://www.pybroker.com/en/latest/reference/pybroker.config.html ;
  Strategy/add_execution,delay1,PriceType.OPEN,unrounded result/fill prices.

Python3.12.13 shared environment resolved all four pins and imported them
successfully; separate environments are unnecessary on this tested resolution.
R peers use isolated temporary library; upstream FinancialInstrument/blotter
pins in setup.R. Full transitive environment is frozen after qualification.

## Scope, source budget and report

cut3_peer_suite_file_plan.md allocates every source; cumulative caps unchanged.
Actual minimal native interfaces are qualified before any expected records.
No new/unallocated helper; new estimate/actual cap overrun stops for disposition.
Assignment CSV includes every lane and peer, including seven authoring rules;
missing peers remain in required denominators. Preliminary HTML reads one
explicit committed record, offline,never benchmarks/installs. False equivalence,
omitted peer and wrong record selector must fail. Full-suite readiness remains
with later workstreams; no external claim or legacy retirement here.

## Maintainer amendment: common native price precision, 2026-10-28

Accepted after the first raw-input qualification: round OHLC and volume to
8 decimal places once with R round(x,8), before giving the common fixture to
any engine. This is ledgr's existing snapshot-adapter normalization
(R/snapshot_adapters.R:123--127), not a change to execution or tolerances.
For scaling apply it after low-floor repair and 100+log(price). Preserve
lossless CSV numbers. The raw qualification record remains historical;
freeze/rerun the normalized qualification before headline clocks. The native
cut-2 oracle and baseline remain byte-for-byte unchanged. Native precision or
execution differences that remain are classified without any adapter fix.

## Qualified projection and lifecycle details

Full per-pulse ledgr holdings materialize inside the clock by a SQL running
sum over native FILL quantities, then an ASOF join to native snapshot bars;
terminal quantities must equal public ledgr_state_reconstruct. This is native
ledger extraction, not an adapter filling, cash or PnL engine. Other engines
materialize their native per-pulse position histories; Zipline's documented
held-position lists are sparse, so absent entries mean no native holding.
Quantstrat cash projects native account End.Eq minus native portfolio Net.Value;
no trade is replayed by the adapter. Extra native initial-account rows before
input start are disclosed and outside the keyed comparison window.

Fill tables project into chronological execution-session order, preserving
native within-pulse order. Cross-peer checks never reorder a pulse by asset
ID to create agreement. Intents compare full desired-quantity timelines on
the common decision window through the penultimate input pulse (PMwR does
not invoke a final close signal without a following execution bar). Expanding
a native desired quantity through holds is only a decision-trace projection;
it creates no fill, cash, funding or execution delay.

Clocks use a monotonic process timer; cold adds observed UTC process startup.
The adapter return boundary includes native book/connection close where the
adapter performs it. Record writing and explicit between-book collection are
outside clocks. First-use process state is warm; OS/filesystem or persistent
Numba cache coldness is not claimed. Hash seed0 and external math/Numba
threads1 are fixed before launch; loaded DuckDB threads are observed, not
changed through a private connection policy. Python requirements.lock captures
the tested complete shared environment. Source/product versions and raw attempts
are retained; no favourable retry is permitted for measured rows.

## Accepted workflow and budget amendments,2026-10-29

Maintainer requested canonical ephemeral and spot-FIFO workflow rows in dense,
scaling and sessions; assignments.csv now explicitly includes their18 required
slots. These are public one-candidate ledgr_sweep calls with retained equity/
returns and closed-trade PnL, not full fill/cash/position outputs. Their retained
series and closed-trade PnL matched the durable public run exactly on12x90
(90 equity observations,51 closed trades). They have no full-output peer ratio.
The maintainer explicitly allowed2000 cumulative R lines. The current
completion forecast is2000/reserve0; the file plan records its full accounting.

R native captures now use uncompressed RDS3, preserving native primitive types
and floating values without a large all-row CSV formatting allocation before
the warm retained-memory sample. Python captures remain lossless CSV. The
framework selects its declared capture format; old R CSV captures remain tied
to source1acdb21b, with no current-format fallback. Record export has its own
phase outside the clocks and execution-memory phases. Compact comparison and
measurement CSVs remain review inputs. Frozen cut2 artifacts are unchanged.

Quantstrat quote xts objects and immutable instrument definitions belong to
reusable native preparation; each warm iteration still creates a new native
portfolio/account/orderbook, registers the strategy and recomputes indicators.
The preparation-boundary change preserves exact native small-fixture economics.
Clocks are persisted at each completed arm before export, so a later censor
cannot erase a completed cold observation. A captured partial clock is not
promoted into a completed cold/warm pair. Current R peer dependency versions
are checked against r_requirements.csv after isolated provisioning.

## Discovered lifecycle defect,2026-10-29 (speed diagnosis)

The d3373cd7 durable warm observations are invalid as fresh research
iterations. The adapter omitted run_id on both arms; product registration
maps equal config/seed to one run ID and returns a DONE run without executing
the fold (run-registration.R:14-23; backtest-runner.R:787-789). Profiling
observed ledgr_run return in0.06s while fill reading and state reconstruction
took4.47s and4.36s. Exact economics alone did not detect this reuse.
The prior8.33s durable warm figure and its comparative interpretation are
withdrawn. Raw records remain unchanged. The frozen cut2 timing worker
already supplies distinct timing_cold/timing_warm IDs and is unaffected.
The candidate harness correction supplies explicit suite_cold/suite_warm
IDs and captures native run IDs/state-row counts. Separate profiles will
check fresh execution and gut completed-run reuse; no controlled timing
window is restarted by this diagnosis. Reduced-output sweep observations
are separate from the durable cache defect.

## Corrected WS4 clock and guard candidate

Fresh durable arms explicitly use suite_cold and suite_warm; the worker and
collector require distinct native IDs and the full native strategy-state row
count. Sweep candidates use those same explicit labels; returned pulse counts,
positive native t_engine and actual execution seeds are retained. The master
seed stays20260530; the public sweep derives its candidate seed from its label.
The pure rule's retained economics remain exact against the frozen controls.

Required fills/equity/cash/full holdings remain inside the durable clock.
The extra terminal recovery assertion runs after both arms, in phase validation.
Recovery mutates derived tables, so it operates on a disposable full ledger copy;
the measured ledger is unchanged. Export, validation and inter-arm gc stay outside
clocks; their memory is separate from preparation/cold/retained/warm phases.

The shared sampler now retains process names, creation times and parent IDs.
Descendant links require a child born no earlier than its claimed live parent;
foreign-R detection uses the same process snapshot as descendant collection.
The original failed window cannot identify PID47644's image retrospectively;
its24-CPU affinity violation remains invalid and is never waived. A real child
allocation with deliberately changed affinity exercises the live shared guard.
The scheduled250ms poll records actual timestamps; unobserved short phases are
missing observations, never zero memory. Stopped windows retain every remaining
slot explicitly. PriorLaneSeconds charges earlier work against the same240-minute
lane budget. The maintainer authorized completing the corrected window on2026-10-29.

Qualification attempts corrected-qualification and corrected-qualification-2
are non-promoted harness failures (read-only recovery and unnamed grid call).
Corrected-qualification-3 and final-scratch each complete all nine workflows;
exact native diffs and financial/lifecycle corruptions pass. Product R/src,
registered fixtures and frozen cut2 sources/records remain unchanged.

## Corrected window stopped by unrelated R work

The bbfdba14 window completed two pairs for all nine workflows, then stopped
at spot-FIFO repetition3 startup. Its failure metadata identifies three
unrelated Rscript/Rterm processes, with no affinity violation.18 pairs are
complete, one is host_invalid and26 remaining slots are explicit unrun.
All36 completed-arm native financial controls match exactly. No five-repeat
ratio is eligible. This is a stopped window, not completion of planned clocks;
no automatic retry or clock mixture occurs. Prior7928 plus2633.027492 seconds
remain charged to the same14400-second lane budget. Maintainer disposition
of a further reserved-host window is pending.


## WS4 independent review correction round1

The first Type1 review returned five implementation findings, retained in
cut3_workstream4_review.md. The R dependency lock now gives exact native URLs
for all19 packages, installed in dependency order and checked together in
an explicit temporary library; user/site libraries are excluded for R peers.
The measured original library remains unchanged. The corrected default is
C:/Users/maxth/AppData/Local/Temp/ledgr-peer-suite-cut3-r-library-isolated;
setup.R takes that path as its first argument. Source archives require the
recorded Windows R/Rtools toolchain. Missing archives or mismatched versions
fail rather than replacing pins with current versions.

Host preflight and postflight now return recorded invalid outcomes rather
than throwing before persistence. memory.ps1 -SamplerMode hostwitness
-WitnessOut <new-directory> exercises both using actual foreign R processes;
each case retains one invalid plus four unrun slots and its stopped session.
The launch epoch is cast to double before round-trip formatting, including
exact seconds. The renderer independently checks five complete native pairs
on both sides, required outputs, actual ledgr book IDs and financial controls
before accepting a ratio flag. The shared D2 gut covers insufficient repeats.
Zipline's next-session CLOSE execution is disclosed alongside bundle rounding.

Correction qualification: C:/Users/maxth/AppData/Local/Temp/ledgr-peer-ws4-correction1-scratch
has an empty all-nine native diff using the fully restored R peer library;
C:/Users/maxth/AppData/Local/Temp/ledgr-peer-ws4-correction1-guts passes all
financial/record/cash/DONE-run/insufficient-repeat controls. Host boundaries
pass in C:/Users/maxth/AppData/Local/Temp/ledgr-peer-ws4-correction1-host-guts.
These correctness probes do not restart headline clocks. The measured runtime
remains bbfdba14, with18 completed pairs and no eligible ratio.


## Optional vectorbt/PMwR dense diagnostic,2026-10-29

Maintainer request: add a vectorbt measurement specifically against PMwR.
This is a bounded additional dense pair, not an eighth required framework,
new five-lane assignment, completion of the missing original WS4 repeats or
permission for external claims. Existing six-peer/105 assignments stay fixed.
- DiagnosticPair vectorbt selects only PMwR/vectorbt in the shared runner;
normal runs are unchanged. The same250ms sampler, host guards, cold/warm
endpoints, five pairs, fixed numeric bounds and cumulative dense budget apply.

Vectorbt1.2.0 core, explicitly engine=numba, Numba0.68.1, Python3.12.13,
separate70-dependency environment in python/vectorbt_requirements.lock;
optional Rust/PRO are not measured. Public native MA.run computes fresh SMA5/10
per arm. Portfolio.from_signals uses the documented shifted close-signal /
explicit open-price recipe: this is native next-open execution, not fabricated
fills or accounting. Shared USD1e7 cash, unit size, long-only, no accumulation,
partial fill, fees or slippage; final signals have no following input fill.
Native orders/cash/value/assets expose all four required full-output surfaces.

Primary workflow references: https://vectorbt.dev/getting-started/features/
and https://vectorbt.dev/api/portfolio/base/ ; package pin from
https://pypi.org/pypi/vectorbt/1.2.0/json . Reproduce the separate environment:
uv venv --python 3.12.13 <new-temp-env>, then uv pip sync --python <python.exe>
suite/python/vectorbt_requirements.lock. The measured existing Python and R
libraries remain unchanged. PMwR uses the independently restored isolated R
library already qualified by WS4 review.

Small native cold/warm fork qualifies; fresh scratch diff and actual same-bar
execution gut pass. Large native qualification matches cash/equity exactly,
unit holdings, signal decisions and native fill keys/quantities. PMwR's journal
reports close prices while vectorbt reports execution opens; retain decision-
only classification and no trade-equivalent speed ratio. Within-engine hashes
normalize only lossless numeric types and UTC units. The rdata reader projects
native RDS facts without new R code or a compatibility path in product code.
The first extraction incorrectly supplied group_by to Portfolio.assets;
its stopped qualification is retained and the public assets() reader fixed it.

Full local qualification: TEMP/ledgr-vectorbt-qualification-2 (12x90),
TEMP/ledgr-vectorbt-large-qualification-1 (500x1260); checks/scratch/gut:
TEMP/ledgr-vectorbt-check-small-1 and TEMP/ledgr-vectorbt-scratch-1.
Compact qualification controls are frozen in records/20261029-vectorbt-pmwr.
The new controlled pair window charges11200 prior seconds against14400,
conservatively covering previous windows, qualification/review probes and
this added native work. It is a new maintainer-requested comparison, not an
automatic retry of the stopped nine-workflow window.


## Maintainer correction: native CSV and trace-only PMwR evidence

Ledgr preparation now calls public ledgr_snapshot_from_csv directly. There
is no preceding base-R CSV parse; parsing/normalization/sealing are one native
cold preparation surface, with no separately available input_sec. Warm still
runs from the same sealed snapshot. R peers retain independent input loading.
The worker's callback/equity-row check avoids a second ledgr bars read; the
collector's actual-input pulse-count check stays intact. Small CSV/from_df
hash parity, all-nine scratch native diff and all existing guts pass.

PMwR intent-matrix/index extraction executes only in trace mode; required
results and every indicator calculation stay timed. No package/strategy change
or promised warm gain. Source R/PS line counts do not increase. Two-engine
order now truly alternates, correcting rotate+reverse cancellation; nine-
workflow order stays unchanged. Any new measurements use a new explicit source
and window; older clocks are not pooled into a before/after speedup claim.


## Maintainer-authorized WS4 finish window,2026-10-29

The maintainer accepted360 cumulative dense minutes for this current product
generation only, retaining all historical charges and unchanged20-minute
attempt/host/five-repeat/economic rules. The new all-nine window explicitly
uses -DenseBudgetSeconds21600 -PriorLaneSeconds11800. The precharge rounds
up11602.4450681 plus subsequent small independent review work. No older
clock is pooled with the fresh45 cold/warm processes. The runner defaults
to14400 for other windows; other lane and future-generation limits stay fixed.
An invalid host stops this window, with no automatic retry.


## Active host-policy replacement,2026-10-30

Maintainer directed redesign after idle R sessions repeatedly blocked useful
work. This supersedes the R-presence and one-core-background vetoes above
for new peer records only, aligning with shared timing commit0de48f7f.

- Enforce High performance and0xFFFF on the measured process tree.
- Observe background CPU and other R; neither refuses nor invalidates a run.
  Boundary CPU samples retain the top five positive increments, using
  PID/creation identity; before/during/after R observations are retained.
  Short-lived processes between samples and continuous contention are not
  fully observed. Background context and timing spread remain visible.
- Keep all repeats and every attempted outcome. No outlier deletion,
  favourable retry or claim that a normal desktop is contention-free.
- Leave other sessions alone. Native correctness, reset, output, attempt/
  lane/memory limits and source identities are unchanged.

Historical stopped windows keep their original status. New attempts declare
background_observed_v1. The existing sampler/runner/checkers implement this
policy; no new harness or imported old execution infrastructure is introduced.


## WS5 geometry and actual research sessions, 2026-10-31

The accepted assignment CSV owns the exact four geometries and peers, plus
three ledgr workflows on each. Scaling inputs repair low=min(low,open,close),
then transform OHLC=100+log(price), round8 and preserve volumes/IDs. The
funding envelope, valid OHLC, unique keys and declared dimensions were
executed on all four actual CSVs before native outcomes. The20x23400 labels
are exactly60 synthetic390-minute sessions14:31--21:00UTC, not product
exchange-calendar/intraday support. Cash remains1e7 and quantities0/1.

Ordinary geometries have five isolated cold/warm processes;1166x7200 has
one descriptive process,120-minute/16GiB tree-private caps and no precise
ranking or ratio. Sessions use unchanged raw12x90 input and N10/100/1000
fresh experiments per arm for ledgr durable/canonical ephemeral/spot-FIFO,
PMwR and PyBroker. Session processes have20-minute caps, five attempts where
feasible, and the shared600-minute scaling/stress/session budget. Prior
qualification, debugging and verification charges are retained. No automatic
retry, projected completed counts, reduced replacement or product optimization.

Each session arm executes the actual N public native calls. Every call
recalculates indicators and materializes the declared workflow outputs.
Only unchanged native prepared input is shared; ledgr supplies a distinct
native book/candidate ID each time, and Python constructs a new native
Strategy/portfolio. Explicit progress writes, identity and engine-work checks
are inside the batch clock. All N native results stay resident until the arm
finishes; exact within-engine financial equality is checked outside that
clock before exporting the final native book. The other arm's results are
released before its retained-input sample. Snapshot/run storage accumulated
by the public durable workflow remains part of its observed session cost.

Cold is launch/input/preparation plus N experiments; warm is another N
experiments on prepared input. Neither is a multiplication-based estimate.
Per-book CSVs retain actual returned calls/IDs, verified financial-equality
flags after a completed arm, and positive engine seconds for every sweep
book. Censored prefixes retain observed completion counts even when financial
verification is unfinished; they never become complete-pair medians or ratios.
Original partial clocks and sampled memory remain recorded with their status.

All completed timed native controls must match the executed shape/reference
controls. Scores, native fill order and balances use the same fixed bounds;
no precision relaxation or agreement promotion is introduced. The shared
checker reruns actual N10 books, diffs their native results, corrupts an
observed count and runs real cash/DONE-book reuse guts. Empty phase reads are
marked transition_unobserved, with no invented phase or memory attribution.

Maintainer explicitly raised the cumulative R source cap to2300 on2026-10-31.
Other source, time and memory caps remain unchanged. Full WS5 acceptance
requires its independent Type1 rerun/gut/diff review; later lanes, integrated
release generations and external-report readiness remain separate obligations.


## WS5 executed cold-capture correction

The b385551e measurement window was deliberately stopped after an actual
worker inspection showed the Python post-batch loop retaining a cold-result
reference into warm. Backtrader's pinned metabase.findowner also reads caller
frame locals; simple del alone left cached references resident on Python3.12.
The worker now deletes every result/loop reference and synchronizes locals
outside the clock. Its --probe retention control proves the actual cold
equity object is gone before warm; --probe retention-gut deliberately keeps
it and must fail. Shared D3 owns this lifecycle check; native strategies,
prices, input data, targets, fees and financial oracles do not change.

The defective window's entire actual clock/status set is preserved and
excluded, not pooled or selected by runtime. Its existing no-overwrite guard
was used to stop before the next native workload, with an explicit executor
note; current work finished naturally and no process was killed. This is
an executor stop before work, not a native framework limitation. Corrected
measurements require a successfully committed source and the same600-minute
cumulative budget, including the stopped window's elapsed time. The shared
runner now accepts -StopFile <absolute-path>: an operator-created file stops
new workers after the current one and persists all remaining unrun slots,
without an artificial failure or terminating processes. It never auto-resumes.


## Maintainer-amended PMwR coverage, 2026-10-31

PMwR is required on every WS5 shape. Add20x23400 and1166x7200 to the
assignment CSV (107 required rows). Use -Lane scaling -OnlyEngines pmwr
-OnlyShapes '20x23400,1166x7200': first qualify, then measure five ordinary
processes and one descriptive stress process, with unchanged cold/warm
outputs, pinned adapter, inputs, host/sampler rules and resource bounds.
Both windows charge the existing600-minute ledger. The original in-flight
80-slot window remains intact; the six new measured assignments retain
their own source/window and are collected together without overlapping IDs.
suite/pmwr_shapes.R compares qualification to executed ledgr references
under unchanged numeric bounds and freezes PMwR's exact native financial
controls before measurement. A changed fill with unchanged equity must fail.
Launch after the current measured window to avoid self-contention. All
other shapes already have required PMwR measurements or session assignments.

The two added PMwR assignments run in a later PMwR-only window. They are
not counterbalanced against already collected peers. Retain actual ordering,
source and background observations and report absolute workflow clocks.
No existing peer or covered PMwR case is rerun to change this ordering.


## Active quantitative vectorbt amendment, 2026-10-31

Maintainer accepts vectorbt as seventh regular quantitative peer: native
12x90, headline500x1260, all four scaling shapes, N10/100/1000 sessions,
cold/warm and process-tree memory. Matrix116 supersedes107. Rotation,
seven authoring recipes, custom stateful callbacks and PIT capability are
explicitly deferred. Existing core1.2.0/Numba adapter/environment only;
no new semantic adapter, product change, price/accounting rewrite or RFC.

Use DiagnosticPair vectorbt for paired windows on every quantitative lane.
Ordinary process order alternates PMwR/vectorbt first; five repeats give3/2
first-position counts. Stress remains one descriptive process per engine,
with actual order disclosed and no ranking/ratio. AttemptPrefix paired_
keeps original IDs unambiguous. VectorbtPython selects its existing isolated
environment; other Python peers stay in their own pinned environment.
Main sessions use OnlyEngines ledgr,ledgr_ephemeral,ledgr_spot_fifo,pybroker;
paired sessions use PMwR/vectorbt, each actual N fresh books per arm.

The unified pair_qualification.R replaces the narrow PMwR qualification
wrapper (history at2f39a913). Same primary field bounds, native projections,
exact cold/warm economic diff, book checks and changed-fill gut. It retains
old valid PMwR headline/scaling clocks in previous_pmwr, unpooled, solely
because the maintainer requests balanced new observations. The original
80-slot raw window is unchanged. Its70 non-PMwR rows are an explicit data
view whose native directories/source/phase samples remain original.
New pair controls and normal collector admit all required116 assignments.

Exact paired cash, equity, holdings and decision agreement are separate
fields, alongside native reported-price agreement and observed dollar
differences. Exact failure remains false; no forced fill-price parity or
widened bound. The portfolio-state fields describe this crossover only.
No new top-five, custom callback, authoring or PIT comparison is implied.
Historical PMwR-first optional records remain historical. No source/time
allowance resets: current dense21600/scaling36000-second caps and all prior
charges remain. Whole WS5 still needs independent rerun/gut/diff review.


Environment repair,2026-10-31: the first paired headline window stopped
before vectorbt ran because the previously qualified environment lost six.py
and package metadata. All10 statuses/two excluded PMwR clocks remain in
records/20261031-regular-pair-stopped-env;17.0157293 seconds stay charged.
Use a new task-owned copy-mode environment from the unchanged70-package
lock, requalify native outputs against frozen controls, then a wholly new
balanced cohort. The controller never automatically retries. The optional
checker now passes the explicit VectorbtPython selector it already owns.
No native adapter, value, expected financial control, bound or time cap
changes. This is an environment correction, not timing-selected resampling.


Stable runtime correction,2026-10-31: later TEMP file losses affected the
vectorbt launcher and the primary Python dependency tree. Their deleting
actor remains unattributed. Exact70/106 pins were restored offline as copies
under ~/.cache/ledgr-peer-benchmark/, outside TEMP, and actual native outputs
were requalified. The runner and common Python corruption-probe defaults
use those stable paths. No native adapter, input, financial oracle or bound
changes. All31 completed scaling observations and three completed R session
observations are retained with original metadata; only missing workers run.
The stopped source windows and every elapsed charge remain explicit history.
