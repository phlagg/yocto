# Force OpenSSH to permit root login and empty passwords during development
do_compile:append() {
    echo "PermitRootLogin yes" >> ${B}/sshd_config
    echo "PermitEmptyPasswords yes" >> ${B}/sshd_config
}
