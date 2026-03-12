#!/bin/bash

LOG_FILE="/var/log/sysauditkit.log"
CONFIG_FILE="/etc/sysauditkit/config.cfg"

echo "Nom : "
read NOM
echo "Prénom : "
read PRENOM

ID_USER="$(echo "$PRENOM.$NOM" | tr '[:upper:]' '[:lower:]')"
WORK_DIR="/home/$ID_USER/work"

if id "$ID_USER" &>/dev/null; then
    echo "Utilisateur $ID_USER existe déjà"
    echo "$(date) - INIT : utilisateur $ID_USER existe déjà" >> "$LOG_FILE"
else
    sudo useradd -m -s /bin/bash "$ID_USER"
    sudo mkdir -p "$WORK_DIR"
    sudo chown "$ID_USER":"$ID_USER" "$WORK_DIR"
    sudo chmod 700 "$WORK_DIR"
    echo "$NOM" > "$CONFIG_FILE"
    echo "$PRENOM" >> "$CONFIG_FILE"
    echo "$ID_USER" >> "$CONFIG_FILE"
    echo "$(date) - INIT : utilisateur $ID_USER créé avec dossier $WORK_DIR" >> "$LOG_FILE"
    echo "Utilisateur $ID_USER créé avec succès."
fi

