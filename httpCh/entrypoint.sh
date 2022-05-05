#!/bin/sh

set -e

PROXY_PORT="19200"

AddIPRuleSet() {
    nsenter -t ${PID} -n iptables -t nat -A PREROUTING -i eth0 -p tcp --dport ${TARGET_PORT} -j REDIRECT --to-port ${PROXY_PORT}
}

StartProxyServer() {
    nsenter -t ${PID} -n /toxiproxy -host=0.0.0.0 > /dev/null 2>&1 &
}

CreateProxy() {
    nsenter -t ${PID} -n /toxiproxy-cli create -l 0.0.0.0:${PROXY_PORT} -u localhost:${TARGET_PORT} proxy
}

CreateToxic() {
    case $TOXIC_TYPE in

        toggle)
            nsenter -t ${PID} -n /toxiproxy-cli toggle proxy
            ;;

        reset_peer)
            nsenter -t ${PID} -n /toxiproxy-cli toxic add -t reset_peer -a timeout=${RESET_PEER_TIMEOUT} proxy
            ;;

        latency)
            nsenter -t ${PID} -n /toxiproxy-cli toxic add -t latency -a latency=${TOXIC_LATENCY} proxy
            ;;

        *)
            echo -e "\n[Error]: Unknown TOXIC_TYPE given, Exiting...\n"
            exit 1
            ;;
    esac
}

DeleteProxy() {
    nsenter -t ${PID} -n /toxiproxy-cli delete proxy
}

StopProxyServer() {
    nsenter -t ${PID} -n sudo kill -9 $(ps aux | grep [t]oxiproxy | awk 'FNR==1{print $1}')
}

RemoveIPRuleSet() {
    nsenter -t ${PID} -n iptables -t nat -D PREROUTING -i eth0 -p tcp --dport ${TARGET_PORT} -j REDIRECT --to-port ${PROXY_PORT}
}

echo -e "\n[Info]: Starting HTTP Chaos-------------\n"

StartProxyServer
sleep 5
CreateProxy
CreateToxic
AddIPRuleSet
sleep ${TOTAL_CHAOS_DURATION}
RemoveIPRuleSet
DeleteProxy
StopProxyServer

echo -e "\n[Info]: Chaos Completed-------------------\n"