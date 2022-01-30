#=========================================================================
# Nom : Projet07_Boudrant_Script01.psl
# Auteur : Charles Boudrant
# Date : 19/08/2021
# Date de derni�re modification : 19/09/2021
# Version : 2.6
# Description : Script pour cr�er utilisateur et dossier partag� dans l'AD
#=========================================================================

# Importation du module Active Directory
Import-Module ActiveDirectory

# D�finition des variables
$Error.Clear()
$Date = Get-Date -Format "ddMMyyyy_HHmmss"
$ExportFolder = "C:\Scripts\AddUsers"
$Export = "$ExportFolder\LogAjoutDe$usrnme$Date.txt"

# Cr�ation du dossier pour les exports, "Ignore" en cas de dossier existant pour masquer l'erreur
New-Item -Path $ExportFolder -ItemType Directory -ErrorAction Ignore

Write-Host "Veuillez saisir les informations suivantes"
$prenom = Read-Host "Pr�nom"
$nom = Read-Host "Nom"

# G�n�ration automatique des diff�rentes formes de usernames et du password
## G�n�ration du nom complet (-Name) sous la forme (Pr�nom Nom)
$nomcomplet = "$($prenom) $($nom)"
## G�n�ration de l'username (-SamAccountName) sous la forme "Premi�reLettreDuPr�nom.Nom"
$usrnme = "$($prenom.Substring(0,1)).$($nom)"
## Conversion de l'username g�n�r� en minuscule
$nomcompte = $usrnme.ToLower()
## G�n�ration du nom principal (-UserPrincipalName)
$userprincipalname = "$($nomcompte)@acme.local"
## G�n�ration du password (-AccountPassword), longueur de 10 caract�res
Add-Type    -AssemblyName 'System.web'
$passw = [System.Web.Security.Membership]::GeneratePassword(10, 0)
## G�n�ration de l'username de sauvegarde
$usrsav = "$nomcompte-sav"

# Cr�ation de l'utilisateur, des dossiers et permissions
## Ajout de l'utilisateur � l'AD
New-ADUser -Name $nomcomplet -GivenName $prenom -Surname $nom -SamAccountName $nomcompte -UserPrincipalName $userprincipalname -AccountPassword (ConvertTo-SecureString $passw -AsPlainText -Force) -ChangePasswordAtLogon $true -Enabled $true
## Cr�ation du dossier utilisateur
New-Item "Z:\Users\$nomcompte" -ItemType Directory
## Cr�ation du partage r�seau "cach�" du dossier utilisateur
New-SmbShare -Name $nomcompte$ -Path "Z:\Users\$nomcompte" -FullAccess Administrateurs -ChangeAccess "$userprincipalname" -ConcurrentUserLimit 2
## Mise en correspondance des ACL
Set-SmbPathAcl -ShareName $nomcompte$
## Mappage du dossier utilisateur sur son profil
Set-ADUser -Identity $usrnme -HomeDrive "Z:" -HomeDirectory "\\SRV-AD-PAR-01\$nomcompte$"
## Cr�ation du dossier de sauvegarde de l'utilisateur
New-Item "C:\SAV\$usrsav" -ItemType Directory
## Cr�ation du partage r�seau "cach�" du dossier de sauvegarde quotidienne sur le serveur
New-SmbShare -Name $usrsav$ -Path "C:\SAV\$usrsav" -FullAccess Administrateurs -ChangeAccess "$userprincipalname" -ConcurrentUserLimit 2
## Mise en correspondance des ACL
Set-SmbPathAcl -ShareName $usrsav$

# V�rification du compteur d'erreurs
## Si le compteur est � z�ro (aucune erreur)
if ($Error.Count -ieq 0)
{
    ### Affichage d'un message de succ�s
    Write-Host "$nomcomplet ajout� avec succ�s" -ForegroundColor Green
    Write-Host " "
    ### G�n�ration d'un fichier de sortie � communiquer � l'utilisateur
    "Bonjour $nomcomplet, vous trouverez ci-dessous les identifiants pour acc�der � votre poste :`r`rNom d'utilisateur : $nomcompte`rMot de passe : $passw`r`rVous serez invit�(e) � modifier le mot de passe lors de votre premi�re connexion.`r`rVotre mot de passe est strictement personnel et ne doit �tre communiqu� � personne.`r`rCordialement`r`rLe service IT" | Out-File -FilePath $ExportFolder\$nomcomplet$Date.txt
}
## Si une ou plusieurs erreurs sont survenues
else
{
    ### Sortie des logs vers un fichier .txt et affichage d'un message d'erreur
    $Error | Out-File $Export 
    Write-Host "Une erreur est survenue !" -ForegroundColor Red
    Write-Host "Veuillez consulter le fichier export� dans $Export" -ForegroundColor Red
    break
}

 
# Ajout de l'utilisateur � un groupe
$answergrp = Read-Host "Ajouter l'utilisateur � un groupe ? (y or n)"
Write-Host " "
If($answergrp -eq "y")
{
    ## Listing des groupes pr�sent dans l'AD
    Write-Host "Groupes pr�sents dans l'AD :"
    Get-AdGroup -Filter * | select Name, DistinguishedName | Format-Table -AutoSize

    $Grp = Read-Host "Saisissez le nom du groupe "
    Write-Host " "
    ## Essai de l'ajout du membre au groupe
    Try
    {
        Add-ADGroupMember -Identity $Grp -Members $nomcompte
        Write-Host "$nomcomplet a �t� ajout� au groupe $Grp" -ForegroundColor Green
    }

    ## En cas d'erreur, affichage d'un message et exportation des erreurs dans le m�me fichier .txt
    Catch
    {
        $Error | Out-File $Export -Append
        Write-Host "Une erreur est survenue !" -ForegroundColor Red
        Write-Host "Veuillez consulter le fichier export� dans $Export" -ForegroundColor Red
    }

}elseif($answergrp -eq "n")
{
    Write-Host "$nomcomplet n'a pas �t� ajout� � un groupe" -ForegroundColor Yellow
}else{
    Write-Host "R�ponse incorrecte, $nomcomplet n'a pas �t� ajout� � un groupe" -ForegroundColor Yellow
}
Write-Host " "
Write-Host $Error.Count