#!/bin/bash

LOG_FILE="/var/log/sysauditkit.log"
CONFIG_FILE="/etc/sysauditkit/config.cfg"

if [ ! -f "$CONFIG_FILE" ]; then
    echo "Erreur : fichier de configuration $CONFIG_FILE introuvable."
    exit 1
fi

ID_USER=$(tail -n 1 "$CONFIG_FILE")
if [ -z "$ID_USER" ]; then
    echo "Erreur : identifiant utilisateur introuvable."
    exit 1
fi

USER_HOME="/home/$ID_USER"
if [ ! -d "$USER_HOME" ]; then
    echo "Erreur : répertoire home $USER_HOME introuvable."
    exit 1
fi

REPORT_FILE="$USER_HOME/report_$(date '+%Y%m%d_%H%M%S').txt"

cat <<EOF > "$REPORT_FILE"
==============================
SysAuditKit - Rapport Système
Utilisateur : $ID_USER
Date : $(date)
==============================
EOF

