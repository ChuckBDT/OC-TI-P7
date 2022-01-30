#=========================================================================
# Nom : Projet07_Boudrant_Script01.psl
# Auteur : Charles Boudrant
# Date : 19/08/2021
# Date de dernière modification : 19/09/2021
# Version : 2.6
# Description : Script pour créer utilisateur et dossier partagé dans l'AD
#=========================================================================

# Importation du module Active Directory
Import-Module ActiveDirectory

# Définition des variables
$Error.Clear()
$Date = Get-Date -Format "ddMMyyyy_HHmmss"
$ExportFolder = "C:\Scripts\AddUsers"
$Export = "$ExportFolder\LogAjoutDe$usrnme$Date.txt"

# Création du dossier pour les exports, "Ignore" en cas de dossier existant pour masquer l'erreur
New-Item -Path $ExportFolder -ItemType Directory -ErrorAction Ignore

Write-Host "Veuillez saisir les informations suivantes"
$prenom = Read-Host "Prénom"
$nom = Read-Host "Nom"

# Génération automatique des différentes formes de usernames et du password
## Génération du nom complet (-Name) sous la forme (Prénom Nom)
$nomcomplet = "$($prenom) $($nom)"
## Génération de l'username (-SamAccountName) sous la forme "PremièreLettreDuPrénom.Nom"
$usrnme = "$($prenom.Substring(0,1)).$($nom)"
## Conversion de l'username généré en minuscule
$nomcompte = $usrnme.ToLower()
## Génération du nom principal (-UserPrincipalName)
$userprincipalname = "$($nomcompte)@acme.local"
## Génération du password (-AccountPassword), longueur de 10 caractères
Add-Type    -AssemblyName 'System.web'
$passw = [System.Web.Security.Membership]::GeneratePassword(10, 0)
## Génération de l'username de sauvegarde
$usrsav = "$nomcompte-sav"

# Création de l'utilisateur, des dossiers et permissions
## Ajout de l'utilisateur à l'AD
New-ADUser -Name $nomcomplet -GivenName $prenom -Surname $nom -SamAccountName $nomcompte -UserPrincipalName $userprincipalname -AccountPassword (ConvertTo-SecureString $passw -AsPlainText -Force) -ChangePasswordAtLogon $true -Enabled $true
## Création du dossier utilisateur
New-Item "Z:\Users\$nomcompte" -ItemType Directory
## Création du partage réseau "caché" du dossier utilisateur
New-SmbShare -Name $nomcompte$ -Path "Z:\Users\$nomcompte" -FullAccess Administrateurs -ChangeAccess "$userprincipalname" -ConcurrentUserLimit 2
## Mise en correspondance des ACL
Set-SmbPathAcl -ShareName $nomcompte$
## Mappage du dossier utilisateur sur son profil
Set-ADUser -Identity $usrnme -HomeDrive "Z:" -HomeDirectory "\\SRV-AD-PAR-01\$nomcompte$"
## Création du dossier de sauvegarde de l'utilisateur
New-Item "C:\SAV\$usrsav" -ItemType Directory
## Création du partage réseau "caché" du dossier de sauvegarde quotidienne sur le serveur
New-SmbShare -Name $usrsav$ -Path "C:\SAV\$usrsav" -FullAccess Administrateurs -ChangeAccess "$userprincipalname" -ConcurrentUserLimit 2
## Mise en correspondance des ACL
Set-SmbPathAcl -ShareName $usrsav$

# Vérification du compteur d'erreurs
## Si le compteur est à zéro (aucune erreur)
if ($Error.Count -ieq 0)
{
    ### Affichage d'un message de succès
    Write-Host "$nomcomplet ajouté avec succès" -ForegroundColor Green
    Write-Host " "
    ### Génération d'un fichier de sortie à communiquer à l'utilisateur
    "Bonjour $nomcomplet, vous trouverez ci-dessous les identifiants pour accéder à votre poste :`r`rNom d'utilisateur : $nomcompte`rMot de passe : $passw`r`rVous serez invité(e) à modifier le mot de passe lors de votre première connexion.`r`rVotre mot de passe est strictement personnel et ne doit être communiqué à personne.`r`rCordialement`r`rLe service IT" | Out-File -FilePath $ExportFolder\$nomcomplet$Date.txt
}
## Si une ou plusieurs erreurs sont survenues
else
{
    ### Sortie des logs vers un fichier .txt et affichage d'un message d'erreur
    $Error | Out-File $Export 
    Write-Host "Une erreur est survenue !" -ForegroundColor Red
    Write-Host "Veuillez consulter le fichier exporté dans $Export" -ForegroundColor Red
    break
}

 
# Ajout de l'utilisateur à un groupe
$answergrp = Read-Host "Ajouter l'utilisateur à un groupe ? (y or n)"
Write-Host " "
If($answergrp -eq "y")
{
    ## Listing des groupes présent dans l'AD
    Write-Host "Groupes présents dans l'AD :"
    Get-AdGroup -Filter * | select Name, DistinguishedName | Format-Table -AutoSize

    $Grp = Read-Host "Saisissez le nom du groupe "
    Write-Host " "
    ## Essai de l'ajout du membre au groupe
    Try
    {
        Add-ADGroupMember -Identity $Grp -Members $nomcompte
        Write-Host "$nomcomplet a été ajouté au groupe $Grp" -ForegroundColor Green
    }

    ## En cas d'erreur, affichage d'un message et exportation des erreurs dans le même fichier .txt
    Catch
    {
        $Error | Out-File $Export -Append
        Write-Host "Une erreur est survenue !" -ForegroundColor Red
        Write-Host "Veuillez consulter le fichier exporté dans $Export" -ForegroundColor Red
    }

}elseif($answergrp -eq "n")
{
    Write-Host "$nomcomplet n'a pas été ajouté à un groupe" -ForegroundColor Yellow
}else{
    Write-Host "Réponse incorrecte, $nomcomplet n'a pas été ajouté à un groupe" -ForegroundColor Yellow
}
Write-Host " "
Write-Host $Error.Count