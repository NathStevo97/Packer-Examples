# Build images

# Get Start Time
$startDTM = (Get-Date)

# Variables
$template_file="./Templates/ubuntu-desktop.pkr.hcl"
$var_file="./variables/ubuntu_1804.pkrvars.hcl"
$machine="Ubuntu 18.04"
$packer_log=1
$env:PACKER_LOG_PATH="packerlog-Ubuntu-1804.txt"
packer init "./required_plugins.pkr.hcl"
#Write start time so you know how long it's been
Write-Host "Start Time: = $startDTM" -ForegroundColor Yellow
if ((Test-Path -Path "$template_file")) {
  Write-Output "Template file found"
  Write-Output "Building: $machine"
  try {
    $env:PACKER_LOG=$packer_log
    packer validate -var-file="$var_file" "$template_file"
    #packer validate "$template_file"
  }
  catch {
    Write-Output "Packer validation failed, exiting."
    exit (-1)
  }
  try {
    $env:PACKER_LOG=$packer_log
    packer version
    packer build --force -var-file="$var_file" "$template_file"
    #packer build --force "$template_file" 
  }
  catch {
    Write-Output "Packer build failed, exiting."
    exit (-1)
  }
}
else {
  Write-Output "Template or Var file not found - exiting"
  exit (-1)
}

$endDTM = (Get-Date)
Write-Host "[INFO]  - Elapsed Time: $(($endDTM-$startDTM).totalseconds) seconds" -ForegroundColor Yellow
