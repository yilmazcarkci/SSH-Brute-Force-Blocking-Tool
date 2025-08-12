#!/bin/bash

BLACKLIST="blacklist.txt"
WHITELIST="whitelist.txt"

# Detect SSH log source (file or journalctl)
detect_log_source() {
    if [ -f /var/log/auth.log ]; then
        LOGCMD="cat /var/log/auth.log"
    elif [ -f /var/log/secure ]; then
        LOGCMD="cat /var/log/secure"
    else
        if command -v journalctl >/dev/null 2>&1; then
            # Try both common SSH service names
            LOGCMD="journalctl -u ssh -u sshd --no-pager"
        else
            echo "Cannot find SSH logs! Neither log files nor journalctl available."
            exit 1
        fi
    fi
}

draw_line() { printf '%s\n' "--------------------------------------------------------------------------------"; }
draw_title() { draw_line; printf "| %-76s |\n" "$1"; draw_line; }

show_menu() {
    clear
    draw_title "SSH Black List Menu"
    echo "1. Add White List IP"
    echo "2. Add Black List IP"
    echo "3. Show White List IP"
    echo "4. Show Black List IP"
    echo "5. Detect & Block Brute Force IPs"
    echo "6. Exit"
    echo
    read -p "Select an option (1-6): " choice
}

add_whitelist_ip() {
    read -p "Enter IP to add to whitelist: " ip
    if [[ -n "$ip" ]]; then
        echo "$ip" >> $WHITELIST
        echo "$ip added to whitelist."
    fi
    sleep 1
}

add_blacklist_ip() {
    read -p "Enter IP to add to blacklist: " ip
    if [[ -n "$ip" ]]; then
        echo "$ip" >> $BLACKLIST
        sudo iptables -A INPUT -s $ip -j DROP
        echo "$ip blocked."
    fi
    sleep 1
}

show_whitelist() {
    draw_title "SSH White List"
    if [ -f $WHITELIST ]; then
        cat $WHITELIST
    else
        echo "Whitelist is empty."
    fi
    read -p "Press Enter to continue..."
}

show_blacklist() {
    draw_title "SSH Black List"
    if [ -f $BLACKLIST ]; then
        while read -r ip; do
            echo "$ip    $(date +"%d-%m-%Y %H:%M")"
        done < $BLACKLIST
    else
        echo "Blacklist is empty."
    fi
    read -p "Press Enter to continue..."
}

detect_bruteforce() {
    draw_title "Brute Force IP Detection"
    $LOGCMD | awk '/Failed password/ {print $(NF-3)}' | sort | uniq -c | sort -nr | while read count ip; do
        if [[ "$count" -gt 10 && "$ip" =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
            if ! grep -q "$ip" $WHITELIST 2>/dev/null; then
                if ! grep -q "$ip" $BLACKLIST 2>/dev/null; then
                    echo "$ip" >> $BLACKLIST
                    sudo iptables -A INPUT -s $ip -j DROP
                    echo "$ip blocked (attempts: $count)"
                fi
            fi
        fi
    done
    read -p "Press Enter to continue..."
}

detect_log_source

while true; do
    show_menu
    case $choice in
        1) add_whitelist_ip ;;
        2) add_blacklist_ip ;;
        3) show_whitelist ;;
        4) show_blacklist ;;
        5) detect_bruteforce ;;
        6) exit ;;
        *) echo "Invalid option!"; sleep 1 ;;
    esac
done
