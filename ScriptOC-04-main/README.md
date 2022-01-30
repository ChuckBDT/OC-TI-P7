# ScriptOC-04

Script Powershell créé dans le cadre de mon parcours Technicien Informatique (P7) chez OpenClassrooms.

## Fonction 

Sauvegarder les données d'un utilisateur sur le serveur de l'entreprise.

## Fonctionnement

Ce script doit être programmé via une GPO pour s'exécuter à la déconnexion de l'utilisateur.

Lors de son lancement, le script détermine aléatoirement un temps de pause avant de poursuivre pour éviter que le réseau soit saturé si de nombreux utilisateurs se déconnectent en même temps.

Il purge ensuite tous les fichiers âgés de plus de 6 mois du répertoire de destination puis lance la copie du répertoire $HOME de l'utilisateur vers le serveur.

Un fichier logs.txt est créé dans le même répertoire pour accueillir le log de Robocopy puis le code de sortie.

### Attention

Ce script est dépendant des répertoires créés à l'aide du Script 01 pour son bon fonctionnement.
