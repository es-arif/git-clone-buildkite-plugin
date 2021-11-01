#!/usr/bin/env bats

PROJECT_DIR=$(cd "${BATS_TEST_DIRNAME}/.." && pwd)

load "$BATS_PATH/load.bash"

@test "Echos repository" {
  export BUILDKITE_PLUGIN_GIT_CLONE_REPOSITORY="git@github.com:first-aml/git-clone-buildkite-plugin.git"

  stub git "clone : echo ${BUILDKITE_PLUGIN_GIT_CLONE_REPOSITORY}"

  run "${PROJECT_DIR}/hooks/post-checkout"

  assert_success
  assert_output --partial "cloning repository git@github.com:first-aml/git-clone-buildkite-plugin.git"

  unstub git
}

@test "Echos repository with branch" {
  export BUILDKITE_PLUGIN_GIT_CLONE_REPOSITORY="git@github.com:first-aml/git-clone-buildkite-plugin.git"
  export BUILDKITE_PLUGIN_GIT_CLONE_BRANCH="develop"

  stub git "clone : "

  run "${PROJECT_DIR}/hooks/post-checkout"

  assert_success
  assert_output --partial "cloning repository git@github.com:first-aml/git-clone-buildkite-plugin.git --branch develop"

  unstub git
}

@test "Echos repository with commit" {
  export BUILDKITE_PLUGIN_GIT_CLONE_REPOSITORY="git@github.com:first-aml/git-clone-buildkite-plugin.git"
  export BUILDKITE_PLUGIN_GIT_CLONE_COMMIT="1a95aa566597dcbd00a5cc313de038d5998ba7f8"

  stub git "clone : "

  run "${PROJECT_DIR}/hooks/post-checkout"

  assert_success
  assert_output --partial "cloning repository git@github.com:first-aml/git-clone-buildkite-plugin.git 1a95aa566597dcbd00a5cc313de038d5998ba7f8"

  unstub git
}

@test "Fails when both branch and commit are set" {
  export BUILDKITE_PLUGIN_GIT_CLONE_REPOSITORY="git@github.com:first-aml/git-clone-buildkite-plugin.git"
  export BUILDKITE_PLUGIN_GIT_CLONE_COMMIT="1a95aa566597dcbd00a5cc313de038d5998ba7f8"
  export BUILDKITE_PLUGIN_GIT_CLONE_BRANCH="develop"

  run "${PROJECT_DIR}/hooks/post-checkout"

  assert_failure
  assert_output --partial "both branch and commit parameters are set, unable to determine correct clone option"
}
