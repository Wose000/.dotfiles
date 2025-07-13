#!/usr/bin/env bash

regex() {
    [[ $1 =~ $2 ]] && printf '%s\n' "${BASH_REMATCH[1]}"
}

ETHERNET_INTERFACE="enp2s0"

inet_partial=$(ip -brief addr | grep "$ETHERNET_INTERFACE")

inet=$(regex "$inet_partial" '^enp2s0\s*UP\s*([0-9]{3}\.[0-9]{3}\.[0-9]\.[0-9]{2}).*$')

