# shellcheck shell=bash
# run-shellcheck
test_audit() {
    if [ -f "/.dockerenv" ]; then
        skip "SKIPPED on docker"
    else
        describe Running on blank host
        register_test retvalshouldbe 0
        dismiss_count_for_test
        # shellcheck disable=2154
        run blank "${CIS_CHECKS_DIR}/${script}.sh" --audit-all

        describe correcting situation
        sed -i 's/audit/enabled/' "${CIS_CONF_DIR}/conf.d/${script}.cfg"
        "${CIS_CHECKS_DIR}/${script}.sh" --apply || true

        describe Checking resolved state
        register_test retvalshouldbe 0
        register_test contain "No profiles are unconfined"
        run resolved "${CIS_CHECKS_DIR}/${script}.sh" --audit-all
    fi
}
