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

echo "`r`nCheck BO_DE`r`n"
python .\tools\\compare_excel_result.py data\references\BO_Sok_Stats_DE_20240816.xlsx data\output\BO_Sok_Metrics_DE_20240816_145059.xlsx -of data\output\BO_DE_diffs.xlsx
echo "`r`nCheck BO_FR`r`n"
python .\tools\\compare_excel_result.py data\references\BO_Sok_Stats_FR_20240816.xlsx data\output\BO_Sok_Metrics_FR_20240816_145054.xlsx -of data\output\BO_FR_diffs.xlsx
echo "`r`nCheck LB_DE`r`n"
python .\tools\\compare_excel_result.py data\references\LB_Sok_Stats_DE_20240816.xlsx  data\output\LB_Sok_Metrics_DE_20240816_145055.xlsx -of data\output\LB_DE_diffs.xlsx
echo "`r`nCheck LB_FR`r`n"
python .\tools\\compare_excel_result.py data\references\LB_Sok_Stats_FR_20240816.xlsx  data\output\LB_Sok_Metrics_FR_20240816_145050.xlsx -of data\output\LB_FR_diffs.xlsx
echo "`r`nCheck OL_DE`r`n"
python .\tools\\compare_excel_result.py data\references\OL_Sok_Stats_DE_20240816.xlsx  data\output\OL_Sok_Metrics_DE_20240816_145058.xlsx -of data\output\OL_DE_diffs.xlsx
echo "`r`nCheck OL_FR`r`n"
python .\tools\\compare_excel_result.py data\references\OL_Sok_Stats_FR_20240816.xlsx data\output\OL_Sok_Metrics_FR_20240816_145052.xlsx  -of data\output\OL_FR_diffs.xlsx
