# harmony-cran

Pre-compiled R binary packages for HarmonyOS (aarch64-linux-ohos).

R 4.6.0 recommended packages, built with `R CMD INSTALL --build` on-device
for the [R-HarmonyOS](https://github.com/sxgou/R-harmonyos) project.

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
    repos = c(harmony_cran = "https://sxgou.github.io/harmony-cran",
              CRAN = "https://cloud.r-project.org"))
```

## Included packages (15)

| Package | Version | Needs compilation |
|---------|---------|-------------------|
| MASS | 7.3-65 | yes |
| Matrix | 1.7-5 | yes |
| survival | 3.8-6 | yes |
| mgcv | 1.9-4 | yes |
| lattice | 0.22-9 | yes |
| nlme | 3.1-169 | yes |
| boot | 1.3-32 | no |
| cluster | 2.1.8.2 | yes |
| codetools | 0.2-20 | no |
| foreign | 0.8-91 | yes |
| KernSmooth | 2.23-26 | yes |
| rpart | 4.1.27 | yes |
| class | 7.3-23 | yes |
| nnet | 7.3-20 | yes |
| spatial | 7.3-18 | yes |

## Structure

```
src/contrib/
  PACKAGES          # metadata (auto-generated)
  PACKAGES.gz
  MASS_7.3-65_R_aarch64-pc-linux-musl.tar.gz
  ...
```

## Build from source

Run `bash build-recommended.sh` on a HarmonyOS device with R installed.

---

*Part of the [R-HarmonyOS](https://github.com/sxgou/R-harmonyos) project.*
