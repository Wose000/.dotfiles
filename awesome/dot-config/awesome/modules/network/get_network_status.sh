#!/usr/bin/env bash

regex() {
    [[ $1 =~ $2 ]] && printf '%s\n' "${BASH_REMATCH[1]}"
}

ETHERNET_INTERFACE="enp"
WIRELESS_INTERFACE="wps"

ethernet_partial=$(ip -brief addr | grep "$ETHERNET_INTERFACE")
wireless_partial=$(ip -brief addr | grep "$WIRELESS_INTERFACE")

inet_wired=$(regex "$ethernet_partial" '^enp[a-zA-Z0-9]*\s*UP\s*([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*$')
inet_wireless=$(regex "$wireless_partial" '^wps[a-zA-Z0-9]*\s*UP\s*([0-9]+\.[0-9]+\.[0-9]+\.[0-9]+).*$')

public=$(curl -s ipinfo.io/ip)

echo -e "inet_wired:$inet_wired public:$public"
