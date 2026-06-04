# harmony-cran

Pre-compiled R binary packages for HarmonyOS (aarch64-linux-ohos).

## Usage

Add this repository to your R repo chain via `harmony_install()`:

```r
harmony_install("Matrix")
```

The `harmony_install()` function (provided by the R-HarmonyOS project's
`.Rprofile`) automatically checks this repository before falling back to
CRAN source compilation.

## Manual install

```r
install.packages("Matrix",
    repos = c(harmony_cran = "https://yourname.github.io/harmony-cran",
              CRAN = "https://cloud.r-project.org"))
```

## What's in this repo

Only packages that are difficult to cross-compile from source on HarmonyOS.
Packages that compile fine with `--host=aarch64-linux-ohos` are not included
here — they install directly from CRAN.

## Build from source

Run `bash build-recommended.sh` on a HarmonyOS device with R installed.

## Structure

```
src/contrib/
  PACKAGES          # metadata (auto-generated)
  PACKAGES.gz
  Matrix_1.7-1.tar.gz
  ...
```
