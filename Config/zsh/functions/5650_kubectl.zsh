#!/bin/zsh
print_debug '  ♾️️ Loading Functions [5650] - Kubectl Functions' 'yellow'

verify_commands kubectl || return 1

function kkns() {
    kubectl proxy &
    local proxy_id=$!
    sleep 2

    kubectl get ns | rg 'Terminating' | while read -r line; do 
        local tns=$(echo "$line" | awk '{print $1}')
        print_color "Force terminating Namespace: $tns" "red"

        local result=$(kubectl get ns "$tns" -o json | jq '.spec = {"finalizers":[]}')
        curl -k -H "Content-Type: application/json" -X PUT \
            --data-binary "$result" \
            "127.0.0.1:8001/api/v1/namespaces/$terminating_ns/finalize" > /dev/null
    done

    kill $proxy_pid 2>/dev/null
}