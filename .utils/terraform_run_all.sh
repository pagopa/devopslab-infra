#!/bin/bash



#
# bash .utils/terraform_run_all.sh <Action>
# bash .utils/terraform_run_all.sh init
#

# 'set -e' tells the shell to exit if any of the foreground command fails,
# i.e. exits with a non-zero status.
set -eu

pids=()
ACTION="$1"

array=(
    '.identity::dev'
    'src/aks-platform::itn-dev'
    'src/core::dev'
    'src/coreplus::dev'
    'src/domains/blueprint-app::dev'
    'src/domains/blueprint-common::dev'
    'src/domains/diego-app::itn-dev'
    'src/domains/diego-common::itn-dev'
    'src/domains/diego-container-apps::dev'
    'src/domains/legacy-common::dev'
    'src/domains/marco-common::dev'
    'src/domains/umberto-common::dev'
    'src/domains/test-app::itn-dev'
    'src/domains/test-common::itn-dev'
    'src/elk-monitoring::dev01'
    'src/grafana-monitoring::dev01'
    'src/packer::dev'
)

function rm_terraform {
    find . \( -iname ".terraform*" ! -iname ".terraform-docs*" ! -iname ".terraform-version" ! -iname ".terraform.lock.hcl" \) -print0 | xargs -0 rm -rf
}

# echo "[INFO] 🪚  Delete all .terraform folders"
# rm_terraform

echo "[INFO] 🏁 Init all terraform repos"
for index in "${array[@]}" ; do
    FOLDER="${index%%::*}"
    COMMAND="${index##*::}"
    pushd "$(pwd)/${FOLDER}"
        echo "$FOLDER - $COMMAND"
        echo "🔬 folder: $(pwd) in under terraform: $ACTION action"
        sh terraform.sh "$ACTION" "$COMMAND" &

        # terraform providers lock \
        #   -platform=windows_amd64 \
        #   -platform=darwin_amd64 \
        #   -platform=darwin_arm64 \
        #   -platform=linux_amd64

        pids+=($!)
    popd
done


# Wait for each specific process to terminate.
# Instead of this loop, a single call to 'wait' would wait for all the jobs
# to terminate, but it would not give us their exit status.
#
for pid in "${pids[@]}"; do
  #
  # Waiting on a specific PID makes the wait command return with the exit
  # status of that process. Because of the 'set -e' setting, any exit status
  # other than zero causes the current shell to terminate with that exit
  # status as well.
  #
  wait "$pid"
done
