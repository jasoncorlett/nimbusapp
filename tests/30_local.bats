#!/usr/bin/env bats
#
# Local usage tests
# 

load helper
load docker_assert

function setup() {
    export NIMBUS_BASEDIR="$BATS_TMPDIR/nimbusapp-test-local"
    export TEST_FILE="$NIMBUS_BASEDIR/testfile.dockerapp"

    if is_first_test; then
        mkdir -p "$NIMBUS_BASEDIR"
        cleanup_containers "$TEST_CONTAINER"

        cp -v "$BATS_TEST_DIRNAME/nimbusapp-test.dockerapp" "$TEST_FILE"
        sed -i -e 's/^MESSAGE:.*/MESSAGE: "USE LOCAL FILE"/' $TEST_FILE
    fi
}

function teardown() {
    if is_last_test; then
        cleanup_containers "$TEST_CONTAINER"
        rm -fr "$NIMBUS_BASEDIR"
    fi
}

@test "Local: Render" {
    cd "$NIMBUS_BASEDIR"

    run "$NIMBUS_EXE" "$TEST_FILE" render

    echo $output

    (( status == 0 ))
    grep 'container_name: nimbusapp-test-web' <<< $output
    grep 'message: USE LOCAL FILE' <<< $output
}

@test "Local: Run" {
    cleanup_containers "$TEST_CONTAINER"
    assert_not_container_exists "$TEST_CONTAINER"

    "$NIMBUS_EXE" "$TEST_FILE" -d up

    assert_container_running "$TEST_CONTAINER"

    run docker exec "$TEST_CONTAINER" /bin/sh -c 'echo -n $message'

    (( status == 0 ))
    [[ "$output" == "USE LOCAL FILE" ]]
}

