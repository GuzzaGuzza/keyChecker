#!/bin/bash
# Key Checker Script
# This script checks if a provided license key is valid or not.
# It also logs the usage and notifies a Discord webhook.
# Use command cd ~/Downloads to navigate to the Downloads folder
# Use command chmod +x keyChecker.sh to make the script executable
# Use command ./keyChecker.sh to run the script

WEBHOOK_URL="https://discord.com/api/webhooks/1368939678161436762/MGhaGLDgfU1PDNRjCxEkND2fNU78PKmfQ_9LMJm0n3Nf5iEghmcxAYc-OKoNhHMIOe-Q"

HWID="$(whoami)@$(hostname)"


# Function to log locally
log_event() {
    echo "$(date): $1" >> usage_log.txt
}

# Function to notify Discord
notify_discord() {
    curl -H "Content-Type: application/json" \
         -X POST \
         -d "{\"content\": \"$1\"}" \
         $WEBHOOK_URL > /dev/null 2>&1
}

# Function to check license
check_license() {
    echo -n "Enter License Key (press Enter for Free Trial): "
    read input_key

    IP=$(curl -s ifconfig.me)


    if [ "$input_key" == "" ]; then
        echo "🆓 Free Trial Mode Activated!"
        log_event "Trial used by $HWID"
        notify_discord "🆓 Trial used by \`$HWID\` from IP \`$IP\`"
        return
    fi

    if grep -Fxq "$input_key" valid_keys.txt; then
        echo "✅ License Key Valid! Welcome!"
        log_event "VALID KEY: $input_key by $HWID"
        echo "Please wait... Checking your key..."
        notify_discord "✅ Valid key \`$input_key\` used by \`$HWID\` from IP \`$IP\`"
        log_event "KEY: $input_key | IP: $IP | USER: $HWID"

    elif grep -Fxq "$input_key" VIPvalid_keys.txt; then
        echo "🤑 VIP Key Valid! Welcome!"
        echo "✨ You’ve unlocked premium features!"
        log_event "VIP VALID KEY: $input_key by $HWID"
        echo "Please wait... Checking your key..."
        notify_discord "🤑 VIP Valid key \`$input_key\` used by \`$HWID\` from IP \`$IP\`"
        log_event "KEY: $input_key | IP: $IP | USER: $HWID"
    
    else
        echo "❌ Invalid Key. Please try again."
        log_event "INVALID KEY: $input_key by $HWID"
        echo "Please wait... Checking your key..."
        notify_discord "❌ Invalid key attempt: \`$input_key\` by \`$HWID\` from IP \`$IP\`"
        log_event "KEY: $input_key | IP: $IP | USER: $HWID"
        exit 1
    fi
}

check_license
