#===========================================================================
# Nom : Projet07_Boudrant_Script03.psl
# Auteur : Charles Boudrant
# Date : 26/08/2021
# Date de derni�re modification : 19/09/2021
# Version : 1.1
# Description : Script pour lister les groupes dont un utilisateur est membre
#===========================================================================

# Importation du module Active Directory
Import-Module ActiveDirectory

# D�finition des variables
$Error.Clear()
$Date = Get-Date -Format "ddMMyyyy_HHmmss"
$ExportFolder = "C:\Scripts\UsersGroups"

# Cr�ation du dossier pour les exports, "Ignore" en cas de dossier existant pour masquer l'erreur
New-Item -Path $ExportFolder -ItemType Directory -ErrorAction Ignore

# Listing des utilisateurs
Write-Host "Listing des utilisateurs"
Get-ADUser -Filter * | select Name,SamAccountName | Format-Table

$Username = Read-Host "Veuillez saisir le SamAccountName de l'utilisateur"

# Une fois la variable $Username d�finie, cr�ation du chemin pour le fichier export� dans $Export
$Export = "$ExportFolder\$Username$Date.txt"

# Listing des groupes export� dans un fichier .txt dat�
## Essai de la r�cup�ration
Try
{
    (Get-ADUser $username -Properties MemberOf).MemberOf | Out-File $Export 
    Write-Host "Liste des groupes du groupe dont $Username est membre export�e dans $Export"-ForegroundColor Green
}

## En cas d'erreur, affichage d'un message et exportation des erreurs dans le m�me fichier .txt
Catch
{
    $Error | Out-File $Export 
    Write-Host "Une erreur est survenue !" -ForegroundColor Red
    Write-Host "Veuillez consulter le fichier export� dans $Export" -ForegroundColor Red
}

## Pause pour avoir le temps de lire le message informant du bon d�roulement avant la fermeture de la fen�tre
## Puis ouverture du fichier .txt g�n�r� 
Finally
{
    Pause
    notepad.exe $Export
}

