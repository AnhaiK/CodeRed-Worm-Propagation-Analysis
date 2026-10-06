# CodeRed Worm Propagation — Computational Analysis

This repository contains Julia code used to explore and analyze Code-Red worm
propagation data. The analysis is organized into **July** and **August**
workflows.

The main idea throughout the code is to start from **cumulative observations**
and transform them into quantities that are easier to inspect, plot, and
compare.

---

## 1. What the Code Is Doing

The scripts mainly perform four steps:

1. **Read the CDF data** from text files.
2. **Parse the timestamp and cumulative infection count** from each row.
3. **Convert Unix timestamps into Julia `DateTime` values** for time-based analysis.
4. **Plot the resulting quantities** to visually study worm propagation.

Some scripts go further by calculating **non-cumulative infection counts**
between consecutive observations and, in the August analysis, an exploratory
**slope-like quantity**.

---

# 2. July Analysis

The July scripts are in:

```text
src/july/
```

### `cred_july_start_cdf.jl`

This script reads the July **start CDF** data.

For each data row it extracts:

- the Unix timestamp;
- the cumulative number of infected hosts;
- a converted `DateTime` representation of the timestamp.

The processed values are stored in a `DataFrame`.

The purpose of this script is to turn the raw CDF text data into a structured
table that can be inspected and plotted.

---

### `cred_july_start_cdf_v2.jl`

This is another version of the July start-CDF processing.

It follows the same general workflow:

```text
raw CDF data
      ↓
parse timestamp + cumulative infections
      ↓
convert timestamp to DateTime
      ↓
store in DataFrame
      ↓
plot the observations
```

The script provides an alternate implementation of the start-time analysis.

---

### `cred_july_end_cdf.jl`

This script works with the July **end CDF**.

It reads the end-time information and stores values such as:

- end timestamp;
- cumulative recovered/ended observations;
- converted time information.

It then plots the processed data so that the distribution of ending times
can be examined.

---

### `cred_july_duration_cdf.jl`

This script processes the July **duration CDF**.

It extracts duration-related observations, converts the time information into
a usable `DateTime` representation, and plots the cumulative distribution.

Conceptually:

```text
duration CDF
     ↓
parse observations
     ↓
convert time values
     ↓
DataFrame
     ↓
visualize distribution
```

---

### `cred_july_infected_dur_non_cummulativ.jl`

This script moves from a **cumulative** quantity to a
**non-cumulative** quantity.

If consecutive observations contain:

```text
100 infected
130 infected
170 infected
```

the script can calculate the increments:

```text
100
30
40
```

So instead of asking:

> "How many infections have accumulated up to this point?"

the analysis can ask:

> "How many new infections occurred between consecutive observations?"

This is useful for examining the distribution of infection-duration
increments.

---

### `cred_july_infected_dur_non_cummulativ_excludefirst.jl`

This script performs a similar cumulative-to-non-cumulative transformation,
but treats the **first observation separately/excludes it from the
successive-difference calculation**.

The important operation is the calculation of differences between consecutive
cumulative infection counts.

---

### `dat1.jl`

This script reads a country-distribution style data file line by line.

It is a small data-reading/processing utility rather than one of the main
July plotting workflows.

---

# 3. August Analysis

The August scripts are in:

```text
src/august/
```

The August analysis is particularly useful because it goes beyond simply
plotting the cumulative CDF.

---

## `cred_aug_start_cdf.jl`

This script processes the August **start CDF**.

It:

1. opens `codered-august.start.cdf.txt`;
2. ignores comment lines;
3. extracts the timestamp;
4. extracts the cumulative infection count;
5. converts the Unix timestamp into `DateTime`;
6. stores everything in a `DataFrame`;
7. plots time against cumulative infections.

The basic relationship being visualized is:

```text
time  →  cumulative number of infected hosts
```

The resulting plot provides a visual representation of the August infection
progression.

---

## `cred_aug_start_pdf.jl`

This script takes the August start-CDF analysis one step further.

Instead of only using the cumulative infection count, it calculates the
**difference between consecutive cumulative observations**.

For example:

