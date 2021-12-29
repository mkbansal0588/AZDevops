echo "Get all outputs from terraform output."
v_all_outputs=$(terraform -chdir="$1" output -json)
v_output=$(echo ${v_all_outputs} | jq -c 'with_entries(select(.key | endswith("custom_dns_configs")))')
echo "Subtitute value from json."
for object_dns_configs in $(echo "${v_output}" | jq -c '.[]'); do
    tuple_dns_configs=$(echo "${object_dns_configs}" | jq -c '.value')
    for array_dns_configs in $(echo "${tuple_dns_configs}" | jq -c '.[]'); do
        for value_dns_configs in $(echo "${array_dns_configs}" | jq -c '.[]'); do
            itIsAnArray=$(echo ${value_dns_configs} | jq 'type=="array"')
            value=$value_dns_configs
            if ${itIsAnArray}; then
                value="$(echo "${value_dns_configs}" | jq -c '.[]')"
            fi
            _getElementInObject() {
                echo ${value} | jq -r ${1}
            }
            fqdn=$(_getElementInObject '.fqdn')
            ip_addresses=$(_getElementInObject '.ip_addresses' | tr -d '[]"')
            echo ${fqdn} " : " ${ip_addresses}
            printf "%s : %s\n" ${fqdn} ${ip_addresses} >> "./../dnsEntries/dns_entries.txt"
        done
    done
done