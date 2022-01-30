#=========================================================================
# Nom : Projet07_Boudrant_Script02.psl
# Auteur : Charles Boudrant
# Date : 28/08/2021
# Date de dernière modification : 19/09/2021
# Version : 1.1
# Description : Script pour lister les membres d'un groupe AD
#=========================================================================

# Importation du module Active Directory
Import-Module ActiveDirectory

# Définition des variables
$Error.Clear()
$Date = Get-Date -Format "ddMMyyyy_HHmmss"
$ExportFolder = "C:\Scripts\GroupMembers"

# Création du dossier pour les exports, "Ignore" en cas de dossier existant pour masquer l'erreur
New-Item -Path $ExportFolder -ItemType Directory -ErrorAction Ignore

# Listing des groupes présent dans l'AD
Write-Host "Groupes présents dans l'AD :"
Get-AdGroup -Filter * | select Name, DistinguishedName | Format-Table -AutoSize

$Grp = Read-Host "Saisissez le nom du groupe "

# Une fois la variable $Grp définie, création du chemin pour le fichier exporté dans $Export
$Export = "$ExportFolder\MembresDe$Grp$Date.txt"

# Listing des membres exporté dans un fichier .txt daté
## Essai de la récupération
Try
{
    Get-AdGroupMember -identity $Grp -Recursive | select Name | Out-File $Export 
    Write-Host "Liste des utilisateurs du groupe $Grp exportée dans $Export"-ForegroundColor Green
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

