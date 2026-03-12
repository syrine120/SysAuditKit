#!/bin/bash

LOG_FILE="/var/log/sysauditkit.log"
SEARCH_DIR="$1"
KEYWORDS="$2"
OUTPUT_FILE="$3"

if [ -z "$SEARCH_DIR" ]; then
    echo "Erreur : répertoire de recherche non spécifié."
    exit 1
fi

if [ -z "$KEYWORDS" ]; then
    echo "Erreur : mots-clés non spécifiés."
    exit 1
fi

if [ -z "$OUTPUT_FILE" ]; then
    OUTPUT_FILE="./search_results_$(date '+%Y%m%d_%H%M%S').txt"
fi

if [ ! -d "$SEARCH_DIR" ]; then
    echo "Erreur : le répertoire $SEARCH_DIR n'existe pas."
    echo "$(date) - SEARCH : répertoire $SEARCH_DIR inexistant" >> "$LOG_FILE"
    exit 1
fi

if [ ! -r "$SEARCH_DIR" ]; then
    echo "Erreur : droits insuffisants pour $SEARCH_DIR"
    echo "$(date) - SEARCH : droits insuffisants pour $SEARCH_DIR" >> "$LOG_FILE"
    exit 1
fi

> "$OUTPUT_FILE"

echo "Recherche dans $SEARCH_DIR pour mots-clés : $KEYWORDS"
echo "Résultats enregistrés dans $OUTPUT_FILE"

IFS=',' read -ra WORDS <<< "$KEYWORDS"

RESULT_FOUND=0

for WORD in "${WORDS[@]}"; do
    WORD=$(echo "$WORD" | xargs)
    echo "Recherche du mot-clé : $WORD" >> "$OUTPUT_FILE"

    FIND_RESULTS=$(find "$SEARCH_DIR" -type f -name "*.txt" -size +0c -mtime -365 2>/dev/null)

    if [ -z "$FIND_RESULTS" ]; then
        echo "Aucun fichier correspondant aux critères trouvés dans $SEARCH_DIR" >> "$OUTPUT_FILE"
        continue
    fi

    while read -r FILE; do
        if grep -i -n "$WORD" "$FILE" >> "$OUTPUT_FILE"; then
            RESULT_FOUND=1
        fi
    done <<< "$FIND_RESULTS"
done

if [ $RESULT_FOUND -eq 0 ]; then
    echo "Aucun résultat trouvé pour les mots-clés donnés." >> "$OUTPUT_FILE"
    echo "$(date) - SEARCH : aucun résultat pour $KEYWORDS" >> "$LOG_FILE"
else
    echo "$(date) - SEARCH : recherche terminée, résultats dans $OUTPUT_FILE" >> "$LOG_FILE"
fi

echo "Recherche terminée."

