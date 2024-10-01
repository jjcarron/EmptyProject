# Utilisez $PSScriptRoot si disponible, sinon Get-Location
if ($PSScriptRoot) {
    $path = $PSScriptRoot
} else {
    $path = (Get-Location).Path
}

# Extraire la lettre du disque du chemin
$driveLetter = $path.Substring(0, 2)

# Afficher la lettre du disque
#Write-Output "La lettre du disque est : $driveLetter"

Set-Location "$driveLetter\work\PlaySafeMetrics"

python .\playsafemetrics\play_safe_metrics.py create -db_type access 
python .\playsafemetrics\play_safe_metrics.py export -o LB -l fr -db_type access
python .\playsafemetrics\play_safe_metrics.py export -o OL -l fr -db_type access
python .\playsafemetrics\play_safe_metrics.py export -o BO -l fr -db_type access
python .\playsafemetrics\play_safe_metrics.py export -o LB -l de -db_type access
python .\playsafemetrics\play_safe_metrics.py export -o OL -l de -db_type access
python .\playsafemetrics\play_safe_metrics.py export -o BO -l de -db_type access