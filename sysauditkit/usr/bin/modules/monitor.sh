#!/bin/bash

LOG_FILE="/var/log/sysauditkit.log"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | sudo tee -a "$LOG_FILE" > /dev/null
}

read -p "Enter username to monitor: " USERNAME

if ! id "$USERNAME" &>/dev/null; then
    echo "User $USERNAME does not exist."
    log "MONITOR: Attempted to monitor non-existent user $USERNAME"
    exit 1
fi

echo
echo "Top processes for $USERNAME by CPU:"
ps -u "$USERNAME" -o pid,cmd,%mem,%cpu --sort=-%cpu | head -n 10

echo
echo "Top processes for $USERNAME by Memory:"
ps -u "$USERNAME" -o pid,cmd,%mem,%cpu --sort=-%mem | head -n 10

read -p "Do you want to take action on a process? (yes/no): " RESP

if [[ "$RESP" =~ ^[Yy]$ ]]; then
    read -p "Enter PID of the process: " PID
    if ! ps -p "$PID" &>/dev/null; then
        echo "PID $PID not found."
        exit 1
    fi

    read -p "Choose action (kill/renice): " ACTION
    case "$ACTION" in
        kill)
            read -p "Are you sure you want to kill PID $PID? [y/N]: " CONF
            if [[ "$CONF" =~ ^[Yy]$ ]]; then
                sudo kill -9 "$PID"
                echo "Process $PID killed."
                log "MONITOR: Killed PID $PID of user $USERNAME"
            fi
            ;;
        renice)
            read -p "Enter new nice value (-20 to 19): " NICEVAL
            sudo renice "$NICEVAL" -p "$PID"
            echo "PID $PID reniced to $NICEVAL."
            log "MONITOR: Reniced PID $PID of user $USERNAME to $NICEVAL"
            ;;
        *)
            echo "Invalid action."
            ;;
    esac
else
    echo "No actions performed. Exiting MONITOR."
fi

