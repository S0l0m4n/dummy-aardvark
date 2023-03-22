#!/bin/bash -x
#
# Check if the feature branch needs to be rebased onto the base branch
#
# SSA, 2023

# Bash strict mode
set -euo pipefail

# Git remote name
ORIGIN=origin

function show_help {
    echo "Usage: ${0} <base-branch> <feature-branch>"
}

# check args
# ---
if [[ $# == 2 ]]; then
    if [[ "$1" == "-h" || "$1" == "--help" ]]; then
        # help explicitly requested
        show_help
        exit 0
    else
        BASE_BRANCH=$ORIGIN/$1
        FEATURE_BRANCH=$ORIGIN/$2
    fi
else
    show_help
    exit -1
fi

# main script
# ---
commits_in_base_not_in_feature=`\
    IFS=' ' git rev-list ${BASE_BRANCH} ^${FEATURE_BRANCH}`

if [[ ! -z $commits_in_base_not_in_feature ]]; then
    num_commits_in_base_not_in_feature=`\
        echo "$commits_in_base_not_in_feature" | wc -l`
else
    num_commits_in_base_not_in_feature=0
fi

debug_message="\
There are $num_commits_in_base_not_in_feature commits \
in $BASE_BRANCH which are not in $FEATURE_BRANCH \
"

echo $debug_message

# determine return value
#   - if true   (return 0), feature branch does not need to be rebased
#   - if false  (return 1), feature branch needs to be rebased
[[ $num_commits_in_base_not_in_feature == 0 ]]