```text
Cumulative:       100   130   170   190

Difference:        —     30    40    20
```

The differences represent the change between consecutive observations.

The script stores this as:

```text
non_cummulative_inf
```

and plots it against the normalized time representation.

So the workflow becomes:

```text
Cumulative infection data
          ↓
Difference between observations
          ↓
Non-cumulative infection increments
          ↓
Plot against time
```

This helps inspect where the infection activity changes more rapidly.

---

## `test.jl`

`test.jl` is an exploratory analysis script.

It calculates two changes between consecutive observations:

```text
x = change in time
y = change in cumulative infections
```

and then calculates:

```text
slope = y / x
```

In other words, the code is examining a quantity of the form:

```text
change in infections
--------------------
     change in time
```

The resulting slope-like quantity is then plotted against the time value.

This provides an exploratory way to inspect how quickly the cumulative infection
count is changing over time.

> **Important:** this script is exploratory code; the repository documents
> exactly what the calculation does rather than claiming that it represents a
> finalized epidemiological model.

---

# 4. How the July and August Workflows Relate

The overall progression is approximately:

```text
                 CodeRed CDF data
                        │
              ┌─────────┴─────────┐
              │                   │
            July                August
              │                   │
       Parse CDF data       Parse start CDF
              │                   │
       Convert timestamps    Convert timestamps
              │                   │
          DataFrames            DataFrame
              │                   │
       Plot distributions   Cumulative plot
              │                   │
       Calculate differences       │
              │                   ↓
              │          Calculate differences
              │                   │
              │                   ↓
              │             y / x slope
              │                   │
              └───────────┬───────┘
                          ↓
                  Exploratory analysis
```

The important computational idea is the transition from **cumulative data**
to **incremental changes**, followed by visualization and exploratory
rate/slope calculations.

---

# 5. Tools and Libraries

The original scripts use/reference Julia packages including:

- `DataFrames` — tabular data storage and manipulation
- `Dates` — conversion and handling of dates/times
- `PyCall` — interoperability with Python
- `Plots` — visualization
- `Queryverse`
- `ReadableRegex`

Not every script necessarily requires every package.

---

# 6. Repository Structure

```text
.
├── README.md
├── src/
│   ├── july/
│   │   ├── cred_july_start_cdf.jl
│   │   ├── cred_july_start_cdf_v2.jl
│   │   ├── cred_july_end_cdf.jl
│   │   ├── cred_july_duration_cdf.jl
│   │   ├── cred_july_infected_dur_non_cummulativ.jl
│   │   ├── cred_july_infected_dur_non_cummulativ_excludefirst.jl
│   │   └── dat1.jl
│   │
│   └── august/
│       ├── cred_aug_start_cdf.jl
│       ├── cred_aug_start_pdf.jl
│       └── test.jl
│
├── data/
├── results/
└── docs/
```

---

# 7. Data Policy

The original Code-Red source dataset is **not included** in this repository.

The supplied source documentation states that the CAIDA Code-Red dataset may
not be redistributed. Therefore, the repository contains the analysis code
but not the restricted source data.

Source information:

https://www.caida.org/data/passive/codered_worms_dataset.xml

Place permitted source data locally in `data/` when reproducing the analysis.

---

# 8. Reproducing the Analysis

The general workflow is:

```text
1. Obtain the permitted source data.
2. Place the required CDF file in data/.
3. Open the relevant Julia script.
4. Check the local data path.
5. Run the script with Julia.
6. Inspect the generated DataFrame/output.
7. Inspect the generated plot.
```

The scripts were originally written as research/analysis code, so some paths
or package requirements may need adjustment on a new machine.

---

# 9. What This Repository Demonstrates

This project demonstrates practical computational work involving:

- Julia programming;
- parsing structured research data;
- DataFrame-based data processing;
- Unix timestamp conversion;
- cumulative vs. non-cumulative data;
- numerical differences between observations;
- exploratory rate/slope calculations;
- visualization of time-series/distribution data;
- reproducible organization of research code.

The repository focuses on the **computational analysis represented by these
scripts** and does not claim ownership of the underlying dataset.
