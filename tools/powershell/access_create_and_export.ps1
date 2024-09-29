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
python .\playsafemetrics\play_safe_metrics.py export -o LB -l FR -db_type access
python .\playsafemetrics\play_safe_metrics.py export -o OL -l FR -db_type access
python .\playsafemetrics\play_safe_metrics.py export -o BO -l FR -db_type access
python .\playsafemetrics\play_safe_metrics.py export -o LB -l DE -db_type access
python .\playsafemetrics\play_safe_metrics.py export -o OL -l DE -db_type access
python .\playsafemetrics\play_safe_metrics.py export -o BO -l DE -db_type access