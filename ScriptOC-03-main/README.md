# ScriptOC-03

Script Powershell créé dans le cadre de mon parcours Technicien Informatique (P7) chez OpenClassrooms.

## Fonction 

Extraire la liste des groupes dont un utilisateur est membre.

## Fonctionnement

Lors de son lancement, le script affiche utilisateurs présents dans l'AD puis demande de saisir le SamAccountName visé.

Il génère ensuite un fichier .txt daté dans un dossier dédié (C:\Scripts\UsersGroups). 

En cas de succès le fichier .txt contiendra la liste des groupes et en cas d'erreur, il contiendra les messages retournés par Powershell.

Lorsque le script referme la fenêtre PowerShell, le fichier .txt est ouvert dans notepad.exe automatiquement.