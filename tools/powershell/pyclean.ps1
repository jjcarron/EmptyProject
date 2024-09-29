Set-Location \Work\PlaySafeMetrics\
$to_check_dir = Join-Path -Path (Get-Location) -ChildPath "playsafemetrics"
 
python  tools\remove_trailing_whitespaces.py $to_check_dir -r
python -m isort --overwrite-in-place $to_check_dir 
python -m autopep8 --in-place --aggressive --aggressive  --recursive $to_check_dir
python -m pylint $to_check_dir

