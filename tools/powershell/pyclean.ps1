Set-Alias python python.exe
Set-Location \Work\EmptyProject\
$to_check_dir = Join-Path -Path (Get-Location) -ChildPath "emptyproject"
 
python  tools\remove_trailing_whitespaces.py $to_check_dir -r
python -m isort --overwrite-in-place $to_check_dir 
python -m autopep8 --in-place --aggressive --aggressive  --recursive $to_check_dir
python -m pylint $to_check_dir

$to_check_dir = Join-Path -Path (Get-Location) -ChildPath "tests"
python  tools\remove_trailing_whitespaces.py $to_check_dir -r
python -m isort --overwrite-in-place $to_check_dir 
python -m autopep8 --in-place --aggressive --aggressive  --recursive $to_check_dir
python -m pylint $to_check_dir

$to_check_dir = Join-Path -Path (Get-Location) -ChildPath "tools"
python  tools\remove_trailing_whitespaces.py $to_check_dir -r
python -m isort --overwrite-in-place $to_check_dir 
python -m autopep8 --in-place --aggressive --aggressive  --recursive $to_check_dir
python -m pylint $to_check_dir