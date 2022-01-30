# ScriptOC-02

Script Powershell créé dans le cadre de mon parcours Technicien Informatique (P7) chez OpenClassrooms.

## Fonction 

Extraire la liste des utilisateurs présents dans un groupe Active Directory.

## Fonctionnement

Lors de son lancement, le script affiche tous les groupes présents dans l'AD puis demande de saisir le nom du groupe visé.

Il génère ensuite un fichier .txt daté dans un dossier dédié (C:\Scripts\GroupMembers). 

En cas de succès le fichier .txt contiendra la liste des membres et en cas d'erreur, il contiendra les messages retournés par Powershell.

Lorsque le script referme la fenêtre PowerShell, le fichier .txt est ouvert dans notepad.exe automatiquement.
