#!/bin/bash


REPORT_FILE="network_report.txt"


{
    echo "=================================================="
    echo "            NETWORK HEALTH CHECK REPORT           "
    echo "=================================================="
    
    echo -e "\n[1] Server Information"
    echo "----------------------"
    echo "Hostname:     $(hostname)"
    echo "Current User: $(whoami)"
    echo "Date and Time: $(date)"

    
    echo -e "\n[2] Network Information"
    echo "-----------------------"
    
    echo "IP Address:      $(ip route get 1.1.1.1 2>/dev/null | awk '{print $7}' || echo "Not Found")"
    
    echo "Default Gateway: $(ip route | grep default | awk '{print $3}' || echo "Not Found")"
    
    echo "DNS Server:      $(grep -m 1 nameserver /etc/resolv.conf | awk '{print $2}' || echo "Not Found")"

    
    echo -e "\n[3] Internet Connectivity Check"
    echo "-------------------------------"
    if ping -c 2 8.8.8.8 &>/dev/null; then
        echo "Internet Connectivity: UP"
    else
        echo "Internet Connectivity: DOWN"
    fi

    echo -e "\n[4] DNS Resolution Check"
    echo "------------------------"
    if nslookup google.com &>/dev/null; then
        echo "DNS Resolution: WORKING"
    else
        echo "DNS Resolution: FAILED"
    fi

    echo -e "\n[5] Website Availability Check"
    echo "------------------------------"
    WEBSITES=("google.com" "github.com" "amazon.com")
    
    for site in "${WEBSITES[@]}"; do
        
        if curl -Is --connect-timeout 5 "https://$site" &>/dev/null; then
            echo "$site : UP"
        else
            echo "$site : DOWN"
        fi
    done
    
    echo -e "\n=================================================="
} | tee "$REPORT_FILE"

echo -e "\n[✓] Health check complete. Report saved to: $REPORT_FILE"
