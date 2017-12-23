#!/usr/bin/env bash

set -euf -o pipefail

if [[ $# -gt 0 ]] && [[ "${1:0:1}" != '-' ]]; then
    exec $@
fi

readonly DEFAULT_SS_ENCRYPTION_METHOD='aes-256-cfb'
readonly DEFAULT_SS_PASSWORD='passw0rd'

readonly DEFAULT_KCPTUN_SECRET="it's a secrect"
readonly DEFAULT_KCPTUN_CRYPT="aes"

readonly PROG_NAME="$0"

function usage() {
    cat << EOF
Usage:
    ${PROG_NAME} --help
    ${PROG_NAME} [-m|--method <METHOD>] [-p|--ss-password <PASSWORD>]

Options:
    --help                              show help
    -m|--ss-method          METHOD      shadowsocks encryption method (default: ${DEFAULT_SS_ENCRYPTION_METHOD})
    -p|--ss-password        PASSWORD    shadowsocks password (default: ${DEFAULT_SS_PASSWORD})
    -s|--kcptun-secret      PASSWORD    kcptun pre-shared secret between client and server (default: "${DEFAULT_KCPTUN_SECRET}")
    -c|--kcptun-crypt       CRYPT       aes, aes-128, aes-192, salsa20, blowfish, twofish, cast5, 3des, tea, xtea, xor, sm4, none (default: "${DEFAULT_KCPTUN_CRYPT}")
EOF
}

OPTS=$(getopt -n "$0" -o hm:p:s:c: --long help,ss-method:,ss-password:,kcptun-secret:,kcptun-crypt: -- "$@")

eval set -- "$OPTS"

help='false'
ss_encryption_method="${DEFAULT_SS_ENCRYPTION_METHOD}"
ss_password="${DEFAULT_SS_PASSWORD}"
kcptun_secret="${DEFAULT_KCPTUN_SECRET}"
kcptun_crypt="${DEFAULT_KCPTUN_CRYPT}"
while true; do
    case "$1" in
        -h | --help)
            help='true'
            shift;;
        -m | --ss-method)
            ss_encryption_method="$2"
            shift 2;;
        -p | --ss-password)
            ss_password="$2"
            shift 2;;
        -s| --kcptun-secret)
            kcptun_secret="$2"
            shift 2;;
        -c | --kcptun-crypt)
            kcptun_crypt="$2"
            shift 2;;
        --)
            shift
            break
            ;;
    esac
done

if [[ $# != 0 ]]; then
    usage
    exit 1
fi

if [[ "${help}" = 'true' ]]; then
    usage
    exit 0
fi


exec env \
    SS_METHOD="${ss_encryption_method}" \
    SS_PASSWORD="${ss_password}" \
    KCPTUN_SECRET="${kcptun_secret}" \
    KCPTUN_CRYPT="${kcptun_crypt}" \
    /usr/bin/supervisord --nodaemon -c /etc/supervisor/supervisord.conf -d /
