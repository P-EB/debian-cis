# shellcheck shell=bash
# run-shellcheck
test_audit() {
    describe Running on blank host
    register_test retvalshouldbe 0
    dismiss_count_for_test
    # shellcheck disable=2154
    run blank "${CIS_CHECKS_DIR}/${script}.sh" --audit-all

    describe Correcting situation
    sed -i 's/audit/enabled/' "${CIS_CONF_DIR}/conf.d/${script}.cfg"
    "${CIS_CHECKS_DIR}/${script}.sh" || true

    describe Checking resolved state
    register_test retvalshouldbe 0
    register_test contain "[ OK ] -w /etc/group -p wa -k identity is present in /etc/audit/rules.d/audit.rules"
    register_test contain "[ OK ] -w /etc/passwd -p wa -k identity is present in /etc/audit/rules.d/audit.rules"
    register_test contain "[ OK ] -w /etc/gshadow -p wa -k identity is present in /etc/audit/rules.d/audit.rules"
    register_test contain "[ OK ] -w /etc/shadow -p wa -k identity is present in /etc/audit/rules.d/audit.rules"
    register_test contain "[ OK ] -w /etc/security/opasswd -p wa -k identity is present in /etc/audit/rules.d/audit.rules"
    run resolved "${CIS_CHECKS_DIR}/${script}.sh" --audit-all
}
