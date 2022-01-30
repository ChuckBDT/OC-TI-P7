# ScriptOC-01

Script Powershell créé dans le cadre de mon parcours Technicien Informatique (P7) chez OpenClassrooms.

## Fonction

Créer un nouvel utilisateur ainsi qu'un dossier partagé à son nom.

## Fonctionnement

À partir d'un nom et d'un prénom, ce script va générer les identifiants et un mot de passe aléatoire nécessaires à la création de l'utilisateur dans l'AD.

Une fois l'utilisateur inscrit, un dossier partagé est créé à son nom (accessible uniquement à l'utilisateur et à l'administrateur).

Un dossier destiné à la sauvegarde des données de l'utilisateur est également créé dans le serveur, dossier qui sera utilisé dans le Script 04.

Un fichier .txt contenant les identifiants à communiquer à l'utilisateur est généré, son mot de passe sera à modifier lors de la première connexion.

Pour finir, le script propose l'ajout de l'utilisateur à un groupe. 

Une liste des groupes s'affichera et il suffira de saisir le nom du groupe souhaité.
