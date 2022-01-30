#==================================================================================
# Nom : Projet07_Boudrant_Script04.psl
# Auteur : Charles Boudrant
# Date : 19/08/2021
# Date de dernière modification : 10/09/2021
# Version : 1.1
# Description : Script pour sauvegarder les données d'un utilisateur dans le serveur
#==================================================================================

# Définition des variables
$Username = $Env:USERNAME
$Usersav = "$Username-sav$"
$Savepath = "\\SRV-AD-PAR-01\$usersav"
$Delay = 0, 60, 120, 180, 240, 300 | Get-Random

# Délai aléatoire avant le lancement de la copie pour éviter de saturer la bande passante
Start-Sleep -Seconds $Delay

# Purge des fichiers datant de plus de 6 mois
Get-ChildItem $Savepath -Recurse | Where CreationTime -LT (Get-date).AddDays(-180) | Remove-Item -Force -Recurse

# Sauvegarde du répertoire utilisateur dans le serveur et append du log de robocopy
robocopy $HOME $Savepath /E /Z /TIMFIX /FFT /XJD /XA:S /W:3 /R:1 /LOG+:$Savepath\logs.txt

# Append du code de sortie au fichier log de robocopy
$LASTEXITCODE | Out-File -FilePath $Savepath\logs.txt -Append


