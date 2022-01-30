#===========================================================================
# Nom : Projet07_Boudrant_Script03.psl
# Auteur : Charles Boudrant
# Date : 26/08/2021
# Date de dernière modification : 19/09/2021
# Version : 1.1
# Description : Script pour lister les groupes dont un utilisateur est membre
#===========================================================================

# Importation du module Active Directory
Import-Module ActiveDirectory

# Définition des variables
$Error.Clear()
$Date = Get-Date -Format "ddMMyyyy_HHmmss"
$ExportFolder = "C:\Scripts\UsersGroups"

# Création du dossier pour les exports, "Ignore" en cas de dossier existant pour masquer l'erreur
New-Item -Path $ExportFolder -ItemType Directory -ErrorAction Ignore

# Listing des utilisateurs
Write-Host "Listing des utilisateurs"
Get-ADUser -Filter * | select Name,SamAccountName | Format-Table

$Username = Read-Host "Veuillez saisir le SamAccountName de l'utilisateur"

# Une fois la variable $Username définie, création du chemin pour le fichier exporté dans $Export
$Export = "$ExportFolder\$Username$Date.txt"

# Listing des groupes exporté dans un fichier .txt daté
## Essai de la récupération
Try
{
    (Get-ADUser $username -Properties MemberOf).MemberOf | Out-File $Export 
    Write-Host "Liste des groupes du groupe dont $Username est membre exportée dans $Export"-ForegroundColor Green
}

## En cas d'erreur, affichage d'un message et exportation des erreurs dans le même fichier .txt
Catch
{
    $Error | Out-File $Export 
    Write-Host "Une erreur est survenue !" -ForegroundColor Red
    Write-Host "Veuillez consulter le fichier exporté dans $Export" -ForegroundColor Red
}

## Pause pour avoir le temps de lire le message informant du bon déroulement avant la fermeture de la fenêtre
## Puis ouverture du fichier .txt généré 
Finally
{
    Pause
    notepad.exe $Export
}

