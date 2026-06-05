#!/bin/sh
# build-recommended.sh — Build R recommended packages as binary tarballs
# Run this ON a HarmonyOS device where R is installed.
#
# Usage:  bash build-recommended.sh
# Output: src/contrib/<Package>_<version>_aarch64-linux-ohos.tar.gz
#
# Prerequisites:
#   - R installed and in PATH
#   - R sources extracted at the path below (or override via R_SRC)

set -e

R_SRC="${R_SRC:-${HOME}/R-harmonyos/src/R-4.6.0}"
STAGING_LIB="${STAGING_LIB:-/tmp/harmony-cran-staging}"
OUTPUT_DIR="src/contrib"

mkdir -p "$STAGING_LIB" "$OUTPUT_DIR"

# Get list of recommended packages from R source metadata
RECOMMENDED_PKGS=$(grep '^R_PKGS_RECOMMENDED *=' \
    "${R_SRC}/share/make/vars.mk" 2>/dev/null | \
    sed 's/^R_PKGS_RECOMMENDED *= *//')

if [ -z "$RECOMMENDED_PKGS" ]; then
    echo "Error: could not read recommended packages from ${R_SRC}"
    echo "Set R_SRC to point to the R source tree."
    exit 1
fi

echo "=== Building recommended packages for HarmonyOS ==="
echo "Packages: $RECOMMENDED_PKGS"
echo ""

PKG_OK=0
PKG_FAIL=0
FAILED_LIST=""

for pkg in $RECOMMENDED_PKGS; do
    echo "--- Building $pkg ---"

    # Find the source tarball
    src_tgz=$(find "${R_SRC}/src/library/Recommended" -name "${pkg}_*.tar.gz" | head -1)
    if [ -z "$src_tgz" ]; then
        echo "  [SKIP] $pkg: source tarball not found in Recommended/"
        PKG_FAIL=$((PKG_FAIL + 1))
        FAILED_LIST="$FAILED_LIST $pkg"
        continue
    fi

    # Build binary package
    if R CMD INSTALL --build \
        --library="$STAGING_LIB" \
        --configure-args="--host=aarch64-linux-ohos" \
        "$src_tgz" 2>&1; then
        echo "  [OK] $pkg built successfully"
        PKG_OK=$((PKG_OK + 1))
    else
        echo "  [FAIL] $pkg build failed (see above)"
        PKG_FAIL=$((PKG_FAIL + 1))
        FAILED_LIST="$FAILED_LIST $pkg"
    fi
done

# Collect binary tarballs (R CMD INSTALL --build creates them in CWD)
echo ""
echo "=== Collecting binary packages ==="
mv *.tar.gz "$OUTPUT_DIR/" 2>/dev/null || echo "  (No tarballs to move)"

# Generate PACKAGES metadata
echo "=== Generating PACKAGES metadata ==="
R -e "tools::write_PACKAGES('${OUTPUT_DIR}', type = 'source')" --no-echo

# Cleanup
rm -rf "$STAGING_LIB"

echo ""
echo "=== Summary ==="
echo "  OK:   $PKG_OK"
echo "  FAIL: $PKG_FAIL"
if [ -n "$FAILED_LIST" ]; then
    echo "  Failed packages:$FAILED_LIST"
fi
echo ""
echo "Binary packages in: $OUTPUT_DIR/"
echo "Regenerate README.md with current status after reviewing failures."
