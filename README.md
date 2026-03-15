# SysAuditKit

SysAuditKit est un ensemble de scripts shell automatisés permettant l'initialisation, la surveillance et l'audit d'un parc de machines Linux. L'outil est distribué sous forme de package Debian (.deb) installable via `dpkg` ou `apt`.

---


##  Fonctionnalités

| Module | Description |
|--------|-------------|
| `init` | Initialisation système : création d'utilisateur, dossier de travail, et configuration |
| `report` | Génération d'un rapport système complet (OS, disque, processus, utilisateurs) |
| `search` | Recherche de fichiers et analyse de contenu (find + grep) |
| `monitor` | Surveillance des processus avec actions contrôlées (kill, renice) |
| `help` | Affiche l'aide et la liste des commandes disponibles |

---

##  Installation

### Prérequis
- Système : Ubuntu / Linux Mint
- Privilèges : `sudo` requis
- Outils : `dpkg`, `apt`

### Méthode 1 : Installation depuis le paquet .deb
# Télécharger le paquet
wget https://github.com/syrine120/SysAuditKit/releases/download/v1.0/sysauditkit_1.0_all.deb

# Installer
sudo dpkg -i sysauditkit_1.0_all.deb

# Résoudre les dépendances si nécessaire
sudo apt-get install -f

### Méthode 2 : Build depuis les sources
# Cloner le dépôt
git clone https://github.com/syrine120/SysAuditKit.git
cd SysAuditKit

# Build du paquet Debian
dpkg-buildpackage -us -uc

# Installer le paquet généré
sudo dpkg -i ../sysauditkit_1.0_all.deb

Vérification de l'installation
# Vérifier que le paquet est installé
dpkg -l | grep sysauditkit

# Afficher l'aide
sysauditkit help

##  Guide d'Utilisation

###  Syntaxe Générale
L'outil s'exécute via la commande `sysauditkit`. La plupart des modules nécessitent des privilèges administrateurs.

```bash
sudo sysauditkit <commande> [options]

1. Afficher l'aide
  Pour lister toutes les commandes disponibles et leur description.
  sysauditkit help
  
  Sortie attendue :
  === SysAuditKit v1.0 ===
  Commandes disponibles :
    init      - Initialiser la machine et créer un utilisateur
    report    - Générer un rapport système complet
    search    - Rechercher des fichiers et analyser le contenu
    monitor   - Surveiller et gérer les processus
    help      - Afficher cette aide

  2. Module INIT : Initialisation
  Ce module configure la machine pour un nouvel utilisateur (étudiant).
      sudo sysauditkit init
  Déroulement interactif :
  1/Le script demande le Nom et le Prénom.
  2/Il génère un identifiant (ex: prenom.nom).
  3/Il crée l'utilisateur Linux et son dossier personnel.
  4/Il configure les permissions et enregistre la configuration.
Exemple de log :
[OK] Utilisateur 'john.doe' créé.
[OK] Dossier '/home/john.doe/work' initialisé.
[OK] Permissions configurées (750).
[OK] Action journalisée dans /var/log/sysauditkit.log

3. Module REPORT : Rapport Système
  Génère un fichier texte contenant l'état actuel du système.
  sudo sysauditkit report
  Contenu du rapport :
  
      Version du Kernel et OS.
      Espace disque utilisé (df).
      Utilisateurs actuellement connectés (who).
      Top 5 des processus consommateurs (CPU/RAM).
      Date et heure de génération.
  
  Fichier généré :
  Le rapport est sauvegardé dans /var/log/sysauditkit/report_<identifiant>_<date>.txt.

4. Module SEARCH : Recherche & Analyse
  Recherche des fichiers et analyse leur contenu pour des mots-clés spécifiques (erreurs, alertes)
  # Syntaxe
  sudo sysauditkit search <chemin> <mot_clé>
  Exemple concret :
  Rechercher tous les fichiers .log dans /var/log contenant le mot "error".
  sudo sysauditkit search /var/log "error"
    Fonctionnement :
  
      Utilise find pour filtrer les fichiers (type, extension).
      Utilise grep pour analyser le contenu (insensible à la casse).
      Combine les résultats dans un fichier de sortie.
  
    Fichier de résultats :
    Les résultats sont exportés dans /var/log/sysauditkit/search_results.txt.

5. Module MONITOR : Surveillance Processus
  Permet de visualiser et gérer les processus en temps réel.
  sudo sysauditkit monitor
  Fonctionnalités :
  
      Liste les processus par utilisateur.
      Identifie les processus "gourmands" (CPU > 50%).
      Propose des actions : kill (terminer) ou renice (changer priorité).
  
   Attention :
  Une confirmation est demandée avant toute action destructive (kill).


Désinstallation
  Pour supprimer complètement l'outil et ses fichiers de configuration :
  sudo dpkg -r sysauditkit

Notes de Sécurité

    Ne jamais exécuter les scripts sans privilèges sudo pour les modules init, report, et monitor
    Les logs et rapports générés contiennent des informations système sensibles
    Ne pas commiter les fichiers .log, .txt, .deb dans le dépôt Git
    Vérifier les scripts pour éviter les mots de passe en dur

Licence
  Ce projet est développé dans un cadre pédagogique. Tous droits réservés.


Contact
  Pour toute question ou problème, ouvrez une Issue sur le dépôt GitHub.
  Développeur : Sirine Kanboui
  Établissement : EMSI
  Année : 2026


