#!/bin/bash
# Exit immediately on error, print commands, and fail on pipe errors
set -exo pipefail

mkdir -p build

meson setup build ${MESON_ARGS} \
    -Dwerror=false \
    -Dlogging=disabled \
    -Dexamples=false \
    -Dgstreamer=disabled
meson compile -C build
meson install -C build

# conda-forge injects RUNPATH into the shared lib, so libpisp's is_installed()
# heuristic (backend_default_config.cpp) returns false and resolves the config
# relative to the .so — <libdir>/libpisp/backend/ — instead of PISP_BE_CONFIG_DIR.
# Mirror the json there so the default (no-env-var) path works.
install -Dm644 src/libpisp/backend/backend_default_config.json \
  "$PREFIX/lib/libpisp/backend/backend_default_config.json"